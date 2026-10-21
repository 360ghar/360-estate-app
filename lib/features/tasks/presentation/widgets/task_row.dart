import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/presentation/task_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One maintenance request: what, where, how urgent, and where it stands.
class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = task.category;
    final urgency = task.urgency;
    final status = task.status;
    final created = task.createdAt;
    final visit = task.scheduledFor;
    return AppListCard(
      leading: category == null
          ? null
          : ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  category.icon,
                  size: 22,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
      title: task.title,
      subtitle: task.propertyName(l10n),
      trailing: urgency == null ? null : TaskUrgencyLabel(urgency: urgency),
      facts: [
        if (category != null) category.text(l10n),
        if (visit != null)
          l10n.tasksVisitOn(shortDate(context, visit))
        else if (created != null)
          l10n.tasksReportedOn(shortDate(context, created)),
      ],
      status: status == null
          ? null
          : AppStatusBadge(label: status.text(l10n), type: status.statusType),
      onTap: () => context.go('/tasks/${task.id}', extra: task),
    );
  }
}
