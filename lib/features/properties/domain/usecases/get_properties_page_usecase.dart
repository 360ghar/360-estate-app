import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';

final class GetPropertiesPageUseCase {
  const GetPropertiesPageUseCase(this._repository);

  final PropertiesRepository _repository;

  Future<Page<Property>> call({
    required int page,
    required int limit,
  }) => _repository.listPage(page: page, limit: limit);
}
