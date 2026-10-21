import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

extension DocumentTypeText on DocumentType {
  String text(AppLocalizations l10n) => switch (this) {
    DocumentType.leaseAgreement => l10n.documentTypeLeaseAgreement,
    DocumentType.idProof => l10n.documentTypeIdProof,
    DocumentType.addressProof => l10n.documentTypeAddressProof,
    DocumentType.incomeProof => l10n.documentTypeIncomeProof,
    DocumentType.inspectionReport => l10n.documentTypeInspectionReport,
    DocumentType.receipt => l10n.documentTypeReceipt,
    DocumentType.invoice => l10n.documentTypeInvoice,
    DocumentType.propertyDeed => l10n.documentTypePropertyDeed,
    DocumentType.insurancePolicy => l10n.documentTypeInsurancePolicy,
    DocumentType.other => l10n.documentTypeOther,
  };
}

/// The glyph of a file, from its MIME type or, without one, its name.
IconData fileIcon(String? mimeTypeOrName) {
  final t = (mimeTypeOrName ?? '').toLowerCase();
  if (t.contains('pdf')) return Icons.picture_as_pdf_outlined;
  if (RegExp(r'image|jpe?g|png|gif|webp|heic').hasMatch(t)) {
    return Icons.image_outlined;
  }
  if (RegExp(r'xls|sheet|csv').hasMatch(t)) return Icons.table_chart_outlined;
  if (RegExp(r'doc|word|text').hasMatch(t)) return Icons.article_outlined;
  return Icons.insert_drive_file_outlined;
}

/// 120300 -> 117.5 KB.
String fileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
