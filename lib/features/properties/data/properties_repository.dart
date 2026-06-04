import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/models/property.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  PropertiesRepositoryImpl(
    this._client,
    this._cache, {
    String cacheScope = 'global',
  }) : _cacheScope = cacheScope;

  final ApiClient _client;
  final CacheStore _cache;
  final String _cacheScope;
  static const _cacheTtl = Duration(minutes: 5);

  @override
  Future<Page<Property>> listPage({
    required int page,
    required int limit,
  }) async {
    final cacheKey = 'properties:$_cacheScope:page=$page:limit=$limit';
    final cached = _cache.get<List<Property>>(cacheKey);
    if (cached != null) {
      return Page(
        items: cached,
        page: page,
        limit: limit,
        hasMore: cached.length >= limit,
      );
    }

    final response = await _client.get<dynamic>(
      '/pm/properties/',
      queryParameters: {
        'page': page,
        'limit': limit,
        'offset': (page - 1) * limit,
      },
    );
    final baseUrl = _client.dio.options.baseUrl;
    final items = unwrapList(response.data)
        .whereType<Map<String, dynamic>>()
        .map((item) => _normalizePropertyJson(item, baseUrl: baseUrl))
        .map(Property.fromJson)
        .toList();
    _cache.set(cacheKey, items, ttl: _cacheTtl);
    return Page(
      items: items,
      page: page,
      limit: limit,
      hasMore: items.length >= limit,
    );
  }

  /// List all properties (up to limit)
  @override
  Future<List<Property>> list({int limit = 200}) async {
    final page = await listPage(page: 1, limit: limit);
    return page.items;
  }

  @override
  Future<Property> fetch(String id) async {
    final response = await _client.get<dynamic>('/pm/properties/$id');
    final data = _normalizePropertyJson(
      unwrapMap(response.data),
      baseUrl: _client.dio.options.baseUrl,
    );
    return Property.fromJson(data);
  }

  @override
  Future<Property> create(PropertyPayload payload) async {
    final response = await _client.post<dynamic>(
      '/pm/properties/',
      data: payload.toJson(),
    );
    final data = _normalizePropertyJson(
      unwrapMap(response.data),
      baseUrl: _client.dio.options.baseUrl,
    );
    _cache.invalidatePrefix('properties:$_cacheScope:');
    return Property.fromJson(data);
  }

  @override
  Future<Property> update(String id, PropertyPayload payload) async {
    final response = await _client.patch<dynamic>(
      '/pm/properties/$id',
      data: payload.toJson(),
    );
    final data = _normalizePropertyJson(
      unwrapMap(response.data),
      baseUrl: _client.dio.options.baseUrl,
    );
    _cache.invalidatePrefix('properties:$_cacheScope:');
    return Property.fromJson(data);
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete<dynamic>('/pm/properties/$id');
    _cache.invalidatePrefix('properties:$_cacheScope:');
  }
}

Map<String, dynamic> _normalizePropertyJson(
  Map<String, dynamic> json, {
  String? baseUrl,
}) {
  final normalized = Map<String, dynamic>.from(json);

  final rawName = normalized['name'] ??
      normalized['property_name'] ??
      normalized['title'] ??
      normalized['property_title'];
  if (rawName != null) {
    final name = rawName.toString().trim();
    if (name.isNotEmpty) {
      normalized['name'] ??= name;
      normalized['property_name'] ??= name;
    }
  }

  final images = <String>{};
  void addImages(dynamic value) {
    if (value == null) return;
    if (value is String) {
      final normalizedUrl = _normalizeImageUrl(value, baseUrl: baseUrl);
      if (normalizedUrl != null) images.add(normalizedUrl);
      return;
    }
    if (value is List) {
      for (final entry in value) {
        addImages(entry);
      }
      return;
    }
    if (value is Map<String, dynamic>) {
      final url = value['url'] ??
          value['image_url'] ??
          value['image'] ??
          value['imageUrl'] ??
          value['thumbnail'] ??
          value['path'] ??
          value['file_url'] ??
          value['fileUrl'] ??
          value['secure_url'];
      if (url is String) {
        final normalizedUrl = _normalizeImageUrl(url, baseUrl: baseUrl);
        if (normalizedUrl != null) images.add(normalizedUrl);
      }
    }
  }

  addImages(normalized['images']);
  addImages(normalized['image']);
  addImages(normalized['photo']);
  addImages(normalized['photo_url']);
  addImages(normalized['cover_image']);
  addImages(normalized['coverImage']);
  addImages(normalized['thumbnail']);
  addImages(normalized['image_url']);
  addImages(normalized['imageUrl']);
  addImages(normalized['main_image']);
  if (images.isNotEmpty) {
    normalized['images'] = images.toList();
  }

  return normalized;
}

String? _normalizeImageUrl(String? raw, {String? baseUrl}) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return null;
  if (uri.hasScheme) return trimmed;

  final base = baseUrl?.trim();
  if (base == null || base.isEmpty) return trimmed;
  final normalizedBase = base.endsWith('/') ? base : '$base/';
  final baseUri = Uri.tryParse(normalizedBase);
  if (baseUri == null) return trimmed;

  return baseUri.resolveUri(uri).toString();
}
