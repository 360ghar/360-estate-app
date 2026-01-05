import 'package:estate_app/features/applications/domain/entities/application.dart';

final class ApplicationFormFieldDto {
  const ApplicationFormFieldDto({
    required this.id,
    required this.label,
    required this.fieldType,
    this.isRequired = false,
    this.options = const [],
  });

  factory ApplicationFormFieldDto.fromJson(Map<String, dynamic> json) {
    return ApplicationFormFieldDto(
      id: json['id'] as int,
      label: json['label'] as String? ?? '',
      fieldType: json['field_type'] as String? ?? 'text',
      isRequired: json['is_required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  final int id;
  final String label;
  final String fieldType;
  final bool isRequired;
  final List<String> options;

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'field_type': fieldType,
      'is_required': isRequired,
      if (options.isNotEmpty) 'options': options,
    };
  }

  ApplicationFormField toEntity() {
    return ApplicationFormField(
      id: id,
      label: label,
      fieldType: fieldType,
      isRequired: isRequired,
      options: options,
    );
  }
}

final class ApplicationFormDto {
  const ApplicationFormDto({
    required this.id,
    required this.propertyId,
    required this.slug,
    required this.isActive,
    this.propertyTitle,
    this.propertyAddress,
    this.customFields = const [],
    this.createdAt,
    this.expiresAt,
  });

  factory ApplicationFormDto.fromJson(Map<String, dynamic> json) {
    return ApplicationFormDto(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      slug: json['slug'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      propertyTitle: json['property_title'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['title'] as String?,
      propertyAddress: json['property_address'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['address'] as String?,
      customFields: (json['custom_fields'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ApplicationFormFieldDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  final int id;
  final int propertyId;
  final String slug;
  final bool isActive;
  final String? propertyTitle;
  final String? propertyAddress;
  final List<ApplicationFormFieldDto> customFields;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'is_active': isActive,
      if (customFields.isNotEmpty)
        'custom_fields': customFields.map((f) => f.toJson()).toList(),
      if (expiresAt != null)
        'expires_at': expiresAt!.toIso8601String().split('T')[0],
    };
  }

  ApplicationForm toEntity() {
    return ApplicationForm(
      id: id,
      propertyId: propertyId,
      slug: slug,
      isActive: isActive,
      propertyTitle: propertyTitle,
      propertyAddress: propertyAddress,
      customFields: customFields.map((f) => f.toEntity()).toList(),
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }
}

final class ApplicationReferenceDto {
  const ApplicationReferenceDto({
    required this.name,
    required this.relationship,
    required this.phone,
    this.email,
  });

  factory ApplicationReferenceDto.fromJson(Map<String, dynamic> json) {
    return ApplicationReferenceDto(
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  final String name;
  final String relationship;
  final String phone;
  final String? email;

  ApplicationReference toEntity() {
    return ApplicationReference(
      name: name,
      relationship: relationship,
      phone: phone,
      email: email,
    );
  }
}

final class ApplicationDto {
  const ApplicationDto({
    required this.id,
    required this.formId,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.status,
    this.propertyId,
    this.propertyTitle,
    this.propertyAddress,
    this.desiredMoveInDate,
    this.monthlyIncome,
    this.employmentStatus,
    this.employerName,
    this.currentAddress,
    this.reasonForMoving,
    this.numberOfOccupants,
    this.hasPets = false,
    this.petDetails,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.references = const [],
    this.customFieldResponses = const {},
    this.documents = const [],
    this.notes,
    this.decisionNotes,
    this.decidedAt,
    this.decidedBy,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ApplicationDto.fromJson(Map<String, dynamic> json) {
    return ApplicationDto(
      id: json['id'] as int,
      formId: json['form_id'] as int? ?? json['application_form_id'] as int,
      applicantName: json['applicant_name'] as String? ?? '',
      applicantEmail: json['applicant_email'] as String? ?? '',
      applicantPhone: json['applicant_phone'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      propertyId: json['property_id'] as int?,
      propertyTitle: json['property_title'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['title'] as String?,
      propertyAddress: json['property_address'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['address'] as String?,
      desiredMoveInDate: json['desired_move_in_date'] != null
          ? DateTime.parse(json['desired_move_in_date'] as String)
          : null,
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble(),
      employmentStatus: json['employment_status'] as String?,
      employerName: json['employer_name'] as String?,
      currentAddress: json['current_address'] as String?,
      reasonForMoving: json['reason_for_moving'] as String?,
      numberOfOccupants: json['number_of_occupants'] as int?,
      hasPets: json['has_pets'] as bool? ?? false,
      petDetails: json['pet_details'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      references: (json['references'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ApplicationReferenceDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      customFieldResponses:
          (json['custom_field_responses'] as Map<String, dynamic>?) ?? {},
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notes: json['notes'] as String?,
      decisionNotes: json['decision_notes'] as String?,
      decidedAt: json['decided_at'] != null
          ? DateTime.parse(json['decided_at'] as String)
          : null,
      decidedBy: json['decided_by'] as String?,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  final int id;
  final int formId;
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;
  final String status;
  final int? propertyId;
  final String? propertyTitle;
  final String? propertyAddress;
  final DateTime? desiredMoveInDate;
  final double? monthlyIncome;
  final String? employmentStatus;
  final String? employerName;
  final String? currentAddress;
  final String? reasonForMoving;
  final int? numberOfOccupants;
  final bool hasPets;
  final String? petDetails;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final List<ApplicationReferenceDto> references;
  final Map<String, dynamic> customFieldResponses;
  final List<String> documents;
  final String? notes;
  final String? decisionNotes;
  final DateTime? decidedAt;
  final String? decidedBy;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Application toEntity() {
    return Application(
      id: id,
      formId: formId,
      applicantName: applicantName,
      applicantEmail: applicantEmail,
      applicantPhone: applicantPhone,
      status: ApplicationStatus.fromApiValue(status),
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyAddress: propertyAddress,
      desiredMoveInDate: desiredMoveInDate,
      monthlyIncome: monthlyIncome,
      employmentStatus: employmentStatus,
      employerName: employerName,
      currentAddress: currentAddress,
      reasonForMoving: reasonForMoving,
      numberOfOccupants: numberOfOccupants,
      hasPets: hasPets,
      petDetails: petDetails,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      references: references.map((r) => r.toEntity()).toList(),
      customFieldResponses: customFieldResponses,
      documents: documents,
      notes: notes,
      decisionNotes: decisionNotes,
      decidedAt: decidedAt,
      decidedBy: decidedBy,
      submittedAt: submittedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
