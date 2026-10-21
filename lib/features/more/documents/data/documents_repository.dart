import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';

class DocumentsRepository {
  DocumentsRepository(this._client, this._uploads);

  final ApiClient _client;
  final FileUploadService _uploads;

  Future<Page<DocumentItem>> listPage({
    required String? cursor,
    required int limit,
    int? propertyId,
    int? leaseId,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.documents,
      ownerScoped: true,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (leaseId != null) 'lease_id': leaseId,
      },
    );
    final raw = unwrapPage(response.data);
    return Page<DocumentItem>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(DocumentItem.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
  }

  /// Every document that matches (follows `next_cursor`).
  Future<List<DocumentItem>> listAll({int? propertyId, int? leaseId}) {
    return fetchAllPages<DocumentItem>(
      ({required cursor, required limit}) => listPage(
        cursor: cursor,
        limit: limit,
        propertyId: propertyId,
        leaseId: leaseId,
      ),
    );
  }

  /// Uploads through the shared [FileUploadService] (one upload
  /// implementation). Takes the picker's `XFile` (bytes-backed on web,
  /// path-backed on IO). `document_type` is required by the backend. A blank
  /// [title] is left out and the backend uses the file name.
  Future<DocumentItem> upload({
    required XFile file,
    required DocumentType documentType,
    String? title,
    int? propertyId,
    int? leaseId,
  }) async {
    final json = await _uploads.uploadDocument(
      file: file,
      documentType: documentType,
      title: title,
      propertyId: propertyId,
      leaseId: leaseId,
    );
    return DocumentItem.fromJson(json);
  }

  /// The signed link of one document (`GET /pm/documents/{id}/download`). The
  /// backend answers 403 when the caller may not open the file. Use it when
  /// only the document id is known, for example a lease's signed document.
  Future<String?> fetchDownloadUrl(int id) async {
    final response = await _client.get<dynamic>(ApiPaths.documentDownload(id));
    final url = unwrapMap(response.data)['url'];
    return url is String && url.isNotEmpty ? url : null;
  }
}
