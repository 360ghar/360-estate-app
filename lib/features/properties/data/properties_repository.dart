import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/cache_control.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/models/property.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  PropertiesRepositoryImpl(this._client, this._cache);

  final ApiClient _client;

  /// Account-scoped by the store itself (see `CacheStore.bindAccount`).
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 5);
  static const _cachePrefix = 'properties:';

  @override
  Future<Page<Property>> listPage({
    required String? cursor,
    required int limit,
    OccupancyFilter? occupancy,
    String? q,
  }) async {
    final search = q?.trim();
    final hasSearch = search != null && search.isNotEmpty;
    final cacheKey =
        '$_cachePrefix${occupancy?.wire ?? 'all'}:'
        'q=${hasSearch ? search : ''}:'
        '${cursor ?? Page.nullCursorCacheKey}:limit=$limit';
    final cached = _cache.get<Page<Property>>(cacheKey);
    if (cached != null) return cached;

    final response = await _client.get<dynamic>(
      ApiPaths.properties,
      ownerScoped: true,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        if (occupancy != null) 'occupancy': occupancy.wire,
        if (hasSearch) 'q': search,
      },
    );
    final raw = unwrapPage(response.data);
    final result = Page<Property>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Property.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
    if (isCacheable(response)) _cache.set(cacheKey, result, ttl: _cacheTtl);
    return result;
  }

  @override
  Future<List<Property>> listAll() {
    return fetchAllPages<Property>(
      ({required cursor, required limit}) =>
          listPage(cursor: cursor, limit: limit),
    );
  }

  @override
  Future<PropertyDetail> fetch(String id) async {
    final response = await _client.get<dynamic>('${ApiPaths.properties}/$id');
    return PropertyDetail.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Property> create(Map<String, dynamic> body) async {
    final response = await _client.post<dynamic>(
      ApiPaths.properties,
      data: body,
      ownerScoped: true,
    );
    _cache.invalidatePrefix(_cachePrefix);
    return Property.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Property> update(String id, Map<String, dynamic> body) async {
    final response = await _client.patch<dynamic>(
      '${ApiPaths.properties}/$id',
      data: body,
    );
    _cache.invalidatePrefix(_cachePrefix);
    return Property.fromJson(unwrapMap(response.data));
  }
}
