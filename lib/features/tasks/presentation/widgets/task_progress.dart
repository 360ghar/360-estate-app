import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Where a request stands in the workflow: four segments, filled up to the
/// current step, with the step names under them.
class TaskProgress extends StatelessWidget {
  const TaskProgress({super.key, required this.status});

  final MaintenanceRequestStatus? status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      l10n.taskStatusOpen,
      l10n.taskStatusInReview,
      l10n.taskStatusInProgress,
      l10n.taskStatusResolved,
    ];
    final current = switch (status) {
      MaintenanceRequestStatus.open => 0,
      MaintenanceRequestStatus.inReview => 1,
      MaintenanceRequestStatus.workOrderCreated => 2,
      // A closed request went through every step.
      MaintenanceRequestStatus.resolved || MaintenanceRequestStatus.closed => 3,
      null => -1,
    };
    final colors = context.colors;
    return Semantics(
      label: current < 0
          ? null
          : l10n.taskProgressSemantics(current + 1, steps[current]),
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= current
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      borderRadius: AppRadii.xs,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    steps[i],
                    maxLines: 2,
                    style: context.text.labelSmall?.copyWith(
                      color: i == current
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      fontWeight: i == current
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
