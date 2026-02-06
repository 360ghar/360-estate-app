import 'package:flutter/material.dart';

/// A button wrapper that provides press animation feedback.
///
/// Scales the button down to 96% of its size when pressed,
/// providing tactile visual feedback. Automatically handles
/// pointer events and restores the scale when released.
///
/// Example:
/// ```dart
/// ButtonPressAnimation(
///   onPressed: () => print('Pressed'),
///   child: GlassButton(label: 'Submit'),
/// )
/// ```
class ButtonPressAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Callback when the button is released (before onPressed)
  final VoidCallback? onRelease;

  /// Scale factor when pressed (default 0.96)
  final double pressedScale;

  /// Duration of the scale animation (default 100ms)
  final Duration duration;

  /// Animation curve (default easeOut)
  final Curve curve;

  /// Whether the button is enabled
  final bool enabled;

  const ButtonPressAnimation({
    super.key,
    required this.child,
    this.onPressed,
    this.onRelease,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.enabled = true,
  });

  @override
  State<ButtonPressAnimation> createState() => _ButtonPressAnimationState();
}

class _ButtonPressAnimationState extends State<ButtonPressAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  void _handlePressDown(PointerDownEvent event) {
    if (!widget.enabled) return;
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
    widget.onRelease?.call();
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePressDown,
      onPointerUp: _handlePressUp,
      onPointerCancel: _handlePressCancel,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A simplified press animation widget that scales on press.
///
/// This is a stateless alternative that uses TweenAnimationBuilder
/// for simpler use cases where you don't need pointer event handling.
class PressScaleAnimation extends StatelessWidget {
  /// The child widget to animate
  final Widget child;

  /// Whether the widget is currently pressed
  final bool isPressed;

  /// Scale factor when pressed (default 0.96)
  final double pressedScale;

  /// Duration of the scale animation (default 100ms)
  final Duration duration;

  /// Animation curve (default easeOut)
  final Curve curve;

  const PressScaleAnimation({
    super.key,
    required this.child,
    this.isPressed = false,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        end: isPressed ? pressedScale : 1.0,
      ),
      duration: duration,
      curve: curve,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// An ink well variant with press scale animation.
///
/// Combines Material ink ripple effect with scale animation
/// for premium button feedback.
class InkWellPressAnimation extends StatelessWidget {
  /// The child widget to animate
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Border radius (matches child's border radius)
  final BorderRadius? borderRadius;

  /// Scale factor when pressed (default 0.96)
  final double pressedScale;

  /// Duration of the scale animation (default 100ms)
  final Duration duration;

  /// Animation curve (default easeOut)
  final Curve curve;

  const InkWellPressAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonPressAnimation(
      onPressed: onTap,
      pressedScale: pressedScale,
      duration: duration,
      curve: curve,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
