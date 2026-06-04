import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

  IconData _fieldTypeIcon(String type) {
    switch (type) {
      case 'text':
        return Icons.edit_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'number':
        return Icons.pin_outlined;
      case 'date':
        return Icons.calendar_today_outlined;
      case 'select':
        return Icons.list_outlined;
      case 'checkbox':
        return Icons.check_box_outlined;
      default:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slug = form.slug ?? '';
    final link = slug.isEmpty ? '' : '/public/applications/$slug';
    final isActive = form.isActive == true;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.title ?? form.propertyName ?? 'Application form',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (form.propertyAddress != null &&
                      form.propertyAddress!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Flexible(
                          child: Text(
                            form.propertyAddress!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppStatusBadge(
              label: isActive ? 'Active' : 'Inactive',
              type: isActive ? AppStatusType.success : AppStatusType.neutral,
              variant: AppStatusVariant.subtle,
            ),
          ],
        ),

        if (form.expiresAt != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                'Expires: ${DateFormat('d MMM yyyy').format(form.expiresAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: AppSpacing.xl),

        // --- Public Link Card ---
        AppCard(
          variant: AppCardVariant.tinted,
          tintColor: AppColors.info,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: AppRadii.sm,
                    ),
                    child: const Icon(
                      Icons.link_rounded,
                      size: 18,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Public Link',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (link.isEmpty)
                Text(
                  'Link not available yet. The form needs a slug to generate a public link.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSecondary
                        : AppColors.surfaceSecondary,
                    borderRadius: AppRadii.md,
                  ),
                  child: Text(
                    link,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: AppColors.info,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: link.isEmpty
                          ? null
                          : () async {
                              await Clipboard.setData(
                                  ClipboardData(text: link));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Link copied.')),
                                );
                              }
                            },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Copy link'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          link.isEmpty ? null : () => context.go(link),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Open form'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // --- Fields Section ---
        AppSectionCard(
          title: 'Custom Fields',
          icon: Icons.dynamic_form_outlined,
          children: [
            if (form.fields == null || form.fields!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'No custom fields added yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (form.fields != null && form.fields!.isNotEmpty)
              ...form.fields!.asMap().entries.map((entry) {
                final field = entry.value;
                final fieldType = field.fieldType ?? 'text';

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < form.fields!.length - 1
                        ? AppSpacing.sm
                        : 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceSecondary
                          : AppColors.surfaceSecondary,
                      borderRadius: AppRadii.md,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: isDark ? 0.15 : 0.08),
                            borderRadius: AppRadii.sm,
                          ),
                          child: Icon(
                            _fieldTypeIcon(fieldType),
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                field.label ?? 'Field',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                fieldType,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (field.isRequired == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: AppRadii.pill,
                            ),
                            child: Text(
                              'Required',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
