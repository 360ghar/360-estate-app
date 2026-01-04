import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/dio_failure_mapper.dart';
import 'package:estate_app/core/network/interceptors/auth_interceptor.dart';
import 'package:estate_app/core/network/interceptors/logging_interceptor.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';
import 'package:estate_app/core/network/interceptors/retry_interceptor.dart';
import 'package:estate_app/core/network/network_info.dart';

final class ApiClient {
  ApiClient({
    required String baseUrl,
    required NetworkInfo networkInfo,
    required AuthTokenProvider tokenProvider,
    required bool enableLogging,
    DioFailureMapper? failureMapper,
    Dio? dio,
  }) : _networkInfo = networkInfo,
       _failureMapper = failureMapper ?? const DioFailureMapper(),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 30),
               validateStatus: (status) =>
                   status != null && status >= 200 && status < 400,
               followRedirects: true,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    _dio.interceptors.addAll([
      RequestIdInterceptor(),
      AuthInterceptor(dio: _dio, tokenProvider: tokenProvider),
      LoggingInterceptor(enabled: enableLogging),
      RetryInterceptor(dio: _dio),
    ]);
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;
  final DioFailureMapper _failureMapper;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _guard<T>(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _guard<T>(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _guard<T>(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _guard<T>(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _guard<T>(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      ),
    );
  }

  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return _guard<T>(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      ),
    );
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final isOffline = !(await _networkInfo.isConnected);
      throw _failureMapper.map(e, isOffline: isOffline);
    } catch (e) {
      throw UnknownFailure('Unexpected error', cause: e);
    }
  }
}
