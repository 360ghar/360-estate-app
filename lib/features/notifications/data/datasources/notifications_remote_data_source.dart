import 'package:estate_app/core/network/api_client.dart';

abstract interface class NotificationsRemoteDataSource {
  /// Register device token for push notifications
  Future<void> registerDevice({
    required String token,
    required String platform,
    String? deviceId,
  });

  /// Unregister device token
  Future<void> unregisterDevice(String token);

  /// Update notification preferences
  Future<void> updateNotificationPreferences(Map<String, dynamic> preferences);
}

final class ApiNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  ApiNotificationsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
    String? deviceId,
  }) async {
    // Don't include /api/v1/ prefix since it's already in base URL
    await _apiClient.post<void>(
      '/notifications/devices/register',
      data: {
        'token': token,
        'platform': platform,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  @override
  Future<void> unregisterDevice(String token) async {
    await _apiClient.post<void>(
      '/notifications/devices/unregister',
      data: {'token': token},
    );
  }

  @override
  Future<void> updateNotificationPreferences(
      Map<String, dynamic> preferences) async {
    await _apiClient.patch<void>(
      '/notifications/preferences',
      data: preferences,
    );
  }
}
