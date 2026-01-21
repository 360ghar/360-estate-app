// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_charge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentChargeImpl _$$RentChargeImplFromJson(Map<String, dynamic> json) =>
    _$RentChargeImpl(
      id: parseInt(json['id']),
      tenantName: json['tenant_name'] as String?,
      propertyName: json['property_name'] as String?,
      amount: parseDouble(json['amount']),
      dueDate: parseDateTime(json['due_date']),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$RentChargeImplToJson(_$RentChargeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_name': instance.tenantName,
      'property_name': instance.propertyName,
      'amount': instance.amount,
      'due_date': instance.dueDate?.toIso8601String(),
      'status': instance.status,
    };
