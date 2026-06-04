import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InspectionFormPage extends ConsumerStatefulWidget {
  const InspectionFormPage({super.key});

  @override
  ConsumerState<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends ConsumerState<InspectionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _propertyController = TextEditingController();
  final _tenantController = TextEditingController();
  final _titleController = TextEditingController();
  final _scheduledController = TextEditingController();
  final _itemController = TextEditingController();

  final List<String> _items = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _propertyController.dispose();
    _tenantController.dispose();
    _titleController.dispose();
    _scheduledController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _itemController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(text);
      _itemController.clear();
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final scheduledAt = DateTime.tryParse(_scheduledController.text.trim());

    setState(() => _isSaving = true);
    try {
      final request = InspectionCreateRequest(
        propertyId: _propertyController.text.trim(),
        tenantId: _tenantController.text.trim().isEmpty
            ? null
            : _tenantController.text.trim(),
        title: _titleController.text.trim(),
        scheduledAt: scheduledAt,
        items: List<String>.from(_items),
      );
      await ref.read(inspectionsRepositoryProvider).create(request);
      ref.invalidate(inspectionsListProvider);
      if (mounted) {
        context.go('/more/inspections');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(title: const Text('Create inspection')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Inspection Details Section
            AppSectionCard(
              title: 'Inspection Details',
              icon: Icons.assignment_outlined,
              iconColor: AppColors.primary,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title, size: 20),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter a title.'
                          : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _scheduledController,
                  decoration: const InputDecoration(
                    labelText: 'Scheduled date',
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Property Section
            AppSectionCard(
              title: 'Property',
              icon: Icons.home_outlined,
              iconColor: AppColors.info,
              children: [
                TextFormField(
                  controller: _propertyController,
                  decoration: const InputDecoration(
                    labelText: 'Property ID',
                    prefixIcon: Icon(Icons.home_work_outlined, size: 20),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter a property ID.'
                          : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _tenantController,
                  decoration: const InputDecoration(
                    labelText: 'Tenant ID (optional)',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Checklist Items Section
            AppSectionCard(
              title: 'Checklist Items',
              icon: Icons.checklist_outlined,
              iconColor: AppColors.warning,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Add checklist item',
                          prefixIcon: Icon(Icons.add_task, size: 20),
                        ),
                        onFieldSubmitted: (_) => _addItem(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton.tonalIcon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (_items.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  ..._items.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceSecondary
                                : AppColors.surfaceSecondary,
                            borderRadius: AppRadii.md,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkCardBorder
                                  : AppColors.cardBorder,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                // Numbered circle
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: isDark ? 0.15 : 0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    item,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: AppColors.danger,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _items.removeAt(index));
                                  },
                                  tooltip: 'Remove item',
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit button
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
                label: Text(_isSaving ? 'Creating...' : 'Create inspection'),
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
}
