import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/more/tenants/presentation/move_in_checklist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final _imagePicker = ImagePicker();
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
    final itemsByCategory = {
      for (var item in _moveOutItems.values)
        item.category: _moveOutItems.values.where((i) => i.category == item.category).toList(),
    };

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
          // Summary Card
          Card(
            margin: const EdgeInsets.all(AppSpacing.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Deposit Summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DepositRow(
                    label: 'Total Deposit',
                    amount: _totalDeposit,
                    isBold: true,
                  ),
                  _DepositRow(
                    label: 'Total Deductions',
                    amount: _totalDeductions,
                    amountColor: _totalDeductions > 0 ? Colors.red : null,
                  ),
                  const Divider(),
                  _DepositRow(
                    label: 'Refundable Amount',
                    amount: _refundableAmount,
                    isBold: true,
                    amountColor: _refundableAmount > 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // Deductions Details
          if (_deductions.isNotEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deduction Details',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ..._deductions.entries.map((entry) {
                      final item = _moveOutItems[entry.key];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(item?.name ?? entry.key)),
                            Text('- ₹${entry.value.toInt()}'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.lg),

          // Inspection Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: InkWell(
              onTap: _selectInspectionDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Inspection Date',
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${_inspectionDate.day}/${_inspectionDate.month}/${_inspectionDate.year}',
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Comparison View
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: const SectionHeader(title: 'Condition Comparison (Move-In → Move-Out)'),
          ),
          const SizedBox(height: AppSpacing.md),

          ...itemsByCategory.entries.map((entry) {
            return _ComparisonCategorySection(
              category: entry.key,
              items: entry.value,
              moveInItems: _moveInItems,
              onConditionChanged: _updateCondition,
            );
          }),

          // Additional Notes
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Additional Notes'),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Overall Notes',
                    hintText: 'Any additional observations or notes',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Signatures Section
                const SectionHeader(title: 'Signatures'),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        _SignatureRow(
                          label: 'Landlord/Manager',
                          onTap: () => _showSignatureDialog(context, 'Landlord'),
                        ),
                        const Divider(height: AppSpacing.lg),
                        _SignatureRow(
                          label: 'Tenant',
                          onTap: () => _showSignatureDialog(context, 'Tenant'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignatureDialog(BuildContext context, String signer) {
    showDialog(
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
    );
  }
}

class _DepositRow extends StatelessWidget {
  const _DepositRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.amountColor,
  });

  final String label;
  final double amount;
  final bool isBold;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Text(
            '₹${amount.toInt()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
  final Function(String itemId, ItemCondition condition) onConditionChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      child: ExpansionTile(
        title: Text(category),
        initiallyExpanded: true,
        children: items.map((item) {
          final moveInCondition = moveInItems[item.id]?.condition ?? ItemCondition.good;
          final conditionChanged = item.condition != moveInCondition;
          final worsened = _getConditionValue(item.condition) < _getConditionValue(moveInCondition);

          return _ComparisonItemTile(
            name: item.name,
            moveInCondition: moveInCondition,
            moveOutCondition: item.condition,
            onChanged: (condition) => onConditionChanged(item.id, condition),
            worsened: worsened,
            changed: conditionChanged,
          );
        }).toList(),
      ),
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
  final Function(ItemCondition) onChanged;
  final bool worsened;
  final bool changed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (worsened)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    'Damaged',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _ConditionSelector(
                  label: 'Move-In',
                  condition: moveInCondition,
                  isReadOnly: true,
                ),
              ),
              const Icon(Icons.arrow_forward, size: 20),
              Expanded(
                child: _ConditionSelector(
                  label: 'Move-Out',
                  condition: moveOutCondition,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConditionSelector extends StatelessWidget {
  const _ConditionSelector({
    required this.label,
    required this.condition,
    this.onChanged,
    this.isReadOnly = false,
  });

  final String label;
  final ItemCondition condition;
  final Function(ItemCondition)? onChanged;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: condition.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: condition.color),
          ),
          child: Center(
            child: Text(
              condition.label,
              style: TextStyle(
                color: condition.color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        if (!isReadOnly && onChanged != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: ItemCondition.values.where((c) => c != ItemCondition.notApplicable).map((c) {
              return InkWell(
                onTap: () => onChanged?.call(c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: condition == c ? c.color.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: c.color.withOpacity(0.5)),
                  ),
                  child: Text(
                    c.label.substring(0, 1), // First letter only
                    style: TextStyle(
                      color: c.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'Tap to sign',
                      style: TextStyle(color: Colors.grey),
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
