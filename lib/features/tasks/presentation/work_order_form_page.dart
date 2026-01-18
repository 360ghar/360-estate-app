import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              const SectionHeader(title: 'Basic Information'),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g., Fix leaking pipe in bathroom',
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
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Priority & Status
              const SectionHeader(title: 'Priority & Status'),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WorkOrderPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority *',
                  hintText: 'Select priority level',
                ),
                items: WorkOrderPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Row(
                      children: [
                        _buildPriorityIcon(priority),
                        const SizedBox(width: AppSpacing.sm),
                        Text(priority.label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPriority = value),
                validator: (value) => value == null ? 'Select a priority' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WorkOrderStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                items: WorkOrderStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(status.icon, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(status.label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Assignment
              const SectionHeader(title: 'Assignment'),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _selectAssignee,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Assigned To',
                    hintText: 'Select relationship manager',
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _assignedToId != null ? Icons.person : Icons.person_outline,
                        color: _assignedToId != null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _assignedToName ?? 'Not assigned',
                          style: TextStyle(
                            color: _assignedToName != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
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
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Timeline & Cost
              const SectionHeader(title: 'Timeline & Cost'),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _selectDueDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _dueDate == null
                            ? 'Select due date'
                            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _estimatedCostController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost (₹)',
                  hintText: 'e.g., 5000',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Additional Notes
              const SectionHeader(title: 'Additional Notes'),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Any additional information or instructions',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Update Work Order' : 'Create Work Order'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIcon(WorkOrderPriority priority) {
    Color color;
    switch (priority) {
      case WorkOrderPriority.low:
        color = Colors.green;
        break;
      case WorkOrderPriority.medium:
        color = Colors.orange;
        break;
      case WorkOrderPriority.high:
        color = Colors.red;
        break;
      case WorkOrderPriority.emergency:
        color = Colors.purple;
        break;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
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
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange,
            size: 48,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No relationship managers available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Assignees will be available once the staff management API is connected.',
            style: TextStyle(color: Colors.grey),
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
