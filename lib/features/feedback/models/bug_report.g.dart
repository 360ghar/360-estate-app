// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BugReportImpl _$$BugReportImplFromJson(Map<String, dynamic> json) =>
    _$BugReportImpl(
      id: parseInt(json['id']),
      source: json['source'] as String?,
      bugType: json['bug_type'] as String?,
      severity: json['severity'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      stepsToReproduce: json['steps_to_reproduce'] as String?,
      expectedBehavior: json['expected_behavior'] as String?,
      actualBehavior: json['actual_behavior'] as String?,
      appVersion: json['app_version'] as String?,
      status: json['status'] as String?,
      tags: parseStringList(json['tags']),
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$BugReportImplToJson(_$BugReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'bug_type': instance.bugType,
      'severity': instance.severity,
      'title': instance.title,
      'description': instance.description,
      'steps_to_reproduce': instance.stepsToReproduce,
      'expected_behavior': instance.expectedBehavior,
      'actual_behavior': instance.actualBehavior,
      'app_version': instance.appVersion,
      'status': instance.status,
      'tags': instance.tags,
      'created_at': instance.createdAt?.toIso8601String(),
    };
