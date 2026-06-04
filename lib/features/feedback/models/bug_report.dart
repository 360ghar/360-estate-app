import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bug_report.freezed.dart';
part 'bug_report.g.dart';

@freezed
class BugReport with _$BugReport {
  const factory BugReport({
    @JsonKey(fromJson: parseInt) int? id,
    String? source,
    @JsonKey(name: 'bug_type') String? bugType,
    String? severity,
    String? title,
    String? description,
    @JsonKey(name: 'steps_to_reproduce') String? stepsToReproduce,
    @JsonKey(name: 'expected_behavior') String? expectedBehavior,
    @JsonKey(name: 'actual_behavior') String? actualBehavior,
    @JsonKey(name: 'app_version') String? appVersion,
    String? status,
    @JsonKey(fromJson: parseStringList) List<String>? tags,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _BugReport;

  factory BugReport.fromJson(Map<String, dynamic> json) =>
      _$BugReportFromJson(json);
}
