import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicationFormCreatePage extends ConsumerStatefulWidget {
  const ApplicationFormCreatePage({super.key});

  @override
  ConsumerState<ApplicationFormCreatePage> createState() =>
      _ApplicationFormCreatePageState();
}

class _ApplicationFormCreatePageState
    extends ConsumerState<ApplicationFormCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _propertyController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expiryController = TextEditingController();

  final _fieldLabelController = TextEditingController();
  final _fieldOptionsController = TextEditingController();
  String _fieldType = 'text';
  bool _fieldRequired = false;

  final List<ApplicationFormField> _fields = [];
  bool _isActive = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _propertyController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _expiryController.dispose();
    _fieldLabelController.dispose();
    _fieldOptionsController.dispose();
    super.dispose();
  }

  void _addField() {
    final label = _fieldLabelController.text.trim();
    if (label.isEmpty) return;
    final options = _fieldOptionsController.text
        .split(',')
        .map((option) => option.trim())
        .where((option) => option.isNotEmpty)
        .toList();
    setState(() {
      _fields.add(
        ApplicationFormField(
          label: label,
          fieldType: _fieldType,
          isRequired: _fieldRequired,
          options: options,
        ),
      );
      _fieldLabelController.clear();
      _fieldOptionsController.clear();
      _fieldType = 'text';
      _fieldRequired = false;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final expiry = _expiryController.text.trim().isEmpty
        ? null
        : DateTime.tryParse(_expiryController.text.trim());

    setState(() => _isSaving = true);
    try {
      final request = ApplicationFormCreateRequest(
        propertyId: _propertyController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isActive: _isActive,
        expiresAt: expiry,
        fields: List<ApplicationFormField>.from(_fields),
      );
      await ref.read(applicationsRepositoryProvider).createForm(request);
      ref.invalidate(applicationFormsPagedProvider);
      if (mounted) {
        context.go('/more/applications');
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

  IconData _fieldTypeIcon(String type) {
    switch (type) {
      case 'text':
        return Icons.edit_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'number':
        return Icons.pin_outlined;
      case 'date':
        return Icons.calendar_today_outlined;
      case 'select':
        return Icons.list_outlined;
      case 'checkbox':
        return Icons.check_box_outlined;
      default:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(title: const Text('Create application form')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Form Details Section ---
            AppSectionCard(
              title: 'Form Details',
              icon: Icons.article_outlined,
              children: [
                TextFormField(
                  controller: _propertyController,
                  decoration: const InputDecoration(
                    labelText: 'Property ID',
                    prefixIcon: Icon(Icons.apartment_outlined),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter a property ID.'
                          : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Form title',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.notes_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry date (optional)',
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: Icon(Icons.event_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSecondary
                        : AppColors.surfaceSecondary,
                    borderRadius: AppRadii.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isActive
                                ? Icons.toggle_on_rounded
                                : Icons.toggle_off_rounded,
                            color: _isActive
                                ? AppColors.success
                                : AppColors.textTertiary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Form is active',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isActive,
                        onChanged: (value) =>
                            setState(() => _isActive = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // --- Custom Fields Section ---
            AppSectionCard(
              title: 'Form Fields',
              icon: Icons.dynamic_form_outlined,
              children: [
                TextFormField(
                  controller: _fieldLabelController,
                  decoration: const InputDecoration(
                    labelText: 'Field label',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Field type selector as icon chips
                Text(
                  'Field type',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _FieldTypeChip(
                      label: 'Text',
                      icon: Icons.edit_outlined,
                      value: 'text',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      value: 'email',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      value: 'phone',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Number',
                      icon: Icons.pin_outlined,
                      value: 'number',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Date',
                      icon: Icons.calendar_today_outlined,
                      value: 'date',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Select',
                      icon: Icons.list_outlined,
                      value: 'select',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                    _FieldTypeChip(
                      label: 'Checkbox',
                      icon: Icons.check_box_outlined,
                      value: 'checkbox',
                      groupValue: _fieldType,
                      onSelected: (v) => setState(() => _fieldType = v),
                    ),
                  ],
                ),

                if (_fieldType == 'select') ...[
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _fieldOptionsController,
                    decoration: const InputDecoration(
                      labelText: 'Options',
                      hintText: 'Option 1, Option 2',
                      prefixIcon: Icon(Icons.format_list_bulleted),
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),

                // Required toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSecondary
                        : AppColors.surfaceSecondary,
                    borderRadius: AppRadii.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline_rounded,
                            size: 18,
                            color: _fieldRequired
                                ? AppColors.warning
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Required',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _fieldRequired,
                        onChanged: (value) =>
                            setState(() => _fieldRequired = value),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    onPressed: _addField,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add field'),
                  ),
                ),

                // Added fields list
                if (_fields.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  ...List.generate(_fields.length, (index) {
                    final field = _fields[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _fields.length - 1
                            ? AppSpacing.sm
                            : 0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
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
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: isDark ? 0.15 : 0.08),
                                borderRadius: AppRadii.sm,
                              ),
                              child: Icon(
                                _fieldTypeIcon(field.fieldType ?? 'text'),
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    field.label ?? 'Field',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Row(
                                    children: [
                                      Text(
                                        field.fieldType ?? 'text',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      if (field.isRequired == true) ...[
                                        const SizedBox(width: AppSpacing.sm),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning
                                                .withValues(alpha: 0.1),
                                            borderRadius: AppRadii.pill,
                                          ),
                                          child: Text(
                                            'Required',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              color: AppColors.warning,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.textTertiary,
                              ),
                              onPressed: () {
                                setState(() => _fields.removeAt(index));
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create form'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _FieldTypeChip extends StatelessWidget {
  const _FieldTypeChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(value),
        borderRadius: AppRadii.pill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                : (isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceSecondary),
            borderRadius: AppRadii.pill,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.4)
                  : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
              width: isSelected ? 1.5 : 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
