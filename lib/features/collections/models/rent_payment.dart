import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_payment.freezed.dart';
part 'rent_payment.g.dart';

/// A payment against a rent charge (`RentPayment`). A payment recorded by the
/// owner is `settled`. A tenant claim is `pending` until the owner settles it.
@freezed
class RentPayment with _$RentPayment {
  const factory RentPayment({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'charge_id', fromJson: parseInt) int? chargeId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    @JsonKey(name: 'amount_paid', fromJson: parseDouble) double? amountPaid,
    @JsonKey(
      name: 'payment_method',
      fromJson: PaymentMethod.fromJson,
      toJson: PaymentMethod.toJsonValue,
    )
    PaymentMethod? paymentMethod,
    @JsonKey(
      fromJson: RentPaymentStatus.fromJson,
      toJson: RentPaymentStatus.toJsonValue,
    )
    RentPaymentStatus? status,
    String? reference,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _RentPayment;

  factory RentPayment.fromJson(Map<String, dynamic> json) =>
      _$RentPaymentFromJson(json);
}

/// The result of `POST /pm/rent/charges/generate` (`RentChargeGenerateResult`).
@freezed
class RentChargeGenerateResult with _$RentChargeGenerateResult {
  const factory RentChargeGenerateResult({
    @JsonKey(fromJson: parseInt) int? created,
    @JsonKey(fromJson: parseInt) int? skipped,
  }) = _RentChargeGenerateResult;

  factory RentChargeGenerateResult.fromJson(Map<String, dynamic> json) =>
      _$RentChargeGenerateResultFromJson(json);
}

extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.bankTransfer => 'Bank transfer',
    PaymentMethod.upi => 'UPI',
    PaymentMethod.cheque => 'Cheque',
    PaymentMethod.online => 'Online',
    PaymentMethod.other => 'Other',
  };
}
