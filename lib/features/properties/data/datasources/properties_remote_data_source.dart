import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';

abstract interface class PropertiesRemoteDataSource {
  Future<Page<PropertyDto>> getProperties({
    required int page,
    required int limit,
    required String query,
  });

  Future<PropertyDto> getPropertyById(int id);

  Future<PropertyDto> createProperty(PropertyDto property);

  Future<PropertyDto> updateProperty(int id, Map<String, dynamic> updates);

  Future<void> deleteProperty(int id);
}

final class ApiPropertiesRemoteDataSource
    implements PropertiesRemoteDataSource {
  ApiPropertiesRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<Page<PropertyDto>> getProperties({
    required int page,
    required int limit,
    required String query,
  }) async {
    final response = await _client.get<dynamic>(
      '/api/v1/pm/properties',
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
        if (query.trim().isNotEmpty) 'q': query.trim(),
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue = data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
      explicitHasMore = _extractHasMore(data);
    } else if (data is Map<dynamic, dynamic>) {
      final map = data.cast<String, dynamic>();
      final itemsValue = map['items'] ?? map['data'] ?? map['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
      explicitHasMore = _extractHasMore(map);
    } else {
      rawItems = <dynamic>[];
    }

    final bool hasMore = explicitHasMore ?? rawItems.length == limit;

    final items = rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(PropertyDto.fromJson)
        .toList(growable: false);

    return Page<PropertyDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  static bool? _extractHasMore(Map<String, dynamic> data) {
    final hasMore = data['hasMore'];
    if (hasMore is bool) return hasMore;

    final meta = data['meta'];
    if (meta is Map<String, dynamic>) {
      final mHasMore = meta['hasMore'];
      if (mHasMore is bool) return mHasMore;
      final mHasMoreSnake = meta['has_more'];
      if (mHasMoreSnake is bool) return mHasMoreSnake;
    } else if (meta is Map<dynamic, dynamic>) {
      final metaMap = meta.cast<String, dynamic>();
      final mHasMore = metaMap['hasMore'];
      if (mHasMore is bool) return mHasMore;
      final mHasMoreSnake = metaMap['has_more'];
      if (mHasMoreSnake is bool) return mHasMoreSnake;
    }
    return null;
  }

  @override
  Future<PropertyDto> getPropertyById(int id) async {
    final response = await _client.get<dynamic>(
      '/api/v1/pm/properties/$id',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return PropertyDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return PropertyDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<PropertyDto> createProperty(PropertyDto property) async {
    final response = await _client.post<dynamic>(
      '/api/v1/pm/properties',
      data: property.toJson(),
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return PropertyDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return PropertyDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<PropertyDto> updateProperty(int id, Map<String, dynamic> updates) async {
    final response = await _client.patch<dynamic>(
      '/api/v1/pm/properties/$id',
      data: updates,
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      return PropertyDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return PropertyDto.fromJson(data.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<void> deleteProperty(int id) async {
    await _client.delete<dynamic>(
      '/api/v1/pm/properties/$id',
      options: Options(responseType: ResponseType.json),
    );
  }
}
