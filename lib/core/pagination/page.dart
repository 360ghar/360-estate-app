final class Page<T> {
  const Page({
    required this.items,
    required this.limit,
    required this.hasMore,
    this.nextCursor,
    this.total,
  });

  final List<T> items;
  final int limit;
  final bool hasMore;

  /// Opaque base64 cursor returned by the backend for the next page.
  /// `null` on the terminal page (when [hasMore] is `false`).
  final String? nextCursor;

  /// Total number of items across all pages, if the backend includes it.
  final int? total;
}
