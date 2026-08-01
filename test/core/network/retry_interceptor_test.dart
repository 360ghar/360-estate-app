import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/interceptors/retry_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adapter that fails the first [failuresBeforeSuccess] requests with a
/// connection error, then succeeds.
class _FlakyAdapter implements HttpClientAdapter {
  _FlakyAdapter(this.failuresBeforeSuccess);

  final int failuresBeforeSuccess;
  int requests = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests++;
    if (requests <= failuresBeforeSuccess) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'connection refused',
      );
    }
    return ResponseBody.fromString(
      '{"ok": true}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWithRetry(int failures, {int maxRetries = 2}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dio.httpClientAdapter = _FlakyAdapter(failures);
  dio.interceptors.addAll([
    RetryInterceptor(
      dio: dio,
      maxRetries: maxRetries,
      baseDelay: Duration.zero,
      random: Random(1),
    ),
  ]);
  return dio;
}

void main() {
  group('RetryInterceptor', () {
    test('retries a transient connection error and succeeds', () async {
      final dio = _dioWithRetry(1);
      final response = await dio.get<Map<String, dynamic>>('/x');
      expect(response.statusCode, 200);
      expect(response.data, {'ok': true});
      final adapter = dio.httpClientAdapter as _FlakyAdapter;
      expect(adapter.requests, 2); // original + 1 retry
    });

    test('does not retry non-idempotent POST requests', () async {
      final dio = _dioWithRetry(1);
      await expectLater(
        dio.post<dynamic>('/x', data: {'a': 1}),
        throwsA(isA<DioException>()),
      );
      final adapter = dio.httpClientAdapter as _FlakyAdapter;
      expect(adapter.requests, 1);
    });

    test('gives up after maxRetries and surfaces the last error', () async {
      final dio = _dioWithRetry(5);
      await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
      final adapter = dio.httpClientAdapter as _FlakyAdapter;
      expect(adapter.requests, 3); // original + 2 retries, then give up
    });

    test('does not retry cancelled requests', () async {
      final dio = _dioWithRetry(1);
      final cancelToken = CancelToken();
      cancelToken.cancel();
      await expectLater(
        dio.get<dynamic>('/x', cancelToken: cancelToken),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.cancel,
          ),
        ),
      );
      final adapter = dio.httpClientAdapter as _FlakyAdapter;
      expect(adapter.requests, 0);
    });
  });
}
