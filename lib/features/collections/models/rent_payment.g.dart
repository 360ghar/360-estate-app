// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentPaymentImpl _$$RentPaymentImplFromJson(Map<String, dynamic> json) =>
    _$RentPaymentImpl(
      id: parseInt(json['id']),
      tenantName: json['tenant_name'] as String?,
      amount: parseDouble(json['amount']),
      paidAt: parseDateTime(json['paid_at']),
      method: json['method'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$RentPaymentImplToJson(_$RentPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_name': instance.tenantName,
      'amount': instance.amount,
      'paid_at': instance.paidAt?.toIso8601String(),
      'method': instance.method,
      'notes': instance.notes,
    };
