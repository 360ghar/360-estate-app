import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lease.freezed.dart';
part 'lease.g.dart';

@freezed
class Lease with _$Lease {
  const factory Lease({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'rent_amount', fromJson: parseDouble) double? rentAmount,
    @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
    double? depositAmount,
    String? status,
    @JsonKey(name: 'signed_document_url') String? signedDocumentUrl,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _Lease;

  factory Lease.fromJson(Map<String, dynamic> json) => _$LeaseFromJson(json);
}

extension LeaseX on Lease {
  String get displayName {
    final property = propertyName?.trim();
    final tenant = tenantName?.trim();
    if (property != null && property.isNotEmpty && tenant != null) {
      return '$property - $tenant';
    }
    return property ?? tenant ?? 'Lease';
  }
}
