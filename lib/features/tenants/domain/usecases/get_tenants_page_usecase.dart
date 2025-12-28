import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';

final class GetTenantsPageUseCase {
  GetTenantsPageUseCase(this._repository);

  final TenantsRepository _repository;

  Future<Page<Tenant>> call({
    required int page,
    required int limit,
    required String query,
  }) {
    return _repository.getTenants(
      page: page,
      limit: limit,
      query: query,
    );
  }
}
