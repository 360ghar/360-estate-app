import 'package:flutter/material.dart';

enum DocumentType {
  leaseAgreement,
  idProof,
  addressProof,
  incomeProof,
  inspectionReport,
  receipt,
  invoice,
  propertyDeed,
  insurancePolicy,
  other,
  ;

  static DocumentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'lease_agreement':
        return DocumentType.leaseAgreement;
      case 'id_proof':
      case 'identity_proof':
        return DocumentType.idProof;
      case 'address_proof':
        return DocumentType.addressProof;
      case 'income_proof':
        return DocumentType.incomeProof;
      case 'inspection_report':
      case 'inspection':
        return DocumentType.inspectionReport;
      case 'receipt':
      case 'rent_receipt':
        return DocumentType.receipt;
      case 'invoice':
      case 'maintenance_invoice':
        return DocumentType.invoice;
      case 'property_deed':
      case 'property_document':
        return DocumentType.propertyDeed;
      case 'insurance_policy':
        return DocumentType.insurancePolicy;
      default:
        return DocumentType.other;
    }
  }

  String get apiValue {
    switch (this) {
      case DocumentType.leaseAgreement:
        return 'lease_agreement';
      case DocumentType.idProof:
        return 'id_proof';
      case DocumentType.addressProof:
        return 'address_proof';
      case DocumentType.incomeProof:
        return 'income_proof';
      case DocumentType.inspectionReport:
        return 'inspection_report';
      case DocumentType.receipt:
        return 'receipt';
      case DocumentType.invoice:
        return 'invoice';
      case DocumentType.propertyDeed:
        return 'property_deed';
      case DocumentType.insurancePolicy:
        return 'insurance_policy';
      case DocumentType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case DocumentType.leaseAgreement:
        return 'Lease Agreement';
      case DocumentType.idProof:
        return 'ID Proof';
      case DocumentType.addressProof:
        return 'Address Proof';
      case DocumentType.incomeProof:
        return 'Income Proof';
      case DocumentType.inspectionReport:
        return 'Inspection Report';
      case DocumentType.receipt:
        return 'Receipt';
      case DocumentType.invoice:
        return 'Invoice';
      case DocumentType.propertyDeed:
        return 'Property Deed';
      case DocumentType.insurancePolicy:
        return 'Insurance Policy';
      case DocumentType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentType.leaseAgreement:
        return Icons.description;
      case DocumentType.receipt:
        return Icons.receipt;
      case DocumentType.idProof:
        return Icons.badge;
      case DocumentType.addressProof:
        return Icons.home;
      case DocumentType.propertyDeed:
        return Icons.apartment;
      case DocumentType.invoice:
        return Icons.build;
      case DocumentType.inspectionReport:
        return Icons.checklist;
      case DocumentType.incomeProof:
        return Icons.account_balance_wallet_outlined;
      case DocumentType.insurancePolicy:
        return Icons.verified_outlined;
      case DocumentType.other:
        return Icons.insert_drive_file;
    }
  }

  Color get color {
    switch (this) {
      case DocumentType.leaseAgreement:
        return Colors.blue;
      case DocumentType.receipt:
        return Colors.green;
      case DocumentType.idProof:
        return Colors.purple;
      case DocumentType.addressProof:
        return Colors.teal;
      case DocumentType.propertyDeed:
        return Colors.orange;
      case DocumentType.invoice:
        return Colors.brown;
      case DocumentType.inspectionReport:
        return Colors.indigo;
      case DocumentType.incomeProof:
        return Colors.blueGrey;
      case DocumentType.insurancePolicy:
        return Colors.cyan;
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
