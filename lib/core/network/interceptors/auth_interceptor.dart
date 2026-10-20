import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/jwt.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AuthTokenProvider tokenProvider})
    : _tokenProvider = tokenProvider;

  final AuthTokenProvider _tokenProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _tokenProvider.getAccessToken();
      options.extra['auth_header_attached'] = token != null && token.isNotEmpty;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        final payload = Jwt.decodePayload(token);
        if (payload != null) {
          options.extra['auth_token_iss'] = payload['iss']?.toString();
          options.extra['auth_token_exp'] = Jwt.formatExpFromPayload(payload);
        }
      }
      handler.next(options);
    } catch (error, stackTrace) {
      // A token-fetch failure must never strand the request: surface it so
      // the caller gets a mapped failure instead of an unhandled async error
      // from an `async void` handler (the request would otherwise hang).
      AppLogger.w(
        'AuthInterceptor: token fetch failed; continuing without auth header',
        error: error,
        stackTrace: stackTrace,
      );
      options.extra['auth_header_attached'] = false;
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final hadAuthHeader =
        err.requestOptions.extra['auth_header_attached'] == true;
    if (hadAuthHeader &&
        (statusCode == 401 ||
            (statusCode == 403 && _isInactiveAccount(err.response?.data)))) {
      await _tokenProvider.clearSession();
    }
    handler.next(err);
  }
}

/// A 401 means the token is missing, invalid or expired. A 403 is a plain
/// access failure, except for the error code `USER_INACTIVE`: the account was
/// deactivated, so the session ends. The code is read from the error envelope
/// `{"error": {"code": ...}}` and nowhere else.
bool _isInactiveAccount(Object? data) {
  if (data is! Map) return false;
  final error = data['error'];
  return error is Map && error['code'] == 'USER_INACTIVE';
}
