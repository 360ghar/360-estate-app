import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
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

/// Extension to convert between MaintenanceStatus and string for UI compatibility
extension MaintenanceRequestX on MaintenanceRequest {
  /// Get status as string for filtering
  String get statusValue => status.apiValue;

  /// Get priority as string for UI
  String get priorityValue => priority.name;
}

/// Professional B2B Tasks/Maintenance page with:
/// - List/Pipeline (Kanban) view toggle
/// - Status and priority filter chips
/// - Color-coded priority badges
/// - Enhanced task cards with assignee and due date
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

    // Filter items based on status
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
          // Filter chips
          _FilterChipsBar(
            selectedFilter: _statusFilter,
            onFilterChanged: _setStatusFilter,
          ),
          const Divider(height: 1),

          // Content
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
              AppSegment(value: TaskView.list, label: 'List', icon: Icons.view_list),
              AppSegment(value: TaskView.pipeline, label: 'Board', icon: Icons.view_kanban),
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

/// Filter chips for task status.
class _FilterChipsBar extends StatelessWidget {
  final TaskStatusFilter selectedFilter;
  final ValueChanged<TaskStatusFilter> onFilterChanged;

  const _FilterChipsBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              child: FilterChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) => onFilterChanged(filter),
                backgroundColor: Colors.transparent,
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Task list card with priority badge and status.
class _TaskListCard extends StatelessWidget {
  const _TaskListCard({required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final date = task.createdAt == null
        ? 'New'
        : DateFormat('dd MMM yyyy').format(task.createdAt!);
    final priority = _getPriority(task.priority);
    final priorityBadge = _PriorityBadge(priority: priority);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPriorityBorderColor(context, priority),
          width: priority == TaskPriority.high ? 1.5 : 0.5,
        ),
      ),
      child: InkWell(
        onTap: () => context.go(
          '/tasks/${task.id}',
          extra: task,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and badges
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  priorityBadge,
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Property name
              Row(
                children: [
                  Icon(
                    Icons.apartment_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.propertyTitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Description (if available)
              if (task.description.isNotEmpty) ...[
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Footer with status and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(context),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = task.status.apiValue;
    final statusType = switch (status) {
      'completed' || 'resolved' || 'closed' => AppStatusType.success,
      'in_progress' || 'work_order_created' || 'assigned' =>
        AppStatusType.warning,
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

/// Kanban-style pipeline view for tasks.
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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

/// Individual column in the pipeline view.
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Task cards
          ...tasks.map((task) => _PipelineTaskCard(task: task)),
        ],
      ),
    );
  }
}

/// Compact task card for pipeline view.
class _PipelineTaskCard extends StatelessWidget {
  const _PipelineTaskCard({required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final priority = _getPriority(task.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with priority indicator
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Property name
          Text(
            task.propertyTitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Priority badge component.
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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Get priority from MaintenancePriority enum.
TaskPriority _getPriority(MaintenancePriority priority) {
  return switch (priority) {
    MaintenancePriority.urgent => TaskPriority.high,
    MaintenancePriority.high => TaskPriority.high,
    MaintenancePriority.medium => TaskPriority.medium,
    MaintenancePriority.low => TaskPriority.low,
  };
}

/// Get color for priority.
Color _getPriorityColor(TaskPriority priority) {
  return switch (priority) {
    TaskPriority.high => AppColors.danger,
    TaskPriority.medium => AppColors.warning,
    TaskPriority.low => AppColors.textSecondary,
  };
}

/// Get border color based on priority.
Color _getPriorityBorderColor(BuildContext context, TaskPriority priority) {
  if (priority == TaskPriority.high) {
    return AppColors.danger.withOpacity(0.5);
  }
  return Theme.of(context).colorScheme.outlineVariant;
}

/// Task view mode.
enum TaskView { list, pipeline }

/// Task status filter.
enum TaskStatusFilter {
  all('All'),
  open('Open'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const TaskStatusFilter(this.label);
}

/// Task priority level.
enum TaskPriority { high, medium, low }
