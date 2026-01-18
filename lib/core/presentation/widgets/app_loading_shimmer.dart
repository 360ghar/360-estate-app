import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

class AppLoadingShimmer extends StatefulWidget {
  const AppLoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 68,
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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHighest;
    final highlight = scheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2;
        final lerp = t <= 1 ? t : 2 - t;
        final color = Color.lerp(base, highlight, lerp) ?? base;

        return ListView.separated(
          padding: widget.padding,
          itemCount: widget.itemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            return Container(
              height: widget.itemHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.lg,
              ),
            );
          },
        );
      },
    );
  }
}
