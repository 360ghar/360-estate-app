import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:flutter/material.dart';

/// The one list shell: skeleton, error with retry, empty state, rows, load
/// more. Every state can be pulled to refresh.
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
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyAction,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.separatorSpacing = AppSpacing.md,
    this.enableStagger = true,
    this.onLoadMoreRetry,
    this.header,
  });

  final PagedListState<T> state;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget? emptyAction;
  final EdgeInsetsGeometry padding;
  final double separatorSpacing;

  /// Rows rise into place the first time they show.
  final bool enableStagger;
  final VoidCallback? onLoadMoreRetry;

  /// Scrolls with the list, above the first row.
  final Widget? header;

  bool _onScroll(ScrollNotification notification) {
    if (state.isLoadingMore || !state.hasMore) return false;
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) return const AppLoadingShimmer();

    if (state.items.isEmpty) {
      final failure = state.error;
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: StateScrollView(
          child: failure != null
              ? AppErrorView(
                  title: context.l10n.commonLoadFailedTitle,
                  message: failure.localizedMessage(context.l10n),
                  onRetry: onRetry,
                )
              : AppEmptyView(
                  title: emptyTitle,
                  message: emptyMessage,
                  icon: emptyIcon,
                  action: emptyAction,
                ),
        ),
      );
    }

    final showLoadMoreError =
        state.loadMoreError != null && !state.isLoadingMore;
    final lead = header == null ? 0 : 1;
    final tail = state.isLoadingMore || showLoadMoreError ? 1 : 0;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          itemCount: lead + state.items.length + tail,
          separatorBuilder: (_, _) => SizedBox(height: separatorSpacing),
          itemBuilder: (context, index) {
            if (index < lead) return header!;
            final i = index - lead;
            if (i >= state.items.length) {
              if (showLoadMoreError) {
                return _LoadMoreError(onRetry: onLoadMoreRetry);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      semanticsLabel: context.l10n.commonLoading,
                    ),
                  ),
                ),
              );
            }
            final child = itemBuilder(context, state.items[i]);
            return enableStagger ? RiseIn(index: i, child: child) : child;
          },
        ),
      ),
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.cloud_off_rounded, size: 18, color: context.colors.error),
      const SizedBox(width: AppSpacing.sm),
      Flexible(
        child: Text(
          context.l10n.commonLoadMoreFailed,
          style: context.text.bodyMedium?.copyWith(color: context.colors.error),
        ),
      ),
      if (onRetry != null)
        TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
    ],
  );
}
