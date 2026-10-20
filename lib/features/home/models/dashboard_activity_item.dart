import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_activity_item.freezed.dart';
part 'dashboard_activity_item.g.dart';

/// A row of `GET /pm/dashboard/activity` (`ActivityItem`). `at` is the UTC time
/// of the event. `title` and `description` are the display text.
@freezed
class DashboardActivityItem with _$DashboardActivityItem {
  const factory DashboardActivityItem({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(fromJson: ActivityType.fromJson, toJson: ActivityType.toJsonValue)
    ActivityType? type,
    @JsonKey(fromJson: parseDateTime) DateTime? at,
    String? title,
    String? description,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? status,
  }) = _DashboardActivityItem;

  factory DashboardActivityItem.fromJson(Map<String, dynamic> json) =>
      _$DashboardActivityItemFromJson(json);
}
