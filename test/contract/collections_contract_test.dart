import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/models/rent_payment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  final fixtures = loadFixture('rent');

  group('rent charges (GET /pm/rent/charges)', () {
    test('unwraps the charge and reads the totals', () {
      final page = unwrapPage(loadPage('rent', 'charges_page'));
      expect(page.nextCursor, isNotNull);
      expect(page.hasMore, isTrue);
      final rows = page.items
          .cast<Map<String, dynamic>>()
          .map(RentChargeWithTotals.fromJson)
          .toList();
      expect(rows, hasLength(3));

      final row = rows.first;
      expect(row.id, 101);
      expect(row.charge.leaseId, 31);
      expect(row.charge.amountDue, 32000);
      expect(row.charge.dueDate, DateTime.utc(2026, 10, 5));
      expect(row.status, RentChargeStatus.pending);
      expect(row.paid, 12000.5);
      expect(row.totalDue, 32000);
      expect(row.balance, 19999.5);
    });

    test('partial, overdue, paid and waived all parse', () {
      final first = unwrapPage(loadPage('rent', 'charges_page')).items;
      final last = unwrapPage(loadPage('rent', 'charges_last_page')).items;
      final statuses = [...first, ...last]
          .cast<Map<String, dynamic>>()
          .map((json) => RentChargeWithTotals.fromJson(json).status)
          .toList();
      expect(statuses, [
        RentChargeStatus.pending,
        RentChargeStatus.partial,
        RentChargeStatus.overdue,
        RentChargeStatus.paid,
        RentChargeStatus.waived,
      ]);
    });

    test('the page limit is the backend maximum', () {
      expect(loadPage('rent', 'charges_page')['limit'], 100);
    });
  });

  group('rent payments', () {
    test('RentPayment reads amount_paid and payment_method', () {
      final payment = RentPayment.fromJson(
        fixtures['payment'] as Map<String, dynamic>,
      );
      expect(payment.id, 201);
      expect(payment.chargeId, 101);
      expect(payment.amountPaid, 12000.5);
      expect(payment.paymentMethod, PaymentMethod.upi);
      expect(payment.status, RentPaymentStatus.settled);
      expect(payment.paidAt, DateTime.utc(2026, 10, 1, 10, 15, 2));
    });

    test('generate result reads created and skipped', () {
      final result = RentChargeGenerateResult.fromJson(
        fixtures['generate_result'] as Map<String, dynamic>,
      );
      expect(result.created, 3);
      expect(result.skipped, 1);
    });

    test('record payment sends charge_id, amount_paid and an enum method', () {
      final body = RentPaymentRequest(
        chargeId: 101,
        amountPaid: 500.5,
        paidAt: DateTime.utc(2026, 10, 2, 9),
        paymentMethod: PaymentMethod.bankTransfer,
        notes: 'Part payment',
      ).toJson();
      expectValidBody('RentPaymentCreate', body);
      expect(body['charge_id'], 101);
      expect(body['amount_paid'], 500.5);
      expect(body['payment_method'], 'bank_transfer');
      expect(body['paid_at'], '2026-10-02T09:00:00.000Z');
      expect(body.containsKey('tenant_id'), isFalse);
      expect(body.containsKey('method'), isFalse);
    });

    test('generate charges takes an empty object', () {
      expectValidBody('RentChargeGenerateRequest', <String, dynamic>{});
    });
  });
}
