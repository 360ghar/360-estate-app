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
      AppLogger.w(
        'HTTP ✕ [${code ?? '-'}] ${options.method} ${options.uri.path} (rid=$requestId)',
        error: err,
        stackTrace: err.stackTrace,
      );
    }
    handler.next(err);
  }
}
