import 'package:flutter/material.dart';

enum ApplicationStatus {
  pending,
  underReview,
  approved,
  rejected,
  withdrawn;

  String get apiValue {
    switch (this) {
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.underReview:
        return 'under_review';
      case ApplicationStatus.approved:
        return 'approved';
      case ApplicationStatus.rejected:
        return 'rejected';
      case ApplicationStatus.withdrawn:
        return 'withdrawn';
    }
  }

  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.pending:
        return Icons.pending;
      case ApplicationStatus.underReview:
        return Icons.rate_review;
      case ApplicationStatus.approved:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.withdrawn:
        return Icons.undo;
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.underReview:
        return Colors.blue;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }

  static ApplicationStatus fromApiValue(String value) {
    switch (value) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'under_review':
        return ApplicationStatus.underReview;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'withdrawn':
        return ApplicationStatus.withdrawn;
      default:
        return ApplicationStatus.pending;
    }
  }
}

final class ApplicationForm {
  const ApplicationForm({
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

  final int id;
  final int propertyId;
  final String slug;
  final bool isActive;
  final String? propertyTitle;
  final String? propertyAddress;
  final List<ApplicationFormField> customFields;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  String get publicUrl => '/public/application/$slug';
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
}

final class ApplicationFormField {
  const ApplicationFormField({
    required this.id,
    required this.label,
    required this.fieldType,
    this.isRequired = false,
    this.options = const [],
  });

  final int id;
  final String label;
  final String fieldType; // text, email, phone, number, date, select, checkbox
  final bool isRequired;
  final List<String> options;
}

final class Application {
  const Application({
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

  final int id;
  final int formId;
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;
  final ApplicationStatus status;
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
  final List<ApplicationReference> references;
  final Map<String, dynamic> customFieldResponses;
  final List<String> documents;
  final String? notes;
  final String? decisionNotes;
  final DateTime? decidedAt;
  final String? decidedBy;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isPending => status == ApplicationStatus.pending;
  bool get isUnderReview => status == ApplicationStatus.underReview;
  bool get isApproved => status == ApplicationStatus.approved;
  bool get isRejected => status == ApplicationStatus.rejected;
  bool get isWithdrawn => status == ApplicationStatus.withdrawn;

  bool get canReview => isPending;
  bool get canDecide => isUnderReview;
  bool get isDecided => isApproved || isRejected;
}

final class ApplicationReference {
  const ApplicationReference({
    required this.name,
    required this.relationship,
    required this.phone,
    this.email,
  });

  final String name;
  final String relationship;
  final String phone;
  final String? email;
}
