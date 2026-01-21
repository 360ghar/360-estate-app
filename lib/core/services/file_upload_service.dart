import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';

enum UploadTarget { general, documents }

class UploadResult {
  const UploadResult({this.url, this.data});

  final String? url;
  final Map<String, dynamic>? data;
}

class FileUploadService {
  FileUploadService(this._client);

  final ApiClient _client;

  Future<UploadResult> uploadFile({
    required File file,
    UploadTarget target = UploadTarget.documents,
    String? title,
    String? type,
    int? propertyId,
    int? leaseId,
    ProgressCallback? onSendProgress,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final trimmedTitle = title?.trim();
    final trimmedType = type?.trim();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      if (trimmedTitle != null && trimmedTitle.isNotEmpty) 'title': trimmedTitle,
      if (trimmedType != null &&
          trimmedType.isNotEmpty &&
          target == UploadTarget.documents)
        'document_type': trimmedType,
      if (trimmedType != null &&
          trimmedType.isNotEmpty &&
          target == UploadTarget.general)
        'type': trimmedType,
      if (propertyId != null && target == UploadTarget.documents)
        'property_id': propertyId.toString(),
      if (leaseId != null && target == UploadTarget.documents)
        'lease_id': leaseId.toString(),
    });

    final path =
        target == UploadTarget.documents ? '/pm/documents/upload' : '/upload/';
    final response = await _client.upload<Map<String, dynamic>>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
    );

    final payload = unwrapData(response.data);
    if (payload is String) {
      return UploadResult(
        url: _resolveUploadUrl(payload, baseUrl: _client.dio.options.baseUrl),
      );
    }
    if (payload is Map<String, dynamic>) {
      final url = _extractUrl(payload, baseUrl: _client.dio.options.baseUrl);
      return UploadResult(url: url, data: payload);
    }
    return const UploadResult();
  }
}

String? _extractUrl(Map<String, dynamic> payload, {String? baseUrl}) {
  final candidates = [
    payload['url'],
    payload['file_url'],
    payload['download_url'],
    payload['path'],
  ];
  for (final value in candidates) {
    if (value is String && value.trim().isNotEmpty) {
      return _resolveUploadUrl(value, baseUrl: baseUrl);
    }
  }

  final data = payload['data'];
  if (data is Map<String, dynamic>) {
    return _extractUrl(data, baseUrl: baseUrl);
  }
  return null;
}

String? _resolveUploadUrl(String? raw, {String? baseUrl}) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return null;
  if (uri.hasScheme) return trimmed;

  final base = baseUrl?.trim();
  if (base == null || base.isEmpty) return trimmed;
  final normalizedBase = base.endsWith('/') ? base : '$base/';
  final baseUri = Uri.tryParse(normalizedBase);
  if (baseUri == null) return trimmed;

  return baseUri.resolveUri(uri).toString();
}
