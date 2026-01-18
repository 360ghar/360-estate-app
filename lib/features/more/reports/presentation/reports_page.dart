import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/reports_providers.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  ReportType _type = ReportType.rentRoll;
  DateTime? _from;
  DateTime? _to;
  ReportRequest? _request;

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      initialDate: _from ?? DateTime.now().subtract(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _from = picked);
    }
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _to ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _to = picked);
    }
  }

  void _runReport() {
    setState(() {
      _request = ReportRequest(type: _type, from: _from, to: _to);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = _request;
    final reportAsync = request == null ? null : ref.watch(reportProvider(request));
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppScaffold(
      appBar: AppBar(title: const Text('Reports')),
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          DropdownButtonFormField<ReportType>(
            value: _type,
            items: const [
              DropdownMenuItem(
                value: ReportType.rentRoll,
                child: Text('Rent roll'),
              ),
              DropdownMenuItem(value: ReportType.income, child: Text('Income')),
              DropdownMenuItem(
                value: ReportType.expenses,
                child: Text('Expenses'),
              ),
              DropdownMenuItem(value: ReportType.pnl, child: Text('P&L')),
              DropdownMenuItem(
                value: ReportType.occupancy,
                child: Text('Occupancy'),
              ),
              DropdownMenuItem(
                value: ReportType.maintenance,
                child: Text('Maintenance'),
              ),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
            decoration: const InputDecoration(labelText: 'Report type'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'From'),
                  child: Text(_from == null ? 'Any' : dateFormat.format(_from!)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(onPressed: _pickFrom, child: const Text('Pick')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'To'),
                  child: Text(_to == null ? 'Any' : dateFormat.format(_to!)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(onPressed: _pickTo, child: const Text('Pick')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _runReport,
              child: const Text('Run report'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (reportAsync == null)
            const AppEmptyView(
              title: 'No report yet',
              message: 'Select filters and run a report.',
            )
          else
            reportAsync.when(
              data: (result) {
                if (result.rows.isEmpty) {
                  return const AppEmptyView(
                    title: 'No data',
                    message: 'There is nothing to show for this report.',
                  );
                }
                return Column(
                  children: result.rows
                      .map(
                        (row) => Card(
                          child: ListTile(
                            title: Text(row.label ?? 'Item'),
                            trailing: Text(
                              row.amount?.toStringAsFixed(2) ??
                                  row.value ??
                                  '-',
                            ),
                            onTap: () => context.go(
                              '/more/reports/drilldown',
                              extra: ReportDrilldownArgs(
                                result: result,
                                row: row,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const AppLoadingShimmer(itemCount: 4),
              error: (error, _) => AppErrorView(
                title: 'Unable to load report',
                message: error.toString(),
                onRetry: _runReport,
                retryLabel: 'Try again',
              ),
            ),
        ],
      ),
    );
  }
}
