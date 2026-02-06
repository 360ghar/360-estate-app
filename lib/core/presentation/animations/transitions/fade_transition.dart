import 'package:flutter/material.dart';

/// A fade-through transition widget for smooth page and element transitions.
///
/// Provides a professional fade-in effect with configurable duration and curve.
/// Ideal for page transitions, modal appearances, and element reveals.
class FadeThroughTransition extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Duration of the fade animation (default 300ms)
  final Duration duration;

  /// Animation curve (default easeOut)
  final Curve curve;

  /// Delay before starting the animation
  final Duration delay;

  /// Whether to animate on first build
  final bool animateOnBuild;

  /// Optional callback when animation completes
  final VoidCallback? onEnd;

  const FadeThroughTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.delay = Duration.zero,
    this.animateOnBuild = true,
    this.onEnd,
  });

  @override
  State<FadeThroughTransition> createState() => _FadeThroughTransitionState();
}

class _FadeThroughTransitionState extends State<FadeThroughTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.animateOnBuild) {
      _startAnimation();
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
  void didUpdateWidget(FadeThroughTransition oldWidget) {
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}

/// A fade-through transition with slide effect for page transitions.
///
/// Combines fade and slide for a more dynamic transition effect.
/// Ideal for page-to-page navigation.
class FadeSlideTransition extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Duration of the animation (default 350ms)
  final Duration duration;

  /// Animation curve (default easeOutCubic)
  final Curve curve;

  /// Slide offset (default slide up from bottom)
  final Offset slideOffset;

  /// Delay before starting the animation
  final Duration delay;

  /// Whether to animate on first build
  final bool animateOnBuild;

  /// Optional callback when animation completes
  final VoidCallback? onEnd;

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0, 0.1),
    this.delay = Duration.zero,
    this.animateOnBuild = true,
    this.onEnd,
  });

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.animateOnBuild) {
      _startAnimation();
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
  void didUpdateWidget(FadeSlideTransition oldWidget) {
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
