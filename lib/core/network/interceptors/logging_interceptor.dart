import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';

final class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required bool enabled}) : _enabled = enabled;

  final bool _enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enabled) {
      final requestId = options.extra[RequestIdKeys.requestId] ?? 'n/a';
      final attempt = options.extra[RequestIdKeys.attempt] ?? 0;
      AppLogger.d(
        'HTTP → [${options.method}] ${options.uri.path} (attempt=$attempt, rid=$requestId)',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_enabled) {
      final options = response.requestOptions;
      final requestId = options.extra[RequestIdKeys.requestId] ?? 'n/a';
      final startedAtMs = options.extra[RequestIdKeys.startedAt] as int?;
      final elapsedMs = startedAtMs == null
          ? null
          : DateTime.now().millisecondsSinceEpoch - startedAtMs;
      AppLogger.d(
        'HTTP ← [${response.statusCode}] ${options.method} ${options.uri.path} (${elapsedMs ?? '?'}ms, rid=$requestId)',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enabled) {
      final options = err.requestOptions;
      final requestId = options.extra[RequestIdKeys.requestId] ?? 'n/a';
      final code = err.response?.statusCode;
      final data = _sanitizeBody(err.response?.data);
      final tokenMeta = _formatTokenMeta(options.extra);
      AppLogger.w(
        'HTTP ERROR [${code ?? '-'}] ${options.method} ${options.uri.path} (rid=$requestId)$tokenMeta - Response: $data',
        error: err,
        stackTrace: err.stackTrace,
      );
    }
    handler.next(err);
  }
}

/// Redacts sensitive values and truncates over-long bodies so debug logs
/// never contain PII (phones, emails, tokens, addresses) or megabytes of
/// response payloads.
Object? _sanitizeBody(Object? data) {
  const sensitiveKeys = {
    'phone',
    'phone_number',
    'mobile',
    'email',
    'email_address',
    'token',
    'access_token',
    'refresh_token',
    'id_token',
    'password',
    'authorization',
    'pan',
    'aadhaar',
    'upi',
    'bank_account',
    'ifsc',
  };
  const maxBodyChars = 1024;

  Object? sanitize(Object? value) {
    if (value is Map) {
      return value.map((key, value) {
        final k = key.toString().toLowerCase();
        final v = sanitize(value);
        return MapEntry(key, sensitiveKeys.contains(k) ? '***REDACTED***' : v);
      });
    }
    if (value is List) return value.map(sanitize).toList();
    return value;
  }

  final sanitized = sanitize(data);
  // Truncate the text representation for both string and structured bodies;
  // a multi-megabyte Map/List would otherwise be dumped in full by the
  // interpolation below.
  final text = sanitized is String ? sanitized : sanitized.toString();
  if (text.length > maxBodyChars) {
    return '${text.substring(0, maxBodyChars)}…(truncated ${text.length - maxBodyChars} chars)';
  }
  return sanitized;
}

String _formatTokenMeta(Map<String, dynamic> extras) {
  final tail = extras['auth_token_tail']?.toString();
  final exp = extras['auth_token_exp']?.toString();
  final iss = extras['auth_token_iss']?.toString();
  final parts = <String>[];
  if (tail != null && tail.isNotEmpty) {
    parts.add('tail=$tail');
  }
  if (exp != null && exp.isNotEmpty) {
    parts.add('exp=$exp');
  }
  if (iss != null && iss.isNotEmpty) {
    parts.add('iss=$iss');
  }
  if (parts.isEmpty) return '';
  return ' token[${parts.join(',')}]';
}
