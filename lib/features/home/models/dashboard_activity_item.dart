import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_activity_item.freezed.dart';
part 'dashboard_activity_item.g.dart';

@freezed
class DashboardActivityItem with _$DashboardActivityItem {
  const factory DashboardActivityItem({
    @JsonKey(fromJson: parseInt) int? id,
    String? type,
    String? title,
    String? message,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _DashboardActivityItem;

  factory DashboardActivityItem.fromJson(Map<String, dynamic> json) =>
      _$DashboardActivityItemFromJson(json);
}
