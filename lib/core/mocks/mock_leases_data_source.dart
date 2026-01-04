/// Mock implementation of LeasesRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/data/datasources/leases_remote_data_source.dart';
import 'package:estate_app/features/leases/data/models/lease_dto.dart';

final class MockLeasesRemoteDataSource implements LeasesRemoteDataSource {
  MockLeasesRemoteDataSource();

  // Local mutable copy for CRUD operations
  final List<Map<String, dynamic>> _leases = 
      List<Map<String, dynamic>>.from(MockDataFactory.leases);

  int _nextId = 100;

  @override
  Future<Page<LeaseDto>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _leases.toList();

    // Apply filters
    if (propertyId != null) {
      filtered = filtered.where((l) => l['property_id'] == propertyId).toList();
    }
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((l) => l['status'] == status).toList();
    }

    // Sort by start_date descending
    filtered.sort((a, b) {
      final aDate = DateTime.parse(a['start_date'] as String);
      final bDate = DateTime.parse(b['start_date'] as String);
      return bDate.compareTo(aDate);
    });

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map((l) => LeaseDto.fromJson(l)).toList();

    return Page<LeaseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<LeaseDto> getLeaseById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final lease = _leases.firstWhere(
      (l) => l['id'] == id,
      orElse: () => throw Exception('Lease not found: $id'),
    );

    return LeaseDto.fromJson(lease);
  }

  @override
  Future<LeaseDto> createLease(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();

    // Find property title
    final propertyId = data['property_id'] as int;
    final property = MockDataFactory.findPropertyById(propertyId);
    final propertyTitle = property?['title'] ?? 'Unknown Property';

    // Find tenant name
    final tenantUserId = data['tenant_user_id'] as String;
    final tenant = MockDataFactory.tenants.firstWhere(
      (t) => t['user_id'] == tenantUserId,
      orElse: () => {'full_name': 'Unknown Tenant'},
    );
    final tenantName = tenant['full_name'] as String;

    final newLease = {
      'id': _nextId++,
      'property_id': propertyId,
      'property_title': propertyTitle,
      'tenant_user_id': tenantUserId,
      'tenant_name': tenantName,
      'start_date': data['start_date'],
      'end_date': data['end_date'],
      'monthly_rent': data['monthly_rent'],
      'security_deposit': data['security_deposit'],
      'rent_due_day': data['rent_due_day'] ?? 1,
      'late_fee_amount': data['late_fee_amount'],
      'late_fee_grace_days': data['late_fee_grace_days'],
      'renewal_notify_days': data['renewal_notify_days'] ?? 30,
      'signed_document_url': null,
      'status': 'draft',
      'notes': data['notes'],
      'created_at': now,
      'updated_at': now,
    };

    _leases.insert(0, newLease);
    return LeaseDto.fromJson(newLease);
  }

  @override
  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _leases.indexWhere((l) => l['id'] == leaseId);
    if (index == -1) {
      throw Exception('Lease not found: $leaseId');
    }

    final updated = Map<String, dynamic>.from(_leases[index]);
    updated['signed_document_url'] = 'https://storage.example.com/leases/signed_$leaseId.pdf';
    updated['status'] = 'active';
    updated['updated_at'] = DateTime.now().toIso8601String();

    _leases[index] = updated;
    return LeaseDto.fromJson(updated);
  }

  @override
  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final oldLease = _leases.firstWhere(
      (l) => l['id'] == leaseId,
      orElse: () => throw Exception('Lease not found: $leaseId'),
    );

    // Mark old lease as renewed
    final oldIndex = _leases.indexWhere((l) => l['id'] == leaseId);
    final updatedOld = Map<String, dynamic>.from(oldLease);
    updatedOld['status'] = 'renewed';
    updatedOld['updated_at'] = DateTime.now().toIso8601String();
    _leases[oldIndex] = updatedOld;

    // Create new lease
    final now = DateTime.now().toIso8601String();
    final newLease = {
      'id': _nextId++,
      'property_id': oldLease['property_id'],
      'property_title': oldLease['property_title'],
      'tenant_user_id': oldLease['tenant_user_id'],
      'tenant_name': oldLease['tenant_name'],
      'start_date': data['start_date'],
      'end_date': data['end_date'],
      'monthly_rent': data['monthly_rent'] ?? oldLease['monthly_rent'],
      'security_deposit': oldLease['security_deposit'],
      'rent_due_day': data['rent_due_day'] ?? oldLease['rent_due_day'],
      'late_fee_amount': oldLease['late_fee_amount'],
      'late_fee_grace_days': oldLease['late_fee_grace_days'],
      'renewal_notify_days': oldLease['renewal_notify_days'],
      'signed_document_url': null,
      'status': 'draft',
      'notes': data['notes'] ?? 'Renewed from lease #$leaseId',
      'created_at': now,
      'updated_at': now,
    };

    _leases.insert(0, newLease);
    return LeaseDto.fromJson(newLease);
  }

  @override
  Future<void> terminateLease(int leaseId, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _leases.indexWhere((l) => l['id'] == leaseId);
    if (index == -1) {
      throw Exception('Lease not found: $leaseId');
    }

    final updated = Map<String, dynamic>.from(_leases[index]);
    updated['status'] = 'terminated';
    updated['notes'] = reason ?? updated['notes'];
    updated['updated_at'] = DateTime.now().toIso8601String();

    _leases[index] = updated;
  }
}
