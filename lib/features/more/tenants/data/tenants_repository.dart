import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/cache_control.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';

class TenantsRepository {
  TenantsRepository(this._client, this._cache);

  final ApiClient _client;

  /// Account-scoped by the store itself (see `CacheStore.bindAccount`): sign-out
  /// and an account switch drop every entry.
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 5);

  Future<Page<Tenant>> listPage({
    required String? cursor,
    required int limit,
  }) async {
    final cacheKey =
        'tenants:cursor=${cursor ?? Page.nullCursorCacheKey}:limit=$limit';
    final cached = _cache.get<Page<Tenant>>(cacheKey);
    if (cached != null) return cached;

    final response = await _client.get<dynamic>(
      ApiPaths.tenants,
      ownerScoped: true,
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    final raw = unwrapPage(response.data);
    final result = Page<Tenant>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Tenant.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
    if (isCacheable(response)) _cache.set(cacheKey, result, ttl: _cacheTtl);
    return result;
  }

  /// A tenant by `user_id` (the id of the tenant's user account).
  Future<Tenant> fetch(int userId) async {
    final response = await _client.get<dynamic>(
      ApiPaths.tenant(userId),
      ownerScoped: true,
    );
    return Tenant.fromJson(unwrapMap(response.data));
  }
}
