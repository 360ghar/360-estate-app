import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/models/lease.dart';

abstract interface class LeasesRepository {
  /// One page of leases. Filters are the backend keys `property_id`,
  /// `tenant_user_id` and `status`.
  Future<Page<Lease>> listPage({
    required String? cursor,
    required int limit,
    int? propertyId,
    int? tenantUserId,
    LeaseStatus? status,
  });

  /// Every lease that matches (follows `next_cursor`).
  Future<List<Lease>> listAll({
    int? propertyId,
    int? tenantUserId,
    LeaseStatus? status,
  });

  /// Get a lease by ID
  Future<Lease> fetch(String leaseId);

  /// Create a new lease
  Future<Lease> create(LeaseCreateRequest request);

  /// Upload the signed lease: the file goes through the documents route, then
  /// `upload-signed` links the document (`lease_document_id`) to the lease.
  Future<Lease> uploadSigned(
    String leaseId,
    XFile file, {
    bool signedByTenant = false,
  });

  /// Renew an existing lease
  Future<Lease> renew(String leaseId, LeaseRenewRequest request);

  /// Terminate a lease
  Future<Lease> terminate(String leaseId, LeaseTerminateRequest request);
}

/// Body of `POST /pm/leases` (`LeaseCreate`). Money is a number. Dates are
/// `YYYY-MM-DD`. `payment_due_day` (1 to 28) and `grace_period_days` take the
/// property's values when unset. A fixed `late_fee_amount` wins over a
/// `late_fee_percentage` of the rent.
class LeaseCreateRequest {
  const LeaseCreateRequest({
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    this.securityDeposit = 0,
    this.tenantUserId,
    this.tenantName,
    this.tenantPhone,
    this.tenantEmail,
    this.status,
    this.paymentDueDay,
    this.gracePeriodDays,
    this.lateFeeAmount,
    this.lateFeePercentage,
    this.specialClauses,
  });

  final int propertyId;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double securityDeposit;
  final int? tenantUserId;
  final String? tenantName;
  final String? tenantPhone;
  final String? tenantEmail;

  /// Only `draft`, `pending_signature` and `active` are accepted.
  final LeaseStatus? status;
  final int? paymentDueDay;
  final int? gracePeriodDays;
  final double? lateFeeAmount;
  final double? lateFeePercentage;
  final String? specialClauses;

  static String? _text(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'start_date': toApiDateOnly(startDate),
      'end_date': toApiDateOnly(endDate),
      'monthly_rent': monthlyRent,
      'security_deposit': securityDeposit,
      if (tenantUserId != null) 'tenant_user_id': tenantUserId,
      if (_text(tenantName) != null) 'tenant_name': _text(tenantName),
      if (_text(tenantPhone) != null) 'tenant_phone': _text(tenantPhone),
      if (_text(tenantEmail) != null) 'tenant_email': _text(tenantEmail),
      if (status != null) 'status': status!.wire,
      if (paymentDueDay != null) 'payment_due_day': paymentDueDay,
      if (gracePeriodDays != null) 'grace_period_days': gracePeriodDays,
      if (lateFeeAmount != null) 'late_fee_amount': lateFeeAmount,
      if (lateFeePercentage != null) 'late_fee_percentage': lateFeePercentage,
      if (_text(specialClauses) != null)
        'special_clauses': _text(specialClauses),
    };
  }
}

/// Body of `POST /pm/leases/{id}/renew` (`LeaseRenew`). `start_date` and
/// `end_date` are required. The rent and deposit fall back to the old lease.
class LeaseRenewRequest {
  const LeaseRenewRequest({
    required this.startDate,
    required this.endDate,
    this.monthlyRent,
    this.securityDeposit,
    this.makeActive = false,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double? monthlyRent;
  final double? securityDeposit;
  final bool makeActive;

  Map<String, dynamic> toJson() {
    return {
      'start_date': toApiDateOnly(startDate),
      'end_date': toApiDateOnly(endDate),
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (securityDeposit != null) 'security_deposit': securityDeposit,
      if (makeActive) 'make_active': true,
    };
  }
}

/// Body of `POST /pm/leases/{id}/terminate` (`LeaseTerminate`).
/// `termination_date` is a date, not a datetime.
class LeaseTerminateRequest {
  const LeaseTerminateRequest({this.reason, this.terminationDate});

  final String? reason;
  final DateTime? terminationDate;

  Map<String, dynamic> toJson() {
    final text = reason?.trim();
    return {
      if (text != null && text.isNotEmpty) 'reason': text,
      if (terminationDate != null)
        'termination_date': toApiDateOnly(terminationDate),
    };
  }
}
