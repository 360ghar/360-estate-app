// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_charge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentChargeImpl _$$RentChargeImplFromJson(Map<String, dynamic> json) =>
    _$RentChargeImpl(
      id: parseInt(json['id']),
      leaseId: parseInt(json['lease_id']),
      propertyId: parseInt(json['property_id']),
      ownerId: parseInt(json['owner_id']),
      tenantUserId: parseInt(json['tenant_user_id']),
      billingMonth: parseDateTime(json['billing_month']),
      periodStart: parseDateTime(json['period_start']),
      periodEnd: parseDateTime(json['period_end']),
      dueDate: parseDateTime(json['due_date']),
      amountDue: parseDouble(json['amount_due']),
      lateFeeAssessed: parseDouble(json['late_fee_assessed']),
      status: RentChargeStatus.fromJson(json['status']),
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$RentChargeImplToJson(_$RentChargeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lease_id': instance.leaseId,
      'property_id': instance.propertyId,
      'owner_id': instance.ownerId,
      'tenant_user_id': instance.tenantUserId,
      'billing_month': instance.billingMonth?.toIso8601String(),
      'period_start': instance.periodStart?.toIso8601String(),
      'period_end': instance.periodEnd?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'amount_due': instance.amountDue,
      'late_fee_assessed': instance.lateFeeAssessed,
      'status': RentChargeStatus.toJsonValue(instance.status),
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$RentChargeWithTotalsImpl _$$RentChargeWithTotalsImplFromJson(
  Map<String, dynamic> json,
) => _$RentChargeWithTotalsImpl(
  charge: RentCharge.fromJson(json['charge'] as Map<String, dynamic>),
  amountPaidTotal: parseDouble(json['amount_paid_total']),
  amountDueTotal: parseDouble(json['amount_due_total']),
  outstanding: parseDouble(json['outstanding']),
);

Map<String, dynamic> _$$RentChargeWithTotalsImplToJson(
  _$RentChargeWithTotalsImpl instance,
) => <String, dynamic>{
  'charge': instance.charge,
  'amount_paid_total': instance.amountPaidTotal,
  'amount_due_total': instance.amountDueTotal,
  'outstanding': instance.outstanding,
};
