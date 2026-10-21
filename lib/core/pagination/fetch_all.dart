import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart'
    show PageFetcher;

/// Reads every row of a cursor list.
///
/// Calls [fetchPage] with `limit` up to [kMaxPageLimit] and follows
/// `next_cursor` while the page says `has_more`. Use it where the screen needs
/// all rows (a picker, a total, a lookup). Screens that scroll use
/// `PagedListController` instead.
///
/// Stops, without an error, if the backend repeats a cursor. Throws a
/// [StateError] when [maxPages] pages are read and more remain, so a faulty
/// server cannot loop the app and a caller never gets a partial list as if it
/// were complete. [maxPages] must be at least one.
Future<List<T>> fetchAllPages<T>(
  PageFetcher<T> fetchPage, {
  int limit = kMaxPageLimit,
  int maxPages = 200,
}) async {
  assert(limit >= 1 && limit <= kMaxPageLimit);
  if (maxPages < 1) throw ArgumentError.value(maxPages, 'maxPages');
  final all = <T>[];
  final seen = <String>{};
  String? cursor;
  for (var i = 0; i < maxPages; i++) {
    final page = await fetchPage(cursor: cursor, limit: limit);
    all.addAll(page.items);
    final next = page.nextCursor;
    if (!page.hasMore || next == null || !seen.add(next)) return all;
    cursor = next;
  }
  // Callers treat the result as complete, so a partial list is an error.
  throw StateError('More than $maxPages pages: the list is not complete.');
}
