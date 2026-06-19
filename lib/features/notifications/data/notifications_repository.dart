import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';

class DeviceRegistrationRequest {
  const DeviceRegistrationRequest({required this.token, this.platform});

  final String token;
  final String? platform;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'token': token};
    if (platform != null && platform!.trim().isNotEmpty) {
      payload['platform'] = platform!.trim();
    }
    return payload;
  }
}

class NotificationsRepository {
  NotificationsRepository(this._client);

  final ApiClient _client;

  Future<void> registerDevice(DeviceRegistrationRequest request) async {
    await _client.post<dynamic>(
      '/notifications/devices/register',
      data: request.toJson(),
    );
  }

  Future<List<NotificationItem>> listForUser(
    String userId, {
    int limit = 50,
    String? cursor,
  }) async {
    final response = await _client.get<dynamic>(
      '/notifications/users/$userId/',
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
    final page = unwrapPage(response.data);
    return page.items
        .whereType<Map<String, dynamic>>()
        .map(NotificationItem.fromJson)
        .toList();
  }
}
