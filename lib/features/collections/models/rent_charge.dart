import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_charge.freezed.dart';
part 'rent_charge.g.dart';

/// One month's rent for a lease (`RentCharge`). The late fee is the fee the
/// backend already assessed; it is zero until the grace period has passed.
@freezed
class RentCharge with _$RentCharge {
  const factory RentCharge({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'billing_month', fromJson: parseDateTime)
    DateTime? billingMonth,
    @JsonKey(name: 'period_start', fromJson: parseDateTime)
    DateTime? periodStart,
    @JsonKey(name: 'period_end', fromJson: parseDateTime) DateTime? periodEnd,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    @JsonKey(name: 'amount_due', fromJson: parseDouble) double? amountDue,
    @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
    double? lateFeeAssessed,
    @JsonKey(
      fromJson: RentChargeStatus.fromJson,
      toJson: RentChargeStatus.toJsonValue,
    )
    RentChargeStatus? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _RentCharge;

  factory RentCharge.fromJson(Map<String, dynamic> json) =>
      _$RentChargeFromJson(json);
}

/// A list item of `GET /pm/rent/charges`: the charge and its totals
/// (`RentChargeWithTotals`). The amounts count settled payments only.
@freezed
class RentChargeWithTotals with _$RentChargeWithTotals {
  const factory RentChargeWithTotals({
    required RentCharge charge,
    @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
    double? amountPaidTotal,
    @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
    double? amountDueTotal,
    @JsonKey(fromJson: parseDouble) double? outstanding,
  }) = _RentChargeWithTotals;

  factory RentChargeWithTotals.fromJson(Map<String, dynamic> json) =>
      _$RentChargeWithTotalsFromJson(json);
}

extension RentChargeWithTotalsX on RentChargeWithTotals {
  int? get id => charge.id;
  RentChargeStatus? get status => charge.status;
  DateTime? get dueDate => charge.dueDate;

  /// The whole amount due for this charge: the rent and the assessed late fee.
  double get totalDue =>
      amountDueTotal ?? (charge.amountDue ?? 0) + (charge.lateFeeAssessed ?? 0);

  double get paid => amountPaidTotal ?? 0;

  /// What is still owed (rent and assessed late fee, less settled payments).
  double get balance => outstanding ?? (totalDue - paid).clamp(0, totalDue);

  double get lateFee => charge.lateFeeAssessed ?? 0;
}

extension RentChargeStatusLabel on RentChargeStatus {
  String get label => switch (this) {
    RentChargeStatus.pending => 'Due',
    RentChargeStatus.partial => 'Partly paid',
    RentChargeStatus.paid => 'Paid',
    RentChargeStatus.overdue => 'Overdue',
    RentChargeStatus.waived => 'Waived',
  };
}
