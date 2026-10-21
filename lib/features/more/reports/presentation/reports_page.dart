import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:estate_app/features/more/reports/presentation/widgets/report_lines.dart';
import 'package:estate_app/features/more/reports/presentation/widgets/report_text.dart';
import 'package:estate_app/features/more/reports/reports_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pick a report (and, for money over time, a period); the report runs at
/// once and shows its lines as text with bars to compare them.
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  ReportType _type = ReportType.rentRoll;
  DateTime? _from;
  DateTime? _to;

  ReportRequest get _request => ReportRequest(
    type: _type,
    from: _type.windowed ? _from : null,
    to: _type.windowed ? _to : null,
  );

  Future<void> _reload() async {
    final request = _request;
    ref.invalidate(reportProvider(request));
    await ref
        .read(reportProvider(request).future)
        .catchError((_) => ReportResult(type: request.type, rows: const []));
  }

  Future<void> _pickDate({required bool from}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: from ? now : now.add(const Duration(days: 365)),
      initialDate:
          (from ? _from : _to) ??
          (from ? now.subtract(const Duration(days: 30)) : now),
    );
    if (picked == null) return;
    setState(() => from ? _from = picked : _to = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final report = ref.watch(reportProvider(_request));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final type in ReportType.values)
                  ChoiceChip(
                    label: Text(type.text(l10n)),
                    selected: _type == type,
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _type.about(l10n),
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            if (_type.windowed) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: l10n.reportsFrom,
                      date: _from,
                      onPick: () => _pickDate(from: true),
                      onClear: () => setState(() => _from = null),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _DateField(
                      label: l10n.reportsTo,
                      date: _to,
                      onPick: () => _pickDate(from: false),
                      onClear: () => setState(() => _to = null),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            report.when(
              loading: () => const AppLoadingShimmer(
                itemCount: 3,
                itemHeight: 64,
                padding: EdgeInsets.zero,
              ),
              error: (error, _) => AppErrorView(
                title: l10n.commonLoadFailedTitle,
                message: userFacingMessage(error),
                onRetry: _reload,
              ),
              data: (result) => result.rows.isEmpty
                  ? AppEmptyView(
                      title: l10n.reportsEmptyTitle,
                      message: l10n.reportsEmptyBody,
                      icon: Icons.insights_outlined,
                    )
                  : RiseIn(child: _ReportResultCard(result: result)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportResultCard extends StatelessWidget {
  const _ReportResultCard({required this.result});

  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = [
      for (final r in result.rows)
        if (r.amount != null) r,
    ];
    final values = [
      for (final r in result.rows)
        if (r.amount == null) r,
    ];
    // The rent roll ranks properties: largest rent first. The other reports
    // keep their own order (income, expenses, net).
    final rentRoll = result.type == ReportType.rentRoll;
    if (rentRoll) {
      money.sort((a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0));
    }

    return AppCard(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.xs,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      result.type.text(l10n),
                      style: context.text.titleLarge,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.reportsExportCsv,
                  icon: const Icon(Icons.ios_share_rounded),
                  onPressed: () => shareReportCsv(result),
                ),
              ],
            ),
          ),
          if (money.length == 1 && !rentRoll)
            _Total(row: money.single)
          else if (money.isNotEmpty)
            ReportBars(
              rows: money,
              // A share of the total only means something for the rent roll.
              onTap: rentRoll
                  ? (row) => context.go(
                      '/more/reports/drilldown',
                      extra: ReportDrilldownArgs(result: result, row: row),
                    )
                  : null,
            ),
          if (money.isNotEmpty && values.isNotEmpty)
            const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
          if (values.isNotEmpty) ReportValues(rows: values),
        ],
      ),
    );
  }
}

/// A report with one money line (total income, total expenses): the figure.
class _Total extends StatelessWidget {
  const _Total({required this.row});

  final ReportRow row;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.md,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rupees(row.amount ?? 0),
          style: AppTextStyles.currencyLarge.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        Text(
          row.labelText(context.l10n),
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// A date that may be left open: "Any date" until picked, then clearable.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final value = date;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onPick,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            contentPadding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
            suffixIcon: value == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(
                    tooltip: l10n.reportsClearDate,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClear,
                  ),
          ),
          child: Text(
            value == null ? l10n.reportsAnyDate : shortDate(context, value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
