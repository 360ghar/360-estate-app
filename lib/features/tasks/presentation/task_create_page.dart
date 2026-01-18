import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Task creation page with mid-level complexity form.
/// Includes: Title, Description, Property, Category, Priority, Due Date (optional)
class TaskCreatePage extends ConsumerStatefulWidget {
  const TaskCreatePage({super.key});

  @override
  ConsumerState<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends ConsumerState<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedPropertyId;
  MaintenanceCategory _category = MaintenanceCategory.other;
  MaintenancePriority _priority = MaintenancePriority.medium;
  DateTime? _dueDate;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _dueDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      // Only send property_id if it's not empty and a valid number
      final propertyId = _selectedPropertyId?.trim().isEmpty == true
          ? null
          : int.tryParse(_selectedPropertyId?.trim() ?? '');

      if (propertyId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a valid property')),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      // Debug: Log what we're sending
      debugPrint('Creating task with:');
      debugPrint('  title: "$title" (length: ${title.length})');
      debugPrint('  description: "$description" (length: ${description.length})');
      debugPrint('  propertyId: $propertyId');
      debugPrint('  category: ${_category.name}');
      debugPrint('  priority: ${_priority.name}');

      await ref.read(maintenanceRepositoryProvider).createRequest(
            propertyId: propertyId,
            category: _category.name,
            priority: _priority.name,
            title: title,
            description: description,
            scheduledDate: _dueDate,
          );

      // Invalidate providers to refresh the list
      ref.invalidate(maintenancePagedProvider);
      ref.invalidate(maintenanceListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created successfully')),
        );
        context.go('/tasks');
      }
    } catch (error) {
      if (!mounted) return;

      // Extract detailed error information
      String errorMessage = error.toString();
      if (error is Failure) {
        errorMessage = error.message;
        if (error is ValidationFailure && error.fields.isNotEmpty) {
          final fieldErrors = error.fields.entries
              .map((e) => '${e.key}: ${e.value}')
              .join('\n');
          errorMessage += '\n\n$fieldErrors';
        }
      }

      // Debug: Log the full error
      debugPrint('Error creating task: $errorMessage');
      debugPrint('Full error: $error');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, maxLines: 5),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesListProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Details Section
            const SectionHeader(title: 'Task Details'),
            const SizedBox(height: AppSpacing.md),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Fix leaking faucet',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the task in detail...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Category Section
            const SectionHeader(title: 'Category *'),
            const SizedBox(height: AppSpacing.md),

            // Category selector
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenanceCategory.values.map((cat) {
                final isSelected = _category == cat;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                      const SizedBox(width: 4),
                      Text(cat.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _category = cat),
                  selectedColor: AppColors.brand,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Property Section
            const SectionHeader(title: 'Property *'),
            const SizedBox(height: AppSpacing.md),

            // Property dropdown
            propertiesAsync.when(
              data: (properties) {
                if (properties.isEmpty) {
                  return const _PropertyEmptyState();
                }
                return DropdownButtonFormField<String>(
                  value: _selectedPropertyId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Property',
                    hintText: 'Choose a property',
                    border: OutlineInputBorder(),
                  ),
                  items: properties.map((property) {
                    return DropdownMenuItem<String>(
                      value: property.id?.toString(),
                      child: Text(
                        property.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPropertyId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a property';
                    }
                    return null;
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: AppLoader(),
                ),
              ),
              error: (error, _) => _PropertyErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(propertiesListProvider),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Priority & Date Section
            const SectionHeader(title: 'Priority & Due Date'),
            const SizedBox(height: AppSpacing.md),

            // Priority selector
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenancePriority.values.map((priority) {
                final isSelected = _priority == priority;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(priority.icon, size: 16, color: isSelected ? Colors.white : priority.color),
                      const SizedBox(width: 4),
                      Text(priority.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _priority = priority),
                  selectedColor: priority.color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Due date picker
            InkWell(
              onTap: _pickDueDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                      child: Text(
                        _dueDate == null
                            ? 'Set due date (optional)'
                            : 'Due: ${_formatDate(_dueDate!)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _dueDate != null
                                  ? Theme.of(context).colorScheme.primary
                                  : AppColors.textSecondary,
                            ),
                      ),
                    ),
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => setState(() => _dueDate = null),
                        tooltip: 'Clear due date',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isSubmitting ? 'Creating...' : 'Create Task'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Empty state for properties.
class _PropertyEmptyState extends StatelessWidget {
  const _PropertyEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        border: Border.all(
          color: AppColors.danger.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'No properties available. Please add a property first before creating tasks.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state for properties.
class _PropertyErrorState extends StatelessWidget {
  const _PropertyErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: AppErrorView(
        title: 'Failed to load properties',
        message: message,
        retryLabel: 'Retry',
        onRetry: onRetry,
      ),
    );
  }
}
