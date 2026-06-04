import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Condition rating for checklist items
enum ItemCondition {
  excellent('Excellent', Colors.green),
  good('Good', Colors.lightGreen),
  fair('Fair', Colors.orange),
  poor('Poor', Colors.red),
  notApplicable('N/A', Colors.grey);

  const ItemCondition(this.label, this.color);
  final String label;
  final Color color;
}

/// Checklist item for room inspection
class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.name,
    required this.category,
    this.condition = ItemCondition.good,
    this.notes = '',
    this.photos = const [],
  });

  final String id;
  final String name;
  final String category;
  final ItemCondition condition;
  final String notes;
  final List<File> photos;

  ChecklistItem copyWith({
    String? id,
    String? name,
    String? category,
    ItemCondition? condition,
    String? notes,
    List<File>? photos,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
    );
  }
}

/// Default checklist items for different room types
const defaultChecklistItems = [
  // Living Room
  ChecklistItem(id: 'lr_walls', name: 'Walls & Ceiling', category: 'Living Room'),
  ChecklistItem(id: 'lr_floor', name: 'Flooring', category: 'Living Room'),
  ChecklistItem(id: 'lr_windows', name: 'Windows', category: 'Living Room'),
  ChecklistItem(id: 'lr_doors', name: 'Doors', category: 'Living Room'),
  ChecklistItem(id: 'lr_lights', name: 'Lighting', category: 'Living Room'),
  ChecklistItem(id: 'lr_switches', name: 'Switches & Sockets', category: 'Living Room'),
  ChecklistItem(id: 'lr_ac', name: 'AC/Cooler', category: 'Living Room'),

  // Bedroom
  ChecklistItem(id: 'br_walls', name: 'Walls & Ceiling', category: 'Bedroom'),
  ChecklistItem(id: 'br_floor', name: 'Flooring', category: 'Bedroom'),
  ChecklistItem(id: 'br_windows', name: 'Windows', category: 'Bedroom'),
  ChecklistItem(id: 'br_doors', name: 'Doors', category: 'Bedroom'),
  ChecklistItem(id: 'br_wardrobe', name: 'Wardrobe', category: 'Bedroom'),
  ChecklistItem(id: 'br_lights', name: 'Lighting', category: 'Bedroom'),
  ChecklistItem(id: 'br_fans', name: 'Ceiling Fan', category: 'Bedroom'),

  // Kitchen
  ChecklistItem(id: 'kt_walls', name: 'Walls & Ceiling', category: 'Kitchen'),
  ChecklistItem(id: 'kt_floor', name: 'Flooring', category: 'Kitchen'),
  ChecklistItem(id: 'kt_sink', name: 'Sink', category: 'Kitchen'),
  ChecklistItem(id: 'kt_faucet', name: 'Faucet', category: 'Kitchen'),
  ChecklistItem(id: 'kt_taps', name: 'Water Taps', category: 'Kitchen'),
  ChecklistItem(id: 'kt_exhaust', name: 'Exhaust Fan', category: 'Kitchen'),
  ChecklistItem(id: 'kt_cabinets', name: 'Cabinets', category: 'Kitchen'),

  // Bathroom
  ChecklistItem(id: 'bt_walls', name: 'Walls & Floor', category: 'Bathroom'),
  ChecklistItem(id: 'bt_sink', name: 'Sink', category: 'Bathroom'),
  ChecklistItem(id: 'bt_toilet', name: 'Toilet', category: 'Bathroom'),
  ChecklistItem(id: 'bt_shower', name: 'Shower', category: 'Bathroom'),
  ChecklistItem(id: 'bt_faucets', name: 'Faucets', category: 'Bathroom'),
  ChecklistItem(id: 'bt_ventilation', name: 'Ventilation', category: 'Bathroom'),
  ChecklistItem(id: 'bt_geyser', name: 'Geyser', category: 'Bathroom'),
];

/// Move-in inspection checklist page
class MoveInChecklistPage extends ConsumerStatefulWidget {
  const MoveInChecklistPage({
    super.key,
    this.propertyId,
    this.tenantId,
    this.leaseId,
  });

  final String? propertyId;
  final String? tenantId;
  final String? leaseId;

  @override
  ConsumerState<MoveInChecklistPage> createState() => _MoveInChecklistPageState();
}

class _MoveInChecklistPageState extends ConsumerState<MoveInChecklistPage> {
  final _imagePicker = ImagePicker();
  final Map<String, ChecklistItem> _checklistItems = {};
  final _notesController = TextEditingController();
  final _tenantNameController = TextEditingController();
  final _propertyAddressController = TextEditingController();

  bool _isSaving = false;
  DateTime _inspectionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    for (var item in defaultChecklistItems) {
      _checklistItems[item.id] = item;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _tenantNameController.dispose();
    _propertyAddressController.dispose();
    super.dispose();
  }

  void _updateCondition(String itemId, ItemCondition condition) {
    setState(() {
      _checklistItems[itemId] = _checklistItems[itemId]!.copyWith(condition: condition);
    });
  }

  void _updateNotes(String itemId, String notes) {
    setState(() {
      _checklistItems[itemId] = _checklistItems[itemId]!.copyWith(notes: notes);
    });
  }

  Future<void> _addPhoto(String itemId) async {
    final images = await _imagePicker.pickMultiImage();
    if (images.isEmpty) return;

    // Limit to 3 images max
    final limitedImages = images.take(3).toList();

    setState(() {
      final currentPhotos = _checklistItems[itemId]!.photos;
      final newPhotos = [...currentPhotos, ...limitedImages.map((e) => File(e.path))];
      _checklistItems[itemId] = _checklistItems[itemId]!.copyWith(photos: newPhotos);
    });
  }

  Future<void> _selectInspectionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inspectionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      setState(() => _inspectionDate = picked);
    }
  }


  int get _completedCount {
    return _checklistItems.values
        .where((item) => item.condition != ItemCondition.notApplicable)
        .length;
  }

  int get _totalItems => _checklistItems.length;

  int get _issuesCount {
    return _checklistItems.values
        .where((item) => item.condition == ItemCondition.poor)
        .length;
  }

  Future<void> _saveChecklist() async {
    setState(() => _isSaving = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving move-in checklists is not available yet.'),
      ),
    );
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final itemsByCategory = <String, List<ChecklistItem>>{};
    for (var item in _checklistItems.values) {
      itemsByCategory.putIfAbsent(item.category, () => []);
      if (!itemsByCategory[item.category]!.any((i) => i.id == item.id)) {
        itemsByCategory[item.category]!.add(item);
      }
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Move-In Checklist'),
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppCard(
              variant: AppCardVariant.tinted,
              tintColor: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(
                    label: 'Inspected',
                    value: '$_completedCount',
                    total: '$_totalItems',
                    icon: Icons.fact_check_outlined,
                  ),
                  _SummaryItem(
                    label: 'Issues',
                    value: '$_issuesCount',
                    icon: Icons.warning_amber_rounded,
                    color: _issuesCount > 0 ? AppColors.danger : null,
                  ),
                  _SummaryItem(
                    label: 'Date',
                    value: '${_inspectionDate.day}/${_inspectionDate.month}/${_inspectionDate.year}',
                    icon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),
          ),

          // General Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppSectionCard(
              title: 'General Information',
              icon: Icons.info_outline,
              children: [
                TextFormField(
                  controller: _tenantNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tenant Name',
                    hintText: 'Enter tenant name',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _propertyAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Property Address',
                    hintText: 'Enter property address',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: _selectInspectionDate,
                  borderRadius: AppRadii.md,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Inspection Date',
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18),
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

          // Checklist Items by Category
          ...itemsByCategory.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: _CategorySection(
                category: entry.key,
                items: entry.value,
                onConditionChanged: _updateCondition,
                onNotesChanged: _updateNotes,
                onAddPhoto: _addPhoto,
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

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    this.total,
    this.icon,
    this.color,
  });

  final String label;
  final String value;
  final String? total;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        if (icon != null)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: effectiveColor, size: 18),
          ),
        if (icon != null) const SizedBox(height: AppSpacing.sm),
        Text(
          total != null ? '$value/$total' : value,
          style: textTheme.titleMedium?.copyWith(
            color: effectiveColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
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

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.items,
    required this.onConditionChanged,
    required this.onNotesChanged,
    required this.onAddPhoto,
  });

  final String category;
  final List<ChecklistItem> items;
  final void Function(String itemId, ItemCondition condition) onConditionChanged;
  final void Function(String itemId, String notes) onNotesChanged;
  final void Function(String itemId) onAddPhoto;

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
                child: _ChecklistItemTile(
                  item: item,
                  onConditionChanged: (condition) =>
                      onConditionChanged(item.id, condition),
                  onNotesChanged: (notes) => onNotesChanged(item.id, notes),
                  onAddPhoto: () => onAddPhoto(item.id),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _ChecklistItemTile extends StatefulWidget {
  const _ChecklistItemTile({
    required this.item,
    required this.onConditionChanged,
    required this.onNotesChanged,
    required this.onAddPhoto,
  });

  final ChecklistItem item;
  final void Function(ItemCondition) onConditionChanged;
  final void Function(String) onNotesChanged;
  final VoidCallback onAddPhoto;

  @override
  State<_ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends State<_ChecklistItemTile> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.item.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final conditionColor = _semanticConditionColor(widget.item.condition);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.item.name,
                style: textTheme.titleSmall,
              ),
            ),
            // Current condition chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: conditionColor.withValues(alpha: 0.1),
                borderRadius: AppRadii.pill,
              ),
              child: Text(
                widget.item.condition.label,
                style: TextStyle(
                  color: conditionColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Condition chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: ItemCondition.values.map((condition) {
            final isSelected = widget.item.condition == condition;
            final chipColor = _semanticConditionColor(condition);
            return GestureDetector(
              onTap: () => widget.onConditionChanged(condition),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? chipColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: AppRadii.pill,
                  border: Border.all(
                    color: isSelected
                        ? chipColor
                        : chipColor.withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  condition.label,
                  style: TextStyle(
                    color: isSelected ? chipColor : chipColor.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        // Photo thumbnails
        if (widget.item.photos.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.item.photos.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: AppRadii.sm,
                  child: Image.file(
                    widget.item.photos[index],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Add notes...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                  ),
                ),
                style: const TextStyle(fontSize: 12),
                onChanged: widget.onNotesChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: AppRadii.md,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: widget.onAddPhoto,
                tooltip: 'Add photo',
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
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
