import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';

final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AuthTokenProvider tokenProvider})
    : _tokenProvider = tokenProvider;

  final AuthTokenProvider _tokenProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      final payload = _decodeJwtPayload(token);
      if (payload != null) {
        options.extra['auth_token_iss'] = payload['iss']?.toString();
        options.extra['auth_token_exp'] = _formatJwtExp(payload['exp']);
        options.extra['auth_token_tail'] =
            token.length <= 8 ? token : token.substring(token.length - 8);
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 ||
        (statusCode == 403 && _isExpiredTokenResponse(err.response?.data))) {
      await _tokenProvider.clearSession();
    }
    handler.next(err);
  }
}

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
  return lower.contains('exp') && lower.contains('timestamp');
}

Map<String, dynamic>? _decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length < 2) return null;
  try {
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    final data = jsonDecode(decoded);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  } catch (_) {
    return null;
  }
}

String? _formatJwtExp(Object? exp) {
  int? expValue;
  if (exp is num) {
    expValue = exp.toInt();
  } else if (exp is String) {
    expValue = int.tryParse(exp);
  }
  if (expValue == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(expValue * 1000)
      .toUtc()
      .toIso8601String();
}
