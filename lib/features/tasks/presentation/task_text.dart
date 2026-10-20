import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

extension TaskStatusText on MaintenanceRequestStatus {
  String text(AppLocalizations l10n) => switch (this) {
    MaintenanceRequestStatus.open => l10n.taskStatusOpen,
    MaintenanceRequestStatus.inReview => l10n.taskStatusInReview,
    MaintenanceRequestStatus.workOrderCreated => l10n.taskStatusInProgress,
    MaintenanceRequestStatus.resolved => l10n.taskStatusResolved,
    MaintenanceRequestStatus.closed => l10n.taskStatusClosed,
  };

  AppStatusType get statusType => switch (this) {
    MaintenanceRequestStatus.open => AppStatusType.info,
    MaintenanceRequestStatus.inReview ||
    MaintenanceRequestStatus.workOrderCreated => AppStatusType.warning,
    MaintenanceRequestStatus.resolved => AppStatusType.success,
    MaintenanceRequestStatus.closed => AppStatusType.neutral,
  };
}

extension TaskUrgencyText on MaintenanceUrgency {
  String text(AppLocalizations l10n) => switch (this) {
    MaintenanceUrgency.low => l10n.taskUrgencyLow,
    MaintenanceUrgency.medium => l10n.taskUrgencyMedium,
    MaintenanceUrgency.high => l10n.taskUrgencyHigh,
    MaintenanceUrgency.emergency => l10n.taskUrgencyEmergency,
  };

  /// The arrow tells the level without colour.
  IconData get glyph => switch (this) {
    MaintenanceUrgency.low => Icons.south_rounded,
    MaintenanceUrgency.medium => Icons.drag_handle_rounded,
    MaintenanceUrgency.high => Icons.north_rounded,
    MaintenanceUrgency.emergency => Icons.keyboard_double_arrow_up_rounded,
  };

  Color tone(BuildContext context) => switch (this) {
    MaintenanceUrgency.low => context.colors.onSurfaceVariant,
    MaintenanceUrgency.medium => context.palette.warning,
    MaintenanceUrgency.high ||
    MaintenanceUrgency.emergency => context.colors.error,
  };
}

extension TaskCategoryText on MaintenanceCategory {
  String text(AppLocalizations l10n) => switch (this) {
    MaintenanceCategory.plumbing => l10n.taskCategoryPlumbing,
    MaintenanceCategory.electrical => l10n.taskCategoryElectrical,
    MaintenanceCategory.hvac => l10n.taskCategoryHvac,
    MaintenanceCategory.appliance => l10n.taskCategoryAppliance,
    MaintenanceCategory.structural => l10n.taskCategoryStructural,
    MaintenanceCategory.pestControl => l10n.taskCategoryPestControl,
    MaintenanceCategory.cleaning => l10n.taskCategoryCleaning,
    MaintenanceCategory.other => l10n.taskCategoryOther,
  };
}

extension TaskPropertyText on MaintenanceRequest {
  String propertyName(AppLocalizations l10n) {
    final name = propertyTitle?.trim();
    if (name != null && name.isNotEmpty) return name;
    return l10n.commonPropertyNumber('$propertyId');
  }
}

/// The urgency in words, with an arrow and a colour: never a pill.
class TaskUrgencyLabel extends StatelessWidget {
  const TaskUrgencyLabel({super.key, required this.urgency});

  final MaintenanceUrgency urgency;

  @override
  Widget build(BuildContext context) {
    final color = urgency.tone(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Icon(urgency.glyph, size: 16, color: color)),
        const SizedBox(width: 4),
        Text(
          urgency.text(context.l10n),
          style: context.text.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
