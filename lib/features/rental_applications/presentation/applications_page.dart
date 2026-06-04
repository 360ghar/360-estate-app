import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('Applications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Forms'),
              Tab(text: 'Inbox'),
            ],
          ),
        ),
        padding: EdgeInsets.zero,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/more/applications/forms/new'),
          icon: const Icon(Icons.add),
          label: const Text('New form'),
        ),
        body: const TabBarView(
          children: [
            _FormsTab(),
            _InboxTab(),
          ],
        ),
      ),
    );
  }
}

class _FormsTab extends ConsumerWidget {
  const _FormsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationFormsPagedProvider);
    final controller = ref.read(applicationFormsPagedProvider.notifier);

    return PagedListView<ApplicationForm>(
      state: state,
      emptyTitle: 'No forms yet',
      emptyMessage: 'Create a rental application form to get started.',
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      itemBuilder: (context, form) => _FormTile(form: form),
    );
  }
}

class _FormTile extends StatelessWidget {
  const _FormTile({required this.form});

  final ApplicationForm form;

  String _formatDate(DateTime? date) {
    if (date == null) return 'No expiry';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final slug = form.slug ?? 'draft';
    final isActive = form.isActive == true;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: GestureDetector(
        onTap: () => context.go('/more/applications/forms/${form.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.lg,
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              width: 0.5,
            ),
            boxShadow: AppShadows.cardResting,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.darkAccentSoft : AppColors.accentSoft),
                        borderRadius: AppRadii.md,
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            form.title ?? form.propertyName ?? 'Application form',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Expires: ${_formatDate(form.expiresAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppStatusBadge(
                      label: isActive ? 'Active' : 'Inactive',
                      type: isActive ? AppStatusType.success : AppStatusType.neutral,
                      variant: AppStatusVariant.subtle,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        slug,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ActionChip(
                      icon: Icons.copy_rounded,
                      label: 'Copy link',
                      onTap: slug.isEmpty
                          ? null
                          : () async {
                              final link = '/public/applications/$slug';
                              await Clipboard.setData(ClipboardData(text: link));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Public link copied.')),
                                );
                              }
                            },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ActionChip(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: () => context.go('/more/applications/forms/${form.id}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pill,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceSecondary,
            borderRadius: AppRadii.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: onTap != null ? AppColors.textSecondary : AppColors.textDisabled,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: onTap != null ? AppColors.textSecondary : AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InboxTab extends ConsumerWidget {
  const _InboxTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationInboxPagedProvider);
    final controller = ref.read(applicationInboxPagedProvider.notifier);

    return PagedListView<ApplicationSubmission>(
      state: state,
      emptyTitle: 'No applications yet',
      emptyMessage: 'Applications submitted by tenants will show here.',
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      itemBuilder: (context, submission) =>
          _SubmissionTile(submission: submission),
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  const _SubmissionTile({required this.submission});

  final ApplicationSubmission submission;

  String _formatDate(DateTime? date) {
    if (date == null) return 'New';
    return DateFormat('d MMM yyyy').format(date);
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'pending':
        return AppStatusType.info;
      case 'reviewed':
        return AppStatusType.warning;
      case 'approved':
        return AppStatusType.success;
      case 'rejected':
        return AppStatusType.danger;
      default:
        return AppStatusType.neutral;
    }
  }

  String _statusLabel(String status) {
    if (status.isEmpty) return 'New';
    return status[0].toUpperCase() + status.substring(1);
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final status = submission.status ?? 'pending';
    final applicant = submission.applicantName ?? 'Applicant';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: GestureDetector(
        onTap: () => context.go('/more/applications/inbox/${submission.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.lg,
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              width: 0.5,
            ),
            boxShadow: AppShadows.cardResting,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials(applicant),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(
                            Icons.apartment_rounded,
                            size: 13,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Flexible(
                            child: Text(
                              submission.propertyName ?? 'Property',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            _formatDate(submission.submittedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppStatusBadge(
                  label: _statusLabel(status),
                  type: _statusType(status),
                  variant: AppStatusVariant.subtle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
