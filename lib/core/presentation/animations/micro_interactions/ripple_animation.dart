import 'package:flutter/material.dart';

/// A custom ripple animation widget for premium feedback.
///
/// Provides a configurable ripple effect that expands from the tap position.
/// Ideal for glass buttons and custom interactive elements.
class RippleAnimation extends StatefulWidget {
  /// The child widget that receives taps
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Ripple color
  final Color? rippleColor;

  /// Border radius for clipping the ripple
  final BorderRadius? borderRadius;

  /// Ripple size multiplier (default 2.0)
  final double rippleSize;

  /// Duration of the ripple animation
  final Duration duration;

  /// Whether the ripple is enabled
  final bool enabled;

  const RippleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.borderRadius,
    this.rippleSize = 2.0,
    this.duration = const Duration(milliseconds: 400),
    this.enabled = true,
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  final List<_Ripple> _ripples = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener(_handleStatus);
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _ripples.clear();
      });
    }
  }

  void _addRipple(TapDownDetails details) {
    if (!widget.enabled) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final size = renderBox.size;

    // Calculate max distance from tap position to corner
    final dx = (localPosition.dx - size.width / 2).abs();
    final dy = (localPosition.dy - size.height / 2).abs();
    final maxRadius = (dx * dx + dy * dy) * widget.rippleSize;

    final ripple = _Ripple(
      position: localPosition,
      maxRadius: maxRadius,
      color: widget.rippleColor ?? Colors.white.withOpacity(0.3),
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
    );

    setState(() {
      _ripples.add(ripple);
    });

    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _addRipple,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: [
            widget.child,
            ..._ripples.map(
              (ripple) => _RippleWidget(
                ripple: ripple,
                size: MediaQuery.sizeOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ripple {
  final Offset position;
  final double maxRadius;
  final Color color;
  final Animation<double> animation;

  _Ripple({
    required this.position,
    required this.maxRadius,
    required this.color,
    required this.animation,
  });
}

class _RippleWidget extends StatelessWidget {
  final _Ripple ripple;
  final Size size;

  const _RippleWidget({
    required this.ripple,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ripple.animation,
      builder: (context, child) {
        final radius = ripple.maxRadius * ripple.animation.value;
        final opacity = 1 - ripple.animation.value;

        return Positioned(
          left: ripple.position.dx - radius,
          top: ripple.position.dy - radius,
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ripple.color.withOpacity(opacity),
            ),
          ),
        );
      },
    );
  }
}

/// A subtle pulse animation that can be used for various purposes.
///
/// Continuously animates the scale and opacity to create a breathing effect.
class PulseAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Pulse scale (default 1.05)
  final double pulseScale;

  /// Pulse duration (default 1 second)
  final Duration duration;

  /// Whether to pulse
  final bool pulsing;

  const PulseAnimation({
    super.key,
    required this.child,
    this.pulseScale = 1.05,
    this.duration = const Duration(seconds: 1),
    this.pulsing = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.pulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing != oldWidget.pulsing) {
      if (widget.pulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
