// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
  userId: parseInt(json['user_id']),
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  status: TenantStatus.fromJson(json['status']),
  propertyName: json['property_name'] as String?,
  activeLeasesCount: parseInt(json['active_leases_count']),
  leases: (json['leases'] as List<dynamic>?)
      ?.map((e) => Lease.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'status': TenantStatus.toJsonValue(instance.status),
      'property_name': instance.propertyName,
      'active_leases_count': instance.activeLeasesCount,
      'leases': instance.leases,
    };
