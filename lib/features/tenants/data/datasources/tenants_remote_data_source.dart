import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/data/models/tenant_dto.dart';

abstract interface class TenantsRemoteDataSource {
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  });

  Future<TenantDto> getTenantById(String id);

  /// Get current tenant's own data (for tenant view)
  Future<TenantDto> getMyTenantData();

  Future<TenantDto> createTenant(Map<String, dynamic> data);
}

final class ApiTenantsRemoteDataSource implements TenantsRemoteDataSource {
  ApiTenantsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  }) async {
    AppLogger.d(' Fetching tenants from /pm/tenants/');

    final response = await _apiClient.get<dynamic>(
      '/pm/tenants/',
      queryParameters: <String, dynamic>{
        'page': page + 1, // Backend uses 1-indexed pages
        'limit': limit,
        if (query.isNotEmpty) 'q': query,
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      // Backend may return: { tenants: [...], total: int, ... }
      final itemsValue =
          data['tenants'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];

      // Check for hasMore or total
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
        .map(TenantDto.fromJson)
        .toList(growable: false);

    AppLogger.d(' Fetched ${items.length} tenants');

    return Page<TenantDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<TenantDto> getTenantById(String id) async {
    AppLogger.d(' Fetching tenant by ID: $id');

    final response = await _apiClient.get<dynamic>(
      '/pm/tenants/$id',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return TenantDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return TenantDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<TenantDto> getMyTenantData() async {
    AppLogger.d(' Fetching current tenant data from /pm/tenants/me');

    final response = await _apiClient.get<dynamic>(
      '/pm/tenants/me',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return TenantDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return TenantDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<TenantDto> createTenant(Map<String, dynamic> data) async {
    AppLogger.d(' Creating tenant at /pm/tenants/');

    // Ensure mandatory fields are present per backend specs
    final payload = <String, dynamic>{
      'first_name': data['first_name'] ?? data['firstName'],
      'last_name': data['last_name'] ?? data['lastName'],
      'email': data['email'],
      'phone': data['phone'],
      'status': data['status'] ?? 'active',
      ...data, // Include any other fields
    };

    final response = await _apiClient.post<dynamic>(
      '/pm/tenants/',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return TenantDto.fromJson(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return TenantDto.fromJson(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }
}
