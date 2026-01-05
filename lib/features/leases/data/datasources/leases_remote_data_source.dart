import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/data/models/lease_dto.dart';

/// Remote data source for lease management.
/// Uses /pm/leases/ endpoints as per backend specs.
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

  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> renewalData);

  Future<void> terminateLease(int leaseId, {String? reason});
}

/// API implementation for leases using /pm/leases/ endpoints.
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
    AppLogger.d(' Fetching leases from /pm/leases/');

    final response = await _apiClient.get<dynamic>(
      '/pm/leases/',
      queryParameters: <String, dynamic>{
        'page': page + 1, // Backend uses 1-indexed pages
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (status != null) 'status': status,
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue =
          data['leases'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];

      final hasMore = data['has_more'];
      if (hasMore is bool) explicitHasMore = hasMore;
      final total = data['total'] as int?;
      if (total != null) explicitHasMore = (page * limit) < total;
    } else {
      rawItems = <dynamic>[];
    }

    final bool hasMore = explicitHasMore ?? rawItems.length == limit;

    final items = rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(LeaseDto.fromJson)
        .toList(growable: false);

    AppLogger.d(' Fetched ${items.length} leases');

    return Page<LeaseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<LeaseDto> getLeaseById(int id) async {
    AppLogger.d(' Fetching lease by ID: $id');

    final response = await _apiClient.get<dynamic>(
      '/pm/leases/$id',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return LeaseDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return LeaseDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<LeaseDto> createLease(Map<String, dynamic> data) async {
    AppLogger.d(' Creating lease at /pm/leases/');

    // Build payload with mandatory fields per backend specs:
    // property_id, tenant_user_id, start_date, end_date, rent_amount, deposit_amount, payment_frequency
    final payload = <String, dynamic>{
      'property_id': data['property_id'] ?? data['propertyId'],
      'tenant_user_id': data['tenant_user_id'] ?? data['tenantUserId'],
      'start_date': data['start_date'] ?? data['startDate'],
      'end_date': data['end_date'] ?? data['endDate'],
      'rent_amount':
          data['rent_amount'] ?? data['monthlyRent'] ?? data['rentAmount'],
      'deposit_amount': data['deposit_amount'] ??
          data['securityDeposit'] ??
          data['depositAmount'] ??
          0,
      'payment_frequency':
          data['payment_frequency'] ?? data['paymentFrequency'] ?? 'monthly',
      // Optional fields
      if (data['rent_due_day'] != null || data['rentDueDay'] != null)
        'rent_due_day': data['rent_due_day'] ?? data['rentDueDay'],
      if (data['notes'] != null) 'notes': data['notes'],
      if (data['description'] != null) 'description': data['description'],
    };

    AppLogger.d(' Payload: $payload');

    final response = await _apiClient.post<dynamic>(
      '/pm/leases/',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return LeaseDto.fromJson(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return LeaseDto.fromJson(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath) async {
    AppLogger.d(' Uploading signed lease for ID: $leaseId');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _apiClient.upload<dynamic>(
      '/pm/leases/$leaseId/upload-signed',
      data: formData,
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return LeaseDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return LeaseDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<LeaseDto> renewLease(
      int leaseId, Map<String, dynamic> renewalData) async {
    AppLogger.d(' Renewing lease ID: $leaseId');

    final response = await _apiClient.post<dynamic>(
      '/pm/leases/$leaseId/renew',
      data: renewalData,
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return LeaseDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return LeaseDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<void> terminateLease(int leaseId, {String? reason}) async {
    AppLogger.d(' Terminating lease ID: $leaseId');

    await _apiClient.post<dynamic>(
      '/pm/leases/$leaseId/terminate',
      data: reason != null ? {'reason': reason} : null,
      options: Options(responseType: ResponseType.json),
    );
  }
}
