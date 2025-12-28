import 'package:estate_app/core/presentation/controllers/paginated_controller.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/domain/usecases/get_properties_page_usecase.dart';

class PropertiesController extends PaginatedController<Property, int> {
  PropertiesController({required GetPropertiesPageUseCase getPropertiesPage})
    : super(
        fetchPage:
            ({required int page, required int limit, required String query}) =>
                getPropertiesPage(page: page, limit: limit, query: query),
        keyOf: (p) => p.id,
        pageSize: 20,
      );
}
