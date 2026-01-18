// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
  id: parseInt(json['id']),
  name: json['name'] as String?,
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  propertyName: json['property_name'] as String?,
  roomNumber: json['room_number'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'property_name': instance.propertyName,
      'room_number': instance.roomNumber,
      'status': instance.status,
    };
