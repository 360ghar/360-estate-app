import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';

abstract interface class LeasesRepository {
  Future<Page<Lease>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  });

  Future<Lease> getLeaseById(int id);

  Future<Lease> createLease({
    required int propertyId,
    required String tenantUserId,
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyRent,
    double? securityDeposit,
    int rentDueDay = 1,
    double? lateFeeAmount,
    int? lateFeeGraceDays,
    int renewalNotifyDays = 30,
    String? notes,
  });

  Future<Lease> uploadSignedLease(int leaseId, String filePath);

  Future<Lease> renewLease({
    required int leaseId,
    required DateTime newEndDate,
    double? newMonthlyRent,
  });

  Future<void> terminateLease(int leaseId, {String? reason});
}
