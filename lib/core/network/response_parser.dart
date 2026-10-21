import 'package:estate_app/core/errors/failure.dart';

/// Reads a `CursorPage` body: `{items, next_cursor, has_more, limit, total}`.
///
/// The backend sends all five keys on every list route. A body that is not
/// that shape is a contract break, so it throws instead of returning an empty
/// list that hides the break. `total` is null unless the request set
/// `include_total=true`.
({List<dynamic> items, String? nextCursor, bool hasMore, int? total})
unwrapPage(Object? payload) {
  if (payload is! Map) {
    throw const UnknownFailure('Unexpected list response from the server.');
  }
  final rawItems = payload['items'];
  if (rawItems is! List) {
    throw const UnknownFailure('Unexpected list response from the server.');
  }

  final rawCursor = payload['next_cursor'];
  final nextCursor = rawCursor is String && rawCursor.isNotEmpty
      ? rawCursor
      : null;

  final rawHasMore = payload['has_more'];
  final hasMore = rawHasMore is bool ? rawHasMore : nextCursor != null;

  final rawTotal = payload['total'];
  final total = rawTotal is int ? rawTotal : null;

  return (
    items: rawItems,
    nextCursor: nextCursor,
    hasMore: hasMore && nextCursor != null,
    total: total,
  );
}

/// Reads a JSON object body (a resource). The backend sends the resource
/// itself, with no `data` wrapper.
Map<String, dynamic> unwrapMap(Object? payload) {
  if (payload is Map<String, dynamic>) return payload;
  if (payload is Map) return Map<String, dynamic>.from(payload);
  throw const UnknownFailure('Unexpected response from the server.');
}
