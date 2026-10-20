import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

/// One inbox row of `GET /notifications/me` (`NotificationItem`). `id` is the
/// delivery id (a string), the key of `POST /notifications/deliveries/{id}/opened`.
@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    String? id,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'read_at', fromJson: parseDateTime) DateTime? readAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
