import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';

abstract interface class TenantsRepository {
  Future<Page<Tenant>> getTenants({
    required int page,
    required int limit,
    required String query,
  });

  Future<Tenant> getTenantById(String id);

  /// Get current tenant's own data (for tenant view)
  Future<Tenant> getMyTenantData();

  Future<Tenant> createTenant(Map<String, dynamic> data);
}
