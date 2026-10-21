import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  final fixtures = loadFixture('leases');

  group('Lease (GET /pm/leases)', () {
    test('reads the backend keys', () {
      final lease = Lease.fromJson(fixtures['detail'] as Map<String, dynamic>);
      expect(lease.id, 31);
      expect(lease.propertyId, 1);
      expect(lease.tenantUserId, 52);
      expect(lease.tenantName, 'Meera Nair');
      expect(lease.monthlyRent, 32000);
      expect(lease.securityDeposit, 64000);
      expect(lease.status, LeaseStatus.active);
      expect(lease.startDate, DateTime.utc(2026, 4));
      expect(lease.endDate, DateTime.utc(2027, 3, 31));
      expect(lease.leaseDocumentId, 9);
    });

    test('late fee, grace and due day are read as enforced', () {
      final lease = Lease.fromJson(fixtures['detail'] as Map<String, dynamic>);
      expect(lease.lateFeeAmount, 500);
      expect(lease.gracePeriodDays, 3);
      expect(lease.paymentDueDay, 5);
      expect(lease.lateFeeDescription, '₹500 flat');
      expect(
        lease.enforcementSummary,
        'Rent is due on day 5 of each month. '
        'A late fee of ₹500 flat is charged once after 3 days of grace.',
      );
    });

    test('expiring_soon and expired are statuses of their own', () {
      final page = unwrapPage(loadPage('leases', 'list_page'));
      final leases = page.items
          .cast<Map<String, dynamic>>()
          .map(Lease.fromJson)
          .toList();
      expect(leases[1].status, LeaseStatus.expiringSoon);
      expect(leases[1].isExpiringSoon, isTrue);
      expect(leases[1].isOccupying, isTrue);
      expect(leases[1].daysUntilEnd(DateTime.utc(2026, 10, 10)), 10);
      expect(leases[2].status, LeaseStatus.pendingSignature);
      expect(leases[2].leaseDocumentId, isNull);

      final last = unwrapPage(loadPage('leases', 'list_last_page'));
      final expired = Lease.fromJson(last.items.first as Map<String, dynamic>);
      expect(expired.isExpired, isTrue);
    });

    test('termination_date is a date', () {
      final lease = Lease.fromJson(
        fixtures['terminated'] as Map<String, dynamic>,
      );
      expect(lease.status, LeaseStatus.terminated);
      expect(lease.terminationDate, DateTime.utc(2026, 9, 15));
      expect(lease.terminationReason, 'Moved out');
    });
  });

  group('lease request bodies', () {
    test('create sends monthly_rent, security_deposit, tenant_user_id', () {
      final body = LeaseCreateRequest(
        propertyId: 1,
        startDate: DateTime(2026, 11),
        endDate: DateTime(2027, 10, 31),
        monthlyRent: 30000,
        securityDeposit: 60000,
        tenantUserId: 52,
        tenantName: 'Meera Nair',
        paymentDueDay: 5,
        gracePeriodDays: 3,
        lateFeeAmount: 500,
        status: LeaseStatus.draft,
      ).toJson();
      expectValidBody('LeaseCreate', body);
      expect(body['monthly_rent'], 30000);
      expect(body['security_deposit'], 60000);
      expect(body['tenant_user_id'], 52);
      expect(body['start_date'], '2026-11-01');
      expect(body['status'], 'draft');
      expect(body.containsKey('rent_amount'), isFalse);
      expect(body.containsKey('tenant_id'), isFalse);
    });

    test('renew sends start_date and end_date', () {
      final body = LeaseRenewRequest(
        startDate: DateTime(2027, 4),
        endDate: DateTime(2028, 3, 31),
        monthlyRent: 33000,
      ).toJson();
      expectValidBody('LeaseRenew', body);
      expect(body['monthly_rent'], 33000);
    });

    test('terminate sends termination_date, not terminated_at', () {
      final body = LeaseTerminateRequest(
        reason: 'Moved out',
        terminationDate: DateTime(2026, 9, 15),
      ).toJson();
      expectValidBody('LeaseTerminate', body);
      expect(body['termination_date'], '2026-09-15');
    });

    test('upload-signed body keys are declared', () {
      expectValidBody('LeaseUploadSigned', {
        'lease_document_id': 9,
        'signed_by_owner': true,
        'signed_by_tenant': false,
      });
    });
  });
}
