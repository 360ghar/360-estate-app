import 'dart:io';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/models/lease.dart';

abstract interface class LeasesRepository {
  /// List leases with optional filters
  Future<List<Lease>> list({
    String? propertyId,
    String? tenantId,
    String? status,
  });

  /// Get a lease by ID
  Future<Lease> fetch(String leaseId);

  /// Create a new lease
  Future<Lease> create(LeaseCreateRequest request);

  /// Upload a signed lease document
  Future<Lease> uploadSigned(String leaseId, File file);

  /// Renew an existing lease
  Future<Lease> renew(String leaseId, LeaseRenewRequest request);

  /// Terminate a lease
  Future<Lease> terminate(String leaseId, LeaseTerminateRequest request);
}

/// Request payload for creating a lease
class LeaseCreateRequest {
  const LeaseCreateRequest({
    required this.propertyId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
    this.depositAmount,
    this.notes,
  });

  final String propertyId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double rentAmount;
  final double? depositAmount;
  final String? notes;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'property_id': propertyId,
      'tenant_id': tenantId,
      'start_date': toApiDateOnly(startDate),
      'end_date': toApiDateOnly(endDate),
      'rent_amount': rentAmount,
    };
    if (depositAmount != null) {
      payload['deposit_amount'] = depositAmount;
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    return payload;
  }
}

/// Request payload for renewing a lease
class LeaseRenewRequest {
  const LeaseRenewRequest({this.newEndDate, this.newRentAmount});

  final DateTime? newEndDate;
  final double? newRentAmount;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (newEndDate != null) {
      payload['end_date'] = toApiDateOnly(newEndDate);
    }
    if (newRentAmount != null) {
      payload['rent_amount'] = newRentAmount;
    }
    return payload;
  }
}

/// Request payload for terminating a lease
class LeaseTerminateRequest {
  const LeaseTerminateRequest({this.reason, this.terminatedAt});

  final String? reason;
  final DateTime? terminatedAt;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (reason != null && reason!.trim().isNotEmpty) {
      payload['reason'] = reason!.trim();
    }
    if (terminatedAt != null) {
      payload['terminated_at'] = toApiUtcInstant(terminatedAt);
    }
    return payload;
  }
}
