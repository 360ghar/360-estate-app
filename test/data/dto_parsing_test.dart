import 'package:estate_app/features/home/data/models/activity_item_dto.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';
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

  group('Tenant.fromJson (canonical more/tenants, missing legacy keys)', () {
    test('tolerates payload missing all 8 unported keys', () {
      const payload = {'id': 1, 'name': 'Asha', 'phone': '9999999999'};
      expect(() => Tenant.fromJson(payload), returnsNormally);
      final tenant = Tenant.fromJson(payload);
      expect(tenant.id, 1);
      expect(tenant.displayName, 'Asha');
      expect(tenant.phone, '9999999999');
    });
  });
}
