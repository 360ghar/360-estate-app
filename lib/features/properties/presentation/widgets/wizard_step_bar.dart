import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:flutter/material.dart';

/// Where the wizard is: one rounded segment per step (done and current
/// filled), and "Step 2 of 5 · Location" under it.
class WizardStepBar extends StatelessWidget {
  const WizardStepBar({super.key, required this.titles, required this.current});

  final List<String> titles;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final counter = context.l10n.propertyStepCounter(
      current + 1,
      titles.length,
    );
    final duration = reduceMotion(context)
        ? Duration.zero
        : AppDurations.medium;
    return Semantics(
      label: '$counter, ${titles[current]}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i < titles.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AnimatedContainer(
                      duration: duration,
                      curve: AppDurations.defaultCurve,
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= current
                            ? colors.primary
                            : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: counter,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  const TextSpan(text: '  ·  '),
                  TextSpan(
                    text: titles[current],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              style: context.text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
