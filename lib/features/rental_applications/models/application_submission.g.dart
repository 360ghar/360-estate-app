// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationSubmissionImpl _$$ApplicationSubmissionImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationSubmissionImpl(
  id: parseInt(json['id']),
  formId: parseInt(json['form_id']),
  propertyId: parseInt(json['property_id']),
  propertyName: json['property_name'] as String?,
  propertyAddress: json['property_address'] as String?,
  applicantName: json['applicant_name'] as String?,
  applicantEmail: json['applicant_email'] as String?,
  applicantPhone: json['applicant_phone'] as String?,
  status: json['status'] as String?,
  submittedAt: parseDateTime(json['submitted_at']),
  customFieldResponses: json['custom_field_responses'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
  decisionNotes: json['decision_notes'] as String?,
);

Map<String, dynamic> _$$ApplicationSubmissionImplToJson(
  _$ApplicationSubmissionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'form_id': instance.formId,
  'property_id': instance.propertyId,
  'property_name': instance.propertyName,
  'property_address': instance.propertyAddress,
  'applicant_name': instance.applicantName,
  'applicant_email': instance.applicantEmail,
  'applicant_phone': instance.applicantPhone,
  'status': instance.status,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'custom_field_responses': instance.customFieldResponses,
  'notes': instance.notes,
  'decision_notes': instance.decisionNotes,
};
