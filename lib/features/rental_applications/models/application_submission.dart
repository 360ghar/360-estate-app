import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_submission.freezed.dart';
part 'application_submission.g.dart';

@freezed
class ApplicationSubmission with _$ApplicationSubmission {
  const factory ApplicationSubmission({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'form_id', fromJson: parseInt) int? formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    @JsonKey(name: 'applicant_name') String? applicantName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    String? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'custom_field_responses')
    Map<String, dynamic>? customFieldResponses,
    String? notes,
    @JsonKey(name: 'decision_notes') String? decisionNotes,
  }) = _ApplicationSubmission;

  factory ApplicationSubmission.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSubmissionFromJson(json);
}
