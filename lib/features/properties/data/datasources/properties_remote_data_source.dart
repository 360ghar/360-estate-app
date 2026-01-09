import 'dart:io';
import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/api_error.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/logger/app_logger.dart';
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

  /// Get the current authenticated user's ID from Supabase
  String? _getCurrentUserId() {
    try {
      return Supabase.instance.client.auth.currentSession?.user.id;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Page<PropertyDto>> getProperties({
    required int page,
    required int limit,
    required String query,
  }) async {
    // Endpoint: GET /pm/properties/ (backend PM module)
    final response = await _client.get<dynamic>(
      '/pm/properties/',
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
      final itemsValue = data['properties'] ??
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
    // Endpoint: GET /pm/properties/{property_id}
    final response = await _client.get<dynamic>(
      '/pm/properties/$id',
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
    // Endpoint: POST /pm/properties/
    // Backend expects: PropertyCreate schema with mandatory fields
    final response = await _client.post<dynamic>(
      '/pm/properties/',
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
  /// Includes all mandatory fields required by POST /pm/properties/
  Map<String, dynamic> _createPropertyToJson(PropertyDto property) {
    // Get current user ID from Supabase auth session
    final userId = _getCurrentUserId();

    if (userId == null) {
      AppLogger.w('No Supabase user session found; owner_id will be omitted');
    }

    final payload = <String, dynamic>{
      ...property.toJson(),
      // MANDATORY FIELDS (required by backend)
      'title': property.title,
      'description': property.notes ??
          property.title, // Required - use notes or fallback to title
      'address':
          '${property.addressLine}, ${property.city}${property.state != null ? ', ${property.state}' : ''}',
      'property_type': property.propertyType,
      'property_category': property.propertyCategory,
      'status': 'available', // Required: e.g., "available"
      'purpose': property.purpose, // Required: "rent" or "sale"
      'price': property.monthlyRentInr.toDouble(), // Required: Total price
      'base_price': property.basePrice ??
          property.monthlyRentInr.toDouble(), // Required by backend

      // OPTIONAL FIELDS
      'payment_due_day': property.paymentDueDay,
      'grace_period_days': 3, // Default grace period
      'late_fee_policy': {
        'type': 'fixed',
        'amount': 500, // Default late fee
      },
      if (property.nickname != null) 'nickname': property.nickname,
      if (property.bedroomCount != null) 'bedrooms': property.bedroomCount,
      if (property.bathroomCount != null) 'bathrooms': property.bathroomCount,
      if (property.floorAreaSqft != null) 'area_sqft': property.floorAreaSqft,
      // NOTE: Do NOT send 'amenity_ids' as it causes 500/422 errors
    };

    if (userId != null) {
      payload['owner_id'] = userId;
    }

    return payload;
  }

  @override
  Future<PropertyDto> updateProperty(
    int id,
    Map<String, dynamic> updates,
  ) async {
    // Endpoint: PUT /pm/properties/{property_id}
    final response = await _client.put<dynamic>(
      '/pm/properties/$id',
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
    // Endpoint: DELETE /pm/properties/{property_id}/
    await _client.delete<dynamic>(
      '/pm/properties/$id/',
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
