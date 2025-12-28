final class Page<T> {
  const Page({
    required this.items,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  final List<T> items;
  final int page;
  final int limit;
  final bool hasMore;
}
