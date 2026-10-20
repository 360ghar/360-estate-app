import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fetchAllPages', () {
    test('follows next_cursor until has_more is false', () async {
      final calls = <({String? cursor, int limit})>[];
      final pages = {
        null: const Page<int>(
          items: [1, 2],
          limit: 100,
          hasMore: true,
          nextCursor: 'c1',
        ),
        'c1': const Page<int>(
          items: [3],
          limit: 100,
          hasMore: true,
          nextCursor: 'c2',
        ),
        'c2': const Page<int>(items: [4], limit: 100, hasMore: false),
      };
      final all = await fetchAllPages<int>(({
        required cursor,
        required limit,
      }) async {
        calls.add((cursor: cursor, limit: limit));
        return pages[cursor]!;
      });
      expect(all, [1, 2, 3, 4]);
      expect(calls.map((c) => c.cursor), [null, 'c1', 'c2']);
      // Every request uses the backend maximum (100), never 200.
      expect(calls.every((c) => c.limit == kMaxPageLimit), isTrue);
    });

    test('stops when the server repeats a cursor', () async {
      var calls = 0;
      final all = await fetchAllPages<int>(({
        required cursor,
        required limit,
      }) async {
        calls++;
        return const Page<int>(
          items: [1],
          limit: 100,
          hasMore: true,
          nextCursor: 'same',
        );
      });
      expect(calls, 2);
      expect(all, [1, 1]);
    });
  });

  group('unwrapPage', () {
    test('reads the five CursorPage keys', () {
      final page = unwrapPage({
        'items': [1, 2],
        'next_cursor': 'abc',
        'has_more': true,
        'limit': 20,
        'total': null,
      });
      expect(page.items, [1, 2]);
      expect(page.nextCursor, 'abc');
      expect(page.hasMore, isTrue);
      expect(page.total, isNull);
    });

    test('a bare list is a contract break, not an empty page', () {
      expect(() => unwrapPage([1, 2]), throwsA(isA<UnknownFailure>()));
      expect(
        () => unwrapPage({'data': <Object?>[]}),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });
}
