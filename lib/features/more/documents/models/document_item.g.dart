// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentItemImpl _$$DocumentItemImplFromJson(Map<String, dynamic> json) =>
    _$DocumentItemImpl(
      id: parseInt(json['id']),
      title: json['title'] as String?,
      type: json['type'] as String?,
      fileName: json['file_name'] as String?,
      uploadedAt: parseDateTime(json['uploaded_at']),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$DocumentItemImplToJson(_$DocumentItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'file_name': instance.fileName,
      'uploaded_at': instance.uploadedAt?.toIso8601String(),
      'url': instance.url,
    };
