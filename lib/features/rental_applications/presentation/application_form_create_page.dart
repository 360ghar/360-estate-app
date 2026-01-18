import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Create application form')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Form details'),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _propertyController,
              decoration: const InputDecoration(labelText: 'Property ID'),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a property ID.'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Form title'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _expiryController,
              decoration: const InputDecoration(
                labelText: 'Expiry date (optional)',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Form is active'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Custom fields'),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _fieldLabelController,
              decoration: const InputDecoration(labelText: 'Field label'),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _fieldType,
              items: const [
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(value: 'email', child: Text('Email')),
                DropdownMenuItem(value: 'phone', child: Text('Phone')),
                DropdownMenuItem(value: 'number', child: Text('Number')),
                DropdownMenuItem(value: 'date', child: Text('Date')),
                DropdownMenuItem(value: 'select', child: Text('Select')),
                DropdownMenuItem(value: 'checkbox', child: Text('Checkbox')),
              ],
              onChanged: (value) =>
                  setState(() => _fieldType = value ?? 'text'),
              decoration: const InputDecoration(labelText: 'Field type'),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_fieldType == 'select')
              TextFormField(
                controller: _fieldOptionsController,
                decoration: const InputDecoration(
                  labelText: 'Options',
                  hintText: 'Option 1, Option 2',
                ),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Required'),
              value: _fieldRequired,
              onChanged: (value) => setState(() => _fieldRequired = value),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _addField,
                icon: const Icon(Icons.add),
                label: const Text('Add field'),
              ),
            ),
            if (_fields.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Column(
                children: _fields
                    .asMap()
                    .entries
                    .map(
                      (entry) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.value.label ?? 'Field'),
                        subtitle: Text(entry.value.fieldType ?? 'text'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() => _fields.removeAt(entry.key));
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
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
                    : const Text('Create form'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
