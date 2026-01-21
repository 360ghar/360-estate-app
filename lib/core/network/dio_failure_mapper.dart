import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/api_error.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/interceptors/request_id_interceptor.dart';

final class DioFailureMapper {
  const DioFailureMapper();

  Failure map(DioException exception, {required bool isOffline}) {
    if (exception.type == DioExceptionType.cancel) {
      return const NetworkFailure('Request cancelled');
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionError) {
      return NetworkFailure(
        isOffline ? 'No internet connection' : 'Network error',
        isOffline: isOffline,
        cause: exception,
      );
    }

    final statusCode = exception.response?.statusCode;
    final requestId =
        exception.requestOptions.extra[RequestIdKeys.requestId] as String?;

    if (statusCode == 401) {
      return UnauthorizedFailure('Unauthorized', cause: exception);
    }

    if (statusCode == 404) {
      return NotFoundFailure('Not found', cause: exception);
    }

    if (statusCode == 400 || statusCode == 422) {
      final fields = _tryExtractFieldErrors(exception.response?.data);
      return ValidationFailure(
        _tryExtractMessage(exception.response?.data) ?? 'Invalid request',
        fields: fields,
        cause: exception,
      );
    }

    final apiError = ApiError(
      statusCode: statusCode,
      message: _tryExtractMessage(exception.response?.data) ?? 'Request failed',
      details: _tryExtractDetails(exception.response?.data),
      requestId: requestId,
    );

    return ApiFailure(error: apiError, cause: exception);
  }

  static String? _tryExtractMessage(Object? data) {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
      if (detail is Map) {
        final detailMessage = detail['message'] ?? detail['error'] ?? detail['msg'];
        if (detailMessage is String && detailMessage.trim().isNotEmpty) {
          return detailMessage;
        }
      }
      if (detail is List) {
        for (final item in detail) {
          if (item is String && item.trim().isNotEmpty) {
            return item;
          }
          if (item is Map) {
            final msg = item['message'] ?? item['error'] ?? item['msg'];
            if (msg is String && msg.trim().isNotEmpty) {
              return msg;
            }
          }
        }
      }
      final v = data['message'] ?? data['error'] ?? data['msg'];
      if (v is String && v.trim().isNotEmpty) return v;
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }

  static Object? _tryExtractDetails(Object? data) {
    if (data is Map) {
      if (data.containsKey('details')) return data['details'];
      if (data.containsKey('data')) return data['data'];
      return data;
    }
    return data;
  }

  static Map<String, String> _tryExtractFieldErrors(Object? data) {
    if (data is! Map) return const {};
    final errors = data['errors'];
    if (errors is Map) {
      return errors.map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      );
    }
    final detail = data['detail'];
    if (detail is List) {
      final fields = <String, String>{};
      for (final item in detail) {
        if (item is! Map) continue;
        final loc = item['loc'];
        final msg = item['msg'] ?? item['message'] ?? item['error'];
        if (msg is! String || msg.trim().isEmpty) continue;
        String? field;
        if (loc is List && loc.isNotEmpty) {
          final last = loc.last;
          if (last is String && last.trim().isNotEmpty) {
            field = last;
          }
        }
        fields[field ?? 'error'] = msg.trim();
      }
      return fields;
    }
    return const {};
  }
}
