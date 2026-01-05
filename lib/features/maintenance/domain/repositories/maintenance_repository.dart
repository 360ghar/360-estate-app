import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';

abstract interface class MaintenanceRepository {
  Future<Page<MaintenanceRequest>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  });

  Future<MaintenanceRequest> getRequestById(int id);

  Future<MaintenanceRequest> createRequest({
    required int propertyId,
    int? leaseId,
    required String category,
    required String priority,
    required String title,
    required String description,
    String? assignedTo,
    double? estimatedCost,
    DateTime? scheduledDate,
    String? notes,
  });

  Future<MaintenanceRequest> updateRequest(
      int id, Map<String, dynamic> updates);

  Future<void> updateStatus(int id, String status);
}
