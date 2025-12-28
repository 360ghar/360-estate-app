import 'package:dio/dio.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required Dio dio, required AuthTokenProvider tokenProvider})
    : _dio = dio,
      _tokenProvider = tokenProvider;

  final Dio _dio;
  final AuthTokenProvider _tokenProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    final alreadyRefreshed =
        (options.extra[RequestIdKeys.authRefreshed] as bool?) ?? false;

    final cancelled = options.cancelToken?.isCancelled ?? false;
    if (cancelled || statusCode != 401 || alreadyRefreshed) {
      handler.next(err);
      return;
    }

    final refreshed = await _tokenProvider.refreshSession();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    final token = await _tokenProvider.getAccessToken();
    if (token == null || token.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      options.extra[RequestIdKeys.authRefreshed] = true;
      options.headers['Authorization'] = 'Bearer $token';
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
