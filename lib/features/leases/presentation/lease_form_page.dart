import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeaseFormPage extends ConsumerStatefulWidget {
  const LeaseFormPage({super.key});

  @override
  ConsumerState<LeaseFormPage> createState() => _LeaseFormPageState();
}

class _LeaseFormPageState extends ConsumerState<LeaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _propertyController = TextEditingController();
  final _tenantController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _propertyController.dispose();
    _tenantController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final startDate = DateTime.tryParse(_startDateController.text.trim());
    final endDate = DateTime.tryParse(_endDateController.text.trim());
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid start/end dates.')),
      );
      return;
    }

    final rentAmount = double.tryParse(_rentController.text.trim());
    if (rentAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid rent amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final request = LeaseCreateRequest(
        propertyId: _propertyController.text.trim(),
        tenantId: _tenantController.text.trim(),
        startDate: startDate,
        endDate: endDate,
        rentAmount: rentAmount,
        depositAmount: double.tryParse(_depositController.text.trim()),
        notes: _notesController.text.trim(),
      );
      await ref.read(leasesRepositoryProvider).create(request);
      ref.invalidate(leasesListProvider);
      if (mounted) {
        context.go('/more/leases');
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Create lease')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Lease details'),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _propertyController,
              decoration: const InputDecoration(
                labelText: 'Property ID',
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
                labelText: 'Tenant ID',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a tenant ID.'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Start date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'End date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Financials'),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _rentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rent amount'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _depositController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Deposit amount'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
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
                    : const Text('Create lease'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
