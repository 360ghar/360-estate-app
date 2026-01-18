// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationItemImpl(
  id: parseInt(json['id']),
  title: json['title'] as String?,
  body: json['body'] as String?,
  type: json['type'] as String?,
  data: json['data'] as Map<String, dynamic>?,
  createdAt: parseDateTime(json['created_at']),
  readAt: parseDateTime(json['read_at']),
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'type': instance.type,
  'data': instance.data,
  'created_at': instance.createdAt?.toIso8601String(),
  'read_at': instance.readAt?.toIso8601String(),
};
