import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:estate_app/core/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class PlaceDetails {
  final double lat;
  final double lng;
  final String name;
  final String? formattedAddress;

  const PlaceDetails({
    required this.lat,
    required this.lng,
    required this.name,
    this.formattedAddress,
  });
}

final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) {
  final config = ref.read(appConfigProvider);
  return GooglePlacesService(apiKey: config.googlePlacesApiKey);
});

final class GooglePlacesService {
  GooglePlacesService({required this.apiKey});

  final String apiKey;
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Timer? _debounceTimer;

  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/place';

  Future<List<PlaceSuggestion>> getPlaceSuggestions(
    String query, {
    double? lat,
    double? lng,
  }) async {
    if (apiKey.isEmpty || query.trim().length < 2) return const [];

    try {
      final queryParameters = <String, dynamic>{
        'input': query,
        'components': 'country:in',
        'key': apiKey,
      };

      if (lat != null && lng != null) {
        queryParameters['location'] = '$lat,$lng';
        queryParameters['radius'] = '25000';
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/autocomplete/json',
        queryParameters: queryParameters,
      );

      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : json.decode(response.data.toString()) as Map<String, dynamic>;
      final status = body['status'] as String? ?? '';

      if (status != 'OK') {
        if (kDebugMode && status != 'ZERO_RESULTS') {
          debugPrint('GooglePlaces: status=$status for query=$query');
        }
        return const [];
      }

      final predictions = body['predictions'] as List? ?? [];
      return predictions.map((p) {
        return PlaceSuggestion(
          placeId: p['place_id'] as String? ?? '',
          description: p['description'] as String? ?? '',
          mainText:
              p['structured_formatting']?['main_text'] as String? ?? '',
          secondaryText:
              p['structured_formatting']?['secondary_text'] as String? ?? '',
        );
      }).toList();
    } on TimeoutException {
      debugPrint('GooglePlaces: autocomplete timeout for query=$query');
      return const [];
    } on DioException catch (e) {
      debugPrint('GooglePlaces: autocomplete error: ${e.message}');
      return const [];
    } catch (e) {
      debugPrint('GooglePlaces: autocomplete error: $e');
      return const [];
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (apiKey.isEmpty) return null;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'name,geometry,formatted_address,address_components',
          'key': apiKey,
        },
      );

      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : json.decode(response.data.toString()) as Map<String, dynamic>;
      final status = body['status'] as String? ?? '';

      if (status != 'OK') {
        debugPrint(
          'GooglePlaces: details status=$status for placeId=$placeId',
        );
        return null;
      }

      final result = body['result'] as Map<String, dynamic>?;
      if (result == null) return null;

      final location =
          result['geometry']?['location'] as Map<String, dynamic>?;
      if (location == null) return null;

      final lat = (location['lat'] as num?)?.toDouble() ?? 0.0;
      final lng = (location['lng'] as num?)?.toDouble() ?? 0.0;

      String displayName;
      final components = result['address_components'] as List? ?? [];
      String? locality;
      String? city;
      for (final c in components) {
        final types = c['types'] as List? ?? [];
        if (types.contains('locality')) {
          locality = c['long_name'] as String?;
        }
        if (types.contains('administrative_area_level_2')) {
          city = c['long_name'] as String?;
        }
      }
      displayName = result['name'] as String? ?? '';
      if (locality != null && city != null) {
        displayName = '$locality, $city';
      } else if (city != null) {
        displayName = city;
      } else if (locality != null) {
        displayName = locality;
      }

      final formattedAddress =
          result['formatted_address'] as String?;

      return PlaceDetails(
        lat: lat,
        lng: lng,
        name: displayName,
        formattedAddress: formattedAddress,
      );
    } on TimeoutException {
      debugPrint('GooglePlaces: details timeout for placeId=$placeId');
      return null;
    } on DioException catch (e) {
      debugPrint('GooglePlaces: details error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('GooglePlaces: details error: $e');
      return null;
    }
  }

  void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }

  void cancelDebounce() {
    _debounceTimer?.cancel();
  }
}