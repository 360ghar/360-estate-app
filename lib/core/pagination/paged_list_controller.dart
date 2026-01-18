import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PageFetcher<T> = Future<Page<T>> Function({
  required int page,
  required int limit,
});

class PagedListState<T> {
  const PagedListState({
    this.items = const [],
    this.page = 1,
    this.limit = 20,
    this.hasMore = true,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
  });

  final List<T> items;
  final int page;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final Failure? error;

  bool get isInitialLoading => isLoading && items.isEmpty;

  PagedListState<T> copyWith({
    List<T>? items,
    int? page,
    int? limit,
    bool? hasMore,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    Failure? error,
  }) {
    return PagedListState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
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
      page: 1,
      hasMore: true,
      items: const [],
    );
    try {
      final page = await _fetchPage(page: 1, limit: state.limit);
      state = state.copyWith(
        items: page.items,
        page: page.page,
        hasMore: page.hasMore,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _mapFailure(error),
      );
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final page = await _fetchPage(page: 1, limit: state.limit);
      state = state.copyWith(
        items: page.items,
        page: page.page,
        hasMore: page.hasMore,
        isRefreshing: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(
        isRefreshing: false,
        error: _mapFailure(error),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.page + 1;
      final page = await _fetchPage(page: nextPage, limit: state.limit);
      state = state.copyWith(
        items: [...state.items, ...page.items],
        page: page.page,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

Failure? _mapFailure(Object error) {
  if (error is Failure) return error;
  return null;
}
