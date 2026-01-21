import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_charge.freezed.dart';
part 'rent_charge.g.dart';

@freezed
class RentCharge with _$RentCharge {
  const factory RentCharge({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    String? status,
  }) = _RentCharge;

  factory RentCharge.fromJson(Map<String, dynamic> json) =>
      _$RentChargeFromJson(_normalizeRentChargeJson(json));
}

extension RentChargeX on RentCharge {
  String get displayTenant => tenantName ?? 'Tenant';
  String get displayProperty => propertyName ?? 'Property';
  double get displayAmount => amount ?? 0;
}

Map<String, dynamic> _normalizeRentChargeJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  normalized['amount'] ??= json['amount_due'] ?? json['amountDue'];
  normalized['due_date'] ??= json['dueDate'];
  normalized['tenant_name'] ??= json['tenantName'];
  normalized['property_name'] ??=
      json['propertyName'] ?? json['property_title'] ?? json['propertyTitle'];
  return normalized;
}
