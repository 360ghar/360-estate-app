import 'package:flutter/material.dart';

/// A builder that creates staggered animations for list items.
///
/// Each child is animated with a delay based on its index,
/// creating a cascading animation effect.
///
/// Example:
/// ```dart
/// StaggeredAnimationBuilder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => ListTile(title: Text(items[index])),
///   staggerDelay: Duration(milliseconds: 50),
/// )
/// ```
class StaggeredAnimationBuilder extends StatelessWidget {
  /// The number of children to animate
  final int itemCount;

  /// Builder for each child
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each child's animation start
  final Duration staggerDelay;

  /// Duration of each child's animation
  final Duration itemDuration;

  /// Animation curve
  final Curve curve;

  /// Direction of the stagger (forward or reverse)
  final bool reverse;

  /// Optional separator builder
  final Widget? Function(BuildContext context, int index)? separatorBuilder;

  const StaggeredAnimationBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.reverse = false,
    this.separatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < itemCount; i++) ...[
          _StaggeredItem(
            index: reverse ? itemCount - 1 - i : i,
            delay: Duration(milliseconds: staggerDelay.inMilliseconds * i),
            duration: itemDuration,
            curve: curve,
            child: itemBuilder(context, i),
          ),
          if (separatorBuilder != null && i < itemCount - 1)
            separatorBuilder!(context, i) ?? const SizedBox.shrink(),
        ],
      ],
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.delay,
    required this.duration,
    required this.curve,
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
      curve: widget.curve,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after the calculated delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
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

/// A grid variant of staggered animations.
///
/// Creates a staggered animation effect for grid items.
class StaggeredGridBuilder extends StatelessWidget {
  /// Number of items in the grid
  final int itemCount;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Builder for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each item's animation
  final Duration staggerDelay;

  /// Duration of each item's animation
  final Duration itemDuration;

  /// Animation curve
  final Curve curve;

  /// Spacing between items
  final double spacing;

  /// Main axis spacing
  final double runSpacing;

  /// Aspect ratio of each item
  final double? childAspectRatio;

  const StaggeredGridBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.spacing = 8,
    this.runSpacing = 8,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _StaggeredItem(
          index: index,
          delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
          duration: itemDuration,
          curve: curve,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// A flexible staggered animation widget that accepts any child type.
///
/// Use this for custom staggered layouts where you need full control
/// over the widget structure.
class StaggeredAnimation extends StatelessWidget {
  /// The child to animate
  final Widget child;

  /// Delay before starting the animation
  final Duration delay;

  /// Duration of the animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to include slide animation
  final bool slide;

  /// Slide offset (if slide is true)
  final Offset slideOffset;

  const StaggeredAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.slide = true,
    this.slideOffset = const Offset(0, 0.1),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
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
