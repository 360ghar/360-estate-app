import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/data/models/tenant_dto.dart';

abstract interface class TenantsRemoteDataSource {
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  });

  Future<TenantDto> getTenantById(String id);

  /// Get current tenant's own data (for tenant view)
  Future<TenantDto> getMyTenantData();

  Future<TenantDto> createTenant(Map<String, dynamic> data);
}

final class ApiTenantsRemoteDataSource implements TenantsRemoteDataSource {
  ApiTenantsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  }) async {
    // NOTE: /pm/tenants endpoint does NOT exist in the current backend
    // This is a placeholder implementation until the PM module is added
    print('[TENANTS] WARNING: /pm/tenants endpoint not available in backend');
    print('[TENANTS] Returning empty list - PM module pending implementation');
    
    return Page<TenantDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<TenantDto> getTenantById(String id) async {
    // NOTE: /pm/tenants/{id} endpoint does NOT exist
    print('[TENANTS] WARNING: /pm/tenants/$id endpoint not available');
    throw UnsupportedError(
      'Tenant management is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<TenantDto> getMyTenantData() async {
    // NOTE: /pm/tenants/me endpoint does NOT exist
    print('[TENANTS] WARNING: /pm/tenants/me endpoint not available');
    throw UnsupportedError(
      'Tenant profile is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<TenantDto> createTenant(Map<String, dynamic> data) async {
    // NOTE: POST /pm/tenants endpoint does NOT exist
    print('[TENANTS] WARNING: POST /pm/tenants endpoint not available');
    throw UnsupportedError(
      'Tenant creation is not yet available. PM module pending backend implementation.',
    );
  }
}
