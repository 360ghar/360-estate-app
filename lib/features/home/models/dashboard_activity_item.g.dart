// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_activity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardActivityItemImpl _$$DashboardActivityItemImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardActivityItemImpl(
  id: parseInt(json['id']),
  type: json['type'] as String?,
  title: json['title'] as String?,
  message: json['message'] as String?,
  createdAt: parseDateTime(json['created_at']),
);

Map<String, dynamic> _$$DashboardActivityItemImplToJson(
  _$DashboardActivityItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'message': instance.message,
  'created_at': instance.createdAt?.toIso8601String(),
};
