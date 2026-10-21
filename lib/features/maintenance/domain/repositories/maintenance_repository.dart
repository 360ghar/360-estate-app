import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';

abstract interface class MaintenanceRepository {
  /// One page of requests. `status` is the wire `request_status`. There is no
  /// by-id route, so a single request is found in a list.
  Future<Page<MaintenanceRequest>> getRequests({
    required String? cursor,
    required int limit,
    int? propertyId,
    MaintenanceRequestStatus? status,
  });

  /// Every request (follows `next_cursor`), optionally for one property.
  Future<List<MaintenanceRequest>> getAllRequests({int? propertyId});

  Future<MaintenanceRequest> createRequest({
    required int propertyId,
    required MaintenanceCategory category,
    required MaintenanceUrgency urgency,
    required String title,
    String? description,
    int? leaseId,
    double? estimatedCost,
    DateTime? scheduledFor,
    int? assignedAgentId,
    String? availabilityNotes,
  });

  Future<MaintenanceRequest> updateRequest(int id, MaintenanceUpdate update);
}
