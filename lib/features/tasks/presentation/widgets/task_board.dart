import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/presentation/task_text.dart';
import 'package:estate_app/features/tasks/presentation/widgets/task_row.dart';
import 'package:flutter/material.dart';

/// The board at phone width: open, in progress and done as stacked sections,
/// so nothing scrolls sideways. Only called with at least one loaded task.
class TaskBoard extends StatelessWidget {
  const TaskBoard({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onLoadMoreRetry,
  });

  final PagedListState<MaintenanceRequest> state;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final VoidCallback onLoadMoreRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tasks = state.items;
    final sections = [
      (
        l10n.tasksFilterOpen,
        MaintenanceRequestStatus.open.statusType,
        tasks.where((t) => t.isOpen).toList(),
      ),
      (
        l10n.tasksFilterInProgress,
        MaintenanceRequestStatus.workOrderCreated.statusType,
        tasks.where((t) => t.isInProgress).toList(),
      ),
      (
        l10n.tasksFilterDone,
        MaintenanceRequestStatus.resolved.statusType,
        tasks.where((t) => t.isFinished).toList(),
      ),
    ];
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          96,
        ),
        children: [
          for (final (title, type, items) in sections) ...[
            _SectionHeader(title: title, type: type, count: items.length),
            for (final task in items) ...[
              TaskRow(task: task),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
          if (state.loadMoreError != null)
            Center(
              child: TextButton.icon(
                onPressed: onLoadMoreRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.commonLoadMoreFailed),
              ),
            )
          else if (state.isLoadingMore)
            const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
          else if (state.hasMore)
            Center(
              child: TextButton(
                onPressed: onLoadMore,
                child: Text(l10n.tasksLoadMore),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.type,
    required this.count,
  });

  final String title;
  final AppStatusType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final (ink, _) = statusColors(context, type);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Semantics(
        header: true,
        child: Row(
          children: [
            ExcludeSemantics(
              child: CustomPaint(
                size: const Size.square(10),
                painter: StatusMarkPainter(type, ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(title, style: context.text.titleLarge),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '$count',
              style: context.text.titleLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
