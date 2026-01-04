import 'package:dio/dio.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uses QueuedInterceptor to ensure async token operations complete
/// before the request is sent. This prevents race conditions where
/// the Authorization header might be missing.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required AuthTokenProvider tokenProvider,
  })  : _dio = dio,
        _tokenProvider = tokenProvider;

  final Dio _dio;
  final AuthTokenProvider _tokenProvider;
  static const String _tokenKey = 'backend_access_token';

  // Get SharedPreferences synchronously if possible, or await
  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null && token.isNotEmpty) {
        print('[AUTH] Found stored backend token (${token.length} chars)');
      }
      return token;
    } catch (e) {
      print('[AUTH] Error reading stored token: $e');
      return null;
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // First try stored backend token
      final storedToken = await _getStoredToken();
      if (storedToken != null && storedToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $storedToken';
        print('[AUTH] Using stored backend token for: ${options.path}');
        print('[AUTH] Token (first 30 chars): ${storedToken.substring(0, storedToken.length > 30 ? 30 : storedToken.length)}...');
        print('[AUTH] Headers after setting: ${options.headers.containsKey('Authorization') ? 'Authorization present' : 'Authorization MISSING!'}');
        handler.next(options);
        return;
      }

      // If no stored token, try to get from token provider
      final token = await _tokenProvider.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        print('[AUTH] Token found (async), length: ${token.length}, sending to: ${options.path}');
        print('[AUTH] Headers after setting: ${options.headers.containsKey('Authorization') ? 'Authorization present' : 'Authorization MISSING!'}');
      } else {
        print('[AUTH] WARNING: No token available for: ${options.path}');
      }
      
      handler.next(options);
    } catch (e) {
      print('[AUTH] Error in onRequest: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    print('[AUTH] ========================================');
    print('[AUTH] Error on ${options.path}');
    print('[AUTH] Status code: $statusCode');
    print('[AUTH] Response data: ${err.response?.data}');
    print('[AUTH] Request URL: ${options.uri}');
    print('[AUTH] Request headers: ${options.headers}');
    print('[AUTH] ========================================');

    final alreadyRefreshed =
        (options.extra[RequestIdKeys.authRefreshed] as bool?) ?? false;

    final cancelled = options.cancelToken?.isCancelled ?? false;
    if (cancelled || statusCode != 401 || alreadyRefreshed) {
      handler.next(err);
      return;
    }

    print('[AUTH] Attempting token refresh for: ${options.path}');
    final refreshed = await _tokenProvider.refreshSession();
    if (!refreshed) {
      print('[AUTH] Token refresh failed for: ${options.path}');
      handler.next(err);
      return;
    }

    final token = await _tokenProvider.getAccessToken();
    if (token == null || token.isEmpty) {
      print('[AUTH] No token after refresh for: ${options.path}');
      handler.next(err);
      return;
    }

    print('[AUTH] Retrying with new token for: ${options.path}');
    print('[AUTH] New token (first 30 chars): ${token.substring(0, token.length > 30 ? 30 : token.length)}...');
    
    try {
      // Create completely fresh request with new token
      final response = await _dio.request<dynamic>(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          method: options.method,
          headers: {
            ...options.headers,
            'Authorization': 'Bearer $token',
          },
          extra: {
            ...options.extra,
            RequestIdKeys.authRefreshed: true,
          },
        ),
      );
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
