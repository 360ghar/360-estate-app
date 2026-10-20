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
  status: RentalApplicationStatus.fromJson(json['status']),
  applicantFullName: json['applicant_full_name'] as String?,
  applicantEmail: json['applicant_email'] as String?,
  applicantPhone: json['applicant_phone'] as String?,
  answers: json['answers'] as Map<String, dynamic>?,
  applicationData: json['application_data'] as Map<String, dynamic>?,
  submittedAt: parseDateTime(json['submitted_at']),
  decisionAt: parseDateTime(json['decision_at']),
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
  'status': RentalApplicationStatus.toJsonValue(instance.status),
  'applicant_full_name': instance.applicantFullName,
  'applicant_email': instance.applicantEmail,
  'applicant_phone': instance.applicantPhone,
  'answers': instance.answers,
  'application_data': instance.applicationData,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'decision_at': instance.decisionAt?.toIso8601String(),
  'decision_notes': instance.decisionNotes,
};

_$ApplicationSubmittedImpl _$$ApplicationSubmittedImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationSubmittedImpl(
  id: parseInt(json['id']),
  status: RentalApplicationStatus.fromJson(json['status']),
  submittedAt: parseDateTime(json['submitted_at']),
);

Map<String, dynamic> _$$ApplicationSubmittedImplToJson(
  _$ApplicationSubmittedImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': RentalApplicationStatus.toJsonValue(instance.status),
  'submitted_at': instance.submittedAt?.toIso8601String(),
};
