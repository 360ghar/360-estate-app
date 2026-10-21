import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_segmented_button.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/presentation/widgets/task_board.dart';
import 'package:estate_app/features/tasks/presentation/widgets/task_row.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Maintenance requests: a status filter, then a list or the board.
class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

enum TaskView { list, board }

enum TaskStatusFilter { all, open, inProgress, completed }

class _TasksPageState extends ConsumerState<TasksPage> {
  TaskView _view = TaskView.list;
  TaskStatusFilter _filter = TaskStatusFilter.all;

  /// The `request_status` query value, so the filter applies across every
  /// page on the server. Null fetches all statuses.
  MaintenanceRequestStatus? get _apiStatus => switch (_filter) {
    TaskStatusFilter.open => MaintenanceRequestStatus.open,
    TaskStatusFilter.inProgress => MaintenanceRequestStatus.workOrderCreated,
    TaskStatusFilter.completed => MaintenanceRequestStatus.resolved,
    TaskStatusFilter.all => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = maintenancePagedByStatusProvider(_apiStatus);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final filtered = _filter != TaskStatusFilter.all;

    final labels = {
      TaskStatusFilter.all: l10n.commonAll,
      TaskStatusFilter.open: l10n.tasksFilterOpen,
      TaskStatusFilter.inProgress: l10n.tasksFilterInProgress,
      TaskStatusFilter.completed: l10n.tasksFilterDone,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasksTitle),
        actions: [
          AppSegmentedButton<TaskView>(
            showLabels: false,
            segments: [
              AppSegment(
                value: TaskView.list,
                label: l10n.tasksViewList,
                icon: Icons.view_agenda_outlined,
              ),
              AppSegment(
                value: TaskView.board,
                label: l10n.tasksViewBoard,
                icon: Icons.view_kanban_outlined,
              ),
            ],
            selected: _view,
            onSelected: (view) {
              if (view != null) setState(() => _view = view);
            },
          ),
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tasks/create'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.tasksNew),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: TaskStatusFilter.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final filter = TaskStatusFilter.values[i];
                return Center(
                  child: FilterChip(
                    label: Text(labels[filter]!),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _view == TaskView.board && state.items.isNotEmpty
                ? TaskBoard(
                    state: state,
                    onRefresh: controller.refresh,
                    onLoadMore: controller.loadMore,
                    onLoadMoreRetry: controller.retryLoadMore,
                  )
                : PagedListView<MaintenanceRequest>(
                    state: state,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xs,
                      AppSpacing.lg,
                      96,
                    ),
                    emptyTitle: filtered
                        ? l10n.tasksEmptyFilteredTitle
                        : l10n.tasksEmptyTitle,
                    emptyMessage: filtered
                        ? l10n.tasksEmptyFilteredBody
                        : l10n.tasksEmptyBody,
                    emptyIcon: Icons.handyman_outlined,
                    emptyAction: filtered
                        ? TextButton(
                            onPressed: () =>
                                setState(() => _filter = TaskStatusFilter.all),
                            child: Text(l10n.commonClearFilters),
                          )
                        : FilledButton.icon(
                            onPressed: () => context.go('/tasks/create'),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.tasksNew),
                          ),
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    onLoadMoreRetry: controller.retryLoadMore,
                    itemBuilder: (context, task) => TaskRow(task: task),
                  ),
          ),
        ],
      ),
    );
  }
}
