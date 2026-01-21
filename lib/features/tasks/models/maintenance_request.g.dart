// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaintenanceRequestImpl _$$MaintenanceRequestImplFromJson(
  Map<String, dynamic> json,
) => _$MaintenanceRequestImpl(
  id: parseInt(json['id']),
  title: json['title'] as String?,
  description: json['description'] as String?,
  status: json['status'] as String?,
  priority: json['priority'] as String?,
  propertyName: json['property_name'] as String?,
  tenantName: json['tenant_name'] as String?,
  attachments: parseStringList(json['attachments']),
  createdAt: parseDateTime(json['created_at']),
  updatedAt: parseDateTime(json['updated_at']),
);

Map<String, dynamic> _$$MaintenanceRequestImplToJson(
  _$MaintenanceRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'priority': instance.priority,
  'property_name': instance.propertyName,
  'tenant_name': instance.tenantName,
  'attachments': instance.attachments,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
