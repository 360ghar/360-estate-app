import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:estate_app/features/rental_applications/presentation/application_field_type_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Applications that came in, and the forms that collect them. The inbox is
/// first: it is what an owner checks.
class ApplicationsPage extends ConsumerStatefulWidget {
  const ApplicationsPage({super.key});

  @override
  ConsumerState<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends ConsumerState<ApplicationsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _newForm() => context.go(Routes.applicationsFormsNew);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final forms = ref.watch(applicationFormsPagedProvider);
    // The empty forms list has its own "New form" button.
    final showFab =
        _tabs.index == 1 && !(forms.items.isEmpty && !forms.isInitialLoading);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.applicationsTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.applicationsTabInbox),
            Tab(text: l10n.applicationsTabForms),
          ],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: _newForm,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.applicationsNewForm),
            )
          : null,
      body: TabBarView(
        controller: _tabs,
        children: [
          const _InboxTab(),
          _FormsTab(onNewForm: _newForm),
        ],
      ),
    );
  }
}

class _InboxTab extends ConsumerWidget {
  const _InboxTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(applicationInboxPagedProvider);
    final controller = ref.read(applicationInboxPagedProvider.notifier);
    return PagedListView<ApplicationSubmission>(
      state: state,
      emptyTitle: l10n.applicationsInboxEmptyTitle,
      emptyMessage: l10n.applicationsInboxEmptyBody,
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      onLoadMoreRetry: controller.retryLoadMore,
      itemBuilder: (context, submission) => _SubmissionRow(submission),
    );
  }
}

class _SubmissionRow extends StatelessWidget {
  const _SubmissionRow(this.submission);

  final ApplicationSubmission submission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = submission.applicantFullName ?? l10n.applicationsApplicant;
    final status = submission.status;
    final submitted = submission.submittedAt;
    return AppListCard(
      leading: AppAvatar(name: name),
      title: name,
      subtitle: submission.propertyName,
      facts: [
        if (submitted != null)
          l10n.applicationsSubmittedOn(shortDate(context, submitted)),
      ],
      status: AppStatusBadge(
        label: status?.text(l10n) ?? l10n.applicationsStatusUnknown,
        type: status?.statusType ?? AppStatusType.neutral,
      ),
      onTap: () => context.go(Routes.applicationInbox('${submission.id}')),
    );
  }
}

class _FormsTab extends ConsumerWidget {
  const _FormsTab({required this.onNewForm});

  final VoidCallback onNewForm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(applicationFormsPagedProvider);
    final controller = ref.read(applicationFormsPagedProvider.notifier);
    return PagedListView<ApplicationForm>(
      state: state,
      // Room under the last row for the floating button.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        96,
      ),
      emptyTitle: l10n.applicationsFormsEmptyTitle,
      emptyMessage: l10n.applicationsFormsEmptyBody,
      emptyIcon: Icons.description_outlined,
      emptyAction: FilledButton.icon(
        onPressed: onNewForm,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.applicationsNewForm),
      ),
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      onLoadMoreRetry: controller.retryLoadMore,
      itemBuilder: (context, form) => _FormRow(form),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow(this.form);

  final ApplicationForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slug = form.slug ?? '';
    final active = form.isActive == true;
    final expires = form.expiresAt;
    final fee = form.applicationFeeAmount;
    return AppListCard(
      title:
          form.title ?? form.propertyName ?? l10n.applicationFormDefaultTitle,
      subtitle: form.propertyName,
      facts: [
        l10n.applicationsQuestionCount(form.fields?.length ?? 0),
        if (expires != null)
          l10n.applicationsExpires(shortDate(context, expires)),
        if (fee != null && fee > 0) l10n.applicationsFee(rupees(fee)),
      ],
      trailing: slug.isEmpty
          ? null
          : IconButton(
              tooltip: l10n.applicationsCopyLink,
              icon: const Icon(Icons.link_rounded),
              color: context.colors.onSurfaceVariant,
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: DeepLinkService.applicationUrl(slug)),
                );
                if (context.mounted) {
                  context.showSnack(l10n.applicationsLinkCopied);
                }
              },
            ),
      status: AppStatusBadge(
        label: active ? l10n.applicationsActive : l10n.applicationsInactive,
        type: active ? AppStatusType.success : AppStatusType.neutral,
      ),
      onTap: () => context.go(Routes.applicationForm('${form.id}')),
    );
  }
}
