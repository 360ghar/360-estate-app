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
          id: 1,
          title: 'Property 1',
          city: 'Mumbai',
          addressLine: 'Address',
          monthlyRentInr: 25000,
          propertyType: PropertyType.apartment,
          propertyCategory: PropertyCategory.residential,
          managementStatus: ManagementStatus.active,
        ),
      ],
      page: 1,
      limit: 20,
      hasMore: false,
    );
  }

  @override
  Future<Property> getPropertyById(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<Property> createProperty({
    required String title,
    String? nickname,
    required String addressLine,
    required String city,
    String? state,
    String? pincode,
    String country = 'India',
    required String propertyType,
    required String propertyCategory,
    int? bedroomCount,
    int? bathroomCount,
    int? balconyCount,
    double? floorAreaSqft,
    int monthlyRentInr = 0,
    double? securityDeposit,
    double? maintenanceCharges,
    String managementStatus = 'active',
    int paymentDueDay = 1,
    String? notes,
    List<String> images = const [],
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Property> updateProperty(int id, Map<String, dynamic> updates) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProperty(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPropertyImage(String filePath) async {
    return 'https://example.com/image.jpg';
  }
}
