import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/inspections/data/models/inspection_dto.dart';

abstract interface class InspectionsRemoteDataSource {
  Future<List<InspectionDto>> getInspections({
    required int limit,
    required int offset,
    int? propertyId,
    String? inspectionType,
    String? status,
  });

  Future<InspectionDto> getInspectionById(int id);

  Future<InspectionDto> createInspection(Map<String, dynamic> data);

  Future<InspectionDto> updateInspection(int id, Map<String, dynamic> data);

  Future<InspectionDto> startInspection(int id);

  Future<InspectionDto> completeInspection(int id, {String? notes});

  Future<InspectionDto> signInspection(int id, Map<String, dynamic> data);

  Future<void> cancelInspection(int id, {String? reason});

  Future<InspectionDto> addInspectionItem(int inspectionId, Map<String, dynamic> data);

  Future<InspectionDto> updateInspectionItem(
    int inspectionId,
    int itemId,
    Map<String, dynamic> data,
  );
}

final class ApiInspectionsRemoteDataSource implements InspectionsRemoteDataSource {
  ApiInspectionsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<InspectionDto>> getInspections({
    required int limit,
    required int offset,
    int? propertyId,
    String? inspectionType,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (inspectionType != null) 'inspection_type': inspectionType,
      if (status != null) 'status': status,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/inspections',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [];

    return items
        .map((e) => InspectionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<InspectionDto> getInspectionById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/inspections/$id',
    );

    final data = response.data!;
    final inspection = data['data'] as Map<String, dynamic>? ?? data;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> createInspection(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections',
      data: data,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> updateInspection(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/inspections/$id',
      data: data,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> startInspection(int id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections/$id/start',
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> completeInspection(int id, {String? notes}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections/$id/complete',
      data: notes != null ? {'notes': notes} : null,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> signInspection(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections/$id/sign',
      data: data,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<void> cancelInspection(int id, {String? reason}) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections/$id/cancel',
      data: reason != null ? {'reason': reason} : null,
    );
  }

  @override
  Future<InspectionDto> addInspectionItem(
    int inspectionId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/inspections/$inspectionId/items',
      data: data,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }

  @override
  Future<InspectionDto> updateInspectionItem(
    int inspectionId,
    int itemId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/inspections/$inspectionId/items/$itemId',
      data: data,
    );

    final responseData = response.data!;
    final inspection = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return InspectionDto.fromJson(inspection);
  }
}
