import 'package:estate_app/core/pagination/page.dart' as paging;
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/domain/usecases/get_properties_page_usecase.dart';
import 'package:estate_app/features/properties/presentation/controllers/properties_controller.dart';
import 'package:estate_app/features/properties/presentation/pages/properties_page.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('PropertiesPage shows loaded items', (WidgetTester tester) async {
    Get.testMode = true;
    Get.reset();

    final repository = _FakePropertiesRepository();
    final useCase = GetPropertiesPageUseCase(repository);

    Get.put<PropertiesController>(
      PropertiesController(getPropertiesPage: useCase),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PropertiesPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Property 1'), findsOneWidget);
  });
}

final class _FakePropertiesRepository implements PropertiesRepository {
  @override
  Future<paging.Page<Property>> getProperties({
    required int page,
    required int limit,
    required String query,
  }) async {
    return const paging.Page<Property>(
      items: [
        Property(
          id: 'prop_1',
          title: 'Property 1',
          city: 'Mumbai',
          addressLine: 'Address',
          monthlyRentInr: 25000,
        ),
      ],
      page: 1,
      limit: 20,
      hasMore: false,
    );
  }
}
