import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A form's one action, pinned under the scrolling fields and above the
/// keyboard. It shows a spinner and ignores taps while the form saves.
class SubmitBar extends StatelessWidget {
  const SubmitBar({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: busy ? null : onPressed,
          // A check reads as done, and the action has not run yet, so the
          // default is the label alone; busy shows the spinner.
          icon: busy
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    semanticsLabel: context.l10n.commonSaving,
                  ),
                )
              : icon == null
              ? null
              : Icon(icon),
          label: Text(label),
        ),
      ),
    ),
  );
}
