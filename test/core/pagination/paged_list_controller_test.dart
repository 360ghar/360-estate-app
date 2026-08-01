import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Page<int> page(List<int> items, {String? cursor, bool hasMore = false}) =>
      Page<int>(items: items, limit: 20, hasMore: hasMore, nextCursor: cursor);

  test('loadInitial populates items from the first page', () async {
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async =>
          page([1, 2, 3], cursor: 'next'),
    );
    await controller.loadInitial();
    expect(controller.state.items, [1, 2, 3]);
    expect(controller.state.nextCursor, 'next');
    expect(controller.state.isLoading, isFalse);
    expect(controller.state.error, isNull);
  });

  test('loadMore appends the next page', () async {
    var calls = 0;
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        calls++;
        if (calls == 1) return page([1], cursor: 'c2', hasMore: true);
        return page([2]);
      },
    );
    await controller.loadInitial();
    await controller.loadMore();
    expect(controller.state.items, [1, 2]);
    expect(controller.state.hasMore, isFalse);
    expect(controller.state.isLoadingMore, isFalse);
  });

  test('loadMore is a no-op when there is no more data', () async {
    var calls = 0;
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        calls++;
        return page([1]);
      },
    );
    await controller.loadInitial();
    await controller.loadMore();
    expect(calls, 1); // no second fetch
  });

  test(
    'loadInitial failure surfaces as state.error and stops pagination',
    () async {
      final controller = PagedListController<int>(
        fetchPage: ({required cursor, required limit}) async {
          throw const NetworkFailure('offline');
        },
      );
      await controller.loadInitial();
      expect(controller.state.error, isA<NetworkFailure>());
      expect(controller.state.hasMore, isFalse);
      expect(controller.state.isLoading, isFalse);
    },
  );

  test('non-Failure errors are wrapped (not silently dropped)', () async {
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        throw StateError('bug');
      },
    );
    await controller.loadInitial();
    expect(controller.state.error, isA<UnknownFailure>());
  });

  test('loadMore failure keeps items and exposes loadMoreError', () async {
    var calls = 0;
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        calls++;
        if (calls == 1) return page([1], cursor: 'c2', hasMore: true);
        throw const NetworkFailure('offline');
      },
    );
    await controller.loadInitial();
    await controller.loadMore();
    expect(controller.state.items, [1]);
    expect(controller.state.loadMoreError, isA<NetworkFailure>());
    expect(controller.state.hasMore, isFalse);
  });

  test('refresh replaces items', () async {
    var calls = 0;
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        calls++;
        return page([calls]);
      },
    );
    await controller.loadInitial();
    await controller.refresh();
    expect(controller.state.items, [2]);
    expect(controller.state.isRefreshing, isFalse);
  });

  test('retryLoadMore re-runs after a loadMore failure', () async {
    var calls = 0;
    final controller = PagedListController<int>(
      fetchPage: ({required cursor, required limit}) async {
        calls++;
        if (calls == 1) return page([1], cursor: 'c2', hasMore: true);
        if (calls == 2) throw const NetworkFailure('offline');
        return page([2]);
      },
    );
    await controller.loadInitial();
    await controller.loadMore();
    expect(controller.state.loadMoreError, isNotNull);
    await controller.retryLoadMore();
    expect(controller.state.loadMoreError, isNull);
    expect(controller.state.items, [1, 2]);
  });
}
