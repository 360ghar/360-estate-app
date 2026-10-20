import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A label and its value as two columns (2 : 3), so values line up down a
/// section. [trailing] (a call button, say) sits inside the value column.
class DetailLine extends StatelessWidget {
  const DetailLine({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      style: context.text.bodyMedium?.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
    );
    final value = Row(
      children: [
        Expanded(
          child: Text(
            this.value,
            style: context.text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ?trailing,
      ],
    );
    // Large text: the label goes above the value, so a phone number or an
    // email never breaks mid-word.
    if (MediaQuery.textScalerOf(context).scale(1) > 1.3) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [label, value],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: trailing == null ? AppSpacing.xs : 0,
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: label),
          const SizedBox(width: AppSpacing.md),
          Expanded(flex: 3, child: value),
        ],
      ),
    );
  }
}
