// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentPaymentImpl _$$RentPaymentImplFromJson(Map<String, dynamic> json) =>
    _$RentPaymentImpl(
      id: parseInt(json['id']),
      chargeId: parseInt(json['charge_id']),
      leaseId: parseInt(json['lease_id']),
      propertyId: parseInt(json['property_id']),
      tenantUserId: parseInt(json['tenant_user_id']),
      paidAt: parseDateTime(json['paid_at']),
      amountPaid: parseDouble(json['amount_paid']),
      paymentMethod: PaymentMethod.fromJson(json['payment_method']),
      status: RentPaymentStatus.fromJson(json['status']),
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$RentPaymentImplToJson(_$RentPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'charge_id': instance.chargeId,
      'lease_id': instance.leaseId,
      'property_id': instance.propertyId,
      'tenant_user_id': instance.tenantUserId,
      'paid_at': instance.paidAt?.toIso8601String(),
      'amount_paid': instance.amountPaid,
      'payment_method': PaymentMethod.toJsonValue(instance.paymentMethod),
      'status': RentPaymentStatus.toJsonValue(instance.status),
      'reference': instance.reference,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$RentChargeGenerateResultImpl _$$RentChargeGenerateResultImplFromJson(
  Map<String, dynamic> json,
) => _$RentChargeGenerateResultImpl(
  created: parseInt(json['created']),
  skipped: parseInt(json['skipped']),
);

Map<String, dynamic> _$$RentChargeGenerateResultImplToJson(
  _$RentChargeGenerateResultImpl instance,
) => <String, dynamic>{
  'created': instance.created,
  'skipped': instance.skipped,
};
