import 'dart:convert';
import 'dart:io';

import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/api/wire_log.dart';
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:flutter_test/flutter_test.dart';

/// `contract-audit/enums.json` sits beside the app repo. The test skips the
/// source check when it is not there (a checkout of the app alone).
const _enumsPath = '../../360ghar/contract-audit/enums.json';

void main() {
  group('wire enums', () {
    test('unknown wire value reads as null and is logged', () {
      final logged = <String>[];
      final previous = wireLogSink;
      wireLogSink = logged.add;
      addTearDown(() => wireLogSink = previous);

      expect(LeaseStatus.fromJson('bogus'), isNull);
      expect(PaymentMethod.fromJson('card'), isNull);
      expect(RentChargeStatus.fromJson(null), isNull);
      expect(logged, [
        'Unknown LeaseStatus wire value: bogus',
        'Unknown PaymentMethod wire value: card',
      ]);
    });

    test('every member round-trips through its wire value', () {
      expect(LeaseStatus.fromJson('expiring_soon'), LeaseStatus.expiringSoon);
      expect(LeaseStatus.expiringSoon.toJson(), 'expiring_soon');
      expect(PaymentMethod.bankTransfer.wire, 'bank_transfer');
      expect(ManagedPropertyStatus.values.map((e) => e.wire), [
        'draft',
        'active',
        'archived',
      ]);
      expect(ManagedPropertyStatus.toJsonValue(null), isNull);
    });

    test('the removed estate statuses are not enum members', () {
      // sold and inactive are not backend values: they map to archived.
      expect(ManagedPropertyStatus.fromJson('sold'), isNull);
      expect(ManagedPropertyStatus.fromJson('inactive'), isNull);
      expect(PropertyType.fromJson('commercial'), isNull);
      expect(PropertyType.fromJson('land'), isNull);
    });

    test('values match contract-audit/enums.json', () {
      final file = File(_enumsPath);
      if (!file.existsSync()) {
        markTestSkipped('contract-audit/enums.json not found');
        return;
      }
      final source =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final cases = <String, List<String>>{
        'LeaseStatus': LeaseStatus.values.map((e) => e.wire).toList(),
        'PaymentMethod': PaymentMethod.values.map((e) => e.wire).toList(),
        'RentChargeStatus': RentChargeStatus.values.map((e) => e.wire).toList(),
        'RentPaymentStatus': RentPaymentStatus.values
            .map((e) => e.wire)
            .toList(),
        'ManagedPropertyStatus': ManagedPropertyStatus.values
            .map((e) => e.wire)
            .toList(),
        'PropertyType': PropertyType.values.map((e) => e.wire).toList(),
        'ExpenseCategory': ExpenseCategory.values.map((e) => e.wire).toList(),
        'DocumentType': DocumentType.values.map((e) => e.wire).toList(),
        'InspectionType': InspectionType.values.map((e) => e.wire).toList(),
        'MaintenanceUrgency': MaintenanceUrgency.values
            .map((e) => e.wire)
            .toList(),
        'MaintenanceCategory': MaintenanceCategory.values
            .map((e) => e.wire)
            .toList(),
        'MaintenanceRequestStatus': MaintenanceRequestStatus.values
            .map((e) => e.wire)
            .toList(),
        'RentalApplicationStatus': RentalApplicationStatus.values
            .map((e) => e.wire)
            .toList(),
        'ApplicationFieldType': ApplicationFieldType.values
            .map((e) => e.wire)
            .toList(),
        'TenantStatus': TenantStatus.values.map((e) => e.wire).toList(),
        'DevicePlatform': DevicePlatform.values.map((e) => e.wire).toList(),
        'AppKey': AppKey.values.map((e) => e.wire).toList(),
        'FurnishingLevel': FurnishingLevel.values.map((e) => e.wire).toList(),
        'TourVisibility': TourVisibility.values.map((e) => e.wire).toList(),
        // Hand-written enum of the auth feature: the guard keeps it in step.
        'AuthMethod': AuthMethod.values.map((e) => e.wireName).toList(),
      };
      cases.forEach((name, wires) {
        expect(
          wires,
          (source[name] as List<dynamic>).cast<String>(),
          reason: name,
        );
      });
    });
  });
}
