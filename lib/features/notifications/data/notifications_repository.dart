import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
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

  Future<Page<NotificationItem>> listForUser(
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
    final items = page.items
        .whereType<Map<String, dynamic>>()
        .map(NotificationItem.fromJson)
        .toList();
    return Page(
      items: items,
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }
}
