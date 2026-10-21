import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lease.freezed.dart';
part 'lease.g.dart';

/// A lease as the backend sends it (`Lease`). Money is a JSON number. `start_date`,
/// `end_date` and `termination_date` are dates (`YYYY-MM-DD`). The late fee,
/// grace period and due day are the values the backend enforces.
@freezed
class Lease with _$Lease {
  const factory Lease({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'tenant_phone') String? tenantPhone,
    @JsonKey(name: 'tenant_email') String? tenantEmail,
    @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
    LeaseStatus? status,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    double? securityDeposit,
    @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
    double? lateFeeAmount,
    @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
    double? lateFeePercentage,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    int? gracePeriodDays,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'special_clauses') String? specialClauses,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'termination_date', fromJson: parseDateTime)
    DateTime? terminationDate,
    @JsonKey(name: 'termination_reason') String? terminationReason,
    @JsonKey(name: 'lease_document_id', fromJson: parseInt)
    int? leaseDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _Lease;

  factory Lease.fromJson(Map<String, dynamic> json) => _$LeaseFromJson(json);
}

extension LeaseX on Lease {
  String get displayName {
    final tenant = tenantName?.trim();
    if (tenant != null && tenant.isNotEmpty) return tenant;
    return id == null ? 'Lease' : 'Lease #$id';
  }

  /// An occupying lease: active, or active and ending within the notice window.
  bool get isOccupying =>
      status == LeaseStatus.active || status == LeaseStatus.expiringSoon;

  bool get isExpiringSoon => status == LeaseStatus.expiringSoon;

  /// The backend renews only an active or expiring lease (400 otherwise).
  bool get canRenew => isOccupying;

  /// The backend terminates an active, expiring or pending-signature lease. A
  /// draft or a renewed lease gives 400, and an ended one is already over.
  bool get canTerminate =>
      isOccupying || status == LeaseStatus.pendingSignature;

  /// The lease ended: expired (the backend's daily job sets it), or its end
  /// date has passed while it is still shown as active.
  bool get isExpired =>
      status == LeaseStatus.expired ||
      (isOccupying && (daysUntilEnd(DateTime.now()) ?? 0) < 0);

  /// Whole days from [today] to the end date. Negative after the end date.
  int? daysUntilEnd(DateTime today) {
    final end = endDate;
    if (end == null) return null;
    final endDay = DateTime.utc(end.year, end.month, end.day);
    final day = DateTime.utc(today.year, today.month, today.day);
    return endDay.difference(day).inDays;
  }

  /// How the backend charges a late fee for this lease, or null when the
  /// lease has no late fee. A fixed amount wins over a percentage of the rent.
  String? get lateFeeDescription {
    final amount = lateFeeAmount;
    if (amount != null && amount > 0) {
      return '₹${_trimZeros(amount)} flat';
    }
    final percentage = lateFeePercentage;
    if (percentage != null && percentage > 0) {
      return '${_trimZeros(percentage)}% of the rent';
    }
    return null;
  }

  /// `Rent is due on day 5. Late fee after 3 days of grace.`
  String? get enforcementSummary {
    final parts = <String>[];
    final dueDay = paymentDueDay;
    if (dueDay != null) parts.add('Rent is due on day $dueDay of each month.');
    final fee = lateFeeDescription;
    final grace = gracePeriodDays;
    if (fee != null) {
      final graceText = grace == null
          ? 'after the grace period'
          : grace == 0
          ? 'right after the due date'
          : 'after $grace ${grace == 1 ? 'day' : 'days'} of grace';
      parts.add('A late fee of $fee is charged once $graceText.');
    } else if (grace != null) {
      parts.add('Grace period: $grace ${grace == 1 ? 'day' : 'days'}.');
    }
    return parts.isEmpty ? null : parts.join(' ');
  }
}

extension LeaseStatusLabel on LeaseStatus {
  String get label => switch (this) {
    LeaseStatus.draft => 'Draft',
    LeaseStatus.pendingSignature => 'Pending signature',
    LeaseStatus.active => 'Active',
    LeaseStatus.expiringSoon => 'Expiring soon',
    LeaseStatus.expired => 'Expired',
    LeaseStatus.terminated => 'Terminated',
    LeaseStatus.renewed => 'Renewed',
  };
}

String _trimZeros(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
