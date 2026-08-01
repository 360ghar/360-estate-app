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
          options.extra['auth_token_exp'] = Jwt.formatExp(token);
          options.extra['auth_token_tail'] = token.length <= 8
              ? token
              : token.substring(token.length - 8);
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
            (statusCode == 403 &&
                _isExpiredTokenResponse(err.response?.data)))) {
      await _tokenProvider.clearSession();
    }
    handler.next(err);
  }
}

/// Detects a 403 that means "the presented token has expired" as opposed to a
/// genuine authorization failure.
///
/// Heuristic is deliberately narrow (matched against the whole message, not
/// substrings that collide with unrelated words like "expenses" or "expert"):
/// the token must be explicitly named, and the message must state it is
/// expired/invalid.
bool _isExpiredTokenResponse(Object? data) {
  if (data == null) return false;
  String? message;
  if (data is Map) {
    final detail = data['detail'];
    if (detail is String) {
      message = detail;
    } else if (detail is Map) {
      message = detail['message']?.toString();
    }
    message ??= data['message']?.toString();
  } else if (data is String) {
    message = data;
  }
  if (message == null) return false;
  final lower = message.toLowerCase();
  final mentionsToken =
      lower.contains('token') ||
      lower.contains('jwt') ||
      lower.contains('bearer');
  if (!mentionsToken) return false;
  final isStale =
      lower.contains('expired') ||
      lower.contains('has expired') ||
      lower.contains('expiration') ||
      lower.contains('invalid') ||
      lower.contains('not valid');
  return isStale;
}
