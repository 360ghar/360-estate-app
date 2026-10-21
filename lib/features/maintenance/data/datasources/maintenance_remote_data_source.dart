import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';

abstract interface class MaintenanceRemoteDataSource {
  Future<Page<MaintenanceRequest>> getRequests({
    required String? cursor,
    required int limit,
    int? propertyId,
    MaintenanceRequestStatus? status,
  });

  Future<MaintenanceRequest> createRequest(Map<String, dynamic> data);

  Future<MaintenanceRequest> updateRequest(
    int id,
    Map<String, dynamic> updates,
  );
}

final class ApiMaintenanceRemoteDataSource
    implements MaintenanceRemoteDataSource {
  ApiMaintenanceRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<MaintenanceRequest>> getRequests({
    required String? cursor,
    required int limit,
    int? propertyId,
    MaintenanceRequestStatus? status,
  }) async {
    final response = await _apiClient.get<dynamic>(
      ApiPaths.maintenanceRequests,
      ownerScoped: true,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
        if (propertyId != null) 'property_id': propertyId,
        if (status != null) 'request_status': status.wire,
      },
    );

    final page = unwrapPage(response.data);
    return Page<MaintenanceRequest>(
      items: page.items
          .whereType<Map<String, dynamic>>()
          .map(MaintenanceRequest.fromJson)
          .toList(),
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  @override
  Future<MaintenanceRequest> createRequest(Map<String, dynamic> data) async {
    final response = await _apiClient.post<dynamic>(
      ApiPaths.maintenanceRequests,
      data: data,
    );
    return MaintenanceRequest.fromJson(unwrapMap(response.data));
  }

  @override
  Future<MaintenanceRequest> updateRequest(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiClient.patch<dynamic>(
      ApiPaths.maintenanceRequest(id),
      data: updates,
    );
    return MaintenanceRequest.fromJson(unwrapMap(response.data));
  }
}
