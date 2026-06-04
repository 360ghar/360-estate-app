import 'package:estate_app/features/applications/data/models/application_dto.dart';
import 'package:estate_app/features/home/data/models/activity_item_dto.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';
import 'package:estate_app/features/reports/data/models/report_dto.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression tests for the post-refactor JSON parse-hardening pass.
///
/// Before the fix these `fromJson` factories used raw casts
/// (`json['id'] as int`, `(json['x'] as num).toDouble()`,
/// `DateTime.parse(json['x'] as String)`, `json['items'] as List`) which threw
/// at runtime whenever the backend returned null, omitted a key, or sent a
/// date-only string — surfacing as crashing / broken screens.
void main() {
  group('ActivityItemDto.fromJson (home activity feed)', () {
    test('does not throw when id is missing', () {
      expect(() => ActivityItemDto.fromJson(const {}), returnsNormally);
    });

    test('defaults id to 0 and timestamp to now when absent', () {
      final dto = ActivityItemDto.fromJson(const {'type': 'payment'});
      expect(dto.id, 0);
      expect(dto.type, 'payment');
      expect(dto.timestamp, isNotNull);
    });

    test('accepts a date-only "at" string', () {
      final dto = ActivityItemDto.fromJson(const {'id': 5, 'at': '2026-01-02'});
      expect(dto.id, 5);
      expect(dto.timestamp.year, 2026);
    });
  });

  group('ApplicationDto / ApplicationFormDto.fromJson', () {
    test('ApplicationDto does not throw when form_id keys are missing', () {
      expect(() => ApplicationDto.fromJson(const {'id': 1}), returnsNormally);
      final dto = ApplicationDto.fromJson(const {'id': 1});
      expect(dto.formId, 0);
    });

    test('ApplicationDto falls back to application_form_id', () {
      final dto = ApplicationDto.fromJson(const {
        'id': 1,
        'application_form_id': 42,
      });
      expect(dto.formId, 42);
    });

    test('ApplicationFormDto does not throw when id/property_id missing', () {
      expect(() => ApplicationFormDto.fromJson(const {}), returnsNormally);
    });
  });

  group('PropertyDto.fromJson (properties list / detail)', () {
    test('parses an active_lease missing its dates without throwing', () {
      final dto = PropertyDto.fromJson(const {
        'id': 7,
        'title': 'Unit A',
        'active_lease': {'id': 3, 'tenant_name': 'Asha'},
      });
      expect(dto.activeLease, isNotNull);
      // Missing lease dates are null (not fabricated to now/now+365).
      expect(dto.activeLease!.startDate, isNull);
      expect(dto.activeLease!.endDate, isNull);
    });

    test('does not throw on an essentially empty payload', () {
      expect(() => PropertyDto.fromJson(const {}), returnsNormally);
    });
  });

  group('report_dto.fromJson (reports module)', () {
    test('RentRollReportDto tolerates null totals and missing items', () {
      expect(() => RentRollReportDto.fromJson(const {}), returnsNormally);
      final dto = RentRollReportDto.fromJson(const {});
      expect(dto.items, isEmpty);
      expect(dto.totalCollected, 0);
      expect(dto.generatedAt, isNull);
    });

    test('RentRollItemDto tolerates null numeric fields', () {
      final item = RentRollItemDto.fromJson(const {'property_id': 1});
      expect(item.monthlyRent, 0);
      expect(item.amountDue, 0);
    });

    test('MaintenanceReportDto accepts a date-only generated_at', () {
      final dto = MaintenanceReportDto.fromJson(const {
        'generated_at': '2026-02-01',
      });
      expect(dto.generatedAt?.year, 2026);
      expect(dto.items, isEmpty);
    });

    test('report dates are null (not fabricated) when missing', () {
      // Required dates are nullable now and must NOT default to DateTime.now().
      expect(RentRollReportDto.fromJson(const {}).generatedAt, isNull);
      final pnl = ProfitAndLossReportDto.fromJson(const {});
      expect(pnl.startDate, isNull);
      expect(pnl.endDate, isNull);
    });

    test('OccupancyReportDto tolerates a non-list items value', () {
      expect(
        () => OccupancyReportDto.fromJson(const {'items': 'oops'}),
        returnsNormally,
      );
    });
  });
}
