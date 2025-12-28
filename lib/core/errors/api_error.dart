final class ApiError {
  const ApiError({
    required this.statusCode,
    required this.message,
    this.details,
    this.requestId,
  });

  final int? statusCode;
  final String message;
  final Object? details;
  final String? requestId;
}
