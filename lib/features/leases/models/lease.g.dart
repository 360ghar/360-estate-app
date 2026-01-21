// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaseImpl _$$LeaseImplFromJson(Map<String, dynamic> json) => _$LeaseImpl(
  id: parseInt(json['id']),
  propertyId: parseInt(json['property_id']),
  propertyName: json['property_name'] as String?,
  tenantId: parseInt(json['tenant_id']),
  tenantName: json['tenant_name'] as String?,
  startDate: parseDateTime(json['start_date']),
  endDate: parseDateTime(json['end_date']),
  rentAmount: parseDouble(json['rent_amount']),
  depositAmount: parseDouble(json['deposit_amount']),
  status: json['status'] as String?,
  signedDocumentUrl: json['signed_document_url'] as String?,
  createdAt: parseDateTime(json['created_at']),
  updatedAt: parseDateTime(json['updated_at']),
);

Map<String, dynamic> _$$LeaseImplToJson(_$LeaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'tenant_id': instance.tenantId,
      'tenant_name': instance.tenantName,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'rent_amount': instance.rentAmount,
      'deposit_amount': instance.depositAmount,
      'status': instance.status,
      'signed_document_url': instance.signedDocumentUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
