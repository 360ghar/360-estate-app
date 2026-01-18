import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_payment.freezed.dart';
part 'rent_payment.g.dart';

@freezed
class RentPayment with _$RentPayment {
  const factory RentPayment({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    String? method,
    String? notes,
  }) = _RentPayment;

  factory RentPayment.fromJson(Map<String, dynamic> json) =>
      _$RentPaymentFromJson(json);
}
