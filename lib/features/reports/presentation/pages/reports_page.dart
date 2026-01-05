import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/reports/domain/entities/report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Select a report to view',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          _ReportCategory(
            title: 'Financial Reports',
            reports: [
              _ReportItem(
                title: 'Rent Roll',
                subtitle: 'Current rent status for all properties',
                icon: Icons.payments_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.rentRoll},
                ),
              ),
              _ReportItem(
                title: 'Income Report',
                subtitle: 'Revenue breakdown by source',
                icon: Icons.receipt_long_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.income},
                ),
              ),
              _ReportItem(
                title: 'Expenses Report',
                subtitle: 'Expense breakdown by category',
                icon: Icons.money_off_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.expenses},
                ),
              ),
              _ReportItem(
                title: 'Profit & Loss',
                subtitle: 'Overall financial performance',
                icon: Icons.analytics_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.profitAndLoss},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ReportCategory(
            title: 'Operational Reports',
            reports: [
              _ReportItem(
                title: 'Occupancy Report',
                subtitle: 'Units status and availability',
                icon: Icons.business_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.occupancy},
                ),
              ),
              _ReportItem(
                title: 'Maintenance Summary',
                subtitle: 'Track maintenance requests status',
                icon: Icons.build_outlined,
                onTap: () => Get.toNamed<void>(
                  Routes.reportDetail,
                  arguments: {'reportType': ReportType.maintenance},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCategory extends StatelessWidget {
  const _ReportCategory({
    required this.title,
    required this.reports,
  });

  final String title;
  final List<_ReportItem> reports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < reports.length; i++) ...[
                reports[i],
                if (i < reports.length - 1)
                  const Divider(height: 1, indent: 56),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportItem extends StatelessWidget {
  const _ReportItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
