import 'dart:math';

import 'package:dio/dio.dart';

abstract final class RequestIdKeys {
  static const requestId = 'request_id';
  static const attempt = 'attempt';
  static const startedAt = 'started_at_ms';
  static const authRefreshed = 'auth_refreshed';
}

final class RequestIdInterceptor extends Interceptor {
  RequestIdInterceptor({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String _newRequestId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final rand = _random.nextInt(1 << 32);
    return 'req_${now}_$rand';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[RequestIdKeys.requestId] ??= _newRequestId();
    options.extra[RequestIdKeys.attempt] ??= 0;
    options.extra[RequestIdKeys.startedAt] ??=
        DateTime.now().millisecondsSinceEpoch;

    final requestId = options.extra[RequestIdKeys.requestId] as String;
    options.headers['x-request-id'] ??= requestId;

    handler.next(options);
  }
}
