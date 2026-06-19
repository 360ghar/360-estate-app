import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

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
    final formatter = NumberFormat.currency(symbol: '\u20B9', decimalDigits: 0);

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Report drilldown'),
        actions: [
          IconButton(
            onPressed: () => _exportCsv(context, args.result),
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Export CSV',
          ),
        ],
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI summary row
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppGradients.primarySubtle,
              color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
              boxShadow: AppShadows.cardResting,
            ),
            child: Row(
              children: [
                // Selected item amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.row.label ?? 'Line item',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        args.row.amount != null
                            ? formatter.format(args.row.amount)
                            : args.row.value ?? '-',
                        style: AppTextStyles.currencyMedium.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 48,
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ),

                const SizedBox(width: AppSpacing.lg),

                // Share of total
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share of total',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        percent != null
                            ? '${percent.toStringAsFixed(1)}%'
                            : '-',
                        style: AppTextStyles.currencyMedium.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                // Total
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatter.format(total),
                        style: AppTextStyles.currencySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Top contributors table
          AppSectionCard(
            title: 'Top contributors',
            icon: Icons.leaderboard_rounded,
            contentPadding: EdgeInsets.zero,
            child: _TopContributorsTable(
              rows: rows,
              total: total,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Automation hooks placeholder
          AppSectionCard(
            title: 'Automation hooks',
            icon: Icons.auto_awesome_rounded,
            iconColor: AppColors.warning,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSecondary
                      : AppColors.surfaceSecondary,
                  borderRadius: AppRadii.md,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Export and automation triggers will be added in a later phase.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  /// Exports the report result as a CSV string and shares it via the system
  /// share sheet.
  void _exportCsv(BuildContext context, ReportResult result) {
    final buffer = StringBuffer();
    buffer.writeln('Label,Amount,Value');
    for (final row in result.rows) {
      final label = _csvEscape(row.label ?? '');
      final amount = row.amount?.toStringAsFixed(2) ?? '';
      final value = _csvEscape(row.value ?? '');
      buffer.writeln('$label,$amount,$value');
    }
    final csv = buffer.toString();
    final reportName = result.type.name;
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Share.share(csv, subject: '$reportName report ($dateStr)');
  }

  /// Escapes a string for CSV output (wraps in quotes if it contains commas,
  /// quotes, or newlines).
  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

/// Table of top contributors with alternating row backgrounds.
class _TopContributorsTable extends StatelessWidget {
  const _TopContributorsTable({
    required this.rows,
    required this.total,
  });

  final List<ReportRow> rows;
  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final formatter = NumberFormat.currency(symbol: '\u20B9', decimalDigits: 0);

    final ranked = rows
        .where((row) => row.amount != null)
        .toList()
      ..sort((a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0));

    if (ranked.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'No numeric breakdown available.',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final display = ranked.take(6).toList();

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceSecondary
                : AppColors.surfaceSecondary,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '#',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Item',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  'Amount',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 48,
                child: Text(
                  '%',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        // Data rows with alternating backgrounds
        ...display.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isOdd = index.isOdd;
          final pct = total > 0
              ? ((row.amount ?? 0) / total * 100).toStringAsFixed(1)
              : '-';

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            color: isOdd
                ? (isDark
                    ? AppColors.darkSurfaceSecondary
                    : AppColors.surfaceSecondary)
                : Colors.transparent,
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${index + 1}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.label ?? 'Item',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    formatter.format(row.amount ?? 0),
                    style: AppTextStyles.currencyXSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 48,
                  child: Text(
                    '$pct%',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
