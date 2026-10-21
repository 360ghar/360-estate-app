import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

/// Words and icons for the form question types. The wire values are
/// `ApplicationFieldType`: text, textarea, number, date, boolean, select.
extension ApplicationFieldTypeUi on ApplicationFieldType {
  String text(AppLocalizations l10n) => switch (this) {
    ApplicationFieldType.text => l10n.applicationFieldText,
    ApplicationFieldType.textarea => l10n.applicationFieldTextarea,
    ApplicationFieldType.number => l10n.applicationFieldNumber,
    ApplicationFieldType.date => l10n.applicationFieldDate,
    ApplicationFieldType.boolean => l10n.applicationFieldBoolean,
    ApplicationFieldType.select => l10n.applicationFieldSelect,
  };

  IconData get icon => switch (this) {
    ApplicationFieldType.text => Icons.short_text_rounded,
    ApplicationFieldType.textarea => Icons.notes_rounded,
    ApplicationFieldType.number => Icons.pin_outlined,
    ApplicationFieldType.date => Icons.calendar_today_outlined,
    ApplicationFieldType.boolean => Icons.rule_rounded,
    ApplicationFieldType.select => Icons.list_rounded,
  };
}

extension RentalApplicationStatusUi on RentalApplicationStatus {
  String text(AppLocalizations l10n) => switch (this) {
    RentalApplicationStatus.applicant => l10n.applicationsStatusApplicant,
    RentalApplicationStatus.approved => l10n.applicationsStatusApproved,
    RentalApplicationStatus.rejected => l10n.applicationsStatusRejected,
  };

  /// A new applicant waits on the owner; that is the state to act on.
  AppStatusType get statusType => switch (this) {
    RentalApplicationStatus.applicant => AppStatusType.warning,
    RentalApplicationStatus.approved => AppStatusType.success,
    RentalApplicationStatus.rejected => AppStatusType.danger,
  };
}

/// An answer as text: a yes/no question reads Yes or No, a list is joined, and
/// an empty answer is a dash.
String applicationAnswerText(AppLocalizations l10n, Object? value) {
  if (value == null) return '-';
  if (value is bool) {
    return value ? l10n.applicationDetailYes : l10n.applicationDetailNo;
  }
  if (value is List) {
    return value.isEmpty
        ? '-'
        : value.map((v) => applicationAnswerText(l10n, v)).join(', ');
  }
  final text = value.toString().trim();
  return text.isEmpty ? '-' : text;
}
