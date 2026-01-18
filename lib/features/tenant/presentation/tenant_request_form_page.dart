import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TenantRequestFormPage extends ConsumerStatefulWidget {
  const TenantRequestFormPage({super.key});

  @override
  ConsumerState<TenantRequestFormPage> createState() =>
      _TenantRequestFormPageState();
}

class _TenantRequestFormPageState extends ConsumerState<TenantRequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _propertyController = TextEditingController();

  final List<File> _attachments = [];
  bool _isSaving = false;
  MaintenanceCategory _category = MaintenanceCategory.other;
  MaintenancePriority _priority = MaintenancePriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _propertyController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );
    if (result == null || result.files.isEmpty) return;

    final files = result.files
        .map((file) => file.path)
        .whereType<String>()
        .map(File.new)
        .toList();
    if (files.isEmpty) return;
    setState(() {
      _attachments
        ..clear()
        ..addAll(files);
    });
  }

  Future<List<String>> _uploadAttachments() async {
    if (_attachments.isEmpty) return [];
    final uploader = ref.read(fileUploadServiceProvider);
    final urls = <String>[];
    for (final file in _attachments) {
      final result = await uploader.uploadFile(
        file: file,
        target: UploadTarget.general,
      );
      if (result.url != null) {
        urls.add(result.url!);
      }
    }
    return urls;
  }

  Lease? _selectPrimaryLease(List<Lease> leases) {
    if (leases.isEmpty) return null;
    final active = leases.where((lease) {
      final status = lease.status?.toLowerCase() ?? '';
      return status.contains('active') || status.contains('current');
    }).toList();
    final candidates = active.isNotEmpty ? active : leases;
    candidates.sort((a, b) {
      final aDate =
          a.startDate ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.startDate ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return candidates.first;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final tenantId = ref.read(authControllerProvider).user?.id?.toString();
    if (tenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to identify tenant.')),
      );
      return;
    }

    final propertyIdText = _propertyController.text.trim();
    final propertyId = int.tryParse(propertyIdText);
    if (propertyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid property ID.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final attachments = await _uploadAttachments();
      if (_attachments.isNotEmpty && attachments.isEmpty) {
        throw Exception('Attachment upload failed.');
      }

      final repository = ref.read(maintenanceRepositoryProvider);
      await repository.createRequest(
        propertyId: propertyId,
        category: _category.name,
        priority: _priority.name,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      ref.invalidate(maintenanceListProvider);
      ref.invalidate(maintenancePagedProvider);
      if (mounted) {
        context.go('/tenant/requests');
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
    final tenantId = ref.watch(authControllerProvider).user?.id?.toString();
    final leaseFilter =
        tenantId == null ? null : LeaseListFilter(tenantId: tenantId);
    final leasesAsync = leaseFilter == null
        ? const AsyncValue.data(<Lease>[])
        : ref.watch(leasesListProvider(leaseFilter));
    final primaryLease =
        _selectPrimaryLease(leasesAsync.asData?.value ?? const <Lease>[]);
    final leasePropertyId = primaryLease?.propertyId?.toString();
    final leasePropertyName = primaryLease?.propertyName;

    if (leasePropertyId != null && _propertyController.text != leasePropertyId) {
      _propertyController.text = leasePropertyId;
    }

    return AppScaffold(
      appBar: AppBar(title: const Text('New request')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Request details'),
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
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a description.'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Category'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenanceCategory.values.map((cat) {
                final isSelected = _category == cat;
                return ChoiceChip(
                  label: Text(cat.displayName),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _category = cat),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Priority'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MaintenancePriority.values.map((priority) {
                final isSelected = _priority == priority;
                return ChoiceChip(
                  label: Text(priority.displayName),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _priority = priority),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            if (leasesAsync.isLoading && leasePropertyId == null) ...[
              Text(
                'Loading lease details...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (leasesAsync.hasError) ...[
              Text(
                'Unable to load lease details. Enter the property ID manually.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextFormField(
              controller: _propertyController,
              decoration: InputDecoration(
                labelText: leasePropertyId != null
                    ? 'Property (from lease)'
                    : 'Property ID',
                helperText: leasePropertyName,
                suffixIcon: leasePropertyId != null
                    ? const Icon(Icons.lock_outline)
                    : null,
              ),
              keyboardType: TextInputType.number,
              readOnly: leasePropertyId != null,
              validator: (value) {
                if (leasePropertyId != null) return null;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return 'Enter a property ID.';
                if (int.tryParse(trimmed) == null) {
                  return 'Enter a valid property ID.';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Attachments'),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _pickAttachments,
              icon: const Icon(Icons.attach_file),
              label: Text(
                _attachments.isEmpty
                    ? 'Add photos or videos'
                    : 'Change attachments (${_attachments.length})',
              ),
            ),
            if (_attachments.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _attachments
                    .map((file) => file.path.split(Platform.pathSeparator).last)
                    .join(', '),
                style: Theme.of(context).textTheme.bodySmall,
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
                    : const Text('Submit request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
