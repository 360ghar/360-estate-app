import 'dart:async';
import 'package:flutter/material.dart';

/// Slide direction for slide transitions
enum SlideDirection {
  /// Slide from left to right
  fromLeft,

  /// Slide from right to left
  fromRight,

  /// Slide from top to bottom
  fromTop,

  /// Slide from bottom to top
  fromBottom,
}

/// A slide transition widget with configurable direction and curve.
///
/// Provides smooth slide-in animations for any widget.
/// Ideal for page transitions, drawer slides, and element reveals.
class SlideTransitionWidget extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Direction to slide from
  final SlideDirection direction;

  /// Duration of the slide animation (default 300ms)
  final Duration duration;

  /// Animation curve (default easeOutCubic)
  final Curve curve;

  /// Delay before starting the animation
  final Duration delay;

  /// Whether to animate on first build
  final bool animateOnBuild;

  /// Optional callback when animation completes
  final VoidCallback? onEnd;

  const SlideTransitionWidget({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.delay = Duration.zero,
    this.animateOnBuild = true,
    this.onEnd,
  });

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

class _SlideTransitionWidgetState extends State<SlideTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final beginOffset = _getBeginOffset();

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.animateOnBuild) {
      _startAnimation();
    }
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return const Offset(-1, 0);
      case SlideDirection.fromRight:
        return const Offset(1, 0);
      case SlideDirection.fromTop:
        return const Offset(0, -1);
      case SlideDirection.fromBottom:
        return const Offset(0, 1);
    }
  }

  void _startAnimation() {
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward().then((_) => widget.onEnd?.call());
        }
      });
    } else {
      _controller.forward().then((_) => widget.onEnd?.call());
    }
  }

  @override
  void didUpdateWidget(SlideTransitionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateOnBuild && !oldWidget.animateOnBuild) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}

/// A slide transition with combined fade effect.
///
/// Provides a premium transition that combines slide and fade
/// for a more polished appearance.
class SlideFadeTransition extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Direction to slide from
  final SlideDirection direction;

  /// Duration of the animation (default 350ms)
  final Duration duration;

  /// Animation curve (default easeOutCubic)
  final Curve curve;

  /// Delay before starting the animation
  final Duration delay;

  /// Whether to animate on first build
  final bool animateOnBuild;

  /// Optional callback when animation completes
  final VoidCallback? onEnd;

  const SlideFadeTransition({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.delay = Duration.zero,
    this.animateOnBuild = true,
    this.onEnd,
  });

  @override
  State<SlideFadeTransition> createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final beginOffset = _getBeginOffset();

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.animateOnBuild) {
      _startAnimation();
    }
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return const Offset(-0.3, 0);
      case SlideDirection.fromRight:
        return const Offset(0.3, 0);
      case SlideDirection.fromTop:
        return const Offset(0, -0.3);
      case SlideDirection.fromBottom:
        return const Offset(0, 0.3);
    }
  }

  void _startAnimation() {
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward().then((_) => widget.onEnd?.call());
        }
      });
    } else {
      _controller.forward().then((_) => widget.onEnd?.call());
    }
  }

  @override
  void didUpdateWidget(SlideFadeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateOnBuild && !oldWidget.animateOnBuild) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
