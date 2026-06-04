import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MaintenanceDetailPage extends ConsumerStatefulWidget {
  const MaintenanceDetailPage({
    super.key,
    required this.requestId,
    this.initialRequest,
  });

  final String requestId;
  final MaintenanceRequest? initialRequest;

  @override
  ConsumerState<MaintenanceDetailPage> createState() =>
      _MaintenanceDetailPageState();
}

class _MaintenanceDetailPageState extends ConsumerState<MaintenanceDetailPage> {
  final _notesController = TextEditingController();
  late MaintenanceStatus _status;
  late MaintenancePriority _priority;
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _populate(MaintenanceRequest request) {
    if (_initialized) return;
    _status = request.status;
    _priority = request.priority;
    final notes = request.notes;
    _notesController.text =
        notes != null && notes.trim().isNotEmpty ? notes : request.description;
    _initialized = true;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final id = int.tryParse(widget.requestId);
      if (id == null) {
        throw Exception('Invalid request ID');
      }

      await ref.read(maintenanceRepositoryProvider).updateRequest(
            id,
            {
              'status': _status.apiValue,
              'priority': _priority.name,
              if (_notesController.text.trim().isNotEmpty)
                'notes': _notesController.text.trim(),
            },
          );
      ref.invalidate(maintenanceListProvider);
      ref.invalidate(maintenancePagedProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request updated.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Color _priorityColor(MaintenancePriority priority) {
    switch (priority) {
      case MaintenancePriority.low:
        return AppColors.info;
      case MaintenancePriority.medium:
        return AppColors.warning;
      case MaintenancePriority.high:
        return AppColors.danger;
      case MaintenancePriority.urgent:
        return const Color(0xFFB91C1C);
    }
  }

  AppStatusType _statusBadgeType(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.open:
        return AppStatusType.info;
      case MaintenanceStatus.inProgress:
        return AppStatusType.warning;
      case MaintenanceStatus.onHold:
        return AppStatusType.neutral;
      case MaintenanceStatus.completed:
        return AppStatusType.success;
      case MaintenanceStatus.cancelled:
        return AppStatusType.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialRequest;
    final state = ref.watch(maintenancePagedProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Request details')),
      scrollable: true,
      body: _buildBody(context, state, initial),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PagedListState<MaintenanceRequest> state,
    MaintenanceRequest? initial,
  ) {
    // Handle invalid ID
    if (widget.requestId.isEmpty || widget.requestId == 'null') {
      return AppErrorView(
        title: 'Invalid Request',
        message: 'The request ID is not valid.',
        retryLabel: 'Go Back',
        onRetry: () => context.pop(),
      );
    }

    if (state.isInitialLoading && initial == null) {
      return const Center(child: CircularProgressIndicator());
    }

    MaintenanceRequest request;
    try {
      request = initial ??
          state.items.firstWhere(
            (item) => item.id.toString() == widget.requestId,
          );
    } catch (_) {
      return AppErrorView(
        title: 'Request not found',
        message: 'This maintenance request is unavailable.',
        retryLabel: 'Go Back',
        onRetry: () => context.pop(),
      );
    }

    _populate(request);

    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and property
        Text(
          request.title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              Icons.home_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                request.propertyTitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Status Stepper
        _StatusStepper(currentStatus: _status),
        const SizedBox(height: AppSpacing.lg),

        // Request Info Section
        AppSectionCard(
          title: 'Request Info',
          icon: Icons.info_outline,
          iconColor: AppColors.info,
          children: [
            _DetailRow(
              label: 'Category',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(request.category.icon, size: 16, color: request.category.color),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    request.category.displayName,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'Priority',
              child: AppStatusBadge(
                label: request.priority.displayName,
                type: _statusBadgeType(_status) == AppStatusType.success
                    ? AppStatusType.success
                    : switch (request.priority) {
                        MaintenancePriority.low => AppStatusType.info,
                        MaintenancePriority.medium => AppStatusType.warning,
                        MaintenancePriority.high => AppStatusType.danger,
                        MaintenancePriority.urgent => AppStatusType.danger,
                      },
                variant: AppStatusVariant.subtle,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'Status',
              child: AppStatusBadge(
                label: request.status.displayName,
                type: _statusBadgeType(request.status),
                variant: AppStatusVariant.subtle,
              ),
            ),
            if (request.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Divider(
                height: 1,
                thickness: 0.5,
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Description',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                request.description,
                style: textTheme.bodyMedium,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Update Status Section
        AppSectionCard(
          title: 'Update Status',
          icon: Icons.edit_outlined,
          iconColor: AppColors.warning,
          children: [
            // Status chips
            Text(
              'Status',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenanceStatus.values.map((status) {
                final isSelected = _status == status;
                return ChoiceChip(
                  label: Text(status.displayName),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _status = status),
                  selectedColor: status.color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Priority chips
            Text(
              'Priority',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenancePriority.values.map((priority) {
                final isSelected = _priority == priority;
                final chipColor = _priorityColor(priority);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        priority.icon,
                        size: 16,
                        color: isSelected ? Colors.white : chipColor,
                      ),
                      const SizedBox(width: 4),
                      Text(priority.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _priority = priority),
                  selectedColor: chipColor,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : chipColor,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Notes Section
        AppSectionCard(
          title: 'Notes',
          icon: Icons.sticky_note_2_outlined,
          iconColor: AppColors.accent,
          children: [
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add notes or updates...',
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Icon(Icons.notes_outlined, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Save button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(_isSaving ? 'Saving...' : 'Save updates'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal status stepper showing the maintenance workflow.
class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.currentStatus});

  final MaintenanceStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    // Define the stepper steps in order
    const steps = [
      (label: 'Open', status: MaintenanceStatus.open),
      (label: 'In Progress', status: MaintenanceStatus.inProgress),
      (label: 'Completed', status: MaintenanceStatus.completed),
    ];

    // Determine step index
    int currentIndex;
    switch (currentStatus) {
      case MaintenanceStatus.open:
        currentIndex = 0;
      case MaintenanceStatus.inProgress:
        currentIndex = 1;
      case MaintenanceStatus.completed:
        currentIndex = 2;
      case MaintenanceStatus.onHold:
        currentIndex = 1; // treat as between open and in-progress
      case MaintenanceStatus.cancelled:
        currentIndex = -1; // special case
    }

    final isCancelled = currentStatus == MaintenanceStatus.cancelled;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: isCancelled
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.danger, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Cancelled',
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  if (i > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i <= currentIndex
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkCardBorder
                                : AppColors.border),
                      ),
                    ),
                  _StepCircle(
                    label: steps[i].label,
                    isCompleted: i < currentIndex,
                    isCurrent: i == currentIndex,
                    isFuture: i > currentIndex,
                  ),
                ],
              ],
            ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
    required this.isFuture,
  });

  final String label;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color circleColor;
    final Color iconColor;
    final Color textColor;

    if (isCompleted) {
      circleColor = AppColors.primary;
      iconColor = Colors.white;
      textColor = AppColors.primary;
    } else if (isCurrent) {
      circleColor = AppColors.primary;
      iconColor = Colors.white;
      textColor = AppColors.primary;
    } else {
      circleColor = AppColors.border;
      iconColor = AppColors.textTertiary;
      textColor = AppColors.textTertiary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted
                ? Icons.check
                : isCurrent
                    ? Icons.circle
                    : Icons.circle_outlined,
            size: isCompleted ? 16 : 10,
            color: iconColor,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: textColor,
            fontWeight: isCurrent || isCompleted ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        child,
      ],
    );
  }
}
