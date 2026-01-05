import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/data/models/maintenance_request_dto.dart';

/// Remote data source for maintenance requests.
/// NOTE: The PM maintenance endpoints (/pm/maintenance/*) do not yet exist in the backend.
abstract interface class MaintenanceRemoteDataSource {
  Future<Page<MaintenanceRequestDto>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  });

  Future<MaintenanceRequestDto> getRequestById(int id);

  Future<MaintenanceRequestDto> createRequest(Map<String, dynamic> data);

  Future<MaintenanceRequestDto> updateRequest(
      int id, Map<String, dynamic> updates);

  Future<void> updateStatus(int id, String status);
}

/// Stub implementation that returns empty data since PM maintenance endpoints
/// are not available in the current backend.
final class ApiMaintenanceRemoteDataSource
    implements MaintenanceRemoteDataSource {
  ApiMaintenanceRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<MaintenanceRequestDto>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  }) async {
    AppLogger.w(' PM maintenance endpoint not available');
    return Page<MaintenanceRequestDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<MaintenanceRequestDto> getRequestById(int id) async {
    AppLogger.w(' PM maintenance endpoint not available');
    throw UnsupportedError(
      'Maintenance requests are not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<MaintenanceRequestDto> createRequest(Map<String, dynamic> data) async {
    AppLogger.w(' PM maintenance endpoint not available');
    throw UnsupportedError(
      'Maintenance request creation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<MaintenanceRequestDto> updateRequest(
      int id, Map<String, dynamic> updates) async {
    AppLogger.w(' PM maintenance endpoint not available');
    throw UnsupportedError(
      'Maintenance request update is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    AppLogger.w(' PM maintenance endpoint not available');
    throw UnsupportedError(
      'Maintenance status update is not yet available. PM module pending backend implementation.',
    );
  }
}
