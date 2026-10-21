// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaseImpl _$$LeaseImplFromJson(Map<String, dynamic> json) => _$LeaseImpl(
  id: parseInt(json['id']),
  propertyId: parseInt(json['property_id']),
  ownerId: parseInt(json['owner_id']),
  tenantUserId: parseInt(json['tenant_user_id']),
  tenantName: json['tenant_name'] as String?,
  tenantPhone: json['tenant_phone'] as String?,
  tenantEmail: json['tenant_email'] as String?,
  status: LeaseStatus.fromJson(json['status']),
  startDate: parseDateTime(json['start_date']),
  endDate: parseDateTime(json['end_date']),
  monthlyRent: parseDouble(json['monthly_rent']),
  securityDeposit: parseDouble(json['security_deposit']),
  lateFeeAmount: parseDouble(json['late_fee_amount']),
  lateFeePercentage: parseDouble(json['late_fee_percentage']),
  gracePeriodDays: parseInt(json['grace_period_days']),
  paymentDueDay: parseInt(json['payment_due_day']),
  specialClauses: json['special_clauses'] as String?,
  signedByTenantAt: parseDateTime(json['signed_by_tenant_at']),
  signedByOwnerAt: parseDateTime(json['signed_by_owner_at']),
  terminationDate: parseDateTime(json['termination_date']),
  terminationReason: json['termination_reason'] as String?,
  leaseDocumentId: parseInt(json['lease_document_id']),
  createdAt: parseDateTime(json['created_at']),
  updatedAt: parseDateTime(json['updated_at']),
);

Map<String, dynamic> _$$LeaseImplToJson(_$LeaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'owner_id': instance.ownerId,
      'tenant_user_id': instance.tenantUserId,
      'tenant_name': instance.tenantName,
      'tenant_phone': instance.tenantPhone,
      'tenant_email': instance.tenantEmail,
      'status': LeaseStatus.toJsonValue(instance.status),
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'monthly_rent': instance.monthlyRent,
      'security_deposit': instance.securityDeposit,
      'late_fee_amount': instance.lateFeeAmount,
      'late_fee_percentage': instance.lateFeePercentage,
      'grace_period_days': instance.gracePeriodDays,
      'payment_due_day': instance.paymentDueDay,
      'special_clauses': instance.specialClauses,
      'signed_by_tenant_at': instance.signedByTenantAt?.toIso8601String(),
      'signed_by_owner_at': instance.signedByOwnerAt?.toIso8601String(),
      'termination_date': instance.terminationDate?.toIso8601String(),
      'termination_reason': instance.terminationReason,
      'lease_document_id': instance.leaseDocumentId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
