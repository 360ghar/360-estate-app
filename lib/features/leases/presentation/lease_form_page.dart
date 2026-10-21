import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/submit_bar.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The statuses `POST /pm/leases` accepts. Any other value gives 422.
const _createStatuses = [
  LeaseStatus.draft,
  LeaseStatus.pendingSignature,
  LeaseStatus.active,
];

final _digits = FilteringTextInputFormatter.digitsOnly;
final _decimal = FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));

class LeaseFormPage extends ConsumerStatefulWidget {
  const LeaseFormPage({super.key});

  @override
  ConsumerState<LeaseFormPage> createState() => _LeaseFormPageState();
}

class _LeaseFormPageState extends ConsumerState<LeaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tenantUserId = TextEditingController();
  final _tenantName = TextEditingController();
  final _tenantPhone = TextEditingController();
  final _tenantEmail = TextEditingController();
  final _startText = TextEditingController();
  final _endText = TextEditingController();
  final _rent = TextEditingController();
  final _deposit = TextEditingController();
  final _dueDay = TextEditingController();
  final _grace = TextEditingController();
  final _lateFeeAmount = TextEditingController();
  final _lateFeePercent = TextEditingController();
  final _clauses = TextEditingController();

  Property? _property;
  LeaseStatus _status = LeaseStatus.draft;
  DateTime? _start;
  DateTime? _end;
  bool _isSaving = false;

  @override
  void dispose() {
    for (final c in [
      _tenantUserId,
      _tenantName,
      _tenantPhone,
      _tenantEmail,
      _startText,
      _endText,
      _rent,
      _deposit,
      _dueDay,
      _grace,
      _lateFeeAmount,
      _lateFeePercent,
      _clauses,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _start : _end) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _start = picked;
        _startText.text = shortDate(context, picked);
      } else {
        _end = picked;
        _endText.text = shortDate(context, picked);
      }
    });
  }

  void _pickProperty(Property? property) {
    setState(() {
      _property = property;
      // The rent and the deposit start from the property's values.
      if (property == null) return;
      if (_rent.text.trim().isEmpty && property.monthlyRent != null) {
        _rent.text = _plain(property.monthlyRent!);
      }
      if (_deposit.text.trim().isEmpty && property.securityDeposit != null) {
        _deposit.text = _plain(property.securityDeposit!);
      }
    });
  }

  /// 12000.0 shows as 12000, 12000.5 keeps its decimals.
  String _plain(double amount) => amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toString();

  /// An optional amount: blank is fine, anything else must be zero or more.
  String? _optionalAmount(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final parsed = double.tryParse(text);
    return parsed == null || parsed < 0
        ? context.l10n.leaseFormAmountInvalid
        : null;
  }

  String? _wholeNumber(String? value, {required int min, required int max}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final parsed = int.tryParse(text);
    return parsed == null || parsed < min || parsed > max
        ? context.l10n.leaseFormRange(min, max)
        : null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    try {
      await ref
          .read(leasesRepositoryProvider)
          .create(
            LeaseCreateRequest(
              propertyId: _property!.id!,
              startDate: _start!,
              endDate: _end!,
              monthlyRent: double.parse(_rent.text.trim()),
              securityDeposit: double.tryParse(_deposit.text.trim()) ?? 0,
              tenantUserId: int.tryParse(_tenantUserId.text.trim()),
              tenantName: _tenantName.text,
              tenantPhone: _tenantPhone.text,
              tenantEmail: _tenantEmail.text,
              status: _status,
              paymentDueDay: int.tryParse(_dueDay.text.trim()),
              gracePeriodDays: int.tryParse(_grace.text.trim()),
              lateFeeAmount: double.tryParse(_lateFeeAmount.text.trim()),
              lateFeePercentage: double.tryParse(_lateFeePercent.text.trim()),
              specialClauses: _clauses.text,
            ),
          );
      ref
        ..invalidate(leasesListProvider)
        ..invalidate(leaseTenantNamesProvider);
      if (!mounted) return;
      context.showSnack(context.l10n.leaseFormCreated);
      context.go('/more/leases');
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final properties = ref.watch(propertiesListProvider);
    const gap = SizedBox(height: AppSpacing.lg);
    const next = TextInputAction.next;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaseFormTitle)),
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
                      title: l10n.leaseFormSectionParties,
                      children: [
                        properties.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (error, _) => Row(
                            children: [
                              Expanded(
                                child: Text(l10n.leaseFormPropertiesFailed),
                              ),
                              TextButton(
                                onPressed: () =>
                                    ref.invalidate(propertiesListProvider),
                                child: Text(l10n.commonRetry),
                              ),
                            ],
                          ),
                          data: (list) => DropdownButtonFormField<Property>(
                            initialValue: _property,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.leaseFormProperty,
                            ),
                            items: [
                              for (final property in list)
                                DropdownMenuItem(
                                  value: property,
                                  child: Text(
                                    property.displayName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: _pickProperty,
                            validator: (value) => value?.id == null
                                ? l10n.leaseFormPropertyRequired
                                : null,
                          ),
                        ),
                        gap,
                        TextFormField(
                          controller: _tenantName,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: next,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormTenantName,
                          ),
                        ),
                        gap,
                        TextFormField(
                          controller: _tenantPhone,
                          keyboardType: TextInputType.phone,
                          textInputAction: next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormTenantPhone,
                          ),
                        ),
                        gap,
                        TextFormField(
                          controller: _tenantEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: next,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormTenantEmail,
                          ),
                        ),
                        gap,
                        TextFormField(
                          controller: _tenantUserId,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_digits],
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormTenantUserId,
                            helperText: l10n.leaseFormTenantUserIdHelper,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.leaseFormSectionTerm,
                      children: [
                        TextFormField(
                          controller: _startText,
                          readOnly: true,
                          onTap: () => _pickDate(isStart: true),
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormStart,
                            suffixIcon: const Icon(Icons.event_outlined),
                          ),
                          validator: (_) => _start == null
                              ? l10n.leaseFormDateRequired
                              : null,
                        ),
                        gap,
                        TextFormField(
                          controller: _endText,
                          readOnly: true,
                          onTap: () => _pickDate(isStart: false),
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormEnd,
                            suffixIcon: const Icon(Icons.event_outlined),
                          ),
                          validator: (_) {
                            final end = _end;
                            if (end == null) return l10n.leaseFormDateRequired;
                            final start = _start;
                            return start != null && !end.isAfter(start)
                                ? l10n.leaseEndAfterStart
                                : null;
                          },
                        ),
                        gap,
                        DropdownButtonFormField<LeaseStatus>(
                          initialValue: _status,
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormStatus,
                          ),
                          items: [
                            for (final status in _createStatuses)
                              DropdownMenuItem(
                                value: status,
                                child: Text(status.text(l10n)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _status = value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.leaseFormSectionRent,
                      children: [
                        TextFormField(
                          controller: _rent,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_decimal],
                          textInputAction: next,
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormRent,
                            prefixText: '₹ ',
                            helperText: _property?.monthlyRent == null
                                ? null
                                : l10n.leaseFormFromProperty,
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            return parsed == null || parsed <= 0
                                ? l10n.leaseFormRentInvalid
                                : null;
                          },
                        ),
                        gap,
                        TextFormField(
                          controller: _deposit,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_decimal],
                          decoration: InputDecoration(
                            labelText: l10n.leaseFormDeposit,
                            prefixText: '₹ ',
                          ),
                          validator: _optionalAmount,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.leaseFormSectionRules,
                      children: [
                        Text(
                          l10n.leaseFormRulesHelp,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        gap,
                        _Pair(
                          TextFormField(
                            controller: _dueDay,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_digits],
                            textInputAction: next,
                            decoration: InputDecoration(
                              labelText: l10n.leaseFormDueDay,
                              hintText: '1-28',
                            ),
                            validator: (v) => _wholeNumber(v, min: 1, max: 28),
                          ),
                          TextFormField(
                            controller: _grace,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_digits],
                            textInputAction: next,
                            decoration: InputDecoration(
                              labelText: l10n.leaseFormGraceDays,
                              hintText: '0-365',
                            ),
                            validator: (v) => _wholeNumber(v, min: 0, max: 365),
                          ),
                        ),
                        gap,
                        _Pair(
                          TextFormField(
                            controller: _lateFeeAmount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_decimal],
                            textInputAction: next,
                            decoration: InputDecoration(
                              labelText: l10n.leaseFormLateFeeFlat,
                              prefixText: '₹ ',
                            ),
                            validator: _optionalAmount,
                          ),
                          TextFormField(
                            controller: _lateFeePercent,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_decimal],
                            decoration: InputDecoration(
                              labelText: l10n.leaseFormLateFeePercent,
                              suffixText: '%',
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';
                              if (text.isEmpty) return null;
                              final parsed = double.tryParse(text);
                              return parsed == null ||
                                      parsed < 0 ||
                                      parsed > 100
                                  ? l10n.leaseFormPercentRange
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.leaseFormSectionClauses,
                      child: TextFormField(
                        controller: _clauses,
                        minLines: 2,
                        maxLines: 6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: l10n.leaseFormClauses,
                          hintText: l10n.leaseFormClausesHint,
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SubmitBar(
              label: l10n.leaseFormCreate,
              busy: _isSaving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Two short fields side by side; stacked when the text is large.
class _Pair extends StatelessWidget {
  const _Pair(this.first, this.second);

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.textScalerOf(context).scale(1) > 1.3) {
      return Column(
        children: [
          first,
          const SizedBox(height: AppSpacing.lg),
          second,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }
}
