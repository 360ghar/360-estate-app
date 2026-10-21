// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentItemImpl _$$DocumentItemImplFromJson(Map<String, dynamic> json) =>
    _$DocumentItemImpl(
      id: parseInt(json['id']),
      ownerId: parseInt(json['owner_id']),
      propertyId: parseInt(json['property_id']),
      leaseId: parseInt(json['lease_id']),
      documentType: DocumentType.fromJson(json['document_type']),
      title: json['title'] as String?,
      fileUrl: json['file_url'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: parseInt(json['file_size']),
      sharedWithTenant: json['shared_with_tenant'] as bool?,
      sharedWithAgent: json['shared_with_agent'] as bool?,
      createdAt: parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$$DocumentItemImplToJson(_$DocumentItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'property_id': instance.propertyId,
      'lease_id': instance.leaseId,
      'document_type': DocumentType.toJsonValue(instance.documentType),
      'title': instance.title,
      'file_url': instance.fileUrl,
      'mime_type': instance.mimeType,
      'file_size': instance.fileSize,
      'shared_with_tenant': instance.sharedWithTenant,
      'shared_with_agent': instance.sharedWithAgent,
      'created_at': instance.createdAt?.toIso8601String(),
    };
