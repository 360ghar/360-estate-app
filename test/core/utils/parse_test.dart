import 'package:estate_app/core/utils/parse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parse helpers', () {
    test('treats naive timestamps as UTC', () {
      final parsed = parseDateTime('2026-03-12T10:15:30');

      expect(parsed, isNotNull);
      expect(parsed!.isUtc, isTrue);
      expect(parsed.toIso8601String(), '2026-03-12T10:15:30.000Z');
    });

    test('parses epoch seconds as UTC', () {
      final parsed = parseDateTime(1710238530);

      expect(parsed, isNotNull);
      expect(parsed!.isUtc, isTrue);
    });

    test('serializes UTC instants and date-only values explicitly', () {
      final local = DateTime.parse('2026-03-12T10:15:30+05:30');

      expect(toApiUtcInstant(local), '2026-03-12T04:45:30.000Z');
      expect(toApiDateOnly(DateTime(2026, 3, 12, 23, 59)), '2026-03-12');
    });
  });
}
