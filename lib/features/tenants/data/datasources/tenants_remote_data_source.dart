import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/tenants/data/models/tenant_dto.dart';

abstract interface class TenantsRemoteDataSource {
  Future<Page<TenantDto>> getTenants({
    required int page,
    required int limit,
    required String query,
  });

  Future<TenantDto> getTenantByUserId(String tenantUserId);
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
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (query.isNotEmpty) 'q': query,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/tenants',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [])
        .map((e) => TenantDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return Page<TenantDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<TenantDto> getTenantByUserId(String tenantUserId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/tenants/$tenantUserId',
    );

    return TenantDto.fromJson(response.data!);
  }
}
