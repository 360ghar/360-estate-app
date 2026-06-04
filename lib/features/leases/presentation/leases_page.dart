import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeasesPage extends ConsumerWidget {
  const LeasesPage({super.key, this.propertyId, this.tenantId});

  final String? propertyId;
  final String? tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsync = ref.watch(
      leasesListProvider(
        LeaseListFilter(propertyId: propertyId, tenantId: tenantId),
      ),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Leases')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/leases/new'),
        icon: const Icon(Icons.post_add_outlined),
        label: const Text('New lease'),
      ),
      body: leasesAsync.when(
        data: (leases) {
          if (leases.isEmpty) {
            return const AppEmptyView(
              title: 'No leases yet',
              message: 'Create your first lease to begin tracking.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: leases.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _LeaseTile(lease: leases[index]);
            },
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load leases',
          message: error.toString(),
          onRetry: () => ref.invalidate(leasesListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _LeaseTile extends StatelessWidget {
  const _LeaseTile({required this.lease});

  final Lease lease;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppStatusType.success;
      case 'expired':
      case 'terminated':
        return AppStatusType.neutral;
      case 'expiring':
      case 'pending':
        return AppStatusType.warning;
      case 'draft':
        return AppStatusType.info;
      default:
        return AppStatusType.info;
    }
  }

  Color _borderColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'expired':
      case 'terminated':
        return AppColors.textTertiary;
      case 'expiring':
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final start = _formatDate(lease.startDate);
    final end = _formatDate(lease.endDate);
    final status = lease.status ?? 'Active';

    return GestureDetector(
      onTap: () => context.go('/more/leases/${lease.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Colored left border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _borderColor(status),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lease.displayName,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          AppStatusBadge(
                            label: status,
                            type: _statusType(status),
                            variant: AppStatusVariant.subtle,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Date range
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '$start  -  $end',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (lease.rentAmount != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Text(
                              '\u20B9${lease.rentAmount!.toStringAsFixed(0)}',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                            ),
                            Text(
                              '/month',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Chevron
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
