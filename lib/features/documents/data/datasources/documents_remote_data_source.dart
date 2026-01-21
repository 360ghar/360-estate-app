import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart' as app_page;
import 'package:estate_app/features/documents/data/models/document_dto.dart';

abstract interface class DocumentsRemoteDataSource {
  Future<app_page.Page<DocumentDto>> getDocuments({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? documentType,
  });

  Future<DocumentDto> getDocumentById(int id);

  Future<DocumentDto> uploadDocument({
    required File file,
    required String documentType,
    int? propertyId,
    int? leaseId,
    String? description,
    String? expiryDate,
  });

  Future<DocumentDto> updateDocument(int id, Map<String, dynamic> updates);

  Future<void> deleteDocument(int id);

  Future<String> getDownloadUrl(int id);
}

final class ApiDocumentsRemoteDataSource implements DocumentsRemoteDataSource {
  ApiDocumentsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<app_page.Page<DocumentDto>> getDocuments({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? documentType,
  }) async {
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      if (documentType != null) 'document_type': documentType,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/documents',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [])
        .map((e) => DocumentDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return app_page.Page<DocumentDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<DocumentDto> getDocumentById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/documents/$id',
    );

    return DocumentDto.fromJson(response.data!);
  }

  @override
  Future<DocumentDto> uploadDocument({
    required File file,
    required String documentType,
    int? propertyId,
    int? leaseId,
    String? description,
    String? expiryDate,
  }) async {
    final fileName = file.path.split('/').last;
    final trimmedDescription = description?.trim();
    final title =
        (trimmedDescription != null && trimmedDescription.isNotEmpty)
            ? trimmedDescription
            : fileName;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'document_type': documentType,
      'title': title,
      if (propertyId != null) 'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      if (expiryDate != null) 'expiry_date': expiryDate,
    });

    final response = await _apiClient.upload<Map<String, dynamic>>(
      '/pm/documents/upload',
      data: formData,
    );

    return DocumentDto.fromJson(response.data!);
  }

  @override
  Future<DocumentDto> updateDocument(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/documents/$id',
      data: updates,
    );

    return DocumentDto.fromJson(response.data!);
  }

  @override
  Future<void> deleteDocument(int id) async {
    await _apiClient.delete<void>('/pm/documents/$id');
  }

  @override
  Future<String> getDownloadUrl(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/documents/$id/download',
    );

    return response.data!['url'] as String? ?? response.data!['download_url'] as String;
  }
}
