import 'package:dio/dio.dart';

/// Represents a cached API response with expiration.
class CacheEntry {
  const CacheEntry({
    required this.response,
    required this.timestamp,
    required this.ttl,
  });

  final Response response;
  final DateTime timestamp;
  final Duration ttl;

  /// Check if this cache entry has expired.
  bool get isExpired => DateTime.now().isAfter(timestamp.add(ttl));

  /// Check if this cache entry is still valid.
  bool get isValid => !isExpired;

  /// Create a cache entry that expires after [ttl].
  factory CacheEntry.create(Response response, Duration ttl) {
    return CacheEntry(
      response: response,
      timestamp: DateTime.now(),
      ttl: ttl,
    );
  }
}
