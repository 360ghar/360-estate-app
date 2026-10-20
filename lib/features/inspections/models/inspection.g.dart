// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionItemImpl _$$InspectionItemImplFromJson(Map<String, dynamic> json) =>
    _$InspectionItemImpl(
      title: json['title'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      isRequired: json['is_required'] as bool?,
    );

Map<String, dynamic> _$$InspectionItemImplToJson(
  _$InspectionItemImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'status': instance.status,
  'notes': instance.notes,
  'is_required': instance.isRequired,
};

_$InspectionImpl _$$InspectionImplFromJson(Map<String, dynamic> json) =>
    _$InspectionImpl(
      id: parseInt(json['id']),
      propertyId: parseInt(json['property_id']),
      leaseId: parseInt(json['lease_id']),
      ownerId: parseInt(json['owner_id']),
      inspectionType: InspectionType.fromJson(json['inspection_type']),
      conductedAt: parseDateTime(json['conducted_at']),
      roomsData: json['rooms_data'] as Map<String, dynamic>?,
      overallNotes: json['overall_notes'] as String?,
      signedByTenantAt: parseDateTime(json['signed_by_tenant_at']),
      signedByOwnerAt: parseDateTime(json['signed_by_owner_at']),
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$InspectionImplToJson(_$InspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'lease_id': instance.leaseId,
      'owner_id': instance.ownerId,
      'inspection_type': InspectionType.toJsonValue(instance.inspectionType),
      'conducted_at': instance.conductedAt?.toIso8601String(),
      'rooms_data': instance.roomsData,
      'overall_notes': instance.overallNotes,
      'signed_by_tenant_at': instance.signedByTenantAt?.toIso8601String(),
      'signed_by_owner_at': instance.signedByOwnerAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
