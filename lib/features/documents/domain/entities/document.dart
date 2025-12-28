import 'package:flutter/material.dart';

enum DocumentType {
  leaseAgreement,
  rentReceipt,
  identityProof,
  addressProof,
  propertyDocument,
  maintenanceInvoice,
  inspection,
  other,
  ;

  static DocumentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'lease_agreement':
        return DocumentType.leaseAgreement;
      case 'rent_receipt':
        return DocumentType.rentReceipt;
      case 'identity_proof':
        return DocumentType.identityProof;
      case 'address_proof':
        return DocumentType.addressProof;
      case 'property_document':
        return DocumentType.propertyDocument;
      case 'maintenance_invoice':
        return DocumentType.maintenanceInvoice;
      case 'inspection':
        return DocumentType.inspection;
      default:
        return DocumentType.other;
    }
  }

  String get apiValue {
    switch (this) {
      case DocumentType.leaseAgreement:
        return 'lease_agreement';
      case DocumentType.rentReceipt:
        return 'rent_receipt';
      case DocumentType.identityProof:
        return 'identity_proof';
      case DocumentType.addressProof:
        return 'address_proof';
      case DocumentType.propertyDocument:
        return 'property_document';
      case DocumentType.maintenanceInvoice:
        return 'maintenance_invoice';
      case DocumentType.inspection:
        return 'inspection';
      case DocumentType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case DocumentType.leaseAgreement:
        return 'Lease Agreement';
      case DocumentType.rentReceipt:
        return 'Rent Receipt';
      case DocumentType.identityProof:
        return 'Identity Proof';
      case DocumentType.addressProof:
        return 'Address Proof';
      case DocumentType.propertyDocument:
        return 'Property Document';
      case DocumentType.maintenanceInvoice:
        return 'Maintenance Invoice';
      case DocumentType.inspection:
        return 'Inspection';
      case DocumentType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentType.leaseAgreement:
        return Icons.description;
      case DocumentType.rentReceipt:
        return Icons.receipt;
      case DocumentType.identityProof:
        return Icons.badge;
      case DocumentType.addressProof:
        return Icons.home;
      case DocumentType.propertyDocument:
        return Icons.apartment;
      case DocumentType.maintenanceInvoice:
        return Icons.build;
      case DocumentType.inspection:
        return Icons.checklist;
      case DocumentType.other:
        return Icons.insert_drive_file;
    }
  }

  Color get color {
    switch (this) {
      case DocumentType.leaseAgreement:
        return Colors.blue;
      case DocumentType.rentReceipt:
        return Colors.green;
      case DocumentType.identityProof:
        return Colors.purple;
      case DocumentType.addressProof:
        return Colors.teal;
      case DocumentType.propertyDocument:
        return Colors.orange;
      case DocumentType.maintenanceInvoice:
        return Colors.brown;
      case DocumentType.inspection:
        return Colors.indigo;
      case DocumentType.other:
        return Colors.grey;
    }
  }
}

final class Document {
  const Document({
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
  final DocumentType documentType;
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

  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysToExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysToExpiry >= 0 && daysToExpiry <= 30;
  }

  String get formattedFileSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isPdf => mimeType == 'application/pdf' || fileName.endsWith('.pdf');
  bool get isImage =>
      mimeType?.startsWith('image/') == true ||
      fileName.endsWith('.jpg') ||
      fileName.endsWith('.jpeg') ||
      fileName.endsWith('.png');
}
