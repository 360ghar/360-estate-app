import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:flutter/material.dart';

class ReportDrilldownArgs {
  const ReportDrilldownArgs({required this.result, required this.row});

  final ReportResult result;
  final ReportRow row;
}

class ReportDrilldownPage extends StatelessWidget {
  const ReportDrilldownPage({super.key, required this.args});

  final ReportDrilldownArgs args;

  @override
  Widget build(BuildContext context) {
    final rows = args.result.rows;
    final total = _totalAmount(rows);
    final rowAmount = args.row.amount ?? 0;
    final percent = total > 0 ? (rowAmount / total) * 100 : null;

    return AppScaffold(
      appBar: AppBar(title: const Text('Report drilldown')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            args.row.label ?? 'Line item',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(args.row.value ?? rowAmount.toStringAsFixed(2)),
          const SizedBox(height: AppSpacing.md),
          if (percent != null)
            Text('Share of total: ${percent.toStringAsFixed(1)}%'),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Top contributors'),
          const SizedBox(height: AppSpacing.md),
          _TopRows(rows: rows),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Automation hooks'),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Export and automation triggers will be added in a later phase.',
          ),
        ],
      ),
    );
  }

  double _totalAmount(List<ReportRow> rows) {
    return rows.fold<double>(
      0,
      (total, row) => total + (row.amount ?? 0),
    );
  }
}

class _TopRows extends StatelessWidget {
  const _TopRows({required this.rows});

  final List<ReportRow> rows;

  @override
  Widget build(BuildContext context) {
    final ranked = rows
        .where((row) => row.amount != null)
        .toList()
      ..sort((a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0));

    if (ranked.isEmpty) {
      return const Text('No numeric breakdown available.');
    }

    return Column(
      children: ranked
          .take(6)
          .map(
            (row) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(row.label ?? 'Item'),
              trailing: Text((row.amount ?? 0).toStringAsFixed(2)),
            ),
          )
          .toList(),
    );
  }
}
