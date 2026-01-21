import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_alert_banner.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_kpi_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Professional B2B dashboard with:
/// - Personalized greeting
/// - Quick action buttons
/// - Urgent alerts (conditional)
/// - KPI cards with trends
/// - Collection summary
/// - Recent activity feed
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(dashboardOverviewProvider);
    final activityAsync = ref.watch(dashboardActivityProvider);

    return AppScaffold(
      appBar: _buildAppBar(context),
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardOverviewProvider);
          ref.invalidate(dashboardActivityProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Quick Actions Row
            const _QuickActionsRow(),
            const SizedBox(height: AppSpacing.lg),

            // Overview Section
            overviewAsync.when(
              data: (overview) {
                if (!_hasOverviewData(overview)) {
                  return AppEmptyView(
                    title: 'No dashboard data yet',
                    message:
                        'Add a property or record your first payment to see your overview.',
                    action: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context.go('/properties/create'),
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          label: const Text('Add property'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/collections/payments/new'),
                          icon: const Icon(Icons.payment_rounded),
                          label: const Text('Record payment'),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Urgent Alert Banner (only if overdue > 0)
                    if (overview.overdue > 0) ...[
                      _UrgentAlertBanner(overdueCount: overview.overdue),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // KPI Grid
                    _KpiGrid(overview: overview),
                    const SizedBox(height: AppSpacing.xl),

                    // Collection Summary
                    _CollectionSummary(collected: overview.collected),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                );
              },
              loading: () => const AppLoadingShimmer(itemCount: 2),
              error: (error, _) => AppErrorView(
                title: 'Unable to load dashboard',
                message: _formatErrorMessage(error),
                onRetry: () => ref.invalidate(dashboardOverviewProvider),
                retryLabel: 'Try again',
              ),
            ),

            // Recent Activity Section
            _RecentActivitySection(
              activityAsync: activityAsync,
              onRefresh: () => ref.invalidate(dashboardActivityProvider),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return AppBar(
      title: Text(
        greeting,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.go('/more/notifications'),
          tooltip: 'Notifications',
        ),
      ],
    );
  }

  bool _hasOverviewData(DashboardOverview overview) {
    return overview.propertiesCount != null ||
        overview.tenantsCount != null ||
        overview.chargesDue != null ||
        overview.chargesOverdue != null ||
        overview.maintenanceOpen != null ||
        overview.rentCollected != null ||
        overview.occupancyRate != null;
  }
}

/// Quick action buttons for common tasks.
class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.payment_rounded,
            label: 'Record\nPayment',
            onTap: () => context.go('/collections/payments/new'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'Add\nProperty',
            onTap: () => context.go('/properties/create'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.build_outlined,
            label: 'New\nTask',
            onTap: () => context.go('/tasks'),
          ),
        ),
      ],
    );
  }
}

/// Individual quick action button.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Urgent alert banner for overdue payments.
class _UrgentAlertBanner extends StatelessWidget {
  final int overdueCount;

  const _UrgentAlertBanner({required this.overdueCount});

  @override
  Widget build(BuildContext context) {
    return AppAlertBanner(
      title: '$overdueCount Payment${overdueCount > 1 ? 's' : ''} Overdue',
      message: 'Action required to avoid late fees',
      type: AppAlertType.danger,
      actionLabel: 'View',
      onAction: () => context.go('/collections?status=overdue'),
      isDismissible: true,
    );
  }
}

/// KPI grid displaying key metrics with the new AppKpiCard component.
class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final isNarrow = constraints.maxWidth < 360;
        final crossAxisCount = isWide ? 3 : (isNarrow ? 2 : 3);
        final childAspectRatio = isWide ? 1.6 : 1.4;
        const kpiVariant = AppKpiVariant.compact;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          children: [
            // Charges Due
            AppKpiCard(
              title: 'Charges Due',
              value: overview.due.toString(),
              icon: Icons.notifications_outlined,
              onTap: () => context.go('/collections?status=due'),
              variant: kpiVariant,
            ),
            // Overdue - highlighted if > 0
            AppKpiCard(
              title: 'Overdue',
              value: overview.overdue.toString(),
              icon: Icons.warning_amber_outlined,
              onTap: () => context.go('/collections?status=overdue'),
              valueColor: overview.overdue > 0
                ? AppColors.danger
                : null,
              variant: kpiVariant,
            ),
            // Maintenance
            AppKpiCard(
              title: 'Maintenance',
              value: overview.maintenance.toString(),
              icon: Icons.build_outlined,
              onTap: () => context.go('/tasks'),
              variant: kpiVariant,
            ),
            // Tenants
            AppKpiCard(
              title: 'Tenants',
              value: overview.tenants.toString(),
              icon: Icons.people_outline,
              onTap: () => context.go('/more/tenants'),
              variant: kpiVariant,
            ),
            // Properties
            AppKpiCard(
              title: 'Properties',
              value: overview.properties.toString(),
              icon: Icons.apartment_outlined,
              onTap: () => context.go('/properties'),
              variant: kpiVariant,
            ),
            // Occupancy with color based on rate
            AppKpiCard(
              title: 'Occupancy',
              value: '${overview.occupancy.toStringAsFixed(0)}%',
              icon: Icons.pie_chart_outline,
              onTap: () => context.go('/more/reports'),
              valueColor: _getOccupancyColor(overview.occupancy),
              variant: kpiVariant,
            ),
          ],
        );
      },
    );
  }

  Color? _getOccupancyColor(double rate) {
    if (rate >= 80) return AppColors.success;
    if (rate >= 50) return AppColors.warning;
    return AppColors.danger;
  }
}

/// Collection summary showing total rent collected.
class _CollectionSummary extends StatelessWidget {
  final double collected;

  const _CollectionSummary({required this.collected});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    );
    final collectedStr = formatter.format(collected);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'This Month',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            collectedStr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.success,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Collected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent activity section with enhanced activity items.
class _RecentActivitySection extends StatelessWidget {
  final AsyncValue<List<DashboardActivityItem>> activityAsync;
  final VoidCallback onRefresh;

  const _RecentActivitySection({
    required this.activityAsync,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: onRefresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        activityAsync.when(
          data: (items) {
            final visibleItems = items.where((item) {
              final hasTitle = item.title?.trim().isNotEmpty ?? false;
              final hasMessage = item.message?.trim().isNotEmpty ?? false;
              return hasTitle || hasMessage;
            }).toList();
            if (visibleItems.isEmpty) {
              return const AppEmptyView(
                title: 'No activity yet',
                message:
                    'Log payments, tasks, or maintenance to see updates here.',
              );
            }
            return Column(
              children: visibleItems
                  .map((item) => _ActivityTile(item: item))
                  .toList(),
            );
          },
          loading: () => const AppLoadingShimmer(itemCount: 4),
          error: (error, _) => AppErrorView(
            title: 'Unable to load activity',
            message: _formatErrorMessage(error),
            onRetry: onRefresh,
            retryLabel: 'Try again',
          ),
        ),
      ],
    );
  }
}

/// Enhanced activity tile with semantic icons and better visual hierarchy.
class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final DashboardActivityItem item;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM, hh:mm a');
    final time = item.createdAt == null
        ? null
        : formatter.format(item.createdAt!);

    final (icon, color, type) = _getActivityIconAndColor(context, item.type);
    final title = item.title?.trim().isNotEmpty ?? false
        ? item.title!.trim()
        : 'Activity';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: item.message != null
            ? Text(
                item.message!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (type != null)
              AppStatusBadge(
                label: type.name.toUpperCase(),
                type: type,
                variant: AppStatusVariant.dot,
              ),
            if (type != null && time != null) const SizedBox(height: 4),
            if (time != null)
              Text(
                time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, AppStatusType?) _getActivityIconAndColor(BuildContext context, String? type) {
    final lowerType = type?.toLowerCase() ?? '';

    if (lowerType.contains('payment') || lowerType.contains('paid') || lowerType.contains('rent')) {
      return (Icons.payments_outlined, AppColors.success, AppStatusType.success);
    }
    if (lowerType.contains('overdue') || lowerType.contains('late')) {
      return (Icons.warning_amber_rounded, AppColors.danger, AppStatusType.danger);
    }
    if (lowerType.contains('maintenance') || lowerType.contains('repair')) {
      return (Icons.build_outlined, AppColors.warning, AppStatusType.warning);
    }
    if (lowerType.contains('lease') || lowerType.contains('tenant')) {
      return (Icons.description_outlined, AppColors.info, AppStatusType.info);
    }
    if (lowerType.contains('property')) {
      return (Icons.apartment_outlined, Theme.of(context).colorScheme.primary, null);
    }
    return (Icons.notifications_outlined, AppColors.textSecondary, null);
  }

}

String _formatErrorMessage(Object error) {
  final message = error.toString().trim();
  if (message.isEmpty) {
    return 'Unexpected error. Check your connection and try again.';
  }
  return '$message\n\nCheck your connection and make sure you are logged in.';
}
