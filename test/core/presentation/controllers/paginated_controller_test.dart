import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/presentation/controllers/paginated_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loadInitial toggles loading and populates items', () async {
    final completer = Completer<Page<int>>();
    final controller = PaginatedController<int, int>(
      fetchPage: ({required page, required limit, required query}) =>
          completer.future,
      keyOf: (v) => v,
      pageSize: 2,
    );

    final future = controller.loadInitial();
    expect(controller.isLoadingFirstPage.value, isTrue);

    completer.complete(
      const Page<int>(items: [1, 2], page: 1, limit: 2, hasMore: true),
    );

    await future;

    expect(controller.isLoadingFirstPage.value, isFalse);
    expect(controller.initialFailure.value, isNull);
    expect(controller.items.toList(), [1, 2]);
    expect(controller.hasMore.value, isTrue);
  });

  test('loadInitial stores failure on error', () async {
    final controller = PaginatedController<int, int>(
      fetchPage: ({required page, required limit, required query}) async {
        throw const NetworkFailure('No internet connection', isOffline: true);
      },
      keyOf: (v) => v,
      pageSize: 2,
    );

    await controller.loadInitial();

    expect(controller.isLoadingFirstPage.value, isFalse);
    expect(controller.items, isEmpty);
    expect(controller.initialFailure.value, isA<NetworkFailure>());
    expect(controller.hasMore.value, isFalse);
  });

  test('loadMore stores failure and keeps items', () async {
    final controller = PaginatedController<int, int>(
      fetchPage: ({required page, required limit, required query}) async {
        if (page == 1) {
          return const Page<int>(
            items: [1, 2],
            page: 1,
            limit: 2,
            hasMore: true,
          );
        }
        throw const NetworkFailure('Network error');
      },
      keyOf: (v) => v,
      pageSize: 2,
    );

    await controller.loadInitial();
    await controller.loadMore();

    expect(controller.items.toList(), [1, 2]);
    expect(controller.loadMoreFailure.value, isA<NetworkFailure>());
  });
}
