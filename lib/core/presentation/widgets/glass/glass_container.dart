import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';

/// A glassmorphism container with frosted glass effect.
///
/// Uses BackdropFilter with blur to create the signature glass effect.
/// Highly customizable with gradient, border, shadow, and opacity options.
///
/// Example:
/// ```dart
/// GlassContainer(
///   blur: AppGlassBlur.medium,
///   opacity: 0.7,
///   child: Text('Glass effect!'),
/// )
/// ```
class GlassContainer extends StatelessWidget {
  /// The child widget inside the glass container
  final Widget child;

  /// Blur sigma value (use AppGlassBlur constants)
  final double blur;

  /// Opacity of the glass surface (0.0 to 1.0)
  final double opacity;

  /// Optional gradient for the glass surface
  final Gradient? gradient;

  /// Border radius of the container
  final double borderRadius;

  /// Optional border for the container
  final BoxBorder? border;

  /// Optional shadow for the container
  final List<BoxShadow>? shadow;

  /// Optional padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  /// Whether to clip the content to the border radius
  final bool clipContent;

  /// Background color (with opacity applied)
  final Color? color;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.gradient,
    this.borderRadius = 12,
    this.border,
    this.shadow,
    this.padding,
    this.width,
    this.height,
    this.clipContent = true,
    this.color,
  });

  /// Creates a light glass container (white with opacity)
  factory GlassContainer.light({
    Key? key,
    required Widget child,
    double blur = AppGlassBlur.medium,
    double opacity = AppGlassColors.opacityMedium,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    List<BoxShadow>? shadow,
  }) {
    return GlassContainer(
      key: key,
      child: child,
      blur: blur,
      opacity: opacity,
      color: Colors.white,
      borderRadius: borderRadius,
      padding: padding,
      width: width,
      height: height,
      shadow: shadow ?? AppShadows.glass,
    );
  }

  /// Creates a dark glass container (dark with opacity)
  factory GlassContainer.dark({
    Key? key,
    required Widget child,
    double blur = AppGlassBlur.medium,
    double opacity = AppGlassColors.opacityMedium,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    List<BoxShadow>? shadow,
  }) {
    return GlassContainer(
      key: key,
      child: child,
      blur: blur,
      opacity: opacity,
      color: const Color(0xFF1E293B),
      borderRadius: borderRadius,
      padding: padding,
      width: width,
      height: height,
      shadow: shadow ?? AppShadows.glassDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color?.withOpacity(opacity) ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppGlassColors.glassSurfaceDark(opacity)
            : AppGlassColors.glassSurfaceLight(opacity));

    final container = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppGlassColors.borderDark
                  : AppGlassColors.borderLight,
              width: 1,
            ),
        boxShadow: shadow,
      ),
      child: clipContent
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child,
            )
          : child,
    );

    if (blur <= 0) {
      return container;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: container,
      ),
    );
  }
}

/// A glass container with gradient border.
///
/// Creates a premium glass effect with animated or static gradient border.
class GlassGradientContainer extends StatelessWidget {
  /// The child widget inside the container
  final Widget child;

  /// Gradient for the border
  final Gradient borderGradient;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the container
  final double borderRadius;

  /// Border width
  final double borderWidth;

  /// Optional padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  const GlassGradientContainer({
    super.key,
    required this.child,
    required this.borderGradient,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 12,
    this.borderWidth = 2,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(borderWidth),
      child: GlassContainer(
        blur: blur,
        opacity: opacity,
        borderRadius: borderRadius - borderWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A glass panel with header and content sections.
///
/// Provides a pre-styled glass container for common UI patterns.
class GlassPanel extends StatelessWidget {
  /// Optional title widget for the panel header
  final Widget? title;

  /// Optional leading widget in the header
  final Widget? leading;

  /// Optional trailing widget in the header
  final Widget? trailing;

  /// The main content of the panel
  final Widget child;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the panel
  final double borderRadius;

  /// Optional padding for the content
  final EdgeInsetsGeometry? contentPadding;

  const GlassPanel({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    required this.child,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 16,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || leading != null || trailing != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(child: title ?? const SizedBox.shrink()),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Padding(
            padding: contentPadding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
