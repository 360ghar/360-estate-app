import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_alert_banner.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_kpi_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/responsive/breakpoints.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
            const _QuickActionsRow(),
            const SizedBox(height: AppSpacing.xl),

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
                          onPressed: () =>
                              context.go('/collections/payments/new'),
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
                    if (overview.overdue > 0) ...[
                      _UrgentAlertBanner(overdueCount: overview.overdue),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    _KpiGrid(overview: overview),
                    const SizedBox(height: AppSpacing.xl),

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

    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Manage your properties',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: AppSpacing.xs),
          child: Material(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go('/more/notifications'),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Icon(Icons.notifications_outlined, size: 22),
              ),
            ),
          ),
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

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.payment_rounded,
            label: 'Record\nPayment',
            onTap: () => context.go('/collections/payments/new'),
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconColor: Colors.white,
            labelColor: Colors.white,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'Add\nProperty',
            onTap: () => context.go('/properties/create'),
            gradient: LinearGradient(
              colors: [
                AppColors.success.withOpacity(0.12),
                AppColors.success.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconColor: AppColors.success,
            labelColor: scheme.onSurface,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.build_outlined,
            label: 'New\nTask',
            onTap: () => context.go('/tasks'),
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.12),
                AppColors.accent.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconColor: AppColors.accent,
            labelColor: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Gradient gradient;
  final Color iconColor;
  final Color labelColor;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradient,
    required this.iconColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final crossAxisCount = screenSize.gridColumns.clamp(2, 3);
        final childAspectRatio = screenSize.isCompact ? 1.35 : 1.55;
        const kpiVariant = AppKpiVariant.compact;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          children: [
            AppKpiCard(
              title: 'Charges Due',
              value: overview.due.toString(),
              icon: Icons.notifications_outlined,
              onTap: () => context.go('/collections?status=due'),
              variant: kpiVariant,
            ),
            AppKpiCard(
              title: 'Overdue',
              value: overview.overdue.toString(),
              icon: Icons.warning_amber_outlined,
              onTap: () => context.go('/collections?status=overdue'),
              valueColor: overview.overdue > 0 ? AppColors.danger : null,
              variant: kpiVariant,
            ),
            AppKpiCard(
              title: 'Maintenance',
              value: overview.maintenance.toString(),
              icon: Icons.build_outlined,
              onTap: () => context.go('/tasks'),
              variant: kpiVariant,
            ),
            AppKpiCard(
              title: 'Tenants',
              value: overview.tenants.toString(),
              icon: Icons.people_outline,
              onTap: () => context.go('/more/tenants'),
              variant: kpiVariant,
            ),
            AppKpiCard(
              title: 'Properties',
              value: overview.properties.toString(),
              icon: Icons.apartment_outlined,
              onTap: () => context.go('/properties'),
              variant: kpiVariant,
            ),
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

class _CollectionSummary extends StatelessWidget {
  final double collected;

  const _CollectionSummary({required this.collected});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final collectedStr = formatter.format(collected);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 5,
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 120),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.success, AppColors.successLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'This Month',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      collectedStr,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final AsyncValue<List<DashboardActivityItem>> activityAsync;
  final VoidCallback onRefresh;

  const _RecentActivitySection({
    required this.activityAsync,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Material(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Refresh',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final DashboardActivityItem item;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM, hh:mm a');
    final DateTime? activityTime =
        item.createdAt ??
        (item.at != null ? DateTime.tryParse(item.at!) : null);
    final time = activityTime == null ? null : formatter.format(activityTime);

    final (icon, color, type) = _getActivityIconAndColor(context, item.type);
    final title = item.title?.trim().isNotEmpty ?? false
        ? item.title!.trim()
        : 'Activity';
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.message != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.message!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
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
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, AppStatusType?) _getActivityIconAndColor(
    BuildContext context,
    String? type,
  ) {
    final lowerType = type?.toLowerCase() ?? '';

    if (lowerType.contains('payment') ||
        lowerType.contains('paid') ||
        lowerType.contains('rent')) {
      return (
        Icons.payments_outlined,
        AppColors.success,
        AppStatusType.success,
      );
    }
    if (lowerType.contains('overdue') || lowerType.contains('late')) {
      return (
        Icons.warning_amber_rounded,
        AppColors.danger,
        AppStatusType.danger,
      );
    }
    if (lowerType.contains('maintenance') || lowerType.contains('repair')) {
      return (Icons.build_outlined, AppColors.warning, AppStatusType.warning);
    }
    if (lowerType.contains('lease') || lowerType.contains('tenant')) {
      return (Icons.description_outlined, AppColors.info, AppStatusType.info);
    }
    if (lowerType.contains('property')) {
      return (
        Icons.apartment_outlined,
        Theme.of(context).colorScheme.primary,
        null,
      );
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
