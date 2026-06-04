import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Property types supported by the backend.
const propertyTypes = [
  'apartment',
  'house',
  'builder_floor',
  'room',
];

String _propertyTypeLabel(String value) {
  switch (value) {
    case 'builder_floor':
      return 'Builder floor';
    case 'apartment':
      return 'Apartment';
    case 'house':
      return 'House';
    case 'room':
      return 'Room';
    default:
      return value;
  }
}

/// Common amenities for filter chips.
const commonAmenities = [
  'Parking',
  'Security',
  'Power Backup',
  'Water Supply',
  'Gym',
  'Swimming Pool',
  'Club House',
  'Garden',
  'Play Area',
  'Lift',
  'AC',
  'Furnished',
  'WiFi',
  'Kitchen',
  'Laundry',
  'Housekeeping',
];

/// Step 1: Basic Details
class PropertyWizardStep1 extends StatefulWidget {
  final PropertyWizardStepData data;
  final ValueChanged<PropertyWizardStepData> onChanged;

  const PropertyWizardStep1({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<PropertyWizardStep1> createState() => _PropertyWizardStep1State();
}

class _PropertyWizardStep1State extends State<PropertyWizardStep1> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.name);
    _notesController = TextEditingController(text: widget.data.notes);

    _nameController.addListener(_onChanged);
    _notesController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged(widget.data.copyWith(
      name: _nameController.text,
      notes: _notesController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = propertyTypes.contains(widget.data.type)
        ? widget.data.type
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Property name *',
            hintText: 'e.g., Green Valley PG',
            prefixIcon: Icon(Icons.apartment_outlined),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.md),

        // Property type
        DropdownButtonFormField<String>(
          initialValue: selectedType,
          decoration: const InputDecoration(
            labelText: 'Property type',
            hintText: 'Select type',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: propertyTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(_propertyTypeLabel(type)),
                  ))
              .toList(),
          onChanged: (value) => widget.onChanged(widget.data.copyWith(type: value)),
        ),
        const SizedBox(height: AppSpacing.md),

        // Management status
        DropdownButtonFormField<String>(
          initialValue: widget.data.managementStatus ?? 'active',
          decoration: const InputDecoration(
            labelText: 'Management status',
            prefixIcon: Icon(Icons.settings_outlined),
          ),
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
            DropdownMenuItem(value: 'sold', child: Text('Sold')),
          ],
          onChanged: (value) => widget.onChanged(
            widget.data.copyWith(managementStatus: value),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Notes
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            hintText: 'Any additional information...',
            prefixIcon: Icon(Icons.notes_outlined),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

/// Step 2: Location
class PropertyWizardStep2 extends StatefulWidget {
  final PropertyWizardStepData data;
  final ValueChanged<PropertyWizardStepData> onChanged;

  const PropertyWizardStep2({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<PropertyWizardStep2> createState() => _PropertyWizardStep2State();
}

class _PropertyWizardStep2State extends State<PropertyWizardStep2> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.data.address);
    _cityController = TextEditingController(text: widget.data.city);
    _stateController = TextEditingController(text: widget.data.state);
    _pincodeController = TextEditingController(text: widget.data.pincode);

    _addressController.addListener(_onChanged);
    _cityController.addListener(_onChanged);
    _stateController.addListener(_onChanged);
    _pincodeController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged(widget.data.copyWith(
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text,
      pincode: _pincodeController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address line',
            hintText: 'Street address',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // City
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City *',
            hintText: 'e.g., Mumbai',
            prefixIcon: Icon(Icons.location_city_outlined),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.md),

        // State and PIN code row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  hintText: 'e.g., Maharashtra',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                  labelText: 'PIN code',
                  hintText: '400001',
                  prefixIcon: Icon(Icons.pin_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Step 3: Specifications
class PropertyWizardStep3 extends StatefulWidget {
  final PropertyWizardStepData data;
  final ValueChanged<PropertyWizardStepData> onChanged;

  const PropertyWizardStep3({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<PropertyWizardStep3> createState() => _PropertyWizardStep3State();
}

class _PropertyWizardStep3State extends State<PropertyWizardStep3> {
  late TextEditingController _unitController;
  late TextEditingController _floorAreaController;
  late TextEditingController _bedroomController;
  late TextEditingController _bathroomController;
  late TextEditingController _balconyController;
  late TextEditingController _yearBuiltController;
  late Set<String> _selectedAmenities;

  @override
  void initState() {
    super.initState();
    _unitController = TextEditingController(text: widget.data.unitCount?.toString());
    _floorAreaController = TextEditingController(text: widget.data.floorAreaSqft?.toString());
    _bedroomController = TextEditingController(text: widget.data.bedroomCount?.toString());
    _bathroomController = TextEditingController(text: widget.data.bathroomCount?.toString());
    _balconyController = TextEditingController(text: widget.data.balconyCount?.toString());
    _yearBuiltController = TextEditingController(text: widget.data.yearBuilt?.toString());
    _selectedAmenities = widget.data.amenities?.toSet() ?? {};

    _unitController.addListener(_onNumericsChanged);
    _floorAreaController.addListener(_onNumericsChanged);
    _bedroomController.addListener(_onNumericsChanged);
    _bathroomController.addListener(_onNumericsChanged);
    _balconyController.addListener(_onNumericsChanged);
    _yearBuiltController.addListener(_onNumericsChanged);
  }

  @override
  void dispose() {
    _unitController.dispose();
    _floorAreaController.dispose();
    _bedroomController.dispose();
    _bathroomController.dispose();
    _balconyController.dispose();
    _yearBuiltController.dispose();
    super.dispose();
  }

  void _onNumericsChanged() {
    widget.onChanged(widget.data.copyWith(
      unitCount: int.tryParse(_unitController.text),
      floorAreaSqft: double.tryParse(_floorAreaController.text),
      bedroomCount: int.tryParse(_bedroomController.text),
      bathroomCount: int.tryParse(_bathroomController.text),
      balconyCount: int.tryParse(_balconyController.text),
      yearBuilt: int.tryParse(_yearBuiltController.text),
      amenities: _selectedAmenities.toList(),
    ));
  }

  void _onAmenitiesChanged() {
    widget.onChanged(widget.data.copyWith(
      unitCount: int.tryParse(_unitController.text),
      floorAreaSqft: double.tryParse(_floorAreaController.text),
      bedroomCount: int.tryParse(_bedroomController.text),
      bathroomCount: int.tryParse(_bathroomController.text),
      balconyCount: int.tryParse(_balconyController.text),
      yearBuilt: int.tryParse(_yearBuiltController.text),
      amenities: _selectedAmenities.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Units and Floor Area
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _unitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total units',
                  hintText: 'Number of units/rooms',
                  prefixIcon: Icon(Icons.meeting_room_outlined),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                controller: _floorAreaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Floor area (sq ft)',
                  hintText: 'e.g., 1200',
                  prefixIcon: Icon(Icons.square_foot_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Bedrooms, Bathrooms, Balconies
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  TextFormField(
                    controller: _bedroomController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bedrooms',
                      hintText: '0',
                      prefixIcon: Icon(Icons.bed_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _bathroomController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bathrooms',
                      hintText: '0',
                      prefixIcon: Icon(Icons.bathtub_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _balconyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Balconies',
                      hintText: '0',
                      prefixIcon: Icon(Icons.balcony_outlined),
                    ),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bedroomController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bedrooms',
                      hintText: '0',
                      prefixIcon: Icon(Icons.bed_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _bathroomController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bathrooms',
                      hintText: '0',
                      prefixIcon: Icon(Icons.bathtub_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _balconyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Balconies',
                      hintText: '0',
                      prefixIcon: Icon(Icons.deck_outlined),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // Year built
        TextFormField(
          controller: _yearBuiltController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Year built',
            hintText: 'e.g., 2010',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Amenities section
        Text(
          'Amenities',
          style: AppTextStyles.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: commonAmenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                  _onAmenitiesChanged();
                });
              },
              backgroundColor: Colors.transparent,
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Step 4: Financial & Management
class PropertyWizardStep4 extends StatefulWidget {
  final PropertyWizardStepData data;
  final ValueChanged<PropertyWizardStepData> onChanged;

  const PropertyWizardStep4({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<PropertyWizardStep4> createState() => _PropertyWizardStep4State();
}

class _PropertyWizardStep4State extends State<PropertyWizardStep4> {
  late TextEditingController _rentController;
  late TextEditingController _paymentDueDayController;
  late TextEditingController _marketValueController;
  late TextEditingController _managerIdController;
  late TextEditingController _propertyTaxIdController;
  late TextEditingController _insuranceController;
  late TextEditingController _hoaController;

  @override
  void initState() {
    super.initState();
    _rentController = TextEditingController(text: widget.data.monthlyRentInr?.toString());
    _paymentDueDayController = TextEditingController(text: widget.data.paymentDueDay?.toString() ?? '1');
    _marketValueController = TextEditingController(text: widget.data.marketValue?.toString());
    _managerIdController = TextEditingController(text: widget.data.assignedManagerId);
    _propertyTaxIdController = TextEditingController(text: widget.data.propertyTaxId);
    _insuranceController = TextEditingController(text: widget.data.insurancePolicy);
    _hoaController = TextEditingController(text: widget.data.hoaInfo);

    _rentController.addListener(_onChanged);
    _paymentDueDayController.addListener(_onChanged);
    _marketValueController.addListener(_onChanged);
    _managerIdController.addListener(_onChanged);
    _propertyTaxIdController.addListener(_onChanged);
    _insuranceController.addListener(_onChanged);
    _hoaController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _rentController.dispose();
    _paymentDueDayController.dispose();
    _marketValueController.dispose();
    _managerIdController.dispose();
    _propertyTaxIdController.dispose();
    _insuranceController.dispose();
    _hoaController.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged(widget.data.copyWith(
      monthlyRentInr: double.tryParse(_rentController.text),
      paymentDueDay: int.tryParse(_paymentDueDayController.text) ?? 1,
      marketValue: double.tryParse(_marketValueController.text),
      assignedManagerId: _managerIdController.text,
      propertyTaxId: _propertyTaxIdController.text,
      insurancePolicy: _insuranceController.text,
      hoaInfo: _hoaController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Financial Section
        Text(
          'Financial Information',
          style: AppTextStyles.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Monthly rent and Payment due day
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly rent (₹)',
                  hintText: 'e.g., 15000',
                  prefixIcon: Icon(Icons.currency_rupee_outlined),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                controller: _paymentDueDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Payment due day',
                  hintText: '1-31',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Market value
        TextFormField(
          controller: _marketValueController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Market value (₹)',
            hintText: 'Current property value',
            prefixIcon: Icon(Icons.trending_up_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Management Section
        Text(
          'Management',
          style: AppTextStyles.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Assigned manager ID
        TextFormField(
          controller: _managerIdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Assigned manager ID',
            hintText: 'Relationship manager user ID',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Legal & Documentation Section
        Text(
          'Legal & Documentation',
          style: AppTextStyles.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Property Tax ID
        TextFormField(
          controller: _propertyTaxIdController,
          decoration: const InputDecoration(
            labelText: 'Property Tax ID',
            hintText: 'Tax identification number',
            prefixIcon: Icon(Icons.receipt_long_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Insurance Policy
        TextFormField(
          controller: _insuranceController,
          decoration: const InputDecoration(
            labelText: 'Insurance Policy',
            hintText: 'Insurance policy details',
            prefixIcon: Icon(Icons.security_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // HOA Information
        TextFormField(
          controller: _hoaController,
          decoration: const InputDecoration(
            labelText: 'HOA Information',
            hintText: 'Homeowners Association details',
            prefixIcon: Icon(Icons.groups_outlined),
          ),
        ),
      ],
    );
  }
}

/// Step 5: Media (Images and Floor Plans)
class PropertyWizardStep5 extends StatelessWidget {
  final PropertyWizardStepData data;
  final ValueChanged<PropertyWizardStepData> onChanged;
  final VoidCallback onAddImages;
  final VoidCallback onAddFloorPlans;
  final void Function(int) onRemoveImage;
  final void Function(int) onRemoveFloorPlan;
  final bool isUploading;

  const PropertyWizardStep5({
    super.key,
    required this.data,
    required this.onChanged,
    required this.onAddImages,
    required this.onAddFloorPlans,
    required this.onRemoveImage,
    required this.onRemoveFloorPlan,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images Section
        _buildMediaSection(
          context,
          title: 'Property Images',
          subtitle: 'Add up to 20 photos',
          items: data.images ?? [],
          maxItems: 20,
          icon: Icons.photo_library_outlined,
          onAdd: data.images != null && data.images!.length >= 20 ? null : onAddImages,
          onRemove: onRemoveImage,
          isUploading: isUploading,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Floor Plans Section
        _buildMediaSection(
          context,
          title: 'Floor Plans',
          subtitle: 'Add up to 10 floor plans',
          items: data.floorPlans ?? [],
          maxItems: 10,
          icon: Icons.map_outlined,
          onAdd: data.floorPlans != null && data.floorPlans!.length >= 10 ? null : onAddFloorPlans,
          onRemove: onRemoveFloorPlan,
          isUploading: isUploading,
        ),
      ],
    );
  }

  Widget _buildMediaSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<String> items,
    required int maxItems,
    required IconData icon,
    required VoidCallback? onAdd,
    required void Function(int) onRemove,
    required bool isUploading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$subtitle (${items.length}/$maxItems)',
                    style: AppTextStyles.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isUploading)
              const Padding(
                padding: EdgeInsets.only(left: AppSpacing.sm),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Grid of images
        if (items.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildImageItem(context, items[index], index, onRemove);
            },
          ),

        // Empty state
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No $title yet',
                    style: AppTextStyles.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tap "Add" to upload',
                    style: AppTextStyles.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, String imageUrl, int index, void Function(int) onRemove) {
    final uri = Uri.tryParse(imageUrl);
    final isFile = uri != null && uri.scheme == 'file';
    final imageWidget = isFile
        ? Image.file(
            File.fromUri(uri),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              );
            },
          )
        : Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          );
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageWidget,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => onRemove(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Simplified data model for wizard step communication.
class PropertyWizardStepData {
  final String? name;
  final String? type;
  final String? managementStatus;
  final String? notes;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final int? unitCount;
  final double? floorAreaSqft;
  final int? bedroomCount;
  final int? bathroomCount;
  final int? balconyCount;
  final int? yearBuilt;
  final List<String>? amenities;
  final double? monthlyRentInr;
  final int? paymentDueDay;
  final double? marketValue;
  final String? assignedManagerId;
  final String? propertyTaxId;
  final String? insurancePolicy;
  final String? hoaInfo;
  final List<String>? images;
  final List<String>? floorPlans;

  const PropertyWizardStepData({
    this.name,
    this.type,
    this.managementStatus,
    this.notes,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.unitCount,
    this.floorAreaSqft,
    this.bedroomCount,
    this.bathroomCount,
    this.balconyCount,
    this.yearBuilt,
    this.amenities,
    this.monthlyRentInr,
    this.paymentDueDay,
    this.marketValue,
    this.assignedManagerId,
    this.propertyTaxId,
    this.insurancePolicy,
    this.hoaInfo,
    this.images,
    this.floorPlans,
  });

  PropertyWizardStepData copyWith({
    String? name,
    String? type,
    String? managementStatus,
    String? notes,
    String? address,
    String? city,
    String? state,
    String? pincode,
    int? unitCount,
    double? floorAreaSqft,
    int? bedroomCount,
    int? bathroomCount,
    int? balconyCount,
    int? yearBuilt,
    List<String>? amenities,
    double? monthlyRentInr,
    int? paymentDueDay,
    double? marketValue,
    String? assignedManagerId,
    String? propertyTaxId,
    String? insurancePolicy,
    String? hoaInfo,
    List<String>? images,
    List<String>? floorPlans,
  }) {
    return PropertyWizardStepData(
      name: name ?? this.name,
      type: type ?? this.type,
      managementStatus: managementStatus ?? this.managementStatus,
      notes: notes ?? this.notes,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      unitCount: unitCount ?? this.unitCount,
      floorAreaSqft: floorAreaSqft ?? this.floorAreaSqft,
      bedroomCount: bedroomCount ?? this.bedroomCount,
      bathroomCount: bathroomCount ?? this.bathroomCount,
      balconyCount: balconyCount ?? this.balconyCount,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      amenities: amenities ?? this.amenities,
      monthlyRentInr: monthlyRentInr ?? this.monthlyRentInr,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      marketValue: marketValue ?? this.marketValue,
      assignedManagerId: assignedManagerId ?? this.assignedManagerId,
      propertyTaxId: propertyTaxId ?? this.propertyTaxId,
      insurancePolicy: insurancePolicy ?? this.insurancePolicy,
      hoaInfo: hoaInfo ?? this.hoaInfo,
      images: images ?? this.images,
      floorPlans: floorPlans ?? this.floorPlans,
    );
  }
}
