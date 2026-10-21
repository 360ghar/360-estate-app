// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationFormFieldImpl _$$ApplicationFormFieldImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationFormFieldImpl(
  id: json['id'] as String?,
  label: json['label'] as String?,
  fieldType: ApplicationFieldType.fromJson(json['field_type']),
  isRequired: json['is_required'] as bool?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$ApplicationFormFieldImplToJson(
  _$ApplicationFormFieldImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'field_type': ApplicationFieldType.toJsonValue(instance.fieldType),
  'is_required': instance.isRequired,
  'options': instance.options,
};

_$ApplicationFormImpl _$$ApplicationFormImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationFormImpl(
  id: parseInt(json['id']),
  propertyId: parseInt(json['property_id']),
  propertyName: json['property_name'] as String?,
  propertyAddress: json['property_address'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  slug: json['slug'] as String?,
  isActive: json['is_active'] as bool?,
  applicationFeeAmount: parseDouble(json['application_fee_amount']),
  fields: (json['custom_fields'] as List<dynamic>?)
      ?.map((e) => ApplicationFormField.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: parseDateTime(json['created_at']),
  expiresAt: parseDateTime(json['expires_at']),
);

Map<String, dynamic> _$$ApplicationFormImplToJson(
  _$ApplicationFormImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'property_id': instance.propertyId,
  'property_name': instance.propertyName,
  'property_address': instance.propertyAddress,
  'title': instance.title,
  'description': instance.description,
  'slug': instance.slug,
  'is_active': instance.isActive,
  'application_fee_amount': instance.applicationFeeAmount,
  'custom_fields': instance.fields,
  'created_at': instance.createdAt?.toIso8601String(),
  'expires_at': instance.expiresAt?.toIso8601String(),
};
