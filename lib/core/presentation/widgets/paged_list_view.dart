import 'dart:async';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:flutter/material.dart';

class PagedListView<T> extends StatelessWidget {
  const PagedListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onRetry,
    required this.emptyTitle,
    required this.emptyMessage,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.separatorSpacing = AppSpacing.md,
    this.enableStagger = true,
    this.onLoadMoreRetry,
    this.loadMoreErrorMessage =
        'Couldn\u0027t load more. Tap retry to try again.',
  });

  final PagedListState<T> state;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final String emptyTitle;
  final String emptyMessage;
  final EdgeInsetsGeometry padding;
  final double separatorSpacing;

  /// Enable staggered entrance animation for list items
  final bool enableStagger;

  /// Optional retry callback invoked when the user taps the inline
  /// load-more retry button. When null, the retry button is not shown.
  final VoidCallback? onLoadMoreRetry;

  /// Message displayed in the inline load-more error banner.
  final String loadMoreErrorMessage;

  bool _onScroll(ScrollNotification notification) {
    if (state.isLoadingMore) return false;
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const AppLoadingShimmer();
    }

    if (state.error != null && state.items.isEmpty) {
      return AppErrorView(
        title: 'Unable to load',
        message:
            state.error?.message ?? 'Please check your connection and try again.',
        onRetry: onRetry,
        retryLabel: 'Retry',
      );
    }

    if (state.items.isEmpty) {
      return AppEmptyView(title: emptyTitle, message: emptyMessage);
    }

    final showLoadMoreError =
        state.loadMoreError != null && !state.isLoadingMore;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: ListView.separated(
          padding: padding,
          itemCount: state.items.length +
              (state.isLoadingMore || showLoadMoreError ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: separatorSpacing),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              if (showLoadMoreError) {
                return _LoadMoreErrorRow(
                  message: loadMoreErrorMessage,
                  onRetry: onLoadMoreRetry,
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              );
            }

            final child = itemBuilder(context, state.items[index]);

            if (!enableStagger) return child;

            return _StaggeredItem(
              index: index,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class _LoadMoreErrorRow extends StatelessWidget {
  const _LoadMoreErrorRow({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 18,
            color: scheme.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animates a list item with a staggered slide + fade entrance.
class _StaggeredItem extends StatefulWidget {
  const _StaggeredItem({
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Cap the stagger delay so items beyond ~10 don't wait too long
    final delay = (widget.index.clamp(0, 10) * 50);

    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.entranceCurve),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.defaultCurve),
    );

    Future.delayed(Duration(milliseconds: delay), () {
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
