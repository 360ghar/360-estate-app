import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/more/tenants/presentation/move_in_checklist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Move-out inspection checklist page
/// Compares current condition with move-in condition
class MoveOutChecklistPage extends ConsumerStatefulWidget {
  const MoveOutChecklistPage({
    super.key,
    this.propertyId,
    this.tenantId,
    this.leaseId,
    this.moveInChecklistId,
  });

  final String? propertyId;
  final String? tenantId;
  final String? leaseId;
  final String? moveInChecklistId;

  @override
  ConsumerState<MoveOutChecklistPage> createState() => _MoveOutChecklistPageState();
}

class _MoveOutChecklistPageState extends ConsumerState<MoveOutChecklistPage> {
  final Map<String, ChecklistItem> _moveOutItems = {};
  final Map<String, ChecklistItem> _moveInItems = {}; // Loaded from database
  final _notesController = TextEditingController();
  final _depositDeductionController = TextEditingController();

  bool _isSaving = false;
  DateTime _inspectionDate = DateTime.now();

  // Deposit deduction calculations
  double _totalDeposit = 0.0;
  double _totalDeductions = 0.0;
  final Map<String, double> _deductions = {};

  @override
  void initState() {
    super.initState();
    _initializeChecklist();
  }

  void _initializeChecklist() {
    // Initialize move-out items (same as move-in by default)
    for (var item in defaultChecklistItems) {
      _moveOutItems[item.id] = item.copyWith(condition: ItemCondition.good);
    }

    // TODO: Load move-in checklist from database
    // For now, use default values
    for (var item in defaultChecklistItems) {
      _moveInItems[item.id] = item;
    }

    // TODO: Load deposit amount from lease API
    // The deposit amount should be fetched from the lease details
    _totalDeposit = 0.0; // Will be loaded from API when lease data is available
  }

  @override
  void dispose() {
    _notesController.dispose();
    _depositDeductionController.dispose();
    super.dispose();
  }

  void _updateCondition(String itemId, ItemCondition condition) {
    setState(() {
      _moveOutItems[itemId] = _moveOutItems[itemId]!.copyWith(condition: condition);
      _calculateDeductions();
    });
  }

  void _calculateDeductions() {
    double total = 0;
    _deductions.clear();

    _moveOutItems.forEach((itemId, moveOutItem) {
      final moveInItem = _moveInItems[itemId];
      if (moveInItem == null) return;

      // Calculate deduction if condition worsened
      if (_getConditionValue(moveOutItem.condition) <
          _getConditionValue(moveInItem.condition)) {
        // Deduction amount based on severity
        final deduction = _calculateItemDeduction(moveInItem, moveOutItem);
        if (deduction > 0) {
          _deductions[itemId] = deduction;
          total += deduction;
        }
      }
    });

    setState(() {
      _totalDeductions = total;
    });
  }

  int _getConditionValue(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.excellent:
        return 4;
      case ItemCondition.good:
        return 3;
      case ItemCondition.fair:
        return 2;
      case ItemCondition.poor:
        return 1;
      case ItemCondition.notApplicable:
        return 0;
    }
  }

  double _calculateItemDeduction(ChecklistItem moveOutItem, ChecklistItem moveInItem) {
    // Simplified deduction calculation
    final difference = _getConditionValue(moveInItem.condition) -
        _getConditionValue(moveOutItem.condition);

    switch (moveOutItem.name.toLowerCase()) {
      case 'walls & ceiling':
      case 'walls & floor':
        return difference * 5000;
      case 'flooring':
        return difference * 3000;
      case 'wardrobe':
      case 'cabinets':
        return difference * 2000;
      case 'geyser':
      case 'ac/cooler':
        return difference * 4000;
      default:
        return difference * 1000;
    }
  }

  double get _refundableAmount => _totalDeposit - _totalDeductions;

  Future<void> _selectInspectionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inspectionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      setState(() => _inspectionDate = picked);
    }
  }

  Future<void> _saveChecklist() async {
    setState(() => _isSaving = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving move-out checklists is not available yet.'),
      ),
    );
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final itemsByCategory = <String, List<ChecklistItem>>{};
    for (var item in _moveOutItems.values) {
      itemsByCategory.putIfAbsent(item.category, () => []);
      if (!itemsByCategory[item.category]!.any((i) => i.id == item.id)) {
        itemsByCategory[item.category]!.add(item);
      }
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Move-Out Checklist'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChecklist,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      scrollable: true,
      body: Column(
        children: [
          // Deposit Summary Card - Prominent tinted card
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppCard(
              variant: AppCardVariant.tinted,
              tintColor: _totalDeductions > 0
                  ? AppColors.danger
                  : AppColors.success,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Security Deposit Summary',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _DepositRow(
                    label: 'Total Deposit',
                    amount: _totalDeposit,
                    isBold: true,
                  ),
                  _DepositRow(
                    label: 'Total Deductions',
                    amount: _totalDeductions,
                    amountColor: _totalDeductions > 0 ? AppColors.danger : null,
                    prefix: _totalDeductions > 0 ? '- ' : '',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Divider(
                      height: 1,
                      color: AppColors.cardBorder,
                    ),
                  ),
                  _DepositRow(
                    label: 'Refundable Amount',
                    amount: _refundableAmount,
                    isBold: true,
                    amountColor: _refundableAmount >= 0
                        ? AppColors.success
                        : AppColors.danger,
                    isLarge: true,
                  ),
                ],
              ),
            ),
          ),

          // Deductions Details
          if (_deductions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSectionCard(
                title: 'Deduction Details',
                icon: Icons.receipt_long_outlined,
                iconColor: AppColors.danger,
                children: [
                  ..._deductions.entries.map((entry) {
                    final item = _moveOutItems[entry.key];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item?.name ?? entry.key,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '- \u20B9${entry.value.toInt()}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

          if (_deductions.isNotEmpty)
            const SizedBox(height: AppSpacing.lg),

          // Inspection Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppSectionCard(
              title: 'Inspection Details',
              icon: Icons.calendar_today_outlined,
              children: [
                InkWell(
                  onTap: _selectInspectionDate,
                  borderRadius: AppRadii.md,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Inspection Date',
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${_inspectionDate.day}/${_inspectionDate.month}/${_inspectionDate.year}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section title for comparison
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                    borderRadius: AppRadii.sm,
                  ),
                  child: Icon(
                    Icons.compare_arrows_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Condition Comparison',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Move-In vs Move-Out',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          ...itemsByCategory.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: _ComparisonCategorySection(
                category: entry.key,
                items: entry.value,
                moveInItems: _moveInItems,
                onConditionChanged: _updateCondition,
              ),
            );
          }),

          // Additional Notes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppSectionCard(
              title: 'Additional Notes',
              icon: Icons.note_outlined,
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Overall Notes',
                    hintText: 'Any additional observations or notes',
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Signatures Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppSectionCard(
              title: 'Signatures',
              icon: Icons.draw_outlined,
              children: [
                _SignatureRow(
                  label: 'Landlord/Manager',
                  onTap: () => _showSignatureDialog(context, 'Landlord'),
                ),
                const Divider(height: AppSpacing.xl),
                _SignatureRow(
                  label: 'Tenant',
                  onTap: () => _showSignatureDialog(context, 'Tenant'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showSignatureDialog(BuildContext context, String signer) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$signer Signature'),
        content: const Text('Signature capture will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sign'),
          ),
        ],
      ),
    ));
  }
}

class _DepositRow extends StatelessWidget {
  const _DepositRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.amountColor,
    this.prefix = '',
    this.isLarge = false,
  });

  final String label;
  final double amount;
  final bool isBold;
  final Color? amountColor;
  final String prefix;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isLarge ? textTheme.titleSmall : textTheme.bodyMedium)?.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            '$prefix\u20B9${amount.abs().toInt()}',
            style: (isLarge ? textTheme.titleMedium : textTheme.bodyMedium)?.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonCategorySection extends StatelessWidget {
  const _ComparisonCategorySection({
    required this.category,
    required this.items,
    required this.moveInItems,
    required this.onConditionChanged,
  });

  final String category;
  final List<ChecklistItem> items;
  final Map<String, ChecklistItem> moveInItems;
  final void Function(String itemId, ItemCondition condition) onConditionChanged;

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'living room':
        return Icons.weekend_outlined;
      case 'bedroom':
        return Icons.bed_outlined;
      case 'kitchen':
        return Icons.kitchen_outlined;
      case 'bathroom':
        return Icons.bathroom_outlined;
      default:
        return Icons.room_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: category,
      icon: _categoryIcon(category),
      contentPadding: EdgeInsets.zero,
      children: [
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final moveInCondition =
              moveInItems[item.id]?.condition ?? ItemCondition.good;
          final worsened = _getConditionValue(item.condition) <
              _getConditionValue(moveInCondition);
          final changed = item.condition != moveInCondition;

          return Column(
            children: [
              if (index > 0)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: AppColors.cardBorder,
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _ComparisonItemTile(
                  name: item.name,
                  moveInCondition: moveInCondition,
                  moveOutCondition: item.condition,
                  onChanged: (condition) =>
                      onConditionChanged(item.id, condition),
                  worsened: worsened,
                  changed: changed,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  int _getConditionValue(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.excellent:
        return 4;
      case ItemCondition.good:
        return 3;
      case ItemCondition.fair:
        return 2;
      case ItemCondition.poor:
        return 1;
      case ItemCondition.notApplicable:
        return 0;
    }
  }
}

Color _semanticConditionColor(ItemCondition condition) {
  switch (condition) {
    case ItemCondition.excellent:
      return AppColors.success;
    case ItemCondition.good:
      return AppColors.info;
    case ItemCondition.fair:
      return AppColors.warning;
    case ItemCondition.poor:
      return AppColors.danger;
    case ItemCondition.notApplicable:
      return AppColors.textTertiary;
  }
}

class _ComparisonItemTile extends StatelessWidget {
  const _ComparisonItemTile({
    required this.name,
    required this.moveInCondition,
    required this.moveOutCondition,
    required this.onChanged,
    this.worsened = false,
    this.changed = false,
  });

  final String name;
  final ItemCondition moveInCondition;
  final ItemCondition moveOutCondition;
  final void Function(ItemCondition) onChanged;
  final bool worsened;
  final bool changed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: textTheme.titleSmall,
              ),
            ),
            if (worsened)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: AppRadii.pill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Damaged',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ConditionDisplay(
                label: 'Move-In',
                condition: moveInCondition,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ),
            Expanded(
              child: _ConditionDisplay(
                label: 'Move-Out',
                condition: moveOutCondition,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Condition selector chips
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: ItemCondition.values
              .where((c) => c != ItemCondition.notApplicable)
              .map((c) {
            final isSelected = moveOutCondition == c;
            final chipColor = _semanticConditionColor(c);
            return GestureDetector(
              onTap: () => onChanged(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? chipColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: AppRadii.pill,
                  border: Border.all(
                    color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  c.label,
                  style: TextStyle(
                    color: isSelected ? chipColor : chipColor.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ConditionDisplay extends StatelessWidget {
  const _ConditionDisplay({
    required this.label,
    required this.condition,
  });

  final String label;
  final ItemCondition condition;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final conditionColor = _semanticConditionColor(condition);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: conditionColor.withValues(alpha: 0.08),
            borderRadius: AppRadii.md,
            border: Border.all(
              color: conditionColor.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              condition.label,
              style: TextStyle(
                color: conditionColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignatureRow extends StatelessWidget {
  const _SignatureRow({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    border: Border.all(color: AppColors.cardBorder),
                    borderRadius: AppRadii.md,
                  ),
                  child: Center(
                    child: Text(
                      'Tap to sign',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
