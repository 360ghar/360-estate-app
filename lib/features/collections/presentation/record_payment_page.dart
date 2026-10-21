import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/submit_bar.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/presentation/rent_status_text.dart';
import 'package:estate_app/features/collections/presentation/widgets/charge_receipt.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Records money received against one open rent charge.
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
  final _dateController = TextEditingController();

  /// The charge the payment is for. The route can preselect it (`chargeId`).
  int? _chargeId;
  DateTime _paidAt = DateTime.now();
  PaymentMethod _method = PaymentMethod.cash;
  bool _isSaving = false;

  /// The amount is filled once from a charge the route preselected.
  bool _amountPrefilled = false;

  @override
  void initState() {
    super.initState();
    _chargeId = int.tryParse(widget.chargeId ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateController.text = shortDate(context, _paidAt);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _paidAt,
    );
    if (picked == null || !mounted) return;
    // `paid_at` is an instant. The picker gives local midnight, which is the
    // evening before in UTC. Keep the clock time for today and use local noon
    // for another day, so the UTC date stays the date the user picked.
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(picked, now);
    setState(() {
      _paidAt = isToday
          ? now
          : DateTime(picked.year, picked.month, picked.day, 12);
      _dateController.text = shortDate(context, _paidAt);
    });
  }

  /// Chooses a charge and fills the amount with its balance.
  void _selectCharge(RentChargeWithTotals? row) {
    setState(() {
      _amountPrefilled = true;
      _chargeId = row?.id;
      if (row != null) _amountController.text = row.balance.toStringAsFixed(2);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final chargeId = _chargeId;
    if (chargeId == null) {
      context.showSnack(context.l10n.paymentChargeRequired);
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref
          .read(rentRepositoryProvider)
          .recordPayment(
            RentPaymentRequest(
              chargeId: chargeId,
              amountPaid: double.parse(_amountController.text.trim()),
              paidAt: _paidAt,
              paymentMethod: _method,
              notes: _notesController.text,
            ),
          );
      ref
        ..invalidate(allRentChargesProvider)
        ..invalidate(unpaidRentChargesProvider)
        ..invalidate(rentChargesPagedProvider)
        ..invalidate(rentChargesForPropertyProvider)
        ..invalidate(dashboardOverviewProvider)
        ..invalidate(dashboardActivityProvider);
      if (!mounted) return;
      context.showSnack(context.l10n.paymentRecorded);
      context.go('/collections');
    } catch (error) {
      // A 400 such as "exceeds outstanding balance" carries the backend text.
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chargesAsync = ref.watch(unpaidRentChargesProvider);
    final tenants = ref.watch(leaseTenantNamesProvider).valueOrNull;
    final properties = ref.watch(propertyTitlesProvider).valueOrNull;
    final charges = chargesAsync.valueOrNull ?? const <RentChargeWithTotals>[];
    final selected = charges.where((r) => r.id == _chargeId).firstOrNull;

    String tenantOf(RentChargeWithTotals row) =>
        tenants?[row.charge.leaseId] ??
        l10n.commonLeaseNumber('${row.charge.leaseId ?? '-'}');
    String propertyOf(RentChargeWithTotals row) =>
        properties?[row.charge.propertyId] ??
        l10n.commonPropertyNumber('${row.charge.propertyId ?? '-'}');

    // A charge preselected by the route (the row tap) starts with its balance.
    if (selected != null && !_amountPrefilled) {
      _amountPrefilled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _amountController.text.isEmpty) {
          _amountController.text = selected.balance.toStringAsFixed(2);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentTitle)),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              // Every field stays built, so the form validates all of them.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSectionCard(
                      child: chargesAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (error, _) => Row(
                          children: [
                            Expanded(child: Text(userFacingMessage(error))),
                            TextButton(
                              onPressed: () =>
                                  ref.invalidate(allRentChargesProvider),
                              child: Text(l10n.commonRetry),
                            ),
                          ],
                        ),
                        data: (charges) => charges.isEmpty
                            ? Text(
                                l10n.paymentNoCharges,
                                style: context.text.bodyMedium?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              )
                            : DropdownButtonFormField<RentChargeWithTotals>(
                                initialValue: selected,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: l10n.paymentChargeLabel,
                                ),
                                selectedItemBuilder: (context) => [
                                  for (final row in charges)
                                    Text(
                                      '${tenantOf(row)}  \u00B7  '
                                      '${propertyOf(row)}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                                items: [
                                  for (final row in charges)
                                    DropdownMenuItem(
                                      value: row,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.sm,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${tenantOf(row)}  \u00B7  '
                                              '${propertyOf(row)}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              [
                                                l10n.paymentOwed(
                                                  rupees(row.balance),
                                                ),
                                                if (row.dueDate != null)
                                                  l10n.paymentDueShort(
                                                    shortDate(
                                                      context,
                                                      row.dueDate!,
                                                    ),
                                                  ),
                                              ].join('  \u00B7  '),
                                              style: context.text.bodySmall
                                                  ?.copyWith(
                                                    color: context
                                                        .colors
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                                onChanged: _selectCharge,
                                validator: (value) => value == null
                                    ? l10n.paymentChargeRequired
                                    : null,
                              ),
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      ChargeReceipt(
                        row: selected,
                        tenant: tenantOf(selected),
                        property: propertyOf(selected),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.paymentDetailsSection,
                      children: [
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          textInputAction: TextInputAction.next,
                          style: AppTextStyles.currencyMedium.copyWith(
                            color: context.colors.onSurface,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.paymentAmountLabel,
                            prefixText: '₹ ',
                            prefixStyle: AppTextStyles.currencyMedium.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                            helperText: selected == null
                                ? null
                                : l10n.paymentAmountHelper,
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed <= 0) {
                              return l10n.paymentAmountInvalid;
                            }
                            // Two decimals of slack: the field shows paise.
                            if (selected != null &&
                                parsed > selected.balance + 0.005) {
                              return l10n.paymentAmountTooHigh(
                                rupees(selected.balance),
                              );
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.paymentMethodLabel,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            for (final method in PaymentMethod.values)
                              ChoiceChip(
                                label: Text(method.text(l10n)),
                                selected: _method == method,
                                onSelected: (_) =>
                                    setState(() => _method = method),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: InputDecoration(
                            labelText: l10n.paymentDateLabel,
                            suffixIcon: const Icon(Icons.event_outlined),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _notesController,
                          minLines: 2,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: l10n.paymentNotesLabel,
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SubmitBar(
              label: l10n.homeRecordPayment,
              busy: _isSaving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
