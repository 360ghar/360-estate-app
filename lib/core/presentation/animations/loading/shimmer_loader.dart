import 'package:flutter/material.dart';

/// A premium shimmer loading widget with gradient animation.
///
/// Provides a sophisticated loading skeleton with animated gradient
/// that creates a shimmer effect across the child widgets.
///
/// Example:
/// ```dart
/// ShimmerLoader(
///   child: Column(
///     children: [
///       ShimmerBox(width: 200, height: 20),
///       ShimmerBox(width: 150, height: 16),
///     ],
///   ),
/// )
/// ```
class ShimmerLoader extends StatefulWidget {
  /// The child widget to display shimmer effect on
  final Widget child;

  /// Base color of the shimmer (when not highlighted)
  final Color? baseColor;

  /// Highlight color of the shimmer
  final Color? highlightColor;

  /// Duration of the shimmer animation cycle
  final Duration duration;

  /// Direction of the shimmer animation
  final ShimmerDirection direction;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1200),
    this.direction = ShimmerDirection.leftToRight,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer(
      controller: _controller,
      direction: widget.direction,
      baseColor: widget.baseColor ??
          (isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFF1F5F9)),
      highlightColor: widget.highlightColor ??
          (isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0)),
      child: widget.child,
    );
  }
}

/// Direction of shimmer animation
enum ShimmerDirection {
  /// Shimmer moves from left to right
  leftToRight,

  /// Shimmer moves from right to left
  rightToLeft,

  /// Shimmer moves from top to bottom
  topToBottom,

  /// Shimmer moves from bottom to top
  bottomToTop,

  /// Shimmer radiates from center
  radial,
}

/// The actual shimmer widget that applies the gradient effect
class Shimmer extends StatelessWidget {
  /// Animation controller that drives the shimmer
  final AnimationController controller;

  /// Direction of the shimmer
  final ShimmerDirection direction;

  /// Base color when not highlighted
  final Color baseColor;

  /// Highlight color during shimmer
  final Color highlightColor;

  /// The child to apply shimmer to
  final Widget child;

  const Shimmer({
    super.key,
    required this.controller,
    this.direction = ShimmerDirection.leftToRight,
    required this.baseColor,
    required this.highlightColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final gradient = _buildGradient();
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: child,
        );
      },
    );
  }

  LinearGradient _buildGradient() {
    final stops = [0.0, 0.5, 1.0];
    final beginOffset = _getBeginOffset();
    final endOffset = _getEndOffset();

    return LinearGradient(
      begin: beginOffset,
      end: endOffset,
      colors: [
        baseColor,
        highlightColor,
        baseColor,
      ],
      stops: stops,
      transform: _SlidingGradientTransform(
        slidePercent: controller.value,
        direction: direction,
      ),
    );
  }

  Alignment _getBeginOffset() {
    switch (direction) {
      case ShimmerDirection.leftToRight:
      case ShimmerDirection.topToBottom:
      case ShimmerDirection.radial:
        return Alignment.centerLeft;
      case ShimmerDirection.rightToLeft:
      case ShimmerDirection.bottomToTop:
        return Alignment.centerRight;
    }
  }

  Alignment _getEndOffset() {
    switch (direction) {
      case ShimmerDirection.leftToRight:
      case ShimmerDirection.topToBottom:
      case ShimmerDirection.radial:
        return Alignment.centerRight;
      case ShimmerDirection.rightToLeft:
      case ShimmerDirection.bottomToTop:
        return Alignment.centerLeft;
    }
  }
}

/// Custom gradient transform for sliding shimmer effect
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  final ShimmerDirection direction;

  _SlidingGradientTransform({
    required this.slidePercent,
    required this.direction,
  });

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    double dx = 0.0;
    double dy = 0.0;

    switch (direction) {
      case ShimmerDirection.leftToRight:
        dx = bounds.width * (slidePercent - 0.5);
        break;
      case ShimmerDirection.rightToLeft:
        dx = bounds.width * (0.5 - slidePercent);
        break;
      case ShimmerDirection.topToBottom:
        dy = bounds.height * (slidePercent - 0.5);
        break;
      case ShimmerDirection.bottomToTop:
        dy = bounds.height * (0.5 - slidePercent);
        break;
      case ShimmerDirection.radial:
        dx = bounds.width * (slidePercent - 0.5);
        dy = bounds.height * (slidePercent - 0.5);
        break;
    }

    return Matrix4.translationValues(dx, dy, 0.0);
  }
}

/// A single shimmer box for skeleton loading
class ShimmerBox extends StatelessWidget {
  /// Width of the box
  final double? width;

  /// Height of the box
  final double? height;

  /// Border radius of the box
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A shimmer loading card that displays a skeleton card layout
class ShimmerCard extends StatelessWidget {
  /// Width of the card
  final double? width;

  /// Whether to show an avatar circle
  final bool showAvatar;

  /// Number of shimmer lines to display
  final int lineCount;

  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.showAvatar = true,
    this.lineCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (showAvatar) ...[
                const ShimmerBox(width: 48, height: 48, borderRadius: 24),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < lineCount; i++) ...[
                      ShimmerBox(
                        width: i == lineCount - 1
                            ? double.infinity
                            : (i == 0 ? 120 : 200),
                        height: i == 0 ? 16 : 12,
                        borderRadius: 4,
                      ),
                      if (i < lineCount - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A shimmer list that displays multiple shimmer cards
class ShimmerList extends StatelessWidget {
  /// Number of shimmer items to display
  final int itemCount;

  /// Whether to show avatars in each item
  final bool showAvatar;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ShimmerCard(showAvatar: showAvatar),
        );
      },
    );
  }
}
