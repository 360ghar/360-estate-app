import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';

final class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl(this._remoteDataSource);

  final MaintenanceRemoteDataSource _remoteDataSource;

  @override
  Future<Page<MaintenanceRequest>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  }) async {
    final dtoPage = await _remoteDataSource.getRequests(
      page: page,
      limit: limit,
      propertyId: propertyId,
      status: status,
      priority: priority,
      category: category,
    );

    return Page<MaintenanceRequest>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<MaintenanceRequest> getRequestById(int id) async {
    final dto = await _remoteDataSource.getRequestById(id);
    return dto.toEntity();
  }

  @override
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
  }) async {
    final data = <String, dynamic>{
      'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      'category': category,
      'priority': priority,
      'title': title,
      'description': description,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (scheduledDate != null)
        'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      if (notes != null) 'notes': notes,
    };

    final dto = await _remoteDataSource.createRequest(data);
    return dto.toEntity();
  }

  @override
  Future<MaintenanceRequest> updateRequest(
      int id, Map<String, dynamic> updates) async {
    final dto = await _remoteDataSource.updateRequest(id, updates);
    return dto.toEntity();
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await _remoteDataSource.updateStatus(id, status);
  }
}
