import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
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

  /// Maps the UI status filter to the API status string(s) understood by the
  /// backend. Returns `null` when no filter is active (fetch all statuses).
  String? get _apiStatus {
    switch (_statusFilter) {
      case TaskStatusFilter.open:
        return 'open';
      case TaskStatusFilter.inProgress:
        return 'work_order_created';
      case TaskStatusFilter.completed:
        return 'resolved';
      case TaskStatusFilter.all:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the status-filtered provider so the filter applies across ALL pages
    // via a backend query parameter, not just the currently loaded items.
    final state = ref.watch(maintenancePagedByStatusProvider(_apiStatus));
    final controller =
        ref.read(maintenancePagedByStatusProvider(_apiStatus).notifier);

    // Items are already filtered by the backend; no client-side filtering
    // needed. The pipeline view groups items by column from the loaded set.
    final filteredItems = state.items;

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
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkCardBorder
                : AppColors.cardBorder,
          ),

          // Content
          Expanded(
            child: _viewMode == TaskView.pipeline
                ? RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: _TaskPipelineView(
                      tasks: filteredItems,
                      hasMore: state.hasMore,
                      onLoadMore: controller.loadMore,
                      isLoadingMore: state.isLoadingMore,
                      loadMoreError: state.loadMoreError,
                      onLoadMoreRetry: controller.retryLoadMore,
                    ),
                  )
                : PagedListView<MaintenanceRequest>(
                    state: state,
                    emptyTitle: 'No tasks yet',
                    emptyMessage: 'Maintenance requests will appear here.',
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    onLoadMoreRetry: controller.retryLoadMore,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
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
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
                selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.md,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                        : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
                    width: isSelected ? 1.5 : 0.5,
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

/// Task list card with colored left priority border, status badge, and card styling.
class _TaskListCard extends StatelessWidget {
  const _TaskListCard({required this.task});

  final MaintenanceRequest task;

  @override
  Widget build(BuildContext context) {
    final date = task.createdAt == null
        ? 'New'
        : DateFormat('dd MMM yyyy').format(task.createdAt!);
    final priority = _getPriority(task.priority);
    final priorityColor = _getPriorityColor(priority);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(
          '/tasks/${task.id}',
          extra: task,
        ),
        borderRadius: AppRadii.lg,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left border based on priority
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadii.lgValue),
                    bottomLeft: Radius.circular(AppRadii.lgValue),
                  ),
                ),
              ),
              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with title and priority badge
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
                          const SizedBox(width: AppSpacing.sm),
                          _PriorityBadge(priority: priority),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Property name
                      Row(
                        children: [
                          Icon(
                            Icons.apartment_outlined,
                            size: 15,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.textTertiary,
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

                      // Description (if available)
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),

                      // Footer with status and date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusBadge(context),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final VoidCallback? onLoadMoreRetry;

  const _TaskPipelineView({
    required this.tasks,
    this.hasMore = false,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.onLoadMoreRetry,
  });

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
          if (loadMoreError != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Center(
                child: TextButton.icon(
                  onPressed: onLoadMoreRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry load more'),
                ),
              ),
            )
          else if (hasMore)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Center(
                child: isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton.icon(
                        onPressed: onLoadMore,
                        icon: const Icon(Icons.expand_more),
                        label: const Text('Load more'),
                      ),
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header with colored accent and count badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: AppRadii.md,
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.25 : 0.15),
                width: 0.5,
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
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.15),
                    borderRadius: AppRadii.pill,
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
          ),
          const SizedBox(height: AppSpacing.sm),

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
    final priorityColor = _getPriorityColor(priority);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: InkWell(
        onTap: () => context.go('/tasks/${task.id}', extra: task),
        borderRadius: AppRadii.md,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored top accent
            Container(
              height: 3,
              color: priorityColor,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Property name
                  Text(
                    task.propertyTitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
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
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.pill,
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
    TaskPriority.low => AppColors.info,
  };
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
