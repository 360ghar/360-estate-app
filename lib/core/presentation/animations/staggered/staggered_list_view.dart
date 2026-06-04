import 'dart:async';
import 'package:flutter/material.dart';

/// A ListView with staggered item animations.
///
/// Items animate in as they become visible, with each item
/// starting a short delay after the previous one.
///
/// Example:
/// ```dart
/// StaggeredListView(
///   itemCount: items.length,
///   itemBuilder: (context, index) => ListTile(title: Text(items[index])),
///   staggerDelay: Duration(milliseconds: 50),
/// )
/// ```
class StaggeredListView extends StatelessWidget {
  /// Number of items in the list
  final int itemCount;

  /// Builder for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each item's animation start
  final Duration staggerDelay;

  /// Duration of each item's animation
  final Duration itemDuration;

  /// Animation curve
  final Curve curve;

  /// Optional separator between items
  final Widget? separator;

  /// Scroll physics (default is ClampingScrollPhysics)
  final ScrollPhysics? physics;

  /// Padding around the list
  final EdgeInsets? padding;

  /// Whether the list is reversed
  final bool reverse;

  /// The axis along which the list scrolls
  final Axis scrollDirection;

  const StaggeredListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.separator,
    this.physics,
    this.padding,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: physics,
      padding: padding,
      reverse: reverse,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      separatorBuilder: separator != null
          ? (context, index) => separator!
          : (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        return _StaggeredListItem(
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

class _StaggeredListItem extends StatefulWidget {
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const _StaggeredListItem({
    required this.index,
    required this.delay,
    required this.duration,
    required this.curve,
    required this.child,
  });

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
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

/// A staggered SliverList for use in CustomScrollView.
///
/// Provides the same staggered animation effect but as a sliver
/// for integration with custom scroll views.
class StaggeredSliverList extends StatelessWidget {
  /// Number of items in the list
  final int itemCount;

  /// Builder for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each item's animation start
  final Duration staggerDelay;

  /// Duration of each item's animation
  final Duration itemDuration;

  /// Animation curve
  final Curve curve;

  /// Optional separator between items
  final Widget? separator;

  const StaggeredSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = _StaggeredListItem(
            index: index,
            delay:
                Duration(milliseconds: staggerDelay.inMilliseconds * index),
            duration: itemDuration,
            curve: curve,
            child: itemBuilder(context, index),
          );

          // Add separator if not the last item
          if (separator != null && index < itemCount - 1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                item,
                separator!,
              ],
            );
          }

          return item;
        },
        childCount: itemCount,
      ),
    );
  }
}

/// A staggered list builder that animates items based on visibility.
///
/// Unlike StaggeredListView, this uses an AnimatedList to animate
/// items as they're added or removed.
class AnimatedStaggeredList extends StatefulWidget {
  /// Number of items in the list
  final int itemCount;

  /// Builder for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each item's animation start
  final Duration staggerDelay;

  /// Duration of each item's animation
  final Duration itemDuration;

  /// Animation curve
  final Curve curve;

  const AnimatedStaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedStaggeredList> createState() => _AnimatedStaggeredListState();
}

class _AnimatedStaggeredListState extends State<AnimatedStaggeredList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<_ListItemModel> _items;

  @override
  void initState() {
    super.initState();
    _items = List.generate(
      widget.itemCount,
      (index) => _ListItemModel(key: ValueKey(index)),
    );

    // Stagger the initial item insertion
    _insertItemsStaggered();
  }

  void _insertItemsStaggered() async {
    for (int i = 0; i < _items.length; i++) {
      await Future<void>.delayed(widget.staggerDelay);
      if (mounted) {
        _listKey.currentState?.insertItem(i);
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedStaggeredList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != oldWidget.itemCount) {
      // Handle item count changes
      _items = List.generate(
        widget.itemCount,
        (index) => _ListItemModel(key: ValueKey(index)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      itemBuilder: (context, index, animation) {
        return _buildAnimatedItem(widget.itemBuilder(context, index), animation);
      },
    );
  }

  Widget _buildAnimatedItem(Widget item, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: widget.curve,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: widget.curve,
        )),
        child: item,
      ),
    );
  }
}

class _ListItemModel {
  final Key key;
  _ListItemModel({required this.key});
}
