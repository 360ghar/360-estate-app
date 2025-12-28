import 'dart:io';

import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';

abstract interface class DocumentsRepository {
  Future<Page<Document>> getDocuments({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? documentType,
  });

  Future<Document> getDocumentById(int id);

  Future<Document> uploadDocument({
    required File file,
    required String documentType,
    int? propertyId,
    int? leaseId,
    String? description,
    DateTime? expiryDate,
  });

  Future<Document> updateDocument(int id, Map<String, dynamic> updates);

  Future<void> deleteDocument(int id);

  Future<String> getDownloadUrl(int id);
}
