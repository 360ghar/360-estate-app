import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicationFormDetailPage extends ConsumerWidget {
  const ApplicationFormDetailPage({super.key, required this.formId});

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(applicationFormDetailProvider(formId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Form details')),
      scrollable: true,
      body: formAsync.when(
        data: (form) => _FormDetail(form: form),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load form',
          message: error.toString(),
          onRetry: () => ref.invalidate(applicationFormDetailProvider(formId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _FormDetail extends StatelessWidget {
  const _FormDetail({required this.form});

  final ApplicationForm form;

  @override
  Widget build(BuildContext context) {
    final slug = form.slug ?? '';
    final link = slug.isEmpty ? '' : '/public/applications/$slug';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          form.title ?? form.propertyName ?? 'Application form',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(form.propertyAddress ?? 'Property address not set'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Public link'),
        const SizedBox(height: AppSpacing.md),
        Text(link.isEmpty ? 'Link not available yet.' : link),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: link.isEmpty
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied.')),
                      );
                    },
              icon: const Icon(Icons.copy),
              label: const Text('Copy link'),
            ),
            OutlinedButton.icon(
              onPressed:
                  link.isEmpty ? null : () => context.go(link),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open public form'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Fields'),
        const SizedBox(height: AppSpacing.md),
        if (form.fields == null || form.fields!.isEmpty)
          const Text('No custom fields added yet.'),
        if (form.fields != null && form.fields!.isNotEmpty)
          Column(
            children: form.fields!
                .map(
                  (field) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(field.label ?? 'Field'),
                    subtitle: Text(field.fieldType ?? 'text'),
                    trailing: Text(field.isRequired == true ? 'Required' : ''),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
