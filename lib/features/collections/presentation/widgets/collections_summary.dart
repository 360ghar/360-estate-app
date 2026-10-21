import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The ledger at a glance: what came in, what is due, what is overdue, and
/// one bar for the same three in the same order. It reads every page of
/// charges.
class CollectionsSummary extends ConsumerWidget {
  const CollectionsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final charges = ref.watch(allRentChargesProvider);
    final rows = charges.valueOrNull;

    double sum(
      bool Function(RentChargeWithTotals) where,
      double Function(RentChargeWithTotals) pick,
    ) => (rows ?? const <RentChargeWithTotals>[])
        .where(where)
        .fold<double>(0, (total, row) => total + pick(row));

    // Due: still owed and not overdue yet. Overdue: still owed past the
    // grace period. Collected: what settled payments brought in.
    final due = sum(
      (r) =>
          r.status == RentChargeStatus.pending ||
          r.status == RentChargeStatus.partial,
      (r) => r.balance,
    );
    final overdue = sum(
      (r) => r.status == RentChargeStatus.overdue,
      (r) => r.balance,
    );
    final paid = sum((_) => true, (r) => r.paid);
    final billed = paid + due + overdue;

    if (charges.hasError && rows == null) {
      return AppCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.collectionsTotalsFailed,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(allRentChargesProvider),
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      );
    }

    String amount(double value) => rows == null ? '…' : rupees(value);
    final collectedShare = billed <= 0 ? 0.0 : paid / billed;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Total(
                  label: l10n.collectionsCollected,
                  amount: amount(paid),
                  type: AppStatusType.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _Total(
                  label: l10n.rentStatusDue,
                  amount: amount(due),
                  type: AppStatusType.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _Total(
                  label: l10n.rentStatusOverdue,
                  amount: amount(overdue),
                  type: AppStatusType.danger,
                  emphasise: overdue > 0,
                ),
              ),
            ],
          ),
          if (rows != null && billed > 0) ...[
            const SizedBox(height: AppSpacing.md),
            ExcludeSemantics(
              child: _ShareBar(paid: paid, due: due, overdue: overdue),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.collectionsCollectedShare(
                (collectedShare * 100).toStringAsFixed(0),
              ),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.amount,
    required this.type,
    this.emphasise = false,
  });

  final String label;
  final String amount;
  final AppStatusType type;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final (ink, _) = statusColors(context, type);
    return Semantics(
      label: '$label $amount',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size.square(10),
                painter: StatusMarkPainter(type, ink),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: AppTextStyles.currencySmall.copyWith(
                color: emphasise
                    ? context.colors.error
                    : context.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Collected, due and overdue as one rounded bar, in that order.
class _ShareBar extends StatelessWidget {
  const _ShareBar({
    required this.paid,
    required this.due,
    required this.overdue,
  });

  final double paid;
  final double due;
  final double overdue;

  @override
  Widget build(BuildContext context) {
    final parts = [
      (paid, context.palette.success),
      (due, context.palette.warning),
      (overdue, context.colors.error),
    ];
    final total = paid + due + overdue;
    return ClipRRect(
      borderRadius: AppRadii.xs,
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            for (final (value, color) in parts)
              if (value > 0)
                Expanded(
                  // Whole thousandths keep a tiny share visible.
                  flex: (value / total * 1000).round().clamp(1, 1000),
                  child: Container(color: color),
                ),
          ],
        ),
      ),
    );
  }
}
