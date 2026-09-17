/// Canonical document type for uploads and filters.
///
/// Moved from the deleted `features/documents/` clean-arch scaffold.
/// The live documents UI uses [String] `type` values on the wire;
/// this enum is the type-safe source for those values.
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

}
