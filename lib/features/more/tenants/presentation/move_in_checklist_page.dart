import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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
      lastDate: DateTime.now(),
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
    final itemsByCategory = {
      for (var item in _checklistItems.values)
        item.category: _checklistItems.values.where((i) => i.category == item.category).toList(),
    };

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
          Card(
            margin: const EdgeInsets.all(AppSpacing.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryItem(
                        label: 'Inspected',
                        value: '$_completedCount',
                        total: '$_totalItems',
                        icon: Icons.fact_check,
                      ),
                      _SummaryItem(
                        label: 'Issues',
                        value: '$_issuesCount',
                        icon: Icons.warning,
                        color: _issuesCount > 0 ? Colors.red : null,
                      ),
                      _SummaryItem(
                        label: 'Date',
                        value: '${_inspectionDate.day}/${_inspectionDate.month}/${_inspectionDate.year}',
                        icon: Icons.calendar_today,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // General Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'General Information'),
                const SizedBox(height: AppSpacing.md),
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
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),

          // Checklist Items by Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: const SectionHeader(title: 'Room Inspection'),
          ),
          const SizedBox(height: AppSpacing.md),

          ...itemsByCategory.entries.map((entry) {
            return _CategorySection(
              category: entry.key,
              items: entry.value,
              onConditionChanged: _updateCondition,
              onNotesChanged: _updateNotes,
              onAddPhoto: _addPhoto,
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
    return Column(
      children: [
        if (icon != null)
          Icon(
            icon,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        if (icon != null) const SizedBox(height: AppSpacing.xs),
        Text(
          total != null ? '$value/$total' : value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color ?? Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
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
  final Function(String itemId, ItemCondition condition) onConditionChanged;
  final Function(String itemId, String notes) onNotesChanged;
  final Function(String itemId) onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      child: ExpansionTile(
        title: Text(category),
        initiallyExpanded: true,
        children: items.map((item) => _ChecklistItemTile(
              item: item,
              onConditionChanged: (condition) => onConditionChanged(item.id, condition),
              onNotesChanged: (notes) => onNotesChanged(item.id, notes),
              onAddPhoto: () => onAddPhoto(item.id),
            )).toList(),
      ),
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
  final Function(ItemCondition) onConditionChanged;
  final Function(String) onNotesChanged;
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.item.condition.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.item.condition.color),
                ),
                child: Text(
                  widget.item.condition.label,
                  style: TextStyle(
                    color: widget.item.condition.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            children: ItemCondition.values.map((condition) {
              final isSelected = widget.item.condition == condition;
              return ChoiceChip(
                label: Text(condition.label, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    widget.onConditionChanged(condition);
                  }
                },
                selectedColor: condition.color.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected ? condition.color : null,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          if (widget.item.photos.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.photo_camera, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  '${widget.item.photos.length} photo(s)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Add notes...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(fontSize: 12),
                  onChanged: widget.onNotesChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: widget.onAddPhoto,
                tooltip: 'Add photo',
              ),
            ],
          ),
        ],
      ),
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
