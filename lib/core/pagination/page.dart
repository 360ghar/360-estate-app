final class Page<T> {
  const Page({
    required this.items,
    required this.limit,
    required this.hasMore,
    this.nextCursor,
    this.total,
  });

  /// Cache-key sentinel used when there is no cursor yet (first page).
  /// Repositories previously used three different conventions
  /// (`'cursor=<null>'`, `'__NULL_CURSOR__'`, `'first'`) for the same thing.
  static const String nullCursorCacheKey = '__NULL_CURSOR__';

  final List<T> items;
  final int limit;
  final bool hasMore;

  /// Opaque base64 cursor returned by the backend for the next page.
  /// `null` on the terminal page (when [hasMore] is `false`).
  final String? nextCursor;

  /// Total number of items across all pages, if the backend includes it.
  final int? total;
}
