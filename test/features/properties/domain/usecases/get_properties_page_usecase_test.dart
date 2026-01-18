import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/domain/usecases/get_properties_page_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPropertiesRepository extends Mock implements PropertiesRepository {}

void main() {
  late PropertiesRepository repository;
  late GetPropertiesPageUseCase useCase;

  setUp(() {
    repository = _MockPropertiesRepository();
    useCase = GetPropertiesPageUseCase(repository);
  });

  test('delegates to repository', () async {
    final expected = Page<Property>(
      items: const [
        Property(
          id: 1,
          name: 'Property 1',
          city: 'Mumbai',
          address: 'Address',
          type: 'apartment',
          managementStatus: 'active',
          monthlyRentInr: 25000,
        ),
      ],
      page: 1,
      limit: 20,
      hasMore: false,
    );

    when(
      () => repository.listPage(page: 1, limit: 20),
    ).thenAnswer((_) async => expected);

    final result = await useCase(page: 1, limit: 20);

    expect(result, same(expected));
    verify(
      () => repository.listPage(page: 1, limit: 20),
    ).called(1);
  });
}
