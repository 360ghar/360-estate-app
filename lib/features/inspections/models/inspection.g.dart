// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionItemImpl _$$InspectionItemImplFromJson(Map<String, dynamic> json) =>
    _$InspectionItemImpl(
      title: json['title'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      isRequired: json['is_required'] as bool?,
    );

Map<String, dynamic> _$$InspectionItemImplToJson(
  _$InspectionItemImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'status': instance.status,
  'notes': instance.notes,
  'is_required': instance.isRequired,
};

_$InspectionImpl _$$InspectionImplFromJson(Map<String, dynamic> json) =>
    _$InspectionImpl(
      id: parseInt(json['id']),
      propertyId: parseInt(json['property_id']),
      propertyName: json['property_name'] as String?,
      tenantId: parseInt(json['tenant_id']),
      tenantName: json['tenant_name'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      scheduledAt: parseDateTime(json['scheduled_at']),
      signedAt: parseDateTime(json['signed_at']),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InspectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );

Map<String, dynamic> _$$InspectionImplToJson(_$InspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'tenant_id': instance.tenantId,
      'tenant_name': instance.tenantName,
      'title': instance.title,
      'status': instance.status,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'signed_at': instance.signedAt?.toIso8601String(),
      'items': instance.items,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
