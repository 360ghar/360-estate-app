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
  at: json['at'] as String?,
  propertyId: parseInt(json['property_id']),
  leaseId: parseInt(json['lease_id']),
  amount: parseDouble(json['amount']),
  status: json['status'] as String?,
  createdAt: parseDateTime(json['created_at']),
);

Map<String, dynamic> _$$DashboardActivityItemImplToJson(
  _$DashboardActivityItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'message': instance.message,
  'at': instance.at,
  'property_id': instance.propertyId,
  'lease_id': instance.leaseId,
  'amount': instance.amount,
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
};
