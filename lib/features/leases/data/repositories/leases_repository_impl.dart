import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/data/datasources/leases_remote_data_source.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';

final class LeasesRepositoryImpl implements LeasesRepository {
  LeasesRepositoryImpl({
    required LeasesRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final LeasesRemoteDataSource _dataSource;

  @override
  Future<Page<Lease>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  }) async {
    final dtoPage = await _dataSource.getLeases(
      page: page,
      limit: limit,
      propertyId: propertyId,
      status: status,
    );

    return Page<Lease>(
      items: dtoPage.items.map((d) => d.toEntity()).toList(growable: false),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<Lease> getLeaseById(int id) async {
    final dto = await _dataSource.getLeaseById(id);
    return dto.toEntity();
  }

  @override
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
  }) async {
    final data = <String, dynamic>{
      'property_id': propertyId,
      'tenant_user_id': tenantUserId,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'monthly_rent': monthlyRent,
      if (securityDeposit != null) 'security_deposit': securityDeposit,
      'rent_due_day': rentDueDay,
      if (lateFeeAmount != null) 'late_fee_amount': lateFeeAmount,
      if (lateFeeGraceDays != null) 'late_fee_grace_days': lateFeeGraceDays,
      'renewal_notify_days': renewalNotifyDays,
      if (notes != null) 'notes': notes,
    };

    final dto = await _dataSource.createLease(data);
    return dto.toEntity();
  }

  @override
  Future<Lease> uploadSignedLease(int leaseId, String filePath) async {
    final dto = await _dataSource.uploadSignedLease(leaseId, filePath);
    return dto.toEntity();
  }

  @override
  Future<Lease> renewLease({
    required int leaseId,
    required DateTime newEndDate,
    double? newMonthlyRent,
  }) async {
    final data = <String, dynamic>{
      'new_end_date': newEndDate.toIso8601String().split('T')[0],
      if (newMonthlyRent != null) 'new_monthly_rent': newMonthlyRent,
    };

    final dto = await _dataSource.renewLease(leaseId, data);
    return dto.toEntity();
  }

  @override
  Future<void> terminateLease(int leaseId, {String? reason}) async {
    await _dataSource.terminateLease(leaseId, reason: reason);
  }
}
