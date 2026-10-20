// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_activity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardActivityItemImpl _$$DashboardActivityItemImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardActivityItemImpl(
  id: parseInt(json['id']),
  type: ActivityType.fromJson(json['type']),
  at: parseDateTime(json['at']),
  title: json['title'] as String?,
  description: json['description'] as String?,
  propertyId: parseInt(json['property_id']),
  leaseId: parseInt(json['lease_id']),
  amount: parseDouble(json['amount']),
  status: json['status'] as String?,
);

Map<String, dynamic> _$$DashboardActivityItemImplToJson(
  _$DashboardActivityItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': ActivityType.toJsonValue(instance.type),
  'at': instance.at?.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'property_id': instance.propertyId,
  'lease_id': instance.leaseId,
  'amount': instance.amount,
  'status': instance.status,
};
