import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';

class DocumentsRepository {
  DocumentsRepository(this._client);

  final ApiClient _client;

  Future<List<DocumentItem>> list() async {
    final response = await _client.get<dynamic>('/pm/documents/');
    final data = unwrapList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(DocumentItem.fromJson)
        .toList();
  }

  Future<DocumentItem> upload({
    required File file,
    String? title,
    String? type,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      if (type != null && type.trim().isNotEmpty) 'type': type.trim(),
    });

    final response = await _client.upload<dynamic>(
      '/pm/documents/upload',
      data: formData,
    );
    final data = unwrapMap(response.data);
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
