import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

class _CapturingSource implements MaintenanceRemoteDataSource {
  Map<String, dynamic>? created;

  @override
  Future<MaintenanceRequest> createRequest(Map<String, dynamic> data) async {
    created = data;
    return MaintenanceRequest.fromJson({'id': 1, ...data});
  }

  @override
  Future<Page<MaintenanceRequest>> getRequests({
    required String? cursor,
    required int limit,
    int? propertyId,
    MaintenanceRequestStatus? status,
  }) => throw UnimplementedError();

  @override
  Future<MaintenanceRequest> updateRequest(
    int id,
    Map<String, dynamic> updates,
  ) => throw UnimplementedError();
}

void main() {
  group('MaintenanceRequest (GET /pm/maintenance/requests)', () {
    final page = unwrapPage(loadPage('maintenance', 'list_page'));
    final requests = page.items
        .cast<Map<String, dynamic>>()
        .map(MaintenanceRequest.fromJson)
        .toList();

    test('reads the joined property title and tenant name', () {
      final first = requests.first;
      expect(first.id, 71);
      expect(first.propertyTitle, '2 BHK Sector 51');
      expect(first.propertyLabel, '2 BHK Sector 51');
      expect(first.tenantName, 'Meera Nair');
      expect(first.leaseId, 31);
      expect(first.estimatedCost, 1800);
      expect(first.scheduledFor, DateTime.utc(2026, 10, 2, 8));
      expect(first.assignedAgentId, 12);
      expect(first.category, MaintenanceCategory.plumbing);
      expect(first.urgency, MaintenanceUrgency.emergency);
      expect(first.status, MaintenanceRequestStatus.workOrderCreated);
      expect(first.workOrderStatus, WorkOrderStatus.assigned);
    });

    test('a request without a joined title falls back to the property id', () {
      expect(requests[1].propertyLabel, 'Property #2');
      expect(requests[1].status, MaintenanceRequestStatus.inReview);
    });

    test('the page limit is the backend maximum', () {
      expect(page.nextCursor, isNotNull);
      expect(loadPage('maintenance', 'list_page')['limit'], 100);
    });
  });

  test('the assigned agent reads id and name', () {
    final agent = assignedAgentFromJson(
      loadFixture('agents')['assigned'] as Map<String, dynamic>,
    );
    expect(agent, (id: 12, name: 'Ravi Kumar'));
    expect(assignedAgentFromJson(const {'name': 'x'}), isNull);
  });

  group('maintenance request bodies', () {
    test('create sends lease, cost, schedule, agent and urgency', () async {
      final source = _CapturingSource();
      await MaintenanceRepositoryImpl(source).createRequest(
        propertyId: 1,
        category: MaintenanceCategory.electrical,
        urgency: MaintenanceUrgency.high,
        title: ' Fuse blown ',
        description: 'Kitchen',
        leaseId: 31,
        estimatedCost: 800,
        scheduledFor: DateTime.utc(2026, 10, 20, 6),
        assignedAgentId: 12,
      );
      final body = source.created!;
      expectValidBody('MaintenanceRequestCreate', body);
      expect(body['urgency'], 'high');
      expect(body['category'], 'electrical');
      expect(body['title'], 'Fuse blown');
      expect(body['lease_id'], 31);
      expect(body['estimated_cost'], 800);
      expect(body['scheduled_for'], '2026-10-20T06:00:00.000Z');
      expect(body['assigned_agent_id'], 12);
      expect(body.containsKey('priority'), isFalse);
    });

    test('update sends urgency and request_status, never priority', () {
      final body = const MaintenanceUpdate(
        status: MaintenanceRequestStatus.resolved,
        urgency: MaintenanceUrgency.low,
        completionNotes: ' Done ',
      ).toJson();
      expectValidBody('MaintenanceRequestUpdate', body);
      expect(body, {
        'request_status': 'resolved',
        'urgency': 'low',
        'completion_notes': 'Done',
      });
    });
  });
}
