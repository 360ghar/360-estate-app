import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Work Order Status
enum WorkOrderStatus {
  draft('Draft', Icons.drafts),
  assigned('Assigned', Icons.person_add),
  inProgress('In Progress', Icons.build),
  completed('Completed', Icons.check_circle),
  cancelled('Cancelled', Icons.cancel);

  const WorkOrderStatus(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Work Order Priority
enum WorkOrderPriority {
  low('Low', 1),
  medium('Medium', 2),
  high('High', 3),
  emergency('Emergency', 4);

  const WorkOrderPriority(this.label, this.value);
  final String label;
  final int value;
}

/// Work Order creation/editing form
class WorkOrderFormPage extends ConsumerStatefulWidget {
  const WorkOrderFormPage({
    super.key,
    this.maintenanceRequestId,
    this.workOrderId,
  });

  final String? maintenanceRequestId;
  final String? workOrderId;

  @override
  ConsumerState<WorkOrderFormPage> createState() => _WorkOrderFormPageState();
}

class _WorkOrderFormPageState extends ConsumerState<WorkOrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _notesController = TextEditingController();

  WorkOrderPriority? _selectedPriority;
  WorkOrderStatus _selectedStatus = WorkOrderStatus.draft;
  DateTime? _dueDate;
  String? _assignedToId;
  String? _assignedToName;

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _estimatedCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _selectAssignee() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _AssigneeSelectionDialog(),
    );
    if (result != null) {
      setState(() {
        _assignedToId = result['id'];
        _assignedToName = result['name'];
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work orders are not available yet.'),
      ),
    );
    setState(() => _isSaving = false);
  }

  Color _priorityColor(WorkOrderPriority priority) {
    switch (priority) {
      case WorkOrderPriority.low:
        return AppColors.info;
      case WorkOrderPriority.medium:
        return AppColors.warning;
      case WorkOrderPriority.high:
        return AppColors.danger;
      case WorkOrderPriority.emergency:
        return const Color(0xFFB91C1C);
    }
  }

  Color _statusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.draft:
        return AppColors.textSecondary;
      case WorkOrderStatus.assigned:
        return AppColors.info;
      case WorkOrderStatus.inProgress:
        return AppColors.warning;
      case WorkOrderStatus.completed:
        return AppColors.success;
      case WorkOrderStatus.cancelled:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workOrderId != null;

    return AppScaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Work Order' : 'Create Work Order'),
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Work Order Details Section
            AppSectionCard(
              title: 'Work Order Details',
              icon: Icons.assignment_outlined,
              iconColor: AppColors.primary,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., Fix leaking pipe in bathroom',
                    prefixIcon: Icon(Icons.title, size: 20),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Enter a title' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Describe the work that needs to be done',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(Icons.description_outlined, size: 20),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Enter a description' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'e.g., Master Bathroom, 2nd Floor',
                    prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Priority & Status Section
            AppSectionCard(
              title: 'Priority & Status',
              icon: Icons.flag_outlined,
              iconColor: AppColors.warning,
              children: [
                // Priority chips
                Text(
                  'Priority *',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: WorkOrderPriority.values.map((priority) {
                    final isSelected = _selectedPriority == priority;
                    final chipColor = _priorityColor(priority);
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : chipColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(priority.label),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedPriority = priority),
                      selectedColor: chipColor,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : chipColor,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Status chips
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: WorkOrderStatus.values.map((status) {
                    final isSelected = _selectedStatus == status;
                    final chipColor = _statusColor(status);
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            status.icon,
                            size: 16,
                            color: isSelected ? Colors.white : chipColor,
                          ),
                          const SizedBox(width: 4),
                          Text(status.label),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedStatus = status),
                      selectedColor: chipColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Assignment Section
            AppSectionCard(
              title: 'Assignment',
              icon: Icons.people_outline,
              iconColor: AppColors.accent,
              children: [
                InkWell(
                  onTap: _selectAssignee,
                  borderRadius: AppRadii.md,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: AppRadii.md,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _assignedToId != null ? Icons.person : Icons.person_outline,
                          color: _assignedToId != null
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assigned To',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                _assignedToName ?? 'Not assigned',
                                style: TextStyle(
                                  color: _assignedToName != null
                                      ? Theme.of(context).colorScheme.onSurface
                                      : AppColors.textTertiary,
                                  fontWeight: _assignedToName != null
                                      ? FontWeight.w500
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_assignedToId != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _assignedToId = null;
                                _assignedToName = null;
                              });
                            },
                          )
                        else
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.textTertiary,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Cost & Schedule Section
            AppSectionCard(
              title: 'Cost & Schedule',
              icon: Icons.attach_money_outlined,
              iconColor: AppColors.success,
              children: [
                // Due date
                InkWell(
                  onTap: _selectDueDate,
                  borderRadius: AppRadii.md,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: AppRadii.md,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: _dueDate != null
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                _dueDate == null
                                    ? 'Select due date'
                                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                                style: TextStyle(
                                  color: _dueDate != null
                                      ? Theme.of(context).colorScheme.primary
                                      : AppColors.textTertiary,
                                  fontWeight:
                                      _dueDate != null ? FontWeight.w500 : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () =>
                                setState(() => _dueDate = null),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Estimated cost - prominent
                TextFormField(
                  controller: _estimatedCostController,
                  decoration: InputDecoration(
                    labelText: 'Estimated Cost',
                    hintText: 'e.g., 5000',
                    prefixIcon: Container(
                      width: 48,
                      alignment: Alignment.center,
                      child: Text(
                        '\u20B9',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Additional Notes Section
            AppSectionCard(
              title: 'Additional Notes',
              icon: Icons.sticky_note_2_outlined,
              iconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Any additional information or instructions',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Icon(Icons.notes_outlined, size: 20),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _submit,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : isEditing
                          ? 'Update Work Order'
                          : 'Create Work Order',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

/// Dialog for selecting assignee (relationship manager)
class _AssigneeSelectionDialog extends StatelessWidget {
  const _AssigneeSelectionDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Work Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No relationship managers available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Assignees will be available once the staff management API is connected.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
