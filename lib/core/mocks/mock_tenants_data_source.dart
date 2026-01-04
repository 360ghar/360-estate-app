/// Mock implementation of TenantsRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/data/datasources/tenants_remote_data_source.dart';
import 'package:estate_app/features/tenants/data/models/tenant_dto.dart';

final class MockTenantsRemoteDataSource implements TenantsRemoteDataSource {
  MockTenantsRemoteDataSource();

  @override
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = MockDataFactory.tenants.toList();

    // Apply search filter
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where((t) {
        final name = (t['full_name'] as String? ?? '').toLowerCase();
        final email = (t['email'] as String? ?? '').toLowerCase();
        final phone = (t['phone'] as String? ?? '').toLowerCase();
        return name.contains(q) || email.contains(q) || phone.contains(q);
      }).toList();
    }

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map(_mapToDto).toList();

    return Page<TenantDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<TenantDto> getTenantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final tenant = MockDataFactory.tenants.firstWhere(
      (t) => t['id'].toString() == id || t['user_id'] == id,
      orElse: () => throw Exception('Tenant not found: $id'),
    );

    return _mapToDto(tenant);
  }

  @override
  Future<TenantDto> getMyTenantData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Return first tenant as "current user" for demo
    final tenant = MockDataFactory.tenants.firstOrNull;
    if (tenant == null) {
      throw Exception('No tenant data available');
    }

    return _mapToDto(tenant);
  }

  TenantDto _mapToDto(Map<String, dynamic> t) {
    // Map current_lease if present
    Map<String, dynamic>? currentLeaseData;
    final currentLease = t['current_lease'];
    if (currentLease != null && currentLease is Map<String, dynamic>) {
      // Look up full lease data
      final leaseId = currentLease['id'];
      final fullLease = MockDataFactory.leases.firstWhere(
        (l) => l['id'] == leaseId,
        orElse: () => currentLease,
      );
      currentLeaseData = fullLease;
    }

    return TenantDto.fromJson({
      ...t,
      if (currentLeaseData != null) 'current_lease': currentLeaseData,
    });
  }

  @override
  Future<TenantDto> createTenant(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate creating a new tenant
    final newTenant = {
      'id': MockDataFactory.tenants.length + 1,
      'user_id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      ...data,
      'status': data['status'] ?? 'active',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    return _mapToDto(newTenant);
  }
}
