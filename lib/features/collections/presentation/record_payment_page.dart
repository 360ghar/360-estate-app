import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecordPaymentPage extends ConsumerStatefulWidget {
  const RecordPaymentPage({super.key, this.chargeId});

  final String? chargeId;

  @override
  ConsumerState<RecordPaymentPage> createState() => _RecordPaymentPageState();
}

class _RecordPaymentPageState extends ConsumerState<RecordPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  Tenant? _selectedTenant;
  DateTime _paidAt = DateTime.now();
  String _method = 'Cash';
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _paidAt,
    );
    if (picked != null) {
      setState(() => _paidAt = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedTenant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a tenant.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final request = RentPaymentRequest(
        tenantId: _selectedTenant!.id?.toString() ?? '',
        amount: double.parse(_amountController.text.trim()),
        paidAt: _paidAt,
        method: _method,
        notes: _notesController.text.trim(),
      );
      await ref.read(rentRepositoryProvider).recordPayment(request);
      ref.invalidate(rentChargesProvider);
      ref.invalidate(rentChargesPagedProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded.')),
        );
        context.go('/collections');
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
    final tenantsAsync = ref.watch(tenantsListProvider);
    final dateLabel = DateFormat('dd MMM yyyy').format(_paidAt);

    return AppScaffold(
      appBar: AppBar(title: const Text('Record payment')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.chargeId != null)
              Text('Charge ID: ${widget.chargeId}'),
            const SizedBox(height: AppSpacing.md),
            tenantsAsync.when(
              data: (tenants) {
                return DropdownButtonFormField<Tenant>(
                  value: _selectedTenant,
                  items: tenants
                      .map(
                        (tenant) => DropdownMenuItem(
                          value: tenant,
                          child: Text(tenant.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedTenant = value),
                  decoration: const InputDecoration(labelText: 'Tenant'),
                  validator: (value) =>
                      value == null ? 'Select a tenant.' : null,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Failed to load tenants: $error'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (INR)'),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount.';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _method,
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
                DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
              ],
              onChanged: (value) => setState(() => _method = value ?? 'Cash'),
              decoration: const InputDecoration(labelText: 'Payment method'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Payment date'),
                    child: Text(dateLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick date'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
                    : const Text('Save payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
