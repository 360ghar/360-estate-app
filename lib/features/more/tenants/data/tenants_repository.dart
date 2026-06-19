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
    required String? cursor,
    required int limit,
  }) async {
    final cacheKey = 'tenants:cursor=${cursor ?? 'first'}:limit=$limit';
    final cached = _cache
        .get<({List<Tenant> items, String? nextCursor, bool hasMore})>(
            cacheKey);
    if (cached != null) {
      return Page(
        items: cached.items,
        limit: limit,
        hasMore: cached.hasMore,
        nextCursor: cached.nextCursor,
      );
    }

    final response = await _client.get<dynamic>(
      '/pm/tenants/',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
    );
    final page = unwrapPage(response.data);
    final data = page.items
        .whereType<Map<String, dynamic>>()
        .map(Tenant.fromJson)
        .toList();
    _cache.set(
      cacheKey,
      (items: data, nextCursor: page.nextCursor, hasMore: page.hasMore),
      ttl: _cacheTtl,
    );
    return Page(
      items: data,
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  Future<List<Tenant>> list({int limit = 200}) async {
    final page = await listPage(cursor: null, limit: limit);
    return page.items;
  }

  Future<Tenant> fetch(String id) async {
    final response = await _client.get<dynamic>('/pm/tenants/$id');
    final data = unwrapMap(response.data);
    return Tenant.fromJson(data);
  }
}
