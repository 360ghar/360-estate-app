import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';

class TenantsRepository {
  TenantsRepository(this._client, this._cache);

  final ApiClient _client;
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 5);

  Future<Page<Tenant>> listPage({
    required int page,
    required int limit,
  }) async {
    final cacheKey = 'tenants:page=$page:limit=$limit';
    final cached = _cache.get<List<Tenant>>(cacheKey);
    if (cached != null) {
      return Page(
        items: cached,
        page: page,
        limit: limit,
        hasMore: cached.length >= limit,
      );
    }

    final response = await _client.get<dynamic>(
      '/pm/tenants/',
      queryParameters: {
        'page': page,
        'limit': limit,
        'offset': (page - 1) * limit,
      },
    );
    final data = unwrapList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(Tenant.fromJson)
        .toList();
    _cache.set(cacheKey, data, ttl: _cacheTtl);
    return Page(
      items: data,
      page: page,
      limit: limit,
      hasMore: data.length >= limit,
    );
  }

  Future<List<Tenant>> list({int limit = 200}) async {
    final page = await listPage(page: 1, limit: limit);
    return page.items;
  }

  Future<Tenant> fetch(String id) async {
    final response = await _client.get<dynamic>('/pm/tenants/$id');
    final data = unwrapMap(response.data);
    return Tenant.fromJson(data);
  }
}
