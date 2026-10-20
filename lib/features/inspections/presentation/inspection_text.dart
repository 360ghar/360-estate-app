import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

extension InspectionTypeText on InspectionType {
  String text(AppLocalizations l10n) => switch (this) {
    InspectionType.moveIn => l10n.inspectionTypeMoveIn,
    InspectionType.moveOut => l10n.inspectionTypeMoveOut,
    InspectionType.routine => l10n.inspectionTypeRoutine,
  };

  IconData get icon => switch (this) {
    InspectionType.moveIn => Icons.login_rounded,
    InspectionType.moveOut => Icons.logout_rounded,
    InspectionType.routine => Icons.event_repeat_rounded,
  };
}

extension InspectionSignStateText on InspectionSignState {
  String text(AppLocalizations l10n) => switch (this) {
    InspectionSignState.open => l10n.inspectionStateOpen,
    InspectionSignState.signedByOwner => l10n.inspectionStateSignedByOwner,
    InspectionSignState.signedByTenant => l10n.inspectionStateSignedByTenant,
    InspectionSignState.signed => l10n.inspectionStateSigned,
  };

  /// Open waits for signatures; one signature is halfway; both is done.
  AppStatusType get statusType => switch (this) {
    InspectionSignState.open => AppStatusType.warning,
    InspectionSignState.signedByOwner ||
    InspectionSignState.signedByTenant => AppStatusType.info,
    InspectionSignState.signed => AppStatusType.success,
  };
}

/// "Move-in inspection", or "Inspection" when the type is unknown.
String inspectionTitle(AppLocalizations l10n, Inspection inspection) {
  final type = inspection.inspectionType;
  return type == null
      ? l10n.inspectionDetailTitle
      : l10n.inspectionsItemTitle(type.text(l10n));
}

/// The backend sends a free-text item status. The common values get a word
/// and a status; anything else is shown as sent.
(String, AppStatusType) inspectionItemStatus(
  AppLocalizations l10n,
  String status,
) => switch (status.toLowerCase()) {
  'pass' ||
  'passed' ||
  'good' ||
  'completed' => (l10n.inspectionItemPass, AppStatusType.success),
  'fail' ||
  'failed' ||
  'poor' => (l10n.inspectionItemFail, AppStatusType.danger),
  'fair' ||
  'needs_attention' ||
  'warning' => (l10n.inspectionItemAttention, AppStatusType.warning),
  'pending' => (l10n.inspectionItemPending, AppStatusType.neutral),
  _ => (status.replaceAll('_', ' '), AppStatusType.neutral),
};
