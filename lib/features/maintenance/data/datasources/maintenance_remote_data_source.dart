import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/data/models/maintenance_request_dto.dart';

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
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (status != null) 'request_status': status,
      if (priority != null) 'priority': priority,
      if (category != null) 'category': category,
    };

    final response = await _apiClient.get<dynamic>(
      '/pm/maintenance/requests',
      queryParameters: queryParams,
    );

    final data = response.data;
    final rawItems = unwrapList(data);
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(MaintenanceRequestDto.fromJson)
        .toList();

    int? total;
    if (data is Map<String, dynamic>) {
      final totalValue = data['total'] ?? data['count'];
      if (totalValue is int) {
        total = totalValue;
      }
    }
    final hasMore =
        total != null ? offset + items.length < total : items.length >= limit;

    return Page<MaintenanceRequestDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<MaintenanceRequestDto> getRequestById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/maintenance/requests/$id',
    );

    return MaintenanceRequestDto.fromJson(response.data!);
  }

  @override
  Future<MaintenanceRequestDto> createRequest(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/maintenance/requests',
      data: data,
    );

    return MaintenanceRequestDto.fromJson(response.data!);
  }

  @override
  Future<MaintenanceRequestDto> updateRequest(
      int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/maintenance/requests/$id',
      data: updates,
    );

    return MaintenanceRequestDto.fromJson(response.data!);
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await _apiClient.patch<void>(
      '/pm/maintenance/requests/$id',
      data: {'request_status': status},
    );
  }
}
