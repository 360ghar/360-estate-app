import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/presentation/widgets/receipt_edge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/presentation/rent_status_text.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The month's rent as a receipt: what came in, one ledger segment per charge
/// (filled by the share paid), what is still owed, and the one action that
/// matters here.
class RentMonthCard extends StatelessWidget {
  const RentMonthCard({
    super.key,
    required this.overview,
    required this.charges,
    required this.onRetryCharges,
  });

  final DashboardOverview overview;
  final AsyncValue<List<RentChargeWithTotals>> charges;
  final VoidCallback onRetryCharges;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final now = DateTime.now();
    final month = DateFormat.MMMM(
      Localizations.localeOf(context).toString(),
    ).format(now);
    final previous = overview.revenuePrevious;
    final change = previous > 0
        ? (overview.revenueCurrent - previous) * 100 / previous
        : null;

    return Material(
      color: context.palette.card,
      shape: const ReceiptEdgeBorder(),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.homeRentCardTitle(month),
                      style: context.text.titleLarge,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/collections'),
                  child: Text(l10n.homeViewAll),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rupees(overview.revenueCurrent),
                    style: AppTextStyles.currencyLarge.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    [
                      l10n.homeCollectedThisMonth,
                      if (change != null)
                        l10n.homeVsLastMonth(
                          '${change >= 0 ? '+' : '−'}'
                          '${change.abs().toStringAsFixed(0)}%',
                        ),
                    ].join('  ·  '),
                    style: context.text.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ChargesLedger(
                    month: month,
                    charges: charges,
                    onRetry: onRetryCharges,
                  ),
                  if (overview.outstanding > 0) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _OutstandingLine(amount: overview.outstanding),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go('/collections/payments/new'),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.homeRecordPayment),
                    ),
                  ),
                  if (overview.upcomingExpenses > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.homeUpcomingExpenses(
                        rupees(overview.upcomingExpenses),
                      ),
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutstandingLine extends StatelessWidget {
  const _OutstandingLine({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final error = context.colors.error;
    return InkWell(
      onTap: () => context.go('/collections?status=overdue'),
      borderRadius: AppRadii.sm,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            ExcludeSemantics(
              child: CustomPaint(
                size: const Size.square(10),
                painter: StatusMarkPainter(AppStatusType.danger, error),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.homeRentOutstanding(rupees(amount)),
                style: context.text.labelLarge?.copyWith(color: error),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: error),
          ],
        ),
      ),
    );
  }
}

/// This month's charges as one ledger strip plus a legend.
class _ChargesLedger extends StatelessWidget {
  const _ChargesLedger({
    required this.month,
    required this.charges,
    required this.onRetry,
  });

  final String month;
  final AsyncValue<List<RentChargeWithTotals>> charges;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return charges.when(
      loading: () => _StripTrack(color: context.colors.surfaceContainerHigh),
      error: (_, _) => Row(
        children: [
          Expanded(child: Text(l10n.homeChargesFailed, style: muted)),
          TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
      data: (all) {
        final now = DateTime.now();
        final month = all
            .where(
              (c) =>
                  c.charge.billingMonth?.year == now.year &&
                  c.charge.billingMonth?.month == now.month,
            )
            .toList();
        if (month.isEmpty) {
          return Text(l10n.homeChargesEmpty(this.month), style: muted);
        }
        final counts = <RentChargeStatus, int>{};
        for (final c in month) {
          final s = c.status ?? RentChargeStatus.pending;
          counts[s] = (counts[s] ?? 0) + 1;
        }
        final paid = counts[RentChargeStatus.paid] ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              button: true,
              label: l10n.homeStripSemantics(paid, month.length),
              excludeSemantics: true,
              child: InkWell(
                onTap: () => context.go('/collections'),
                borderRadius: AppRadii.xs,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _LedgerStrip(charges: month),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                for (final status in RentChargeStatus.values)
                  if (counts[status] != null)
                    AppStatusBadge(
                      label: '${counts[status]} ${status.text(l10n)}',
                      type: status.statusType,
                    ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StripTrack extends StatelessWidget {
  const _StripTrack({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Container(
      height: _LedgerStrip.height,
      decoration: BoxDecoration(color: color, borderRadius: AppRadii.xs),
    ),
  );
}

/// One segment per charge, as wide as its share of the month's rent. The
/// paid share fills from the left the first time it shows; the track under
/// it is always drawn, so the strip reads even before the fill arrives.
class _LedgerStrip extends StatefulWidget {
  const _LedgerStrip({required this.charges});

  static const double height = 14;

  final List<RentChargeWithTotals> charges;

  @override
  State<_LedgerStrip> createState() => _LedgerStripState();
}

class _LedgerStripState extends State<_LedgerStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fill.isAnimating || _fill.isCompleted) return;
    if (reduceMotion(context)) {
      _fill.value = 1;
    } else {
      _fill.forward();
    }
  }

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = context.palette;
    return SizedBox(
      height: _LedgerStrip.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _fill,
        builder: (context, _) => CustomPaint(
          painter: _LedgerPainter(
            charges: widget.charges,
            progress: Curves.easeOutCubic.transform(_fill.value),
            paid: palette.success,
            track: colors.surfaceContainerHighest,
            due: palette.warning,
            overdueTrack: colors.errorContainer,
            overdue: colors.error,
            waived: colors.outlineVariant,
          ),
        ),
      ),
    );
  }
}

class _LedgerPainter extends CustomPainter {
  _LedgerPainter({
    required this.charges,
    required this.progress,
    required this.paid,
    required this.track,
    required this.due,
    required this.overdueTrack,
    required this.overdue,
    required this.waived,
  });

  final List<RentChargeWithTotals> charges;
  final double progress;
  final Color paid;
  final Color track;
  final Color due;
  final Color overdueTrack;
  final Color overdue;
  final Color waived;

  static const double gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final total = charges.fold<double>(
      0,
      (sum, c) => sum + (c.totalDue > 0 ? c.totalDue : 1),
    );
    final usable = size.width - gap * (charges.length - 1);
    if (usable <= 0 || total <= 0) return;
    var x = 0.0;
    for (final c in charges) {
      final w = usable * (c.totalDue > 0 ? c.totalDue : 1) / total;
      final rect = Rect.fromLTWH(x, 0, w, size.height);
      final shape = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      final status = c.status ?? RentChargeStatus.pending;
      canvas.drawRRect(
        shape,
        Paint()
          ..color = switch (status) {
            RentChargeStatus.overdue => overdueTrack,
            RentChargeStatus.waived => waived,
            _ => track,
          },
      );
      final share = status == RentChargeStatus.paid
          ? 1.0
          : c.totalDue > 0
          ? (c.paid / c.totalDue).clamp(0.0, 1.0)
          : 0.0;
      final filled = w * share * progress;
      canvas
        ..save()
        ..clipRRect(shape)
        ..drawRect(
          Rect.fromLTWH(x, 0, filled, size.height),
          Paint()..color = paid,
        );
      // The unpaid part names its state with a rule along its foot: amber
      // for due, red for overdue.
      if (share < 1 && status != RentChargeStatus.waived) {
        canvas.drawRect(
          Rect.fromLTWH(x + w * share, size.height - 3, w * (1 - share), 3),
          Paint()..color = status == RentChargeStatus.overdue ? overdue : due,
        );
      }
      canvas.restore();
      x += w + gap;
    }
  }

  @override
  bool shouldRepaint(_LedgerPainter old) =>
      old.progress != progress ||
      old.charges != charges ||
      old.paid != paid ||
      old.track != track;
}
