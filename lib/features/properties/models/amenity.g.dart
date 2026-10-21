// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AmenityImpl _$$AmenityImplFromJson(Map<String, dynamic> json) =>
    _$AmenityImpl(
      id: parseInt(json['id']),
      title: json['title'] as String?,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$AmenityImplToJson(_$AmenityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'category': instance.category,
      'is_active': instance.isActive,
    };
