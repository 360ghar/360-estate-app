import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:flutter/material.dart';

/// True when the user asked the system to reduce motion.
bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Moves [child] up into place the first time it builds. Only the position
/// animates: the child is fully visible from the first frame, so a paused or
/// skipped animation never hides content. Rows after the eighth do not wait.
class RiseIn extends StatefulWidget {
  const RiseIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  State<RiseIn> createState() => _RiseInState();
}

class _RiseInState extends State<RiseIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.slow,
  );
  late final Animation<double> _offset = Tween<double>(begin: 12, end: 0)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (widget.index.clamp(0, 8) * 0.06).toDouble(),
            1,
            curve: AppDurations.entranceCurve,
          ),
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduced motion wins, also while the entrance runs.
    if (reduceMotion(context)) {
      _controller.value = 1;
      return;
    }
    if (_controller.isAnimating || _controller.isCompleted) return;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _offset,
    builder: (context, child) =>
        Transform.translate(offset: Offset(0, _offset.value), child: child),
    child: widget.child,
  );
}
