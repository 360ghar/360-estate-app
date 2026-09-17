import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:flutter/foundation.dart';

enum UploadTarget { general, documents }

/// Maximum accepted upload size. The avatar path enforces 5MB
/// (`AuthRepository.uploadProfilePhoto`); document uploads are capped here so
/// a single oversized file cannot exhaust memory/timeouts on the wire.
const int kMaxUploadBytes = 25 * 1024 * 1024; // 25 MB

/// Maximum accepted avatar/profile-photo size (5 MB).
const int kMaxAvatarBytes = 5 * 1024 * 1024; // 5 MB

class UploadResult {
  const UploadResult({this.url, this.data});

  final String? url;
  final Map<String, dynamic>? data;
}

class FileUploadService {
  FileUploadService(this._client);

  final ApiClient _client;

  /// Shared basename helper: last path segment. Web-safe on purpose — split
  /// on both `/` and `\` instead of `Platform.pathSeparator` so web builds
  /// (no dart:io Platform) resolve the same basename.
  static String fileNameOf(String path) {
    return path.split(RegExp(r'[/\\]')).last;
  }

  /// Shared image validation used by avatar + document upload paths.
  ///
  /// Pass [isAvatar] true for profile photos (5 MB cap with the legacy
  /// avatar error strings); default enforces the 25 MB document cap.
  /// The `application/octet-stream` passthrough preserves the legacy
  /// `AuthRepository.uploadProfilePhoto` behavior for unknown mime types.
  static void validateImage({
    required int length,
    String? mimeType,
    bool isAvatar = false,
  }) {
    if (mimeType == null ||
        (!mimeType.startsWith('image/') &&
            mimeType != 'application/octet-stream')) {
      throw const ValidationFailure(
        'Invalid file type. Please select an image.',
      );
    }
    final maxBytes = isAvatar ? kMaxAvatarBytes : kMaxUploadBytes;
    if (length > maxBytes) {
      if (isAvatar) {
        throw const ValidationFailure('Image size must be less than 5MB');
      }
      throw ValidationFailure(
        'File is too large. Maximum size is ${(maxBytes / (1024 * 1024)).toStringAsFixed(0)}MB.',
      );
    }
  }

  /// Upload entry point. Accepts the `XFile` returned directly by
  /// `image_picker` / `file_picker` (bytes-backed on web, path-backed on
  /// IO) — no `dart:io` File anywhere in this library, so web compiles.
  /// Streams from disk on IO (`MultipartFile.fromFile`) and uploads bytes
  /// on web (`MultipartFile.fromBytes`).
  Future<UploadResult> uploadXFile({
    required XFile file,
    UploadTarget target = UploadTarget.documents,
    String? title,
    String? type,
    int? propertyId,
    int? leaseId,
    ProgressCallback? onSendProgress,
    int maxBytes = kMaxUploadBytes,
  }) async {
    final length = await file.length();
    if (length > maxBytes) {
      throw ValidationFailure(
        'File is too large. Maximum size is ${(maxBytes / (1024 * 1024)).toStringAsFixed(0)}MB.',
      );
    }
    final fileName = file.name.isNotEmpty
        ? file.name
        : FileUploadService.fileNameOf(file.path);
    // Stream from disk on IO platforms so a 25MB file is not held twice in
    // RAM (readAsBytes + fromBytes). Web has no filesystem path, so it keeps
    // the byte-based upload.
    final MultipartFile multipartFile;
    if (!kIsWeb && file.path.isNotEmpty) {
      multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );
    } else {
      final bytes = await file.readAsBytes();
      multipartFile = MultipartFile.fromBytes(bytes, filename: fileName);
    }
    final trimmedTitle = title?.trim();
    final trimmedType = type?.trim();
    final formData = FormData.fromMap({
      'file': multipartFile,
      if (trimmedTitle != null && trimmedTitle.isNotEmpty)
        'title': trimmedTitle,
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

    final path = target == UploadTarget.documents
        ? ApiPaths.documentsUpload
        : ApiPaths.generalUpload;
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
