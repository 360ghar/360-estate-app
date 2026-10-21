import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/models/amenity.dart';

class AmenitiesRepository {
  AmenitiesRepository(this._client);

  final ApiClient _client;

  Future<Page<Amenity>> listPage({
    required String? cursor,
    required int limit,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.amenities,
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    final raw = unwrapPage(response.data);
    return Page<Amenity>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Amenity.fromJson)
          .where((amenity) => amenity.isActive != false)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
  }
}
