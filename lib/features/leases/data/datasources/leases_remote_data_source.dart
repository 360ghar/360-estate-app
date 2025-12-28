import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/data/models/lease_dto.dart';

abstract interface class LeasesRemoteDataSource {
  Future<Page<LeaseDto>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  });

  Future<LeaseDto> getLeaseById(int id);

  Future<LeaseDto> createLease(Map<String, dynamic> data);

  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath);

  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> data);

  Future<void> terminateLease(int leaseId, {String? reason});
}

final class ApiLeasesRemoteDataSource implements LeasesRemoteDataSource {
  ApiLeasesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<LeaseDto>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  }) async {
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (status != null) 'status': status,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/leases',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [])
        .map((e) => LeaseDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return Page<LeaseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<LeaseDto> getLeaseById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/leases/$id',
    );

    return LeaseDto.fromJson(response.data!);
  }

  @override
  Future<LeaseDto> createLease(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/leases',
      data: data,
    );

    return LeaseDto.fromJson(response.data!);
  }

  @override
  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _apiClient.upload<Map<String, dynamic>>(
      '/pm/leases/$leaseId/upload-signed',
      data: formData,
    );

    return LeaseDto.fromJson(response.data!);
  }

  @override
  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/leases/$leaseId/renew',
      data: data,
    );

    return LeaseDto.fromJson(response.data!);
  }

  @override
  Future<void> terminateLease(int leaseId, {String? reason}) async {
    await _apiClient.post<void>(
      '/pm/leases/$leaseId/terminate',
      data: {
        if (reason != null) 'reason': reason,
      },
    );
  }
}
