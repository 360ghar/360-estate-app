import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/data/datasources/tenants_remote_data_source.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';

final class TenantsRepositoryImpl implements TenantsRepository {
  TenantsRepositoryImpl({
    required TenantsRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final TenantsRemoteDataSource _dataSource;

  @override
  Future<Page<Tenant>> getTenants({
    required int page,
    required int limit,
    required String query,
  }) async {
    final dtoPage = await _dataSource.getTenants(
      page: page,
      limit: limit,
      query: query,
    );

    return Page<Tenant>(
      items: dtoPage.items.map((d) => d.toEntity()).toList(growable: false),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<Tenant> getTenantById(String id) async {
    final dto = await _dataSource.getTenantById(id);
    return dto.toEntity();
  }

  @override
  Future<Tenant> getMyTenantData() async {
    final dto = await _dataSource.getMyTenantData();
    return dto.toEntity();
  }

  @override
  Future<Tenant> createTenant(Map<String, dynamic> data) async {
    final dto = await _dataSource.createTenant(data);
    return dto.toEntity();
  }
}
