import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/features/more/reports/presentation/widgets/report_text.dart';
import 'package:flutter/material.dart';

/// Money lines as a horizontal bar chart: each line carries its label and
/// amount as text, and a bar as long as its share of the largest line. The
/// text is the data; the bar only helps the eye compare.
class ReportBars extends StatelessWidget {
  const ReportBars({super.key, required this.rows, this.onTap});

  final List<ReportRow> rows;

  /// Opens one line, when the report has a breakdown to show.
  final ValueChanged<ReportRow>? onTap;

  @override
  Widget build(BuildContext context) {
    final max = rows.fold<double>(
      0,
      (m, r) => (r.amount ?? 0).abs() > m ? (r.amount ?? 0).abs() : m,
    );
    final top = rows.isEmpty ? null : rows.first;
    return Semantics(
      label: top == null
          ? null
          : context.l10n.reportsBarsSummary(
              rows.length,
              top.labelText(context.l10n),
              rupees(top.amount ?? 0),
            ),
      child: Column(
        children: [
          for (final row in rows)
            _BarRow(
              row: row,
              share: max == 0 ? 0 : (row.amount ?? 0).abs() / max,
              onTap: onTap == null ? null : () => onTap!(row),
            ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.row, required this.share, this.onTap});

  final ReportRow row;
  final double share;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final amount = row.amount ?? 0;
    final detail = row.detailText(context.l10n);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.labelText(context.l10n),
                        style: context.text.titleSmall,
                      ),
                      if (detail != null && detail.isNotEmpty)
                        Text(
                          detail,
                          style: context.text.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  rupees(amount),
                  style: AppTextStyles.currencySmall.copyWith(
                    color: amount < 0 ? colors.error : colors.onSurface,
                  ),
                ),
                if (onTap != null)
                  ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: AppRadii.xs,
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: colors.surfaceContainerHighest),
                      FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: share.clamp(0.0, 1.0),
                        child: Container(
                          color: amount < 0 ? colors.error : colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lines that are not money (counts, a rate, the period) as label and value.
class ReportValues extends StatelessWidget {
  const ReportValues({super.key, required this.rows});

  final List<ReportRow> rows;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final row in rows)
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.labelText(context.l10n),
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    row.valueText(context.l10n) ?? '-',
                    textAlign: TextAlign.end,
                    style: context.text.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
