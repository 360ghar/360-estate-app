import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/presentation/widgets/question_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ApplicationFormDetailPage extends ConsumerWidget {
  const ApplicationFormDetailPage({super.key, required this.formId});

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final appBar = AppBar(title: Text(l10n.applicationFormDetailTitle));
    final id = int.tryParse(formId);
    if (id == null) {
      return Scaffold(
        appBar: appBar,
        body: AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: l10n.applicationFormInvalidLink,
        ),
      );
    }
    final form = ref.watch(applicationFormDetailProvider(id));

    Future<void> refresh() async {
      ref.invalidate(applicationFormDetailProvider(id));
      await ref
          .read(applicationFormDetailProvider(id).future)
          .then<void>((_) {}, onError: (_) {});
    }

    return Scaffold(
      appBar: appBar,
      body: form.when(
        loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 120),
        error: (error, _) => RefreshIndicator(
          onRefresh: refresh,
          child: StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: () => ref.invalidate(applicationFormDetailProvider(id)),
            ),
          ),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: refresh,
          child: _FormBody(form: data),
        ),
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({required this.form});

  final ApplicationForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final active = form.isActive == true;
    final address = form.propertyAddress?.trim() ?? '';
    final expires = form.expiresAt;
    final fee = form.applicationFeeAmount;
    final fields = form.fields ?? const <ApplicationFormField>[];
    final facts = [
      expires == null
          ? l10n.applicationsNoExpiry
          : l10n.applicationsExpires(shortDate(context, expires)),
      if (fee != null && fee > 0) l10n.applicationsFee(rupees(fee)),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          form.title ?? form.propertyName ?? l10n.applicationFormDefaultTitle,
          style: context.text.headlineMedium,
        ),
        if (form.propertyName != null || address.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            [?form.propertyName, if (address.isNotEmpty) address].join(', '),
            style: muted,
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(facts.join('  ·  '), style: muted),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppStatusBadge(
            label: active ? l10n.applicationsActive : l10n.applicationsInactive,
            type: active ? AppStatusType.success : AppStatusType.neutral,
            variant: AppStatusVariant.filled,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ShareCard(slug: form.slug ?? ''),
        const SizedBox(height: AppSpacing.md),
        AppSectionCard(
          title: l10n.applicationFormQuestionsSection,
          children: [
            Text(l10n.applicationFormStandardQuestions, style: muted),
            const SizedBox(height: AppSpacing.sm),
            if (fields.isEmpty) Text(l10n.applicationFormNoQuestions),
            for (final field in fields) QuestionRow(field: field),
          ],
        ),
      ],
    );
  }
}

/// The public link, with one clear way to send it: Share. Copy and preview
/// are quieter.
class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    // `link` is the public URL the owner shares; `route` opens the same form
    // inside the app.
    final link = slug.isEmpty ? '' : DeepLinkService.applicationUrl(slug);
    final route = slug.isEmpty ? '' : Routes.publicApplication(slug);

    return AppSectionCard(
      title: l10n.applicationFormShareSection,
      children: [
        if (link.isEmpty)
          Text(l10n.applicationFormNoLink, style: muted)
        else ...[
          Text(l10n.applicationFormShareHelp, style: muted),
          const SizedBox(height: AppSpacing.md),
          Text(
            link,
            style: context.text.bodyLarge?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => Share.share(link),
            icon: const Icon(Icons.ios_share_rounded),
            label: Text(l10n.applicationFormShare),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: link));
                  if (context.mounted) {
                    context.showSnack(l10n.applicationsLinkCopied);
                  }
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l10n.applicationsCopyLink),
              ),
              TextButton.icon(
                onPressed: () => context.go(route),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(l10n.applicationFormPreview),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
