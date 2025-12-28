import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspection_form_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InspectionFormPage extends StatelessWidget {
  const InspectionFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InspectionFormView();
  }
}

class _InspectionFormView extends StatelessWidget {
  const _InspectionFormView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InspectionFormController>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return AppScaffold(
      appBar: AppBar(
        title: Text(controller.isEditing
            ? 'Edit Inspection'
            : 'Schedule Inspection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Property selector (if not preset)
          if (controller.propertyId == null && !controller.isEditing)
            _PropertySelector(controller: controller),

          // Inspection Type
          Text(
            'Inspection Type',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: InspectionType.values.map((type) {
                  final isSelected = controller.inspectionType.value == type;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type.icon,
                          size: 16,
                          color: isSelected ? Colors.white : type.color,
                        ),
                        const SizedBox(width: 4),
                        Text(type.displayName),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => controller.setInspectionType(type),
                    selectedColor: AppColors.brand,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 24),

          // Scheduled Date
          Text(
            'Scheduled Date',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => InkWell(
                onTap: () => _selectDate(context, controller),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        controller.scheduledDate.value != null
                            ? dateFormat.format(controller.scheduledDate.value!)
                            : 'Select date',
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.scheduledDate.value != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),

          // Inspector Name
          TextFormField(
            initialValue: controller.inspectorName.value,
            decoration: const InputDecoration(
              labelText: 'Inspector Name (Optional)',
              hintText: 'Enter inspector name',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: controller.setInspectorName,
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            initialValue: controller.notes.value,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add any notes for this inspection',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            onChanged: controller.setNotes,
          ),
          const SizedBox(height: 32),

          // Submit button
          Obx(() => AppButton(
                label: controller.isEditing
                    ? 'Update Inspection'
                    : 'Schedule Inspection',
                isLoading: controller.isSubmitting.value,
                onPressed: controller.canSubmit
                    ? () async {
                        final result = await controller.submit();
                        if (result != null) {
                          Get.back<Inspection>(result: result);
                        }
                      }
                    : null,
              )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    InspectionFormController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.scheduledDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.setScheduledDate(picked);
    }
  }
}

class _PropertySelector extends StatefulWidget {
  const _PropertySelector({required this.controller});

  final InspectionFormController controller;

  @override
  State<_PropertySelector> createState() => _PropertySelectorState();
}

class _PropertySelectorState extends State<_PropertySelector> {
  List<_PropertyOption> _properties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProperties());
  }

  Future<void> _loadProperties() async {
    try {
      final repository = Get.find<PropertiesRepository>();
      final page =
          await repository.getProperties(page: 1, limit: 100, query: '');
      setState(() {
        _properties = page.items
            .map((p) => _PropertyOption(id: p.id, title: p.title))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<int>(
              value: widget.controller.selectedPropertyId.value,
              decoration: const InputDecoration(
                hintText: 'Select a property',
                prefixIcon: Icon(Icons.apartment),
              ),
              items: _properties.map((prop) {
                return DropdownMenuItem(
                  value: prop.id,
                  child: Text(prop.title),
                );
              }).toList(),
              onChanged: (value) => widget.controller.setPropertyId(value),
              validator: (value) {
                if (value == null) {
                  return 'Please select a property';
                }
                return null;
              },
            )),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PropertyOption {
  const _PropertyOption({required this.id, required this.title});

  final int id;
  final String title;
}
