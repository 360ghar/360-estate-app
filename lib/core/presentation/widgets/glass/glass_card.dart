import 'dart:ui';

import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Glass card variants
enum GlassCardVariant {
  /// Elevated card with prominent shadow
  elevated,

  /// Flat card with minimal shadow
  flat,

  /// Outlined card with border
  outlined,
}

/// A glassmorphism card with elevated or flat effect.
///
/// Provides premium glass card styling with configurable variants.
/// Supports press animation and tap handling.
///
/// Example:
/// ```dart
/// GlassCard(
///   variant: GlassCardVariant.elevated,
///   onTap: () => print('Card tapped'),
///   child: Text('Glass card content'),
/// )
/// ```
class GlassCard extends StatefulWidget {
  /// The child widget inside the card
  final Widget child;

  /// Card variant (elevated, flat, outlined)
  final GlassCardVariant variant;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the card
  final double borderRadius;

  /// Optional padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Whether to enable press animation
  final bool enablePressAnimation;

  /// Custom border (overrides variant default)
  final BoxBorder? border;

  /// Custom shadow (overrides variant default)
  final List<BoxShadow>? shadow;

  /// Background color (with opacity applied)
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.variant = GlassCardVariant.elevated,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 16,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.enablePressAnimation = true,
    this.border,
    this.shadow,
    this.color,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    if (widget.enablePressAnimation && widget.onTap != null) {
      _pressController = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      );
      _pressAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(
          parent: _pressController,
          curve: Curves.easeOut,
        ),
      );
    }
  }

  void _handlePressDown(PointerDownEvent event) {
    if (widget.onTap == null || !widget.enablePressAnimation) return;
    setState(() => _isPressed = true);
    _pressController.forward();
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
    _pressController.reverse();
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine default shadow based on variant
    List<BoxShadow> defaultShadow;
    switch (widget.variant) {
      case GlassCardVariant.elevated:
        defaultShadow = isDark ? AppShadows.glassLgDark : AppShadows.glassLg;
      case GlassCardVariant.flat:
        defaultShadow = isDark ? AppShadows.glassSmDark : AppShadows.glassSm;
      case GlassCardVariant.outlined:
        defaultShadow = [];
    }

    final effectiveShadow = widget.shadow ?? defaultShadow;

    // Determine default border based on variant
    BoxBorder? defaultBorder;
    switch (widget.variant) {
      case GlassCardVariant.outlined:
        defaultBorder = Border.all(
          color: isDark ? AppGlassColors.borderDark : AppGlassColors.borderLight,
          width: 1.5,
        );
      case GlassCardVariant.elevated:
      case GlassCardVariant.flat:
        defaultBorder = Border.all(
          color: isDark ? AppGlassColors.borderDark : AppGlassColors.borderLight,
          width: 0.5,
        );
    }

    final effectiveBorder = widget.border ?? defaultBorder;

    final cardContent = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.color?.withValues(alpha: widget.opacity) ??
            (isDark
                ? AppGlassColors.glassSurfaceDark(widget.opacity)
                : AppGlassColors.glassSurfaceLight(widget.opacity)),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: widget.child,
      ),
    );

    final wrappedCard = widget.blur > 0
        ? ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
              child: cardContent,
            ),
          )
        : cardContent;

    if (widget.onTap == null) {
      return wrappedCard;
    }

    final animatedCard = widget.enablePressAnimation
        ? _PressAnimatedCard(
            controller: _pressController,
            animation: _pressAnimation,
            child: wrappedCard,
          )
        : wrappedCard;

    return Listener(
      onPointerDown: _handlePressDown,
      onPointerUp: _handlePressUp,
      onPointerCancel: _handlePressCancel,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: widget.onTap,
        child: animatedCard,
      ),
    );
  }
}

class _PressAnimatedCard extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> animation;
  final Widget child;

  const _PressAnimatedCard({
    required this.controller,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}

/// A glass card with header, body, and footer sections.
///
/// Provides a structured card layout with pre-styled sections.
class GlassStructuredCard extends StatelessWidget {
  /// Optional title widget for the card header
  final Widget? title;

  /// Optional subtitle for the header
  final Widget? subtitle;

  /// Optional leading widget in the header
  final Widget? leading;

  /// Optional trailing widget in the header
  final Widget? trailing;

  /// The main content of the card
  final Widget child;

  /// Optional footer widget
  final Widget? footer;

  /// Card variant
  final GlassCardVariant variant;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the card
  final double borderRadius;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  const GlassStructuredCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.child,
    this.footer,
    this.variant = GlassCardVariant.elevated,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      variant: variant,
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || leading != null || trailing != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) title!,
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: subtitle!,
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              title != null ? 8 : 16,
              16,
              footer != null ? 8 : 16,
            ),
            child: child,
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: footer!,
            ),
        ],
      ),
    );
  }
}
