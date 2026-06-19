import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';

abstract interface class TenantsRepository {
  Future<Page<Tenant>> getTenants({
    required String? cursor,
    required int limit,
    required String query,
  });

  Future<Tenant> getTenantByUserId(String tenantUserId);
}
