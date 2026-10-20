import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';

/// Body of `POST /notifications/devices/register` (`DeviceRegisterIn`).
/// `token`, `platform` and `app_key` are required. `platform` is one of
/// `android`, `ios` and `web`. This app is `estate`.
class DeviceRegistrationRequest {
  const DeviceRegistrationRequest({
    required this.token,
    required this.platform,
    this.appKey = AppKey.estate,
    this.appVersion,
    this.locale,
  });

  final String token;
  final DevicePlatform platform;
  final AppKey appKey;
  final String? appVersion;
  final String? locale;

  Map<String, dynamic> toJson() => {
    'token': token.trim(),
    'platform': platform.wire,
    'app_key': appKey.wire,
    if (appVersion != null && appVersion!.isNotEmpty) 'app_version': appVersion,
    if (locale != null && locale!.isNotEmpty) 'locale': locale,
  };
}

class NotificationsRepository {
  NotificationsRepository(this._client);

  final ApiClient _client;

  Future<void> registerDevice(DeviceRegistrationRequest request) async {
    await _client.post<dynamic>(
      ApiPaths.deviceRegister,
      data: request.toJson(),
    );
  }

  /// One page of the signed-in user's inbox (`GET /notifications/me`). The
  /// route reads the caller's own inbox: no user id goes in the path.
  Future<Page<NotificationItem>> listPage({
    required String? cursor,
    required int limit,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.notificationsMe,
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    final page = unwrapPage(response.data);
    return Page(
      items: page.items
          .whereType<Map<String, dynamic>>()
          .map(NotificationItem.fromJson)
          .toList(),
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Marks one inbox row read. The row stays in the list with `read_at` set.
  Future<void> markOpened(String deliveryId) async {
    await _client.post<dynamic>(ApiPaths.notificationOpened(deliveryId));
  }
}
