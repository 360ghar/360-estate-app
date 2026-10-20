import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_category_visual.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key, this.expenseId});

  final String? expenseId;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.other;
  int? _propertyId;
  DateTime _date = DateTime.now();

  bool _initialized = false;
  bool _isSaving = false;

  bool get _isEdit => widget.expenseId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populate(Expense expense) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = expense.title ?? '';
    final amount = expense.amount;
    _amountController.text = amount == null
        ? ''
        : amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toString();
    _notesController.text = expense.notes ?? '';
    _date = expense.date ?? _date;
    _category = expense.category ?? ExpenseCategory.other;
    _propertyId = expense.propertyId;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _date,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final propertyId = _propertyId;
    if (propertyId == null) return;
    setState(() => _isSaving = true);
    try {
      final payload = ExpensePayload(
        propertyId: propertyId,
        title: _titleController.text,
        amount: double.parse(_amountController.text.trim()),
        date: _date,
        category: _category,
        notes: _notesController.text,
      );
      final repository = ref.read(expensesRepositoryProvider);
      final expenseId = int.tryParse(widget.expenseId ?? '');
      if (!_isEdit) {
        await repository.create(payload);
      } else if (expenseId != null) {
        await repository.update(expenseId, payload);
      }
      ref
        ..invalidate(expensesListProvider)
        ..invalidate(expensesForPropertyProvider);
      if (!mounted) return;
      context.showSnack(context.l10n.expenseFormSaved);
      context.go('/more/expenses');
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = Text(
      _isEdit ? l10n.expenseFormEditTitle : l10n.expenseFormNewTitle,
    );

    if (_isEdit && !_initialized) {
      final expenses = ref.watch(expensesListProvider);
      final body = expenses.when(
        loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 140),
        error: (error, _) => AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: userFacingMessage(error),
          onRetry: () => ref.invalidate(expensesListProvider),
        ),
        data: (items) {
          final match = items.where(
            (e) => e.id?.toString() == widget.expenseId,
          );
          if (match.isEmpty) {
            return AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: l10n.expenseFormNotFound,
            );
          }
          _populate(match.first);
          return null;
        },
      );
      if (body != null) {
        return Scaffold(
          appBar: AppBar(title: title),
          body: body,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: title),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            AppSectionCard(
              title: l10n.expenseFormDetails,
              children: [
                TextFormField(
                  controller: _amountController,
                  autofocus: !_isEdit,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.currencyMedium.copyWith(
                    color: context.colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.expenseFormAmount,
                    prefixText: '₹ ',
                    prefixStyle: AppTextStyles.currencyMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    return parsed == null || parsed <= 0
                        ? l10n.expenseFormAmountError
                        : null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertyField(
                  value: _propertyId,
                  onChanged: (value) => setState(() => _propertyId = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: l10n.expenseFormTitleLabel,
                    hintText: l10n.expenseFormTitleHint,
                    helperText: l10n.expenseFormNotesHelper,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  button: true,
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.expenseFormDate,
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(shortDate(context, _date)),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.expenseFormNotes,
                    helperText: l10n.expenseFormNotesHelper,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.expenseFormCategory,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final c in ExpenseCategory.values)
                      ChoiceChip(
                        avatar: Icon(c.icon, size: 18),
                        label: Text(c.text(l10n)),
                        selected: _category == c,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: l10n.commonLoading,
                      ),
                    )
                  : Text(
                      _isEdit ? l10n.expenseFormSave : l10n.expenseFormCreate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The property picker. The backend requires a property for every expense.
class _PropertyField extends ConsumerWidget {
  const _PropertyField({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ref
        .watch(propertiesListProvider)
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Row(
            children: [
              Expanded(
                child: Text(
                  l10n.expenseFormPropertiesFailed,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(propertiesListProvider),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
          data: (properties) {
            final choices = [
              for (final p in properties)
                if (p.id != null) p,
            ];
            return DropdownButtonFormField<int>(
              // A new key rebuilds the field when an edit loads its property
              // after the picker is on screen.
              key: ValueKey('property-$value'),
              initialValue: choices.any((p) => p.id == value) ? value : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.expenseFormProperty),
              items: [
                for (final p in choices)
                  DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.displayName, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onChanged,
              validator: (v) =>
                  v == null ? l10n.expenseFormPropertyError : null,
            );
          },
        );
  }
}
