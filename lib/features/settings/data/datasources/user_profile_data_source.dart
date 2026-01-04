import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/settings/domain/entities/user_profile.dart';

/// Data source for user profile operations from the backend API
abstract interface class UserProfileDataSource {
  /// Fetch current user's profile from /api/v1/users/profile/
  Future<UserProfile> getProfile();

  /// Update user's profile
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  });

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences);

  /// Update notification settings
  Future<void> updateNotificationSettings(NotificationSettings settings);
}

final class UserProfileDataSourceImpl implements UserProfileDataSource {
  UserProfileDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserProfile> getProfile() async {
    try {
      print('[PROFILE] Fetching user profile from /users/profile/');
      
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/users/profile/',
      );

      final data = response.data;
      if (data == null) {
        throw Exception('No profile data received');
      }

      print('[PROFILE] Received profile data: $data');

      // Handle different response structures
      final profileData = data['data'] as Map<String, dynamic>? ??
          data['user'] as Map<String, dynamic>? ??
          data['results'] as Map<String, dynamic>? ??
          data;

      return UserProfile.fromJson(profileData);
    } on DioException catch (e) {
      print('[PROFILE] Error fetching profile: ${e.message}');
      print('[PROFILE] Status: ${e.response?.statusCode}');
      print('[PROFILE] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('[PROFILE] Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (email != null) body['email'] = email;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;

    final response = await _apiClient.put<Map<String, dynamic>>(
      '/users/profile/',
      data: body,
    );

    final data = response.data;
    if (data == null) {
      throw Exception('No profile data received after update');
    }

    final profileData = data['data'] as Map<String, dynamic>? ??
        data['user'] as Map<String, dynamic>? ??
        data;

    return UserProfile.fromJson(profileData);
  }

  @override
  Future<void> updatePreferences(UserPreferences preferences) async {
    await _apiClient.put<void>(
      '/users/preferences/',
      data: {
        'preferred_locations': preferences.preferredLocations,
        'budget_min': preferences.budgetMin,
        'budget_max': preferences.budgetMax,
        'preferred_property_types': preferences.preferredPropertyTypes,
      },
    );
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    await _apiClient.put<void>(
      '/users/notification-settings',
      data: settings.toJson(),
    );
  }
}
