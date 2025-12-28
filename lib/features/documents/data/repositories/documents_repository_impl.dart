import 'dart:io';

import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/documents/data/datasources/documents_remote_data_source.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/documents/domain/repositories/documents_repository.dart';

final class DocumentsRepositoryImpl implements DocumentsRepository {
  DocumentsRepositoryImpl(this._remoteDataSource);

  final DocumentsRemoteDataSource _remoteDataSource;

  @override
  Future<Page<Document>> getDocuments({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? documentType,
  }) async {
    final dtoPage = await _remoteDataSource.getDocuments(
      page: page,
      limit: limit,
      propertyId: propertyId,
      leaseId: leaseId,
      documentType: documentType,
    );

    return Page<Document>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<Document> getDocumentById(int id) async {
    final dto = await _remoteDataSource.getDocumentById(id);
    return dto.toEntity();
  }

  @override
  Future<Document> uploadDocument({
    required File file,
    required String documentType,
    int? propertyId,
    int? leaseId,
    String? description,
    DateTime? expiryDate,
  }) async {
    final dto = await _remoteDataSource.uploadDocument(
      file: file,
      documentType: documentType,
      propertyId: propertyId,
      leaseId: leaseId,
      description: description,
      expiryDate: expiryDate?.toIso8601String().split('T')[0],
    );
    return dto.toEntity();
  }

  @override
  Future<Document> updateDocument(int id, Map<String, dynamic> updates) async {
    final dto = await _remoteDataSource.updateDocument(id, updates);
    return dto.toEntity();
  }

  @override
  Future<void> deleteDocument(int id) async {
    await _remoteDataSource.deleteDocument(id);
  }

  @override
  Future<String> getDownloadUrl(int id) async {
    return _remoteDataSource.getDownloadUrl(id);
  }
}
