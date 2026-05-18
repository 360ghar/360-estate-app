import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_segmented_button.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

extension MaintenanceRequestX on MaintenanceRequest {
  String get statusValue => status.apiValue;

  String get priorityValue => priority.name;
}

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  TaskView _viewMode = TaskView.list;
  TaskStatusFilter _statusFilter = TaskStatusFilter.all;

  void _setViewMode(TaskView mode) {
    setState(() {
      _viewMode = mode;
    });
  }

  void _setStatusFilter(TaskStatusFilter filter) {
    setState(() {
      _statusFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maintenancePagedProvider);
    final controller = ref.read(maintenancePagedProvider.notifier);

    final filteredItems = _filterItems(state.items);

    return AppScaffold(
      appBar: _buildAppBar(context),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tasks/create'),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('New Task'),
      ),
      body: Column(
        children: [
          _FilterChipsBar(
            selectedFilter: _statusFilter,
            onFilterChanged: _setStatusFilter,
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          Expanded(
            child: _viewMode == TaskView.pipeline
                ? _TaskPipelineView(tasks: filteredItems)
                : PagedListView<MaintenanceRequest>(
                    state: state,
                    emptyTitle: 'No tasks yet',
                    emptyMessage: 'Maintenance requests will appear here.',
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    itemBuilder: (context, task) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      child: _TaskListCard(task: task),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Tasks'),
      actions: [
        Flexible(
          child: AppSegmentedButton<TaskView>(
            segments: const [
              AppSegment(
                value: TaskView.list,
                label: 'List',
                icon: Icons.view_list,
              ),
              AppSegment(
                value: TaskView.pipeline,
                label: 'Board',
                icon: Icons.view_kanban,
              ),
            ],
            selected: _viewMode,
            onSelected: (mode) {
              if (mode != null) _setViewMode(mode);
            },
            style: AppSegmentedStyle.rect,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  List<MaintenanceRequest> _filterItems(List<MaintenanceRequest> items) {
    if (_statusFilter == TaskStatusFilter.all) return items;

    final allowedStatuses = switch (_statusFilter) {
      TaskStatusFilter.open => const {'open', 'in_review'},
      TaskStatusFilter.inProgress => const {'work_order_created'},
      TaskStatusFilter.completed => const {'resolved', 'closed'},
      TaskStatusFilter.all => const <String>{},
    };

    if (allowedStatuses.isEmpty) return items;
    return items
        .where((item) => allowedStatuses.contains(item.statusValue))
        .toList();
  }
}

class _FilterChipsBar extends StatelessWidget {
  final TaskStatusFilter selectedFilter;
  final ValueChanged<TaskStatusFilter> onFilterChanged;

  const _FilterChipsBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TaskStatusFilter.values.map((filter) {
            final isSelected = filter == selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Material(
                color: isSelected
                    ? primaryColor.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => onFilterChanged(filter),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor.withOpacity(0.4)
                            : theme.colorScheme.outlineVariant.withOpacity(0.6),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          filter.label,
                          style: AppTextStyles.chipLabel.copyWith(
                            color: isSelected
                                ? primaryColor
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TaskListCard extends StatelessWidget {
  const _TaskListCard({required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = task.createdAt == null
        ? 'New'
        : DateFormat('dd MMM yyyy').format(task.createdAt!);
    final priority = _getPriority(task.priority);
    final priorityBadge = _PriorityBadge(priority: priority);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: _getPriorityBorderColor(context, priority),
          width: priority == TaskPriority.high ? 1.5 : 0.75,
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.lg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/tasks/${task.id}', extra: task),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 40,
                      margin: const EdgeInsets.only(right: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority).withOpacity(0.6),
                        borderRadius: AppRadii.pill,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              priorityBadge,
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.apartment_outlined,
                                size: 14,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  task.propertyTitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md + 3),
                    child: Text(
                      task.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md + 3),
                  child: Row(
                    children: [
                      Flexible(child: _buildStatusBadge(context)),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            date,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = task.status.apiValue;
    final statusType = switch (status) {
      'completed' || 'resolved' || 'closed' => AppStatusType.success,
      'in_progress' ||
      'work_order_created' ||
      'assigned' => AppStatusType.warning,
      'open' || 'in_review' || 'pending' => AppStatusType.info,
      _ => AppStatusType.neutral,
    };

    return AppStatusBadge(
      label: task.status.displayName.toUpperCase(),
      type: statusType,
      variant: AppStatusVariant.subtle,
    );
  }
}

class _TaskPipelineView extends StatelessWidget {
  final List<MaintenanceRequest> tasks;

  const _TaskPipelineView({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final openTasks = tasks.where(_isOpen).toList();
    final progressTasks = tasks.where(_isInProgress).toList();
    final completedTasks = tasks.where(_isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PipelineColumn(
            title: 'Open',
            count: openTasks.length,
            color: AppColors.info,
            tasks: openTasks,
          ),
          const SizedBox(width: AppSpacing.md),
          _PipelineColumn(
            title: 'In Progress',
            count: progressTasks.length,
            color: AppColors.warning,
            tasks: progressTasks,
          ),
          const SizedBox(width: AppSpacing.md),
          _PipelineColumn(
            title: 'Completed',
            count: completedTasks.length,
            color: AppColors.success,
            tasks: completedTasks,
          ),
        ],
      ),
    );
  }

  bool _isOpen(MaintenanceRequest task) {
    return task.status == MaintenanceStatus.open;
  }

  bool _isInProgress(MaintenanceRequest task) {
    return task.status == MaintenanceStatus.inProgress ||
        task.status == MaintenanceStatus.onHold;
  }

  bool _isCompleted(MaintenanceRequest task) {
    return task.status == MaintenanceStatus.completed ||
        task.status == MaintenanceStatus.cancelled;
  }
}

class _PipelineColumn extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final List<MaintenanceRequest> tasks;

  const _PipelineColumn({
    required this.title,
    required this.count,
    required this.color,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: color.withOpacity(0.2), width: 2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Column(
                children: tasks
                    .map((task) => _PipelineTaskCard(task: task))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineTaskCard extends StatelessWidget {
  const _PipelineTaskCard({required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priority = _getPriority(task.priority);
    final priorityColor = _getPriorityColor(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.6),
          width: 0.75,
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.md,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/tasks/${task.id}', extra: task),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.5),
                        borderRadius: AppRadii.pill,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md + 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.apartment_outlined,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          task.propertyTitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _PipelinePriorityDot(priority: priority),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PipelinePriorityDot extends StatelessWidget {
  const _PipelinePriorityDot({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    final label = priority == TaskPriority.high
        ? 'HIGH'
        : priority == TaskPriority.medium
        ? 'MED'
        : 'LOW';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 0.75),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    );
  }
}

TaskPriority _getPriority(MaintenancePriority priority) {
  return switch (priority) {
    MaintenancePriority.urgent => TaskPriority.high,
    MaintenancePriority.high => TaskPriority.high,
    MaintenancePriority.medium => TaskPriority.medium,
    MaintenancePriority.low => TaskPriority.low,
  };
}

Color _getPriorityColor(TaskPriority priority) {
  return switch (priority) {
    TaskPriority.high => AppColors.danger,
    TaskPriority.medium => AppColors.warning,
    TaskPriority.low => AppColors.textSecondary,
  };
}

Color _getPriorityBorderColor(BuildContext context, TaskPriority priority) {
  if (priority == TaskPriority.high) {
    return AppColors.danger.withOpacity(0.35);
  }
  return Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6);
}

enum TaskView { list, pipeline }

enum TaskStatusFilter {
  all('All'),
  open('Open'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const TaskStatusFilter(this.label);
}

enum TaskPriority { high, medium, low }
