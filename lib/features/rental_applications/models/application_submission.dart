import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_submission.freezed.dart';
part 'application_submission.g.dart';

/// A submitted application in the owner's inbox (`RentalApplication`).
/// `answers` is keyed by the form field id. The applicant's free note is
/// `application_data.notes`. The owner's decision note is `decision_notes`.
@freezed
class ApplicationSubmission with _$ApplicationSubmission {
  const factory ApplicationSubmission({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'form_id', fromJson: parseInt) int? formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'applicant_full_name') String? applicantFullName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    Map<String, dynamic>? answers,
    @JsonKey(name: 'application_data') Map<String, dynamic>? applicationData,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'decision_at', fromJson: parseDateTime) DateTime? decisionAt,
    @JsonKey(name: 'decision_notes') String? decisionNotes,
  }) = _ApplicationSubmission;

  factory ApplicationSubmission.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSubmissionFromJson(json);
}

extension ApplicationSubmissionX on ApplicationSubmission {
  /// The applicant's own note (`application_data.notes`), or null.
  String? get notes {
    final value = applicationData?['notes'];
    if (value is String && value.trim().isNotEmpty) return value;
    return null;
  }
}

extension RentalApplicationStatusLabel on RentalApplicationStatus {
  String get label => switch (this) {
    RentalApplicationStatus.applicant => 'Applicant',
    RentalApplicationStatus.approved => 'Approved',
    RentalApplicationStatus.rejected => 'Rejected',
  };
}

/// The result of the public submit route (`PublicRentalApplicationSubmitted`).
@freezed
class ApplicationSubmitted with _$ApplicationSubmitted {
  const factory ApplicationSubmitted({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
  }) = _ApplicationSubmitted;

  factory ApplicationSubmitted.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSubmittedFromJson(json);
}
