import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Premium fade transition with slide effect for page transitions.
///
/// Uses smooth easing curves and subtle slide animation for
/// a premium feel during page transitions.
class PremiumFadeTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset slideOffset;
  final bool slide;

  const PremiumFadeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = const Offset(0, 0.03),
    this.slide = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: slide
              ? Transform.translate(
                  offset: slideOffset * (1 - value),
                  child: child,
                )
              : child,
        );
      },
      child: child,
    );
  }
}

/// Staggered animation for list items with smooth fade and slide.
///
/// Each child animates with a delay based on its index,
/// creating a cascading premium effect.
class PremiumStaggeredList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Duration staggerDelay;
  final Duration itemDuration;

  const PremiumStaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = const Duration(milliseconds: 60),
    this.itemDuration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < itemCount; i++)
          _StaggeredItem(
            index: i,
            delay: Duration(milliseconds: staggerDelay.inMilliseconds * i),
            duration: itemDuration,
            child: itemBuilder(context, i),
          ),
      ],
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final int index;
  final Duration delay;
  final Duration duration;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.delay,
    required this.duration,
    required this.child,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
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
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
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

/// Premium scale animation with elastic bounce effect.
///
/// Perfect for success states, button presses, or
/// drawing attention to elements.
class PremiumScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double beginScale;
  final double endScale;
  final bool autoPlay;
  final bool bounce;

  const PremiumScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.autoPlay = true,
    this.bounce = false,
  });

  @override
  State<PremiumScaleAnimation> createState() => _PremiumScaleAnimationState();
}

class _PremiumScaleAnimationState extends State<PremiumScaleAnimation>
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

    final curve = widget.bounce
        ? Curves.elasticOut
        : Curves.easeOutCubic;

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  void forward() => _controller.forward();
  void reverse() => _controller.reverse();
  void reset() => _controller.reset();

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

/// Premium shimmer effect for loading states.
///
/// Creates a smooth, subtle shimmer animation across
/// the child widget.
class PremiumShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const PremiumShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF1F2937),
    this.highlightColor = const Color(0xFF374151),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PremiumShimmer> createState() => _PremiumShimmerState();
}

class _PremiumShimmerState extends State<PremiumShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Premium pulse animation for drawing attention.
///
/// Creates a smooth pulsing effect with opacity and scale changes.
class PremiumPulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final double minOpacity;
  final double maxOpacity;

  const PremiumPulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 1.0,
    this.maxScale = 1.05,
    this.minOpacity = 0.8,
    this.maxOpacity = 1.0,
  });

  @override
  State<PremiumPulseAnimation> createState() => _PremiumPulseAnimationState();
}

class _PremiumPulseAnimationState extends State<PremiumPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Premium rotation animation.
///
/// Smooth rotation with configurable duration and curve.
class PremiumRotationAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double turns;
  final bool autoPlay;
  final bool infinite;

  const PremiumRotationAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.turns = 1.0,
    this.autoPlay = true,
    this.infinite = false,
  });

  @override
  State<PremiumRotationAnimation> createState() => _PremiumRotationAnimationState();
}

class _PremiumRotationAnimationState extends State<PremiumRotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0, end: widget.turns).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.autoPlay) {
      if (widget.infinite) {
        _controller.repeat();
      } else {
        _controller.forward();
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
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}

/// Premium blur transition animation.
///
/// Smoothly animates blur effect from clear to blurred or vice versa.
class PremiumBlurTransition extends StatefulWidget {
  final Widget child;
  final double beginBlur;
  final double endBlur;
  final Duration duration;
  final bool autoPlay;

  const PremiumBlurTransition({
    super.key,
    required this.child,
    this.beginBlur = 0.0,
    this.endBlur = 10.0,
    this.duration = const Duration(milliseconds: 300),
    this.autoPlay = true,
  });

  @override
  State<PremiumBlurTransition> createState() => _PremiumBlurTransitionState();
}

class _PremiumBlurTransitionState extends State<PremiumBlurTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.beginBlur,
      end: widget.endBlur,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _animation.value, sigmaY: _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Premium page transition for navigation.
///
/// Provides smooth, premium page transitions with fade and slide effects.
class PremiumPageTransition extends PageRouteBuilder<void> {
  final Widget child;

  PremiumPageTransition({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}
