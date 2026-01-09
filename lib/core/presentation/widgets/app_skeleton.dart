import 'package:flutter/material.dart';

/// Skeleton loader widget for showing placeholder content while data loads.
/// Provides better perceived performance than a simple spinner.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: _animation.value,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

/// Pre-defined skeleton shapes for common UI patterns
class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          AppSkeleton(
            height: 160,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                const AppSkeleton(
                  height: 20,
                  width: 200,
                ),
                const SizedBox(height: 8),
                // Address placeholder
                AppSkeleton(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 16),
                // Features row
                Row(
                  children: [
                    const AppSkeleton(width: 60, height: 16),
                    const SizedBox(width: 16),
                    AppSkeleton(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 16,
                    ),
                    const Spacer(),
                    const AppSkeleton(width: 80, height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Avatar placeholder
          const AppSkeleton(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSkeleton(height: 16, width: 150),
                const SizedBox(height: 8),
                AppSkeleton(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceCardSkeleton extends StatelessWidget {
  const FinanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 16,
              ),
              const AppSkeleton(width: 60, height: 20),
            ],
          ),
          const SizedBox(height: 8),
          const AppSkeleton(height: 14, width: 100),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppSkeleton(height: 12, width: 40),
                  SizedBox(height: 4),
                  AppSkeleton(height: 16, width: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
