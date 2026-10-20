import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  group('Tenant (GET /pm/tenants)', () {
    test('user_id is the key, not id', () {
      final page = unwrapPage(loadPage('tenants', 'list_page'));
      final tenants = page.items
          .cast<Map<String, dynamic>>()
          .map(Tenant.fromJson)
          .toList();
      expect(tenants.first.userId, 52);
      expect(tenants.first.displayName, 'Meera Nair');
      expect(tenants.first.status, TenantStatus.active);
      expect(tenants.first.statusLabel, 'Active');
      expect(tenants.first.propertyName, '2 BHK Sector 51');
      expect(tenants.first.activeLeasesCount, 1);
      expect(tenants[1].status, TenantStatus.vacated);
      expect(tenants[1].fullName, isNull);
      expect(tenants[1].displayName, 'Tenant');
      expect(loadPage('tenants', 'list_page')['limit'], 100);
    });

    test('detail reads the leases of the tenant', () {
      final tenant = Tenant.fromJson(
        loadFixture('tenants')['detail'] as Map<String, dynamic>,
      );
      expect(tenant.userId, 52);
      expect(tenant.leases, hasLength(2));
      expect(tenant.leases!.first.id, 31);
    });
  });

  group('Document (GET /pm/documents)', () {
    final page = unwrapPage(loadPage('documents', 'list_page'));
    final documents = page.items
        .cast<Map<String, dynamic>>()
        .map(DocumentItem.fromJson)
        .toList();

    test('reads document_type, created_at and file_url', () {
      final first = documents.first;
      expect(first.id, 91);
      expect(first.documentType, DocumentType.leaseAgreement);
      expect(first.title, 'Lease 2026');
      expect(first.fileUrl, startsWith('https://res.example.com/signed/'));
      expect(first.mimeType, 'application/pdf');
      expect(first.createdAt, DateTime.utc(2026, 10, 1, 10, 15, 2));
      expect(first.sharedWithTenant, isTrue);
    });

    test('a null file_url means the viewer may not open the file', () {
      expect(documents[1].fileUrl, isNull);
      expect(documents[1].documentType, DocumentType.receipt);
    });

    test('the list follows next_cursor', () {
      expect(page.nextCursor, isNotNull);
    });

    test('download route returns a url', () {
      final download =
          loadFixture('documents')['download'] as Map<String, dynamic>;
      expect(download['url'], contains('lease-2026.pdf'));
    });
  });
}
