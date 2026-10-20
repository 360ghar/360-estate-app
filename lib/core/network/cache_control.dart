import 'package:dio/dio.dart';

/// False when the response says `Cache-Control: no-store`. The backend sends
/// it on authenticated responses that must not be kept. The app must not put
/// such a response in its own cache (`CacheStore`) either.
bool isCacheable(Response<dynamic> response) {
  final values = response.headers['cache-control'];
  if (values == null) return true;
  return !values.any((value) => value.toLowerCase().contains('no-store'));
}
