import 'dart:async';
import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/cache_entry.dart';
import 'package:estate_app/core/network/dio_failure_mapper.dart';
import 'package:estate_app/core/network/interceptors/auth_interceptor.dart';
import 'package:estate_app/core/network/interceptors/logging_interceptor.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';
import 'package:estate_app/core/network/interceptors/retry_interceptor.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';

/// HTTP client with automatic auth, retry, caching, and error handling.
///
/// This client provides a robust foundation for API communication with:
/// - Automatic token injection and refresh
/// - Request retry with exponential backoff
/// - Response caching for GET requests
/// - Comprehensive error handling and mapping
final class ApiClient {
  ApiClient({
    required String baseUrl,
    required NetworkInfo networkInfo,
    required AuthTokenProvider tokenProvider,
    required SecureKvStore secureStore,
    required bool enableLogging,
    DioFailureMapper? failureMapper,
    Dio? dio,
    this.enableCache = true,
    this.defaultCacheTtl = const Duration(minutes: 5),
  })  : _networkInfo = networkInfo,
        _failureMapper = failureMapper ?? const DioFailureMapper(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                validateStatus: (status) =>
                    status != null && status >= 200 && status < 400,
                followRedirects: true,
                headers: const {
                  'Accept': 'application/json',
                  'API-Version': 'v1',
                },
              ),
            ) {
    _dio.interceptors.addAll([
      RequestIdInterceptor(),
      AuthInterceptor(
        dio: _dio,
        tokenProvider: tokenProvider,
        secureStore: secureStore,
      ),
      LoggingInterceptor(enabled: enableLogging),
      RetryInterceptor(dio: _dio),
    ]);
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;
  final DioFailureMapper _failureMapper;
  
  /// Whether response caching is enabled
  final bool enableCache;
  
  /// Default TTL for cache entries
  final Duration defaultCacheTtl;
  
  /// In-memory cache for frequently accessed responses
  final Map<String, CacheEntry> _cache = {};

  Dio get dio => _dio;

  /// GET request with optional caching.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool forceRefresh = false,
    Duration? cacheTtl,
  }) {
    return _guard<T>(
      () async {
        if (!forceRefresh && enableCache) {
          final cached = await _getCached<T>(path, queryParameters);
          if (cached != null) return cached;
        }
        
        final response = await _dio.get<T>(
          path,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
        );
        
        if (enableCache) {
          await _setCached(path, queryParameters, response, cacheTtl);
        }
        
        return response;
      },
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

  /// Clear all cached responses.
  void clearCache() {
    _cache.clear();
  }

  /// Clear cached responses for a specific path pattern.
  void clearCacheFor(String pathPattern) {
    _cache.removeWhere((key, _) => key.startsWith(pathPattern));
  }

  String _makeCacheKey(String path, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return path;
    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '$path?$queryString';
  }

  Future<Response<T>?> _getCached<T>(
    String path,
    Map<String, dynamic>? params,
  ) async {
    final key = _makeCacheKey(path, params);
    final entry = _cache[key];
    
    if (entry != null && entry.isValid) {
      return entry.response as Response<T>;
    }
    
    // Remove expired entries
    if (entry != null) {
      _cache.remove(key);
    }
    
    return null;
  }

  Future<void> _setCached<T>(
    String path,
    Map<String, dynamic>? params,
    Response<T> response,
    Duration? ttl,
  ) async {
    // Only cache successful responses
    if (response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      final key = _makeCacheKey(path, params);
      _cache[key] = CacheEntry.create(
        response,
        ttl ?? defaultCacheTtl,
      );
    }
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
