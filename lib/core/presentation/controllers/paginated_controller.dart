import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:get/get.dart';

typedef PageFetcher<T> =
    Future<Page<T>> Function({
      required int page,
      required int limit,
      required String query,
    });

class PaginatedController<T, K> extends GetxController {
  PaginatedController({
    required PageFetcher<T> fetchPage,
    required K Function(T item) keyOf,
    this.pageSize = 20,
    Duration searchDebounce = const Duration(milliseconds: 350),
  }) : _fetchPage = fetchPage,
       _keyOf = keyOf,
       _searchDebounce = searchDebounce;

  final PageFetcher<T> _fetchPage;
  final K Function(T item) _keyOf;
  final int pageSize;
  final Duration _searchDebounce;

  final RxList<T> items = <T>[].obs;

  final RxBool isLoadingFirstPage = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  final Rxn<Failure> initialFailure = Rxn<Failure>();
  final Rxn<Failure> refreshFailure = Rxn<Failure>();
  final Rxn<Failure> loadMoreFailure = Rxn<Failure>();

  final RxString query = ''.obs;

  int _page = 1;
  int _listVersion = 0;
  int _initialOpId = 0;
  int _refreshOpId = 0;
  int _loadMoreOpId = 0;
  final Set<K> _seen = <K>{};
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadInitial());
  }

  Future<void> loadInitial() async {
    final listVersion = ++_listVersion;
    final opId = ++_initialOpId;

    _page = 1;
    hasMore.value = true;
    initialFailure.value = null;
    refreshFailure.value = null;
    loadMoreFailure.value = null;
    isLoadingFirstPage.value = true;
    isRefreshing.value = false;
    isLoadingMore.value = false;
    _seen.clear();
    items.clear();

    try {
      final page = await _fetchPage(
        page: _page,
        limit: pageSize,
        query: query.value,
      );
      if (_listVersion != listVersion || _initialOpId != opId) return;
      final deduped = _dedupe(page.items);
      items.assignAll(deduped);
      hasMore.value = page.hasMore;
      initialFailure.value = null;
    } on Failure catch (f) {
      if (_listVersion != listVersion || _initialOpId != opId) return;
      initialFailure.value = f;
      hasMore.value = false;
    } finally {
      if (_listVersion == listVersion && _initialOpId == opId) {
        isLoadingFirstPage.value = false;
      }
    }
  }

  Future<void> refreshList() async {
    if (isRefreshing.value) return;

    final listVersion = ++_listVersion;
    final opId = ++_refreshOpId;

    isRefreshing.value = true;
    try {
      refreshFailure.value = null;
      loadMoreFailure.value = null;
      isLoadingFirstPage.value = false;
      isLoadingMore.value = false;

      final page = await _fetchPage(
        page: 1,
        limit: pageSize,
        query: query.value,
      );
      if (_listVersion != listVersion || _refreshOpId != opId) return;

      _seen.clear();
      items.assignAll(_dedupe(page.items));
      _page = 1;
      hasMore.value = page.hasMore;
      initialFailure.value = null;
    } on Failure catch (f) {
      if (_listVersion != listVersion || _refreshOpId != opId) return;
      refreshFailure.value = f;
      if (items.isEmpty) initialFailure.value = f;
    } finally {
      if (_listVersion == listVersion && _refreshOpId == opId) {
        isRefreshing.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    if (isLoadingFirstPage.value || isRefreshing.value || isLoadingMore.value) {
      return;
    }

    final listVersion = _listVersion;
    final opId = ++_loadMoreOpId;

    loadMoreFailure.value = null;
    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _fetchPage(
        page: nextPage,
        limit: pageSize,
        query: query.value,
      );
      if (_listVersion != listVersion || _loadMoreOpId != opId) return;

      final deduped = _dedupe(page.items);
      items.addAll(deduped);

      _page = nextPage;
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      if (_listVersion != listVersion || _loadMoreOpId != opId) return;
      loadMoreFailure.value = f;
    } finally {
      if (_listVersion == listVersion && _loadMoreOpId == opId) {
        isLoadingMore.value = false;
      }
    }
  }

  void setQuery(String value) {
    query.value = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_searchDebounce, () {
      unawaited(loadInitial());
    });
  }

  List<T> _dedupe(List<T> newItems) {
    final deduped = <T>[];
    for (final item in newItems) {
      final key = _keyOf(item);
      if (_seen.contains(key)) continue;
      _seen.add(key);
      deduped.add(item);
    }
    return deduped;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
