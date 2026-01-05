import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';
import 'package:estate_app/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:estate_app/features/home/presentation/widgets/activity_feed.dart';
import 'package:estate_app/features/home/presentation/widgets/kpi_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOverviewSection(context, controller),
              const SizedBox(height: 24),
              _buildActivitySection(context, controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOverviewSection(
    BuildContext context,
    DashboardController controller,
  ) {
    final state = controller.overviewState.value;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio Overview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        switch (state.status) {
          ViewStatus.loading || ViewStatus.idle => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: AppLoader(),
              ),
            ),
          ViewStatus.error => AppErrorView(
              title: 'Unable to load dashboard',
              message: state.failure!.localizedMessage(context.l10n),
              onRetry: controller.loadDashboard,
              retryLabel: 'Try Again',
            ),
          ViewStatus.empty => const AppEmptyState(
              icon: Icons.dashboard,
              title: 'No data yet',
              message: 'Add properties to see your portfolio overview',
            ),
          ViewStatus.success => _buildKpiGrid(context, state.data!),
        },
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context, DashboardOverview overview) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: 'en_IN',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: KpiCard(
                title: 'Total Properties',
                value: overview.totalProperties.toString(),
                icon: Icons.apartment,
                subtitle:
                    '${overview.occupiedProperties} occupied, ${overview.vacantProperties} vacant',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KpiCard(
                title: 'Occupancy Rate',
                value: percentFormat.format(overview.occupancyRate),
                icon: Icons.people,
                subtitle:
                    '${overview.underMaintenanceProperties} under maintenance',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KpiCard(
                title: 'Monthly Revenue',
                value: currencyFormat.format(overview.monthlyRevenueCurrent),
                icon: Icons.trending_up,
                trend: overview.revenueChangePercent != 0
                    ? '${overview.revenueChangePercent.toStringAsFixed(1)}%'
                    : null,
                trendPositive: overview.revenueChangePercent > 0
                    ? true
                    : overview.revenueChangePercent < 0
                        ? false
                        : null,
                subtitle: 'vs last month',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KpiCard(
                title: 'Outstanding Rent',
                value: currencyFormat.format(overview.outstandingRentTotal),
                icon: Icons.account_balance_wallet,
                onTap: () => Get.toNamed<void>(Routes.rentCharges),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        KpiCard(
          title: 'Upcoming Expenses',
          value: currencyFormat.format(overview.upcomingExpensesTotal),
          icon: Icons.money_off,
          onTap: () => Get.toNamed<void>(Routes.expenses),
        ),
      ],
    );
  }

  Widget _buildActivitySection(
    BuildContext context,
    DashboardController controller,
  ) {
    final state = controller.activityState.value;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: switch (state.status) {
            ViewStatus.loading || ViewStatus.idle => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: AppLoader(),
                ),
              ),
            ViewStatus.error => Padding(
                padding: const EdgeInsets.all(16),
                child: AppErrorView(
                  title: 'Unable to load activity',
                  message: state.failure!.localizedMessage(context.l10n),
                  onRetry: controller.loadDashboard,
                  retryLabel: 'Try Again',
                ),
              ),
            ViewStatus.empty => const Padding(
                padding: EdgeInsets.all(32),
                child: AppEmptyState(
                  icon: Icons.history,
                  title: 'No activity yet',
                  message: 'Your recent activity will appear here',
                ),
              ),
            ViewStatus.success => ActivityFeed(
                activities: state.data!,
                onActivityTap: (activity) {
                  if (activity.propertyId != null) {
                    unawaited(
                      Get.toNamed<void>(
                        Routes.propertyDetail.replaceFirst(
                            ':id', activity.propertyId.toString()),
                      ),
                    );
                  }
                },
              ),
          },
        ),
      ],
    );
  }
}
