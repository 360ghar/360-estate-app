/// Unwraps a cursor-paginated payload into its items + pagination metadata.
///
/// Supports the uniform PM contract `{items, next_cursor, has_more, limit}` at
/// the top level as well as the legacy-wrapped form `{data: {...}}`. When the
/// payload is a bare list it is returned with no next cursor and `hasMore`
/// derived from the presence of a cursor.
({List<dynamic> items, String? nextCursor, bool hasMore}) unwrapPage(
  Object? payload,
) {
  if (payload is List) {
    return (items: payload, nextCursor: null, hasMore: false);
  }

  Map<String, dynamic> map;
  if (payload is Map<String, dynamic>) {
    final nested = payload['data'] ?? payload['result'] ?? payload['results'];
    if (nested is Map<String, dynamic>) {
      map = nested;
    } else if (nested is Map<dynamic, dynamic>) {
      map = nested.cast<String, dynamic>();
    } else {
      map = payload;
    }
  } else if (payload is Map<dynamic, dynamic>) {
    final casted = payload.cast<String, dynamic>();
    final nested = casted['data'] ?? casted['result'] ?? casted['results'];
    if (nested is Map<String, dynamic>) {
      map = nested;
    } else if (nested is Map<dynamic, dynamic>) {
      map = nested.cast<String, dynamic>();
    } else {
      map = casted;
    }
  } else {
    return (items: <dynamic>[], nextCursor: null, hasMore: false);
  }

  final rawItems = map['items'];
  final items = rawItems is List ? rawItems : <dynamic>[];

  final rawCursor = map['next_cursor'] ?? map['nextCursor'];
  final nextCursor =
      rawCursor is String && rawCursor.isNotEmpty ? rawCursor : null;

  final rawHasMore = map['has_more'] ?? map['hasMore'];
  final hasMore =
      rawHasMore is bool ? rawHasMore : (nextCursor != null);

  return (items: items, nextCursor: nextCursor, hasMore: hasMore);
}

Map<String, dynamic> unwrapMap(Object? payload) {
  if (payload is Map<String, dynamic>) {
    final data = payload['data'] ?? payload['result'] ?? payload['results'];
    if (data is Map<String, dynamic>) return data;
    return payload;
  }
  return <String, dynamic>{};
}

List<dynamic> unwrapList(Object? payload) {
  if (payload is List) return payload;
  if (payload is Map<String, dynamic>) {
    final data = payload['items'] ?? payload['data'] ?? payload['results'];
    if (data is List) return data;
  }
  return <dynamic>[];
}

Object? unwrapData(Object? payload) {
  if (payload is Map<String, dynamic>) {
    return payload['data'] ?? payload['result'] ?? payload['results'] ?? payload;
  }
  return payload;
}
