import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';

final class DocumentDto {
  const DocumentDto({
    required this.id,
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    this.propertyId,
    this.propertyTitle,
    this.leaseId,
    this.tenantName,
    this.description,
    this.fileSize,
    this.mimeType,
    this.uploadedAt,
    this.expiryDate,
  });

  final int id;
  final String documentType;
  final String fileName;
  final String fileUrl;
  final int? propertyId;
  final String? propertyTitle;
  final int? leaseId;
  final String? tenantName;
  final String? description;
  final int? fileSize;
  final String? mimeType;
  final DateTime? uploadedAt;
  final DateTime? expiryDate;

  factory DocumentDto.fromJson(Map<String, dynamic> json) {
    return DocumentDto(
      id: parseInt(json['id']) ?? 0,
      documentType: json['document_type'] as String? ?? 'other',
      fileName:
          json['file_name'] as String? ?? json['filename'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? json['url'] as String? ?? '',
      propertyId: json['property_id'] as int?,
      propertyTitle:
          json['property_title'] as String? ??
          json['property']?['title'] as String?,
      leaseId: json['lease_id'] as int?,
      tenantName:
          json['tenant_name'] as String? ?? json['tenant']?['name'] as String?,
      description: json['description'] as String?,
      fileSize: json['file_size'] as int?,
      mimeType: json['mime_type'] as String? ?? json['content_type'] as String?,
      uploadedAt: parseDateTime(json['uploaded_at'] ?? json['created_at']),
      expiryDate: parseDateTime(json['expiry_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'file_name': fileName,
      'file_url': fileUrl,
      if (propertyId != null) 'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      if (description != null) 'description': description,
      if (expiryDate != null) 'expiry_date': toApiDateOnly(expiryDate),
    };
  }

  Document toEntity() {
    return Document(
      id: id,
      documentType: DocumentType.fromString(documentType),
      fileName: fileName,
      fileUrl: fileUrl,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      leaseId: leaseId,
      tenantName: tenantName,
      description: description,
      fileSize: fileSize,
      mimeType: mimeType,
      uploadedAt: uploadedAt,
      expiryDate: expiryDate,
    );
  }
}
