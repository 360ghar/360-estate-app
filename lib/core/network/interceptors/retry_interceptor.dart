import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';

final class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    int maxRetries = 2,
    Duration baseDelay = const Duration(milliseconds: 350),
    Random? random,
  })  : _dio = dio,
        _maxRetries = maxRetries,
        _baseDelay = baseDelay,
        _random = random ?? Random.secure();

  final Dio _dio;
  final int _maxRetries;
  final Duration _baseDelay;
  final Random _random;

  static bool _isIdempotent(RequestOptions options) {
    final method = options.method.toUpperCase();
    return method == 'GET' || method == 'HEAD' || method == 'OPTIONS';
  }

  static bool _isRetryableStatus(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode == 408 ||
        statusCode == 429 ||
        statusCode == 500 ||
        statusCode == 502 ||
        statusCode == 503 ||
        statusCode == 504;
  }

  static bool _isRetryableException(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => _isRetryableStatus(
          err.response?.statusCode,
        ),
      DioExceptionType.badCertificate => false,
      DioExceptionType.cancel => false,
      DioExceptionType.unknown => false,
    };
  }

  Duration _backoff(int attempt) {
    final exponential = _baseDelay.inMilliseconds * pow(2, attempt).toInt();
    final jitter = _random.nextInt(200);
    return Duration(milliseconds: exponential + jitter);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final cancelled = options.cancelToken?.isCancelled ?? false;
    if (cancelled || !_isIdempotent(options) || !_isRetryableException(err)) {
      handler.next(err);
      return;
    }

    final attempt = (options.extra[RequestIdKeys.attempt] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      handler.next(err);
      return;
    }

    options.extra[RequestIdKeys.attempt] = attempt + 1;

    final delay = _backoff(attempt);
    await Future<void>.delayed(delay);

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(DioException(requestOptions: options, error: e));
      }
    }
  }
}
