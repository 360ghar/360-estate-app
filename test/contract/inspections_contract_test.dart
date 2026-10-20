import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  group('Inspection (GET /pm/inspections)', () {
    test('reads inspection_type, conducted_at and the checklist lines', () {
      final page = unwrapPage(loadPage('inspections', 'list_page'));
      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(Inspection.fromJson)
          .toList();
      final first = items.first;
      expect(first.id, 61);
      expect(first.leaseId, 31);
      expect(first.inspectionType, InspectionType.moveIn);
      expect(first.typeLabel, 'Move-in');
      expect(first.conductedAt, DateTime.utc(2026, 10, 1, 10, 15, 2));
      expect(first.overallNotes, 'All good');
      expect(first.items, hasLength(1));
      expect(first.items.first.title, 'Front door lock');
      expect(first.items.first.status, 'pass');
    });

    test('state comes from the two signature times', () {
      final page = unwrapPage(loadPage('inspections', 'list_page'));
      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(Inspection.fromJson)
          .toList();
      expect(items[0].signState, InspectionSignState.signedByTenant);
      expect(items[1].signState, InspectionSignState.open);
      expect(items[1].items, isEmpty);

      final detail = Inspection.fromJson(
        loadFixture('inspections')['detail'] as Map<String, dynamic>,
      );
      expect(detail.signState, InspectionSignState.signed);
      expect(detail.inspectionType, InspectionType.moveOut);
    });
  });

  group('inspection request bodies', () {
    test('create sends lease_id, inspection_type and rooms_data', () {
      final body = InspectionCreateRequest(
        leaseId: 31,
        inspectionType: InspectionType.moveOut,
        conductedAt: DateTime.utc(2026, 10, 3, 5),
        overallNotes: ' Walls scuffed ',
        items: const ['Walls', 'Floor'],
      ).toJson();
      expectValidBody('InspectionChecklistCreate', body);
      expect(body['lease_id'], 31);
      expect(body['inspection_type'], 'move_out');
      expect(body['overall_notes'], 'Walls scuffed');
      expect(body['rooms_data'], {
        'items': [
          {'title': 'Walls'},
          {'title': 'Floor'},
        ],
      });
      expect(body.containsKey('title'), isFalse);
      expect(body.containsKey('tenant_id'), isFalse);
    });

    test('sign takes an object body', () {
      expectValidBody('InspectionSign', <String, dynamic>{});
    });
  });
}
