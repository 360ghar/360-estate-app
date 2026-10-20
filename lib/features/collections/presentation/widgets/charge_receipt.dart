import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/receipt_edge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The charge being paid, as a rent receipt: billed, paid so far, balance.
class ChargeReceipt extends StatelessWidget {
  const ChargeReceipt({
    super.key,
    required this.row,
    required this.tenant,
    required this.property,
  });

  final RentChargeWithTotals row;
  final String tenant;
  final String property;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = row.charge.billingMonth;
    final monthText = month == null
        ? null
        : l10n.homeRentCardTitle(
            DateFormat.yMMMM(
              Localizations.localeOf(context).toString(),
            ).format(month),
          );
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return Material(
      color: context.palette.card,
      shape: const ReceiptEdgeBorder(),
      child: Padding(
        // The bottom padding clears the perforation.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(tenant, style: context.text.titleLarge),
            Text([property, ?monthText].join('  ·  '), style: muted),
            const SizedBox(height: AppSpacing.md),
            _Line(label: l10n.paymentBilled, value: rupees(row.totalDue)),
            _Line(label: l10n.paymentPaidSoFar, value: rupees(row.paid)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(),
            ),
            _Line(
              label: l10n.paymentBalance,
              value: rupees(row.balance),
              strong: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: strong
                ? context.text.titleSmall
                : context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
          ),
        ),
        Text(
          value,
          style:
              (strong
                      ? AppTextStyles.currencySmall
                      : AppTextStyles.currencyXSmall)
                  .copyWith(color: context.colors.onSurface),
        ),
      ],
    ),
  );
}
