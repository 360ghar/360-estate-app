import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/api_error.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';

/// Maps a [DioException] to a [Failure].
///
/// Errors are read only from the backend error envelope:
/// `{"error": {"code": str, "message": str, "details": object}}`.
/// A 422 carries the field errors in `error.details.fields`, a list of
/// `{field, msg, type}`. A body without the envelope (a proxy page, an empty
/// body) gets a fixed message for its status code.
final class DioFailureMapper {
  const DioFailureMapper();

  Failure map(DioException exception, {required bool isOffline}) {
    if (exception.type == DioExceptionType.cancel) {
      return const NetworkFailure('Request cancelled');
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionError) {
      return NetworkFailure(
        isOffline ? 'No internet connection' : 'Network error',
        isOffline: isOffline,
        cause: exception,
      );
    }

    final statusCode = exception.response?.statusCode;
    final requestId =
        exception.requestOptions.extra[RequestIdKeys.requestId] as String?;
    final envelope = ErrorEnvelopeBody.tryParse(exception.response?.data);
    final message = envelope?.message ?? _fallbackMessage(statusCode);

    if (statusCode == 401) {
      return UnauthorizedFailure(
        message,
        cause: exception,
        code: envelope?.code,
      );
    }

    if (statusCode == 404) {
      return NotFoundFailure(message, cause: exception, code: envelope?.code);
    }

    if (statusCode == 400 || statusCode == 422) {
      return ValidationFailure(
        message,
        fields: envelope?.fieldErrors ?? const <String, String>{},
        cause: exception,
        code: envelope?.code,
      );
    }

    final apiError = ApiError(
      statusCode: statusCode,
      message: message,
      code: envelope?.code,
      details: envelope?.details,
      requestId: requestId,
      retryAfterSeconds: retryAfterSeconds(exception.response),
    );

    return ApiFailure(error: apiError, cause: exception);
  }

  static String _fallbackMessage(int? statusCode) {
    return switch (statusCode) {
      401 => 'Unauthorized',
      403 => 'You do not have access to this',
      404 => 'Not found',
      400 || 422 => 'Invalid request',
      429 => 'Too many requests. Try again shortly.',
      _ => 'Request failed',
    };
  }

  /// `Retry-After` in whole seconds, or null when absent or not a number.
  static int? retryAfterSeconds(Response<dynamic>? response) {
    final raw = response?.headers.value('retry-after');
    if (raw == null) return null;
    final seconds = int.tryParse(raw.trim());
    if (seconds == null || seconds < 0) return null;
    return seconds;
  }
}

/// The parsed `{"error": {...}}` body of a non-2xx response.
final class ErrorEnvelopeBody {
  const ErrorEnvelopeBody({
    required this.code,
    required this.message,
    this.details,
    this.fieldErrors = const <String, String>{},
  });

  final String? code;
  final String? message;

  /// `error.details` when it is an object.
  final Map<String, dynamic>? details;

  /// `error.details.fields` as `field name -> message`.
  final Map<String, String> fieldErrors;

  static ErrorEnvelopeBody? tryParse(Object? data) {
    if (data is! Map) return null;
    final error = data['error'];
    if (error is! Map) return null;

    final code = error['code'];
    final message = error['message'];
    final rawDetails = error['details'];
    final details = rawDetails is Map
        ? Map<String, dynamic>.from(rawDetails)
        : null;

    return ErrorEnvelopeBody(
      code: code is String && code.trim().isNotEmpty ? code : null,
      message: message is String && message.trim().isNotEmpty ? message : null,
      details: details,
      fieldErrors: _fieldErrors(details),
    );
  }

  static Map<String, String> _fieldErrors(Map<String, dynamic>? details) {
    final fields = details?['fields'];
    if (fields is! List) return const <String, String>{};
    final result = <String, String>{};
    for (final item in fields) {
      if (item is! Map) continue;
      final msg = item['msg'];
      if (msg is! String || msg.trim().isEmpty) continue;
      final raw = item['field'];
      final key = _fieldKey(raw is String ? raw : '');
      final previous = result[key];
      result[key] = previous == null ? msg.trim() : '$previous\n${msg.trim()}';
    }
    return result;
  }

  /// `body.monthly_rent` -> `monthly_rent`. The source prefix is dropped.
  static String _fieldKey(String field) {
    final trimmed = field.trim();
    if (trimmed.isEmpty) return 'error';
    final dot = trimmed.indexOf('.');
    if (dot == -1) return trimmed;
    final source = trimmed.substring(0, dot);
    if (const {
      'body',
      'query',
      'path',
      'header',
      'cookie',
      'form',
    }.contains(source)) {
      final rest = trimmed.substring(dot + 1);
      return rest.isEmpty ? 'error' : rest;
    }
    return trimmed;
  }
}
