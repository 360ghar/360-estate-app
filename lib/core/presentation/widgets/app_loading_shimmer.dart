import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:flutter/material.dart';

/// Skeleton rows while a list loads. The blocks breathe between two surface
/// tones; with reduced motion they hold still.
class AppLoadingShimmer extends StatefulWidget {
  const AppLoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 72,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  @override
  State<AppLoadingShimmer> createState() => _AppLoadingShimmerState();
}

class _AppLoadingShimmerState extends State<AppLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.surfaceContainerHigh;
    final high = context.colors.surfaceContainerHighest;
    return Semantics(
      label: context.l10n.commonLoading,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final color = Color.lerp(base, high, _controller.value)!;
            return ListView.separated(
              padding: widget.padding,
              itemCount: widget.itemCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, _) => Container(
                height: widget.itemHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadii.lg,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
