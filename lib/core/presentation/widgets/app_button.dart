import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, destructive }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.semanticsLabel,
    this.fullWidth = false,
    this.size = AppButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final String? semanticsLabel;
  final bool fullWidth;
  final AppButtonSize size;

  double get _iconSize => switch (size) {
    AppButtonSize.small => 16,
    AppButtonSize.medium => 18,
    AppButtonSize.large => 20,
  };

  EdgeInsetsGeometry get _padding => switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 4,
    ),
    AppButtonSize.medium => const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    AppButtonSize.large => const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 14,
    ),
  };

  double get _fontSize => switch (size) {
    AppButtonSize.small => 13,
    AppButtonSize.medium => 14,
    AppButtonSize.large => 16,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveOnPressed = isLoading ? null : onPressed;
    final spinnerColor = switch (variant) {
      AppButtonVariant.primary => scheme.onPrimary,
      AppButtonVariant.secondary => scheme.primary,
      AppButtonVariant.destructive => scheme.onError,
    };

    final child = isLoading
        ? SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(size: _iconSize),
                  child: leading!,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(fontSize: _fontSize),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(size: _iconSize),
                  child: trailing!,
                ),
              ],
            ],
          );

    final shape = RoundedRectangleBorder(borderRadius: AppRadii.lg);

    final buttonStyle = switch (variant) {
      AppButtonVariant.primary => FilledButton.styleFrom(
        padding: _padding,
        shape: shape,
      ),
      AppButtonVariant.secondary => OutlinedButton.styleFrom(
        padding: _padding,
        shape: shape,
      ),
      AppButtonVariant.destructive => FilledButton.styleFrom(
        backgroundColor: scheme.error,
        foregroundColor: scheme.onError,
        padding: _padding,
        shape: shape,
      ),
    };

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle,
        child: child,
      ),
      AppButtonVariant.destructive => FilledButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle,
        child: child,
      ),
    };

    Widget result = button;
    if (fullWidth) {
      result = SizedBox(width: double.infinity, child: result);
    }

    if (semanticsLabel == null) return result;
    return Semantics(button: true, label: semanticsLabel, child: result);
  }
}
