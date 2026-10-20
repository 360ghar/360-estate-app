import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:flutter/foundation.dart';

/// Maximum accepted upload size. The avatar path enforces 5MB
/// (`AuthRepository.uploadProfilePhoto`); document uploads are capped here so
/// a single oversized file cannot exhaust memory/timeouts on the wire.
const int kMaxUploadBytes = 25 * 1024 * 1024; // 25 MB

/// Maximum accepted avatar/profile-photo size (5 MB).
const int kMaxAvatarBytes = 5 * 1024 * 1024; // 5 MB

/// The result of `POST /upload` (`UploadResult`). `publicUrl` is the file URL.
class UploadResult {
  const UploadResult({required this.publicUrl, this.filePath});

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    final url = json['public_url'];
    if (url is! String || url.isEmpty) {
      throw const UnknownFailure('Upload succeeded but no URL returned.');
    }
    final path = json['file_path'];
    return UploadResult(publicUrl: url, filePath: path is String ? path : null);
  }

  final String publicUrl;
  final String? filePath;
}

class FileUploadService {
  FileUploadService(this._client);

  final ApiClient _client;

  /// Shared basename helper: last path segment. Web-safe on purpose: split
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

  /// Builds the multipart `file` part from a picker `XFile` (bytes-backed on
  /// web, path-backed on IO). Streams from disk on IO so a 25MB file is not
  /// held twice in RAM. No `dart:io` File, so web compiles.
  Future<MultipartFile> _filePart(XFile file, int maxBytes) async {
    final length = await file.length();
    if (length > maxBytes) {
      throw ValidationFailure(
        'File is too large. Maximum size is ${(maxBytes / (1024 * 1024)).toStringAsFixed(0)}MB.',
      );
    }
    final fileName = file.name.isNotEmpty
        ? file.name
        : FileUploadService.fileNameOf(file.path);
    if (!kIsWeb && file.path.isNotEmpty) {
      return MultipartFile.fromFile(file.path, filename: fileName);
    }
    return MultipartFile.fromBytes(
      await file.readAsBytes(),
      filename: fileName,
    );
  }

  /// Uploads a picture that the app shows by URL, such as a property photo or
  /// a floor plan, with `POST /upload` (`folder_type` generic, `visibility`
  /// public). The URL goes in the property body (`images`, `floor_plans`).
  /// The route refuses the property folder types: they need a property id.
  Future<UploadResult> uploadPublicImage({
    required XFile file,
    ProgressCallback? onSendProgress,
    int maxBytes = kMaxUploadBytes,
  }) async {
    final formData = FormData.fromMap({
      'file': await _filePart(file, maxBytes),
      'folder_type': StorageFolderType.generic.wire,
      'visibility': TourVisibility.public.wire,
    });
    final response = await _client.upload<dynamic>(
      ApiPaths.generalUpload,
      data: formData,
      onSendProgress: onSendProgress,
    );
    return UploadResult.fromJson(unwrapMap(response.data));
  }

  /// Uploads a document with `POST /pm/documents/upload` and returns the
  /// created document (`Document`) as JSON. `document_type` is required. The
  /// title defaults to the file name on the backend. The file is private.
  Future<Map<String, dynamic>> uploadDocument({
    required XFile file,
    required DocumentType documentType,
    String? title,
    int? propertyId,
    int? leaseId,
    bool sharedWithTenant = false,
    ProgressCallback? onSendProgress,
    int maxBytes = kMaxUploadBytes,
  }) async {
    final trimmedTitle = title?.trim();
    final formData = FormData.fromMap({
      'file': await _filePart(file, maxBytes),
      'document_type': documentType.wire,
      // A blank title is not sent. The backend uses the file name.
      if (trimmedTitle != null && trimmedTitle.isNotEmpty)
        'title': trimmedTitle,
      if (propertyId != null) 'property_id': propertyId.toString(),
      if (leaseId != null) 'lease_id': leaseId.toString(),
      if (sharedWithTenant) 'shared_with_tenant': 'true',
    });
    final response = await _client.upload<dynamic>(
      ApiPaths.documentsUpload,
      data: formData,
      onSendProgress: onSendProgress,
      ownerScoped: true,
    );
    return unwrapMap(response.data);
  }
}
