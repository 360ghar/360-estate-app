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
    final data = payload['data'] ?? payload['results'] ?? payload['items'];
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
