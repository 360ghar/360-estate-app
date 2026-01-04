import 'dart:io';
import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/api_error.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<String> uploadPropertyImage(String path);
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
    // Endpoint: GET /properties (backend uses page/limit pagination)
    // Note: Backend endpoint is /properties, NOT /pm/properties
    final response = await _client.get<dynamic>(
      '/properties',
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
      // Backend returns: { properties: [...], total: int, ... }
      final itemsValue =
          data['properties'] ??
          data['items'] ??
          data['data'] ??
          data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
      explicitHasMore = _extractHasMore(data, page, limit);
    } else if (data is Map<dynamic, dynamic>) {
      final map = data.cast<String, dynamic>();
      final itemsValue =
          map['properties'] ?? map['items'] ?? map['data'] ?? map['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
      explicitHasMore = _extractHasMore(map, page, limit);
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

  static bool? _extractHasMore(Map<String, dynamic> data, int page, int limit) {
    // Check explicit hasMore field
    final hasMore = data['hasMore'];
    if (hasMore is bool) return hasMore;

    final hasMoreSnake = data['has_more'];
    if (hasMoreSnake is bool) return hasMoreSnake;

    // Check total count and total_pages
    final totalPages = data['total_pages'] as int?;
    if (totalPages != null) {
      return page < totalPages;
    }
    
    final total = data['total'] as int?;
    if (total != null) {
      return (page * limit) < total;
    }

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
    // Endpoint: GET /properties/{property_id}
    final response = await _client.get<dynamic>(
      '/properties/$id',
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
    // Endpoint: POST /properties
    // Backend expects: PropertyCreate schema
    final response = await _client.post<dynamic>(
      '/properties',
      data: _createPropertyToJson(property),
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

  /// Converts PropertyDto to backend API format for property creation
  Map<String, dynamic> _createPropertyToJson(PropertyDto property) {
    return {
      'title': property.title,
      'property_type': property.propertyType,
      'purpose': 'rent', // Default purpose for PM properties
      'base_price': property.monthlyRentInr,
      'address': '${property.addressLine}, ${property.city}${property.state != null ? ', ${property.state}' : ''}',
      'payment_due_day': property.paymentDueDay,
      'grace_period_days': 3, // Default grace period
      'late_fee_policy': {
        'type': 'fixed',
        'amount': 500, // Default late fee
      },
      // Optional fields
      if (property.nickname != null) 'nickname': property.nickname,
      if (property.bedroomCount != null) 'bedrooms': property.bedroomCount,
      if (property.bathroomCount != null) 'bathrooms': property.bathroomCount,
      if (property.floorAreaSqft != null) 'area_sqft': property.floorAreaSqft,
      if (property.notes != null) 'description': property.notes,
    };
  }

  @override
  Future<PropertyDto> updateProperty(
    int id,
    Map<String, dynamic> updates,
  ) async {
    // Endpoint: PUT /properties/{property_id}
    final response = await _client.put<dynamic>(
      '/properties/$id',
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
    // Endpoint: DELETE /properties/{property_id}/
    await _client.delete<dynamic>(
      '/properties/$id/',
      options: Options(responseType: ResponseType.json),
    );
  }

  @override
  Future<String> uploadPropertyImage(String path) async {
    // Use Supabase Storage directly as per backend/README.md
    // Bucket: property-images
    try {
      final supabase = Supabase.instance.client;
      final file = File(path);
      final name =
          '${DateTime.now().millisecondsSinceEpoch}_${path.split(Platform.pathSeparator).last}';

      await supabase.storage.from('property-images').upload(name, file);

      // Get public URL
      final url = supabase.storage.from('property-images').getPublicUrl(name);
      return url;
    } on StorageException catch (e) {
      throw ApiFailure(
        error: ApiError(
          statusCode: int.tryParse(e.statusCode ?? ''),
          message: e.message,
        ),
        cause: e,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw UnknownFailure('Failed to upload image', cause: e);
    }
  }
}
