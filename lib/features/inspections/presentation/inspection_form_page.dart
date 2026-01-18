import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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
    return AppScaffold(
      appBar: AppBar(title: const Text('Create inspection')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Inspection details'),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a title.'
                      : null,
            ),
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
              controller: _tenantController,
              decoration: const InputDecoration(labelText: 'Tenant ID'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _scheduledController,
              decoration: const InputDecoration(
                labelText: 'Scheduled date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Checklist'),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Checklist item',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: _addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_items.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _items
                    .asMap()
                    .entries
                    .map(
                      (entry) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() => _items.removeAt(entry.key));
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
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
                    : const Text('Create inspection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
