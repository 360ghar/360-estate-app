import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
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

  static const _paymentMethods = [
    _PaymentMethodOption('Cash', Icons.payments_outlined),
    _PaymentMethodOption('UPI', Icons.qr_code_2_outlined),
    _PaymentMethodOption('Bank Transfer', Icons.account_balance_outlined),
    _PaymentMethodOption('Cheque', Icons.description_outlined),
  ];

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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Charge summary card at top (if charge ID provided)
            if (widget.chargeId != null) ...[
              AppCard(
                variant: AppCardVariant.tinted,
                tintColor: scheme.primary,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: AppRadii.sm,
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 20,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paying for Charge',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Charge #${widget.chargeId}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Amount section - prominent display
            AppSectionCard(
              title: 'Payment Amount',
              icon: Icons.currency_rupee_outlined,
              iconColor: AppColors.success,
              contentPadding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg,
              ),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: AppColors.success,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '\u20B9',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.lg,
                    borderSide: BorderSide(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.lg,
                    borderSide: BorderSide(
                      color: AppColors.success,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.success.withValues(alpha: isDark ? 0.08 : 0.04),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.md,
                  ),
                ),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Payment details section
            AppSectionCard(
              title: 'Payment Details',
              icon: Icons.info_outline,
              children: [
                // Tenant dropdown
                tenantsAsync.when(
                  data: (tenants) {
                    return DropdownButtonFormField<Tenant>(
                      initialValue: _selectedTenant,
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
                      decoration: const InputDecoration(
                        labelText: 'Tenant',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                      ),
                      validator: (value) =>
                          value == null ? 'Select a tenant.' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text('Failed to load tenants: $error'),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Payment method selector
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _PaymentMethodSelector(
                  methods: _paymentMethods,
                  selected: _method,
                  onChanged: (value) => setState(() => _method = value),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Payment date
                InkWell(
                  onTap: _pickDate,
                  borderRadius: AppRadii.md,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Payment Date',
                      prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                      suffixIcon: Icon(Icons.edit_outlined, size: 18),
                    ),
                    child: Text(dateLabel),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.note_outlined, size: 20),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _submit,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isSaving ? 'Saving...' : 'Record Payment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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

/// Payment method data.
class _PaymentMethodOption {
  final String label;
  final IconData icon;

  const _PaymentMethodOption(this.label, this.icon);
}

/// Styled payment method selector as a row of selectable chips.
class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({
    required this.methods,
    required this.selected,
    required this.onChanged,
  });

  final List<_PaymentMethodOption> methods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: methods.map((method) {
        final isSelected = method.label == selected;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(method.label),
            borderRadius: AppRadii.md,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08)
                    : Colors.transparent,
                borderRadius: AppRadii.md,
                border: Border.all(
                  color: isSelected
                      ? scheme.primary
                      : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    method.icon,
                    size: 18,
                    color: isSelected ? scheme.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    method.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? scheme.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
