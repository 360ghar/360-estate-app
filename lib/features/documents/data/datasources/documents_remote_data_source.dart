import 'dart:io';

import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/documents/data/models/document_dto.dart';

/// Remote data source for document management.
/// NOTE: The PM documents endpoints (/pm/documents/*) do not yet exist in the backend.
abstract interface class DocumentsRemoteDataSource {
  Future<Page<DocumentDto>> getDocuments({
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

/// Stub implementation that returns empty data since PM documents endpoints
/// are not available in the current backend.
final class ApiDocumentsRemoteDataSource implements DocumentsRemoteDataSource {
  ApiDocumentsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<DocumentDto>> getDocuments({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? documentType,
  }) async {
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    return Page<DocumentDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<DocumentDto> getDocumentById(int id) async {
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    throw UnsupportedError(
      'Document management is not yet available. PM module pending backend implementation.',
    );
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
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    throw UnsupportedError(
      'Document upload is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<DocumentDto> updateDocument(int id, Map<String, dynamic> updates) async {
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    throw UnsupportedError(
      'Document update is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<void> deleteDocument(int id) async {
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    throw UnsupportedError(
      'Document deletion is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<String> getDownloadUrl(int id) async {
    print('[DOCUMENTS] WARNING: PM documents endpoint not available');
    throw UnsupportedError(
      'Document download is not yet available. PM module pending backend implementation.',
    );
  }
}

