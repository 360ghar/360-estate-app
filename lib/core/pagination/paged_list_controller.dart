import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sentinel used by [PagedListState.copyWith] to distinguish "not provided"
/// from an explicitly-passed `null` cursor.
const _unset = Object();

typedef PageFetcher<T> = Future<Page<T>> Function({
  required String? cursor,
  required int limit,
});

class PagedListState<T> {
  const PagedListState({
    this.items = const [],
    this.limit = 20,
    this.nextCursor,
    this.hasMore = true,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
  });

  final List<T> items;
  final int limit;

  /// Opaque cursor for the next page. `null` on the first page or when the
  /// terminal page has been reached.
  final String? nextCursor;

  /// `false` once the backend reports no more items.
  final bool hasMore;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final Failure? error;

  /// Error raised by the most recent [PagedListController.loadMore] attempt.
  ///
  /// Distinct from [error] so the UI can keep the loaded page visible while
  /// still surfacing a retry affordance for the next-page request.
  final Object? loadMoreError;

  bool get isInitialLoading => isLoading && items.isEmpty;

  PagedListState<T> copyWith({
    List<T>? items,
    int? limit,
    Object? nextCursor = _unset,
    bool? hasMore,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    Object? error = _unset,
    Object? loadMoreError = _unset,
  }) {
    return PagedListState<T>(
      items: items ?? this.items,
      limit: limit ?? this.limit,
      nextCursor: identical(nextCursor, _unset)
          ? this.nextCursor
          : nextCursor as String?,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _unset) ? this.error : error as Failure?,
      loadMoreError: identical(loadMoreError, _unset)
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

class PagedListController<T> extends StateNotifier<PagedListState<T>> {
  PagedListController({
    required PageFetcher<T> fetchPage,
    int pageSize = 20,
  })  : _fetchPage = fetchPage,
        super(PagedListState<T>(limit: pageSize)) {
    unawaited(loadInitial());
  }

  final PageFetcher<T> _fetchPage;

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(
      isLoading: true,
      error: null,
      loadMoreError: null,
      nextCursor: null,
      hasMore: true,
      items: const [],
    );
    try {
      final page = await _fetchPage(cursor: null, limit: state.limit);
      state = state.copyWith(
        items: page.items,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isLoading: false,
        error: null,
        loadMoreError: null,
      );
    } catch (error) {
      // Mark pagination as exhausted so the UI does not keep firing
      // loadMore() against a broken endpoint (see B12).
      state = state.copyWith(
        isLoading: false,
        error: _mapFailure(error),
        hasMore: false,
        nextCursor: null,
      );
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(
      isRefreshing: true,
      error: null,
      loadMoreError: null,
    );
    try {
      final page = await _fetchPage(cursor: null, limit: state.limit);
      state = state.copyWith(
        items: page.items,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isRefreshing: false,
        error: null,
        loadMoreError: null,
      );
    } catch (error) {
      // Same recovery rule as loadInitial (see B12).
      state = state.copyWith(
        isRefreshing: false,
        error: _mapFailure(error),
        hasMore: false,
        nextCursor: null,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.nextCursor == null ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isRefreshing) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);
    try {
      final page =
          await _fetchPage(cursor: state.nextCursor, limit: state.limit);
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isLoadingMore: false,
        loadMoreError: null,
      );
    } catch (error, stackTrace) {
      // Surface the failure to the UI instead of swallowing it (B11). We
      // also reset hasMore so a persistent failure does not produce an
      // infinite retry loop on scroll.
      AppLogger.w(
        'PagedListController.loadMore failed',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: error,
        hasMore: false,
      );
    }
  }

  /// Convenience for retry buttons: clears [loadMoreError] and re-runs
  /// [loadMore] only when there is still something to fetch.
  Future<void> retryLoadMore() async {
    if (state.loadMoreError == null) return;
    state = state.copyWith(hasMore: state.nextCursor != null);
    await loadMore();
  }
}

Failure? _mapFailure(Object error) {
  if (error is Failure) return error;
  return null;
}
