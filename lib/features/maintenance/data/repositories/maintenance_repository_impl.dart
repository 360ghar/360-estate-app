import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';

final class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl(this._remoteDataSource);

  final MaintenanceRemoteDataSource _remoteDataSource;

  @override
  Future<Page<MaintenanceRequest>> getRequests({
    required String? cursor,
    required int limit,
    int? propertyId,
    MaintenanceRequestStatus? status,
  }) {
    return _remoteDataSource.getRequests(
      cursor: cursor,
      limit: limit,
      propertyId: propertyId,
      status: status,
    );
  }

  @override
  Future<List<MaintenanceRequest>> getAllRequests({int? propertyId}) {
    return fetchAllPages<MaintenanceRequest>(
      ({required cursor, required limit}) =>
          getRequests(cursor: cursor, limit: limit, propertyId: propertyId),
    );
  }

  @override
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
  }) {
    final text = description?.trim();
    final notes = availabilityNotes?.trim();
    return _remoteDataSource.createRequest({
      'property_id': propertyId,
      'category': category.wire,
      'urgency': urgency.wire,
      'title': title.trim(),
      if (text != null && text.isNotEmpty) 'description': text,
      if (leaseId != null) 'lease_id': leaseId,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (scheduledFor != null) 'scheduled_for': toApiUtcInstant(scheduledFor),
      if (assignedAgentId != null) 'assigned_agent_id': assignedAgentId,
      if (notes != null && notes.isNotEmpty) 'availability_notes': notes,
    });
  }

  @override
  Future<MaintenanceRequest> updateRequest(int id, MaintenanceUpdate update) {
    return _remoteDataSource.updateRequest(id, update.toJson());
  }
}
