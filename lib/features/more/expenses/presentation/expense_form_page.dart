import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const _expenseCategories = [
  'Repairs',
  'Utilities',
  'Tax',
  'Insurance',
  'Staff',
  'Legal',
  'Furniture',
  'Travel',
  'Other',
];

const _categoryIcons = {
  'Repairs': Icons.build_rounded,
  'Utilities': Icons.bolt_rounded,
  'Tax': Icons.account_balance_rounded,
  'Insurance': Icons.shield_rounded,
  'Staff': Icons.people_rounded,
  'Legal': Icons.gavel_rounded,
  'Furniture': Icons.chair_rounded,
  'Travel': Icons.directions_car_rounded,
  'Other': Icons.receipt_long_rounded,
};

const _categoryColors = {
  'Repairs': Color(0xFFF59E0B),
  'Utilities': Color(0xFF3B82F6),
  'Tax': Color(0xFF8B5CF6),
  'Insurance': Color(0xFF0284C7),
  'Staff': Color(0xFF059669),
  'Legal': Color(0xFFDC2626),
  'Furniture': Color(0xFF14B8A6),
  'Travel': Color(0xFF6366F1),
  'Other': Color(0xFF6B7280),
};

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
  String _selectedCategory = _expenseCategories.last;
  DateTime _date = DateTime.now();

  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populate(Expense expense) {
    if (_initialized) return;
    _titleController.text = expense.title ?? '';
    _amountController.text = expense.amount?.toString() ?? '';
    _notesController.text = expense.notes ?? '';
    _date = expense.date ?? _date;
    // Try to match category
    if (expense.category != null) {
      final match = _expenseCategories.firstWhere(
        (c) => c.toLowerCase() == expense.category!.toLowerCase(),
        orElse: () => _expenseCategories.last,
      );
      _selectedCategory = match;
    }
    _initialized = true;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _date,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);

    try {
      final payload = ExpensePayload(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _date,
        category: _selectedCategory,
        notes: _notesController.text.trim(),
      );

      final repository = ref.read(expensesRepositoryProvider);
      if (widget.expenseId == null) {
        await repository.create(payload);
      } else {
        await repository.update(widget.expenseId!, payload);
      }

      ref.invalidate(expensesListProvider);

      if (mounted) {
        context.go('/more/expenses');
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
    final isEdit = widget.expenseId != null;
    final expensesAsync = isEdit ? ref.watch(expensesListProvider) : null;

    if (expensesAsync != null) {
      expensesAsync.whenData((items) {
        final match = items.firstWhere(
          (item) => item.id?.toString() == widget.expenseId,
          orElse: () => const Expense(),
        );
        if (match.id != null) {
          _populate(match);
        }
      });
    }

    final scheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('dd MMM yyyy').format(_date);

    return AppScaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit expense' : 'New expense')),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prominent amount field
            AppSectionCard(
              title: 'Amount',
              icon: Icons.currency_rupee_rounded,
              iconColor: AppColors.success,
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.currencyLarge.copyWith(
                    color: scheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTextStyles.currencyLarge.copyWith(
                      color: AppColors.textDisabled,
                    ),
                    prefixText: '\u20B9 ',
                    prefixStyle: AppTextStyles.currencyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
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
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Details section
            AppSectionCard(
              title: 'Details',
              icon: Icons.info_outline_rounded,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Expense title',
                    hintText: 'e.g. Plumbing repair',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter a title.'
                          : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Date picker
                InkWell(
                  borderRadius: AppRadii.md,
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today_rounded, size: 20),
                    ),
                    child: Text(dateLabel),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Optional notes about this expense',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Category section with icon chips
            AppSectionCard(
              title: 'Category',
              icon: Icons.category_rounded,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _expenseCategories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    final color = _categoryColors[cat] ?? AppColors.textSecondary;
                    final icon = _categoryIcons[cat] ?? Icons.receipt_long_rounded;

                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 16,
                            color: isSelected ? scheme.onPrimary : color,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(cat),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      selectedColor: color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEdit ? 'Save changes' : 'Create expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
