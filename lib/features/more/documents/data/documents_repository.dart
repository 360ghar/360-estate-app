import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';

class DocumentsRepository {
  DocumentsRepository(this._client);

  final ApiClient _client;

  Future<List<DocumentItem>> list() async {
    final response = await _client.get<dynamic>('/pm/documents');
    final page = unwrapPage(response.data);
    return page.items
        .whereType<Map<String, dynamic>>()
        .map(DocumentItem.fromJson)
        .toList();
  }

  /// Uploads via the shared [FileUploadService] so there is a single upload
  /// implementation. Takes the picker's `XFile` directly (bytes-backed on
  /// web, path-backed on IO) so no `dart:io` File is needed. The service
  /// sends `document_type`, which the backend requires
  /// (`POST /pm/documents/upload` takes it as a required Form field).
  Future<DocumentItem> upload({
    required XFile file,
    String? title,
    String? type,
  }) async {
    final uploads = FileUploadService(_client);
    final result = await uploads.uploadXFile(
      file: file,
      title: title,
      type: type,
    );
    final data = result.data;
    if (data == null) {
      throw const UnknownFailure('Upload succeeded but no data returned.');
    }
    return DocumentItem.fromJson(data);
  }

  Future<String?> fetchDownloadUrl(String id) async {
    final response = await _client.get<dynamic>('/pm/documents/$id/download');
    final data = unwrapData(response.data);
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      final url = data['url'] ?? data['download_url'];
      if (url is String && url.isNotEmpty) return url;
    }
    return null;
  }
}
