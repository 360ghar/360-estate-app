import 'package:estate_app/core/pagination/paged_list_controller.dart';
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

  bool _onScroll(ScrollNotification notification) {
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
        message: state.error?.message ?? 'Please check your connection and try again.',
        onRetry: onRetry,
        retryLabel: 'Retry',
      );
    }

    if (state.items.isEmpty) {
      return AppEmptyView(title: emptyTitle, message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: ListView.separated(
          padding: padding,
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: separatorSpacing),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return itemBuilder(context, state.items[index]);
          },
        ),
      ),
    );
  }
}
