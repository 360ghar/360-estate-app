import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'read_at', fromJson: parseDateTime) DateTime? readAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
