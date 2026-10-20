import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/properties/models/amenity.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  final fixtures = loadFixture('properties');

  group('Property (GET /pm/properties)', () {
    test('parses every item of the cursor page', () {
      final page = unwrapPage(loadPage('properties', 'list_page'));
      expect(page.nextCursor, isNotNull);
      expect(page.hasMore, isTrue);

      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(Property.fromJson)
          .toList();
      final first = items.first;
      expect(first.id, 1);
      expect(first.title, '2 BHK Sector 51');
      expect(first.propertyType, PropertyType.apartment);
      expect(first.purpose, PropertyPurpose.rent);
      expect(first.monthlyRent, 32000);
      expect(first.fullAddress, startsWith('Tower 1'));
      expect(first.areaSqft, 1180.5);
      expect(first.bedrooms, 2);
      expect(first.latitude, closeTo(28.4231, 1e-6));
      expect(first.managementStatus, ManagedPropertyStatus.active);
      expect(first.paymentDueDay, 5);
      expect(first.gracePeriodDays, 3);
      expect(first.lateFeePolicy, {'type': 'fixed', 'amount': 500});
      expect(items[1].managementStatus, ManagedPropertyStatus.archived);
      expect(items[1].statusDisplay, 'Archived');
    });

    test('amenities are objects, not strings', () {
      final property = Property.fromJson(
        (fixtures['created'] as Map<String, dynamic>),
      );
      expect(property.amenities, hasLength(2));
      expect(property.amenities!.first.id, 1);
      expect(property.amenities!.first.title, 'Power Backup');
      expect(property.amenityTitles, ['Power Backup', 'Lift']);
    });

    test('images and floor plans come in their own keys', () {
      final property = Property.fromJson(
        fixtures['created'] as Map<String, dynamic>,
      );
      expect(property.imageUrls, hasLength(2));
      expect(property.floorPlanUrls, ['https://cdn.example.com/p4/plan.jpg']);
    });

    test('detail reads the {property, active_lease} wrapper', () {
      final detail = PropertyDetail.fromJson(
        fixtures['detail'] as Map<String, dynamic>,
      );
      expect(detail.property.id, 1);
      expect(detail.property.title, '2 BHK Sector 51');
      expect(detail.activeLease, isNotNull);
      expect(detail.activeLease!.tenantUserId, 52);
      expect(detail.activeLease!.monthlyRent, 32000);

      final vacant = PropertyDetail.fromJson(
        fixtures['detail_vacant'] as Map<String, dynamic>,
      );
      expect(vacant.property.id, 2);
      expect(vacant.activeLease, isNull);
    });

    test('amenity catalogue page parses with limit 100', () {
      final page = unwrapPage(loadPage('amenities', 'page'));
      final amenities = page.items
          .cast<Map<String, dynamic>>()
          .map(Amenity.fromJson)
          .toList();
      expect(amenities.map((a) => a.id), [1, 2]);
      expect(amenities.first.title, 'Power Backup');
    });
  });

  group('property request bodies', () {
    PropertyWizardData filled() {
      return PropertyWizardData()
        ..name = 'Green Valley'
        ..type = PropertyType.apartment
        ..status = ManagedPropertyStatus.draft
        ..description = 'Two bedrooms'
        ..address = 'Tower 1'
        ..city = 'Gurugram'
        ..state = 'Haryana'
        ..pincode = '122002'
        ..latitude = 28.42
        ..longitude = 77.08
        ..areaSqft = 1100
        ..bedrooms = 2
        ..amenityIds = {2, 1}
        ..monthlyRent = 32000
        ..securityDeposit = 64000
        ..paymentDueDay = 7
        ..gracePeriodDays = 3;
    }

    test(
      'create sends monthly_rent and base_price, body keys, no query keys',
      () {
        final body = filled().toCreateBody();
        expectValidBody('ManagedPropertyCreate', body);
        expect(body['purpose'], 'rent');
        expect(body['monthly_rent'], 32000);
        expect(body['base_price'], 32000);
        expect(body['property_type'], 'apartment');
        expect(body['management_status'], 'draft');
        expect(body['payment_due_day'], 7);
        expect(body['grace_period_days'], 3);
        expect(body['amenity_ids'], [1, 2]);
        expect(body['latitude'], 28.42);
        expect(body['longitude'], 77.08);
        expect(body.containsKey('monthly_rent_inr'), isFalse);
      },
    );

    test('PATCH sends only the keys that changed', () {
      final data = filled()..markSaved();
      data
        ..name = 'Green Valley 2'
        ..gracePeriodDays = 10;
      final body = data.toPatchBody();
      expectValidBody('ManagedPropertyUpdate', body);
      expect(body, {'title': 'Green Valley 2', 'grace_period_days': 10});
    });

    test('PATCH clears a field with an explicit null', () {
      final data = filled()..markSaved();
      data.description = '';
      final body = data.toPatchBody();
      expect(body, {'description': null});
    });

    test('PATCH sends latitude and longitude as a pair', () {
      final data = filled()..markSaved();
      data.latitude = 28.5;
      final body = data.toPatchBody();
      expect(body['latitude'], 28.5);
      expect(body['longitude'], 77.08);
    });

    test('media lists go under images and floor_plans only when changed', () {
      final data = filled()..markSaved(savedImages: ['a'], savedFloorPlans: []);
      final media = data.mediaPatch(photoUrls: ['a', 'b'], floorPlanUrls: []);
      expectValidBody('ManagedPropertyUpdate', media);
      expect(media, {
        'images': ['a', 'b'],
      });
    });

    test('an edit loads the saved values and sends nothing unchanged', () {
      final property = Property.fromJson(
        fixtures['created'] as Map<String, dynamic>,
      );
      final data = PropertyWizardData.fromProperty(property);
      expect(data.toPatchBody(), isEmpty);
      expect(data.amenityIds, {1, 2});
      expect(data.floorPlans, ['https://cdn.example.com/p4/plan.jpg']);
    });
  });
}
