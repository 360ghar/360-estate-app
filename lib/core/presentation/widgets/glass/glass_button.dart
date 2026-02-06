import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';

/// Glass button variants
enum GlassButtonVariant {
  /// Primary filled button with gradient
  primary,

  /// Secondary outlined button
  secondary,

  /// Ghost button (transparent with text)
  ghost,

  /// Glow button with ambient shadow
  glow,
}

/// A glassmorphism button with multiple variants.
///
/// Provides premium button styling with press animation,
/// loading state, and configurable variants.
///
/// Example:
/// ```dart
/// GlassButton(
///   variant: GlassButtonVariant.primary,
///   label: 'Submit',
///   onPressed: () => print('Pressed'),
/// )
/// ```
class GlassButton extends StatefulWidget {
  /// Text label for the button
  final String label;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Button variant
  final GlassButtonVariant variant;

  /// Blur sigma value (not used for primary variant)
  final double blur;

  /// Opacity of the glass surface (not used for primary variant)
  final double opacity;

  /// Border radius of the button
  final double borderRadius;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Optional icon to display after the label
  final IconData? trailingIcon;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is enabled
  final bool enabled;

  /// Optional custom width
  final double? width;

  /// Optional custom height
  final double? height;

  /// Custom gradient for primary variant
  final Gradient? gradient;

  /// Custom text color
  final Color? textColor;

  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GlassButtonVariant.primary,
    this.blur = AppGlassBlur.light,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 12,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
    this.gradient,
    this.textColor,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _handlePressDown(PointerDownEvent event) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handlePressUp(PointerUpEvent event) {
    if (!_isPressed) return;
    _handlePressEnd();
  }

  void _handlePressCancel(PointerCancelEvent event) {
    if (!_isPressed) return;
    _handlePressEnd();
  }

  void _handlePressEnd() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  bool get _isEnabled => widget.enabled && !widget.isLoading;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = widget.width ?? double.infinity;
    final effectiveHeight = widget.height ?? 48;

    return Listener(
      onPointerDown: _handlePressDown,
      onPointerUp: _handlePressUp,
      onPointerCancel: _handlePressCancel,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: _isEnabled ? widget.onPressed : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: effectiveWidth,
            height: effectiveHeight,
            child: _buildButtonForVariant(),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonForVariant() {
    switch (widget.variant) {
      case GlassButtonVariant.primary:
        return _buildPrimaryButton();
      case GlassButtonVariant.secondary:
        return _buildSecondaryButton();
      case GlassButtonVariant.ghost:
        return _buildGhostButton();
      case GlassButtonVariant.glow:
        return _buildGlowButton();
    }
  }

  Widget _buildPrimaryButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppGradients.primary,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _isEnabled ? AppShadows.buttonGlowPrimary : null,
      ),
      child: _buildButtonContentWithColor(
        widget.textColor ?? Colors.white,
      ),
    );
  }

  Widget _buildSecondaryButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final container = Container(
      decoration: BoxDecoration(
        color: (isDark
                ? AppGlassColors.glassSurfaceDark(widget.opacity)
                : AppGlassColors.glassSurfaceLight(widget.opacity))
            .withOpacity(_isEnabled ? 1 : 0.5),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: (isDark ? AppGlassColors.borderDark : AppGlassColors.borderLight)
              .withOpacity(_isEnabled ? 1 : 0.5),
          width: 1.5,
        ),
      ),
      child: _buildButtonContentWithColor(
        widget.textColor ??
            (isDark ? Colors.white : AppColors.textPrimary),
      ),
    );

    if (widget.blur <= 0) return container;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
        child: container,
      ),
    );
  }

  Widget _buildGhostButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: _buildButtonContentWithColor(
        widget.textColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildGlowButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppGradients.primary,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _isEnabled
            ? [
                ...AppShadows.buttonGlowPrimary,
                const BoxShadow(
                  color: AppGlassColors.glowBlue,
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: _buildButtonContentWithColor(
        widget.textColor ?? Colors.white,
      ),
    );
  }

  Widget _buildButtonContentWithColor(Color textColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? widget.onPressed : null,
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: textColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: textColor.withOpacity(_isEnabled ? 1 : 0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          widget.trailingIcon,
                          size: 18,
                          color: textColor,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A glass icon button - circular button with icon only.
class GlassIconButton extends StatefulWidget {
  /// Icon to display
  final IconData icon;

  /// Callback when pressed
  final VoidCallback? onPressed;

  /// Button size
  final double size;

  /// Icon size
  final double iconSize;

  /// Button variant
  final GlassButtonVariant variant;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Whether the button is enabled
  final bool enabled;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom icon color
  final Color? iconColor;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.iconSize = 20,
    this.variant = GlassButtonVariant.secondary,
    this.blur = AppGlassBlur.light,
    this.opacity = AppGlassColors.opacityMedium,
    this.enabled = true,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  bool get _isEnabled => widget.enabled;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonChild = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (widget.variant == GlassButtonVariant.primary
                ? null
                : (isDark
                        ? AppGlassColors.glassSurfaceDark(widget.opacity)
                        : AppGlassColors.glassSurfaceLight(widget.opacity))
                    .withOpacity(_isEnabled ? 1 : 0.5)),
        gradient: widget.variant == GlassButtonVariant.primary
            ? AppGradients.primary
            : null,
        shape: BoxShape.circle,
        border: widget.variant != GlassButtonVariant.primary
            ? Border.all(
                color: (isDark
                        ? AppGlassColors.borderDark
                        : AppGlassColors.borderLight)
                    .withOpacity(_isEnabled ? 1 : 0.5),
                width: 1,
              )
            : null,
        boxShadow: widget.variant == GlassButtonVariant.glow && _isEnabled
            ? AppShadows.glowBlue
            : null,
      ),
      child: Icon(
        widget.icon,
        size: widget.iconSize,
        color: widget.iconColor ??
            (widget.variant == GlassButtonVariant.primary
                ? Colors.white
                : (isDark ? Colors.white : AppColors.textPrimary)),
      ),
    );

    if (widget.blur > 0 && widget.variant != GlassButtonVariant.primary) {
      buttonChild = ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: buttonChild,
        ),
      );
    }

    return Listener(
      onPointerDown: _isEnabled
          ? (_) => _controller.forward()
          : null,
      onPointerUp: (_) => _controller.reverse(),
      onPointerCancel: (_) => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: _isEnabled ? widget.onPressed : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: buttonChild,
        ),
      ),
    );
  }
}
