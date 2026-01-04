import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, destructive, gradient }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.leading,
    this.semanticsLabel,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? leading;
  final String? semanticsLabel;
  final bool fullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animController.reverse();
  }

  void _onTapCancel() {
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = widget.isLoading ? null : widget.onPressed;

    final child = widget.isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.variant == AppButtonVariant.secondary
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize:
                widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );

    Widget button;

    if (widget.variant == AppButtonVariant.gradient) {
      button = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: effectiveOnPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: Container(
            width: widget.fullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: effectiveOnPressed != null
                  ? AppColors.primaryGradient
                  : null,
              color: effectiveOnPressed == null
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.12)
                  : null,
              borderRadius: AppRadii.md,
              boxShadow: effectiveOnPressed != null
                  ? [
                      BoxShadow(
                        color: AppColors.gradientEnd.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: effectiveOnPressed != null
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              child: Center(child: child),
            ),
          ),
        ),
      );
    } else {
      button = switch (widget.variant) {
        AppButtonVariant.primary => GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: FilledButton(
                onPressed: effectiveOnPressed,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 2,
                  shadowColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                child: widget.fullWidth
                    ? Center(child: child)
                    : child,
              ),
            ),
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: effectiveOnPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
            ),
            child: widget.fullWidth ? Center(child: child) : child,
          ),
        AppButtonVariant.destructive => FilledButton(
            onPressed: effectiveOnPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: widget.fullWidth ? Center(child: child) : child,
          ),
        AppButtonVariant.gradient => const SizedBox.shrink(), // Handled above
      };
    }

    if (widget.fullWidth && widget.variant != AppButtonVariant.gradient) {
      button = SizedBox(width: double.infinity, child: button);
    }

    if (widget.semanticsLabel == null) return button;
    return Semantics(button: true, label: widget.semanticsLabel, child: button);
  }
}
