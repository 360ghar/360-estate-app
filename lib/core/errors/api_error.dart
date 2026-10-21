/// A non-2xx response read from the backend error envelope
/// `{"error": {"code", "message", "details"}}`.
final class ApiError {
  const ApiError({
    required this.statusCode,
    required this.message,
    this.code,
    this.details,
    this.requestId,
    this.retryAfterSeconds,
  });

  final int? statusCode;
  final String message;

  /// Stable machine-readable code (`error.code`), for example `NOT_FOUND` or
  /// `USER_INACTIVE`. Branch on this, not on [message].
  final String? code;

  /// `error.details`. A map when the backend sent one, otherwise null.
  final Object? details;
  final String? requestId;

  /// `Retry-After` in seconds on a 429 or 503, when the backend sent it.
  final int? retryAfterSeconds;
}
