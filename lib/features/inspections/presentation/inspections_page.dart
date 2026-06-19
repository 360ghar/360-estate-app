import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/presentation/inspection_templates_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key, this.propertyId, this.tenantId});

  final String? propertyId;
  final String? tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionsAsync = ref.watch(
      inspectionsListProvider(
        InspectionListFilter(propertyId: propertyId, tenantId: tenantId),
      ),
    );

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Inspections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fact_check_outlined),
            tooltip: 'Templates',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const InspectionTemplatesPage(),
                ),
              );
            },
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/inspections/new'),
        icon: const Icon(Icons.playlist_add),
        label: const Text('New inspection'),
      ),
      body: inspectionsAsync.when(
        data: (inspections) {
          if (inspections.isEmpty) {
            return const AppEmptyView(
              title: 'No inspections yet',
              message: 'Create a checklist to start an inspection.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: inspections.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _InspectionTile(inspection: inspections[index]);
            },
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load inspections',
          message: error.toString(),
          onRetry: () => ref.invalidate(inspectionsListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _InspectionTile extends StatelessWidget {
  const _InspectionTile({required this.inspection});

  final Inspection inspection;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not scheduled';
    return DateFormat('d MMM yyyy').format(date);
  }

  Color _statusBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'signed':
        return AppColors.success;
      case 'in_progress':
      case 'in progress':
        return AppColors.warning;
      case 'cancelled':
      case 'canceled':
        return AppColors.danger;
      case 'scheduled':
        return AppColors.info;
      case 'open':
      default:
        return AppColors.accent;
    }
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'signed':
        return AppStatusType.success;
      case 'in_progress':
      case 'in progress':
        return AppStatusType.warning;
      case 'cancelled':
      case 'canceled':
        return AppStatusType.danger;
      case 'scheduled':
        return AppStatusType.info;
      case 'open':
      default:
        return AppStatusType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final status = inspection.status ?? 'Open';
    final scheduled = _formatDate(inspection.scheduledAt);
    final borderColor = _statusBorderColor(status);

    return GestureDetector(
      onTap: () => context.go('/more/inspections/${inspection.id}'),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadii.lgValue),
                    bottomLeft: Radius.circular(AppRadii.lgValue),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: name + chevron
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              inspection.displayName,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Property name (if title is different from property)
                      if (inspection.propertyName != null &&
                          inspection.title != null &&
                          inspection.propertyName != inspection.title)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            inspection.title!,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      // Bottom row: date + badges
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            scheduled,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          AppStatusBadge(
                            label: status,
                            type: _statusType(status),
                            variant: AppStatusVariant.subtle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
