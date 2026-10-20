import 'package:estate_app/core/api/wire_enums.dart';

/// Display names for [DocumentType], the wire enum of `Document.document_type`.
/// Send `DocumentType.wire` in requests.
extension DocumentTypeLabel on DocumentType {
  String get displayName => switch (this) {
    DocumentType.leaseAgreement => 'Lease Agreement',
    DocumentType.idProof => 'ID Proof',
    DocumentType.addressProof => 'Address Proof',
    DocumentType.incomeProof => 'Income Proof',
    DocumentType.inspectionReport => 'Inspection Report',
    DocumentType.receipt => 'Receipt',
    DocumentType.invoice => 'Invoice',
    DocumentType.propertyDeed => 'Property Deed',
    DocumentType.insurancePolicy => 'Insurance Policy',
    DocumentType.other => 'Other',
  };
}
