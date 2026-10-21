import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/dio_failure_mapper.dart';
import 'package:estate_app/core/network/interceptors/auth_interceptor.dart';
import 'package:estate_app/core/network/interceptors/logging_interceptor.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';
import 'package:estate_app/core/network/interceptors/retry_interceptor.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/network/owner_scope.dart';

final class ApiClient {
  ApiClient({
    required String baseUrl,
    required NetworkInfo networkInfo,
    required AuthTokenProvider tokenProvider,
    required bool enableLogging,
    OwnerScope Function()? ownerScope,
    DioFailureMapper? failureMapper,
    Dio? dio,
  }) : _networkInfo = networkInfo,
       _ownerScope = ownerScope,
       _failureMapper = failureMapper ?? const DioFailureMapper(),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 30),
               sendTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 30),
               validateStatus: (status) =>
                   status != null && status >= 200 && status < 300,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    _dio.interceptors.addAll([
      RequestIdInterceptor(),
      AuthInterceptor(tokenProvider: tokenProvider),
      LoggingInterceptor(enabled: enableLogging),
      RetryInterceptor(dio: _dio),
    ]);
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;
  final DioFailureMapper _failureMapper;
  final OwnerScope Function()? _ownerScope;

  Dio get dio => _dio;

  /// Sends the owner the user acts for as `owner_id` when [ownerScoped] is true
  /// (see [OwnerScope]). Set it on the PM list and create routes that declare
  /// `owner_id`. It throws [OwnerRequiredFailure] for an agent who has not
  /// picked an owner.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool ownerScoped = false,
  }) {
    return _guard<T>(
      () => _dio.get<T>(
        path,
        queryParameters: _scopedQuery(queryParameters, ownerScoped),
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
    bool ownerScoped = false,
  }) {
    return _guard<T>(
      () => _dio.post<T>(
        path,
        data: _scopedBody(data, ownerScoped),
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
    bool ownerScoped = false,
  }) {
    return _guard<T>(
      () => _dio.post<T>(
        path,
        data: _scopedBody(data, ownerScoped),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      ),
    );
  }

  /// The `owner_id` to send for an owner-scoped request, or null. Throws
  /// [OwnerRequiredFailure] when an agent has not picked an owner.
  int? _ownerIdFor(bool ownerScoped) {
    if (!ownerScoped) return null;
    final scope = _ownerScope?.call();
    if (scope == null) return null;
    final ownerId = scope.ownerId;
    if (ownerId == null && scope.requiresOwner) {
      throw const OwnerRequiredFailure();
    }
    return ownerId;
  }

  Map<String, dynamic>? _scopedQuery(
    Map<String, dynamic>? query,
    bool ownerScoped,
  ) {
    final ownerId = _ownerIdFor(ownerScoped);
    if (ownerId == null) return query;
    return {...?query, 'owner_id': ownerId};
  }

  Object? _scopedBody(Object? data, bool ownerScoped) {
    final ownerId = _ownerIdFor(ownerScoped);
    if (ownerId == null) return data;
    if (data is FormData) {
      data.fields.add(MapEntry('owner_id', ownerId.toString()));
      return data;
    }
    if (data is Map<String, dynamic>) return {...data, 'owner_id': ownerId};
    if (data == null) return {'owner_id': ownerId};
    return data;
  }

  /// Retry policy (see RetryInterceptor): idempotent GET/HEAD/OPTIONS
  /// only, max 2 retries with exponential backoff on 408/429/500/502/503/504
  /// plus timeouts/connection errors.
  ///
  /// NetworkInfo.isConnected costs a platform-channel round-trip, so it
  /// is only consulted when the error could actually mean offline
  /// (timeouts, connectionError, unknown). An HTTP response (e.g. 4xx)
  /// already proves connectivity: no check needed.
  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final needsConnectivityCheck =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown;
      final isOffline =
          needsConnectivityCheck && !(await _networkInfo.isConnected);
      throw _failureMapper.map(e, isOffline: isOffline);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure('Unexpected error', cause: e);
    }
  }
}
