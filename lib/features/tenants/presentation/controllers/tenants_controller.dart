import 'package:estate_app/core/presentation/controllers/paginated_controller.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/usecases/get_tenants_page_usecase.dart';

class TenantsController extends PaginatedController<Tenant, int> {
  TenantsController({required GetTenantsPageUseCase getTenantsPage})
      : super(
          fetchPage: ({required int page, required int limit, required String query}) =>
              getTenantsPage(page: page, limit: limit, query: query),
          keyOf: (t) => t.id,
          pageSize: 20,
        );
}
