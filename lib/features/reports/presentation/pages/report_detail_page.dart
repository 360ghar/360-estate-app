import 'dart:async';

import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/reports/domain/entities/report.dart';
import 'package:estate_app/features/reports/presentation/controllers/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({super.key});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late final ReportsController controller;
  late final ReportType reportType;
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final dateFormat = DateFormat('MMM d, yyyy');
  final monthFormat = DateFormat('MMM yyyy');

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReportsController>();
    reportType = Get.arguments?['reportType'] as ReportType? ??
        _parseReportTypeFromRoute();
    unawaited(controller.loadReport(reportType));
  }

  ReportType _parseReportTypeFromRoute() {
    final typeStr = Get.parameters['type'];
    return ReportType.values.firstWhere(
      (t) => t.apiValue == typeStr,
      orElse: () => ReportType.rentRoll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(reportType.displayName),
        actions: [
          if (reportType.requiresDateRange)
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () => _showDateRangePicker(context),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => unawaited(controller.loadReport(reportType)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range indicator for applicable reports
          if (reportType.requiresDateRange)
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey,),
                      const SizedBox(width: 8),
                      Text(
                        '${dateFormat.format(controller.startDate.value!)} - ${dateFormat.format(controller.endDate.value!)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showDateRangePicker(context),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ),),
          // Report content
          Expanded(child: _buildReportContent()),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    switch (reportType) {
      case ReportType.rentRoll:
        return _RentRollReportView(
            controller: controller, currencyFormat: currencyFormat,);
      case ReportType.income:
        return _IncomeReportView(
            controller: controller,
            currencyFormat: currencyFormat,
            monthFormat: monthFormat,);
      case ReportType.expenses:
        return _ExpensesReportView(
            controller: controller,
            currencyFormat: currencyFormat,
            monthFormat: monthFormat,);
      case ReportType.profitAndLoss:
        return _PnLReportView(
            controller: controller,
            currencyFormat: currencyFormat,
            monthFormat: monthFormat,);
      case ReportType.occupancy:
        return _OccupancyReportView(controller: controller);
      case ReportType.maintenance:
        return _MaintenanceReportView(
            controller: controller, currencyFormat: currencyFormat,);
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.startDate.value!,
        end: controller.endDate.value!,
      ),
    );

    if (picked != null) {
      controller.setDateRange(picked.start, picked.end);
      unawaited(controller.loadReport(reportType));
    }
  }
}

// Rent Roll Report View
class _RentRollReportView extends StatelessWidget {
  const _RentRollReportView({
    required this.controller,
    required this.currencyFormat,
  });

  final ReportsController controller;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.rentRollState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadRentRollReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Total Rent',
                      value: currencyFormat.format(report.totalMonthlyRent),
                      icon: Icons.attach_money,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Collected',
                      value: currencyFormat.format(report.totalCollected),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Outstanding',
                      value: currencyFormat.format(report.totalOutstanding),
                      icon: Icons.warning,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Collection Rate',
                      value: '${report.collectionRate.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Properties List
              Text(
                'Properties (${report.items.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...report.items.map((item) => _RentRollItemCard(
                    item: item,
                    currencyFormat: currencyFormat,
                  ),),
            ],
          );
      }
    });
  }
}

class _RentRollItemCard extends StatelessWidget {
  const _RentRollItemCard({
    required this.item,
    required this.currencyFormat,
  });

  final RentRollItem item;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (item.status) {
      case 'paid':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
      case 'partial':
        statusColor = Colors.orange;
        statusIcon = Icons.remove_circle;
      case 'overdue':
        statusColor = Colors.red;
        statusIcon = Icons.error;
      case 'vacant':
        statusColor = Colors.grey;
        statusIcon = Icons.home;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.circle;
    }

    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(statusIcon, color: statusColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.propertyTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (item.tenantName != null)
                    Text(
                      item.tenantName!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    Text(
                      'Vacant',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(item.monthlyRent),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (item.amountDue > 0)
                  Text(
                    'Due: ${currencyFormat.format(item.amountDue)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
    );
  }
}

// Income Report View
class _IncomeReportView extends StatelessWidget {
  const _IncomeReportView({
    required this.controller,
    required this.currencyFormat,
    required this.monthFormat,
  });

  final ReportsController controller;
  final NumberFormat currencyFormat;
  final DateFormat monthFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.incomeState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadIncomeReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Total Income
              _SummaryCard(
                label: 'Total Income',
                value: currencyFormat.format(report.totalIncome),
                icon: Icons.trending_up,
                color: Colors.green,
              ),
              const SizedBox(height: 24),

              // By Category
              const Text(
                'By Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byCategory.map((cat) => _CategoryBar(
                    label: cat.category,
                    amount: cat.amount,
                    percentage: cat.percentage,
                    currencyFormat: currencyFormat,
                    color: Colors.green,
                  ),),
              const SizedBox(height: 24),

              // By Month
              const Text(
                'By Month',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byMonth.map((month) => _MonthRow(
                    month: monthFormat.format(month.month),
                    amount: currencyFormat.format(month.amount),
                  ),),
            ],
          );
      }
    });
  }
}

// Expenses Report View
class _ExpensesReportView extends StatelessWidget {
  const _ExpensesReportView({
    required this.controller,
    required this.currencyFormat,
    required this.monthFormat,
  });

  final ReportsController controller;
  final NumberFormat currencyFormat;
  final DateFormat monthFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.expensesState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadExpensesReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SummaryCard(
                label: 'Total Expenses',
                value: currencyFormat.format(report.totalExpenses),
                icon: Icons.trending_down,
                color: Colors.red,
              ),
              const SizedBox(height: 24),

              const Text(
                'By Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byCategory.map((cat) => _CategoryBar(
                    label: cat.category,
                    amount: cat.amount,
                    percentage: cat.percentage,
                    currencyFormat: currencyFormat,
                    color: Colors.red,
                  ),),
              const SizedBox(height: 24),

              const Text(
                'By Month',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byMonth.map((month) => _MonthRow(
                    month: monthFormat.format(month.month),
                    amount: currencyFormat.format(month.amount),
                  ),),
            ],
          );
      }
    });
  }
}

// P&L Report View
class _PnLReportView extends StatelessWidget {
  const _PnLReportView({
    required this.controller,
    required this.currencyFormat,
    required this.monthFormat,
  });

  final ReportsController controller;
  final NumberFormat currencyFormat;
  final DateFormat monthFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.pnlState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadProfitAndLossReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Income',
                      value: currencyFormat.format(report.totalIncome),
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Expenses',
                      value: currencyFormat.format(report.totalExpenses),
                      icon: Icons.trending_down,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Net Income',
                      value: currencyFormat.format(report.netIncome),
                      icon: Icons.account_balance,
                      color:
                          report.netIncome >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Profit Margin',
                      value: '${report.profitMargin.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Monthly Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byMonth.map((month) => AppCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monthFormat.format(month.month),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Income: ${currencyFormat.format(month.income)}',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Expenses: ${currencyFormat.format(month.expenses)}',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Net: ${currencyFormat.format(month.netIncome)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: month.netIncome >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
      }
    });
  }
}

// Occupancy Report View
class _OccupancyReportView extends StatelessWidget {
  const _OccupancyReportView({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.occupancyState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadOccupancyReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Occupancy Rate',
                      value: '${report.occupancyRate.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Avg. Vacancy Days',
                      value: '${report.averageVacancyDays}',
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Occupied',
                      value: '${report.occupiedProperties}',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Vacant',
                      value: '${report.vacantProperties}',
                      icon: Icons.remove_circle,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'By Property Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byPropertyType.map((type) => AppCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.propertyType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${type.occupied}/${type.total} occupied',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getOccupancyColor(type.occupancyRate)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${type.occupancyRate.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _getOccupancyColor(type.occupancyRate),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),

              const Text(
                'Properties',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.items.map((item) => AppCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        item.isOccupied ? Icons.home : Icons.home_outlined,
                        color: item.isOccupied ? Colors.green : Colors.grey,
                      ),
                      title: Text(item.propertyTitle),
                      subtitle: Text(
                        item.isOccupied
                            ? item.tenantName ?? 'Occupied'
                            : item.daysVacant != null
                                ? 'Vacant for ${item.daysVacant} days'
                                : 'Vacant',
                        style: TextStyle(
                          color: item.isOccupied
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Colors.orange,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (item.isOccupied ? Colors.green : Colors.grey)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.isOccupied ? 'Occupied' : 'Vacant',
                          style: TextStyle(
                            fontSize: 12,
                            color: item.isOccupied ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          );
      }
    });
  }

  Color _getOccupancyColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 70) return Colors.orange;
    return Colors.red;
  }
}

// Maintenance Report View
class _MaintenanceReportView extends StatelessWidget {
  const _MaintenanceReportView({
    required this.controller,
    required this.currencyFormat,
  });

  final ReportsController controller;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.maintenanceState.value;

      switch (state.status) {
        case ViewStatus.idle:
        case ViewStatus.loading:
          return const Center(child: AppLoader());
        case ViewStatus.empty:
        case ViewStatus.error:
          return AppErrorView(
            title: context.l10n.errorSomethingWentWrong,
            message: state.failure?.localizedMessage(context.l10n) ??
                'Failed to load report',
            retryLabel: context.l10n.commonRetry,
            onRetry: () => unawaited(controller.loadMaintenanceReport()),
          );
        case ViewStatus.success:
          final report = state.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Total Requests',
                      value: '${report.totalRequests}',
                      icon: Icons.build,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Completion Rate',
                      value: '${report.completionRate.toStringAsFixed(0)}%',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Total Cost',
                      value: currencyFormat.format(report.totalCost),
                      icon: Icons.attach_money,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Avg. Days',
                      value: report.averageCompletionDays.toStringAsFixed(1),
                      icon: Icons.schedule,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'By Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byPriority.map((p) => _CategoryBar(
                    label: p.priority,
                    amount: p.count.toDouble(),
                    percentage: p.percentage,
                    currencyFormat: NumberFormat.decimalPattern(),
                    color: _getPriorityColor(p.priority),
                    showAsCount: true,
                  ),),
              const SizedBox(height: 24),

              const Text(
                'By Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...report.byCategory.map((cat) => AppCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.category,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,),
                              ),
                              Text(
                                '${cat.count} requests',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormat.format(cat.totalCost),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),),
            ],
          );
      }
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'emergency':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

// Shared Widgets
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: effectiveColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.currencyFormat,
    required this.color,
    this.showAsCount = false,
  });

  final String label;
  final double amount;
  final double percentage;
  final NumberFormat currencyFormat;
  final Color color;
  final bool showAsCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                showAsCount
                    ? '${amount.toInt()}'
                    : currencyFormat.format(amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthRow extends StatelessWidget {
  const _MonthRow({required this.month, required this.amount});

  final String month;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: const TextStyle(fontSize: 14)),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
