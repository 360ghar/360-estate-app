import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/features/more/reports/presentation/widgets/report_text.dart';
import 'package:flutter/material.dart';

class ReportDrilldownArgs {
  const ReportDrilldownArgs({required this.result, required this.row});

  final ReportResult result;
  final ReportRow row;
}

/// One line of a report: its amount, its share of the whole, and where it
/// ranks among the other lines.
class ReportDrilldownPage extends StatelessWidget {
  const ReportDrilldownPage({super.key, required this.args});

  final ReportDrilldownArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final ranked = [
      for (final r in args.result.rows)
        if (r.amount != null) r,
    ]..sort((a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0));
    final total = ranked.fold<double>(0, (t, r) => t + (r.amount ?? 0));
    final amount = args.row.amount ?? 0;
    final share = total > 0 ? amount / total : 0.0;
    final detail = args.row.detailText(context.l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportDrilldownTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.row.labelText(context.l10n),
                  style: context.text.titleLarge,
                ),
                if (detail != null && detail.isNotEmpty)
                  Text(
                    detail,
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  args.row.amount == null
                      ? args.row.valueText(context.l10n) ?? '-'
                      : rupees(amount),
                  style: AppTextStyles.currencyLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  ExcludeSemantics(
                    child: ClipRRect(
                      borderRadius: AppRadii.xs,
                      child: LinearProgressIndicator(
                        value: share.clamp(0.0, 1.0),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.reportDrilldownShare(
                      '${(share * 100).toStringAsFixed(1)}%',
                      rupees(total),
                    ),
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            title: l10n.reportDrilldownRanking,
            contentPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
            children: [
              if (ranked.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l10n.reportDrilldownNoAmounts),
                ),
              for (var i = 0; i < ranked.length; i++)
                _RankRow(
                  rank: i + 1,
                  row: ranked[i],
                  total: total,
                  current: identical(ranked[i], args.row),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.row,
    required this.total,
    required this.current,
  });

  final int rank;
  final ReportRow row;
  final double total;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = total > 0
        ? '${((row.amount ?? 0) / total * 100).toStringAsFixed(1)}%'
        : '';
    final ink = current ? colors.onPrimaryContainer : colors.onSurface;
    final tabular = const [FontFeature.tabularFigures()];
    return MergeSemantics(
      child: Container(
        color: current ? colors.primaryContainer : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: context.text.bodyMedium?.copyWith(
                  color: current ? ink : colors.onSurfaceVariant,
                  fontFeatures: tabular,
                ),
              ),
            ),
            Expanded(
              child: Text(
                row.labelText(context.l10n),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium?.copyWith(
                  color: ink,
                  fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              rupees(row.amount ?? 0),
              style: AppTextStyles.currencyXSmall.copyWith(color: ink),
            ),
            SizedBox(
              width: 56,
              child: Text(
                percent,
                textAlign: TextAlign.end,
                style: context.text.bodySmall?.copyWith(
                  color: current ? ink : colors.onSurfaceVariant,
                  fontFeatures: tabular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
