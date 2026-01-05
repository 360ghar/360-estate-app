import 'dart:async';

import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_form_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MaintenanceFormPage extends StatelessWidget {
  const MaintenanceFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MaintenanceFormView();
  }
}

class _MaintenanceFormView extends StatelessWidget {
  const _MaintenanceFormView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MaintenanceFormController>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return AppScaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Request' : 'New Request'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Property selector (only for new requests without a preset propertyId)
            if (!controller.isEditing && controller.propertyId == null)
              _PropertySelector(controller: controller),

            // Title
            TextFormField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Brief description of the issue',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: controller.validateTitle,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Detailed description of the issue',
                alignLabelWithHint: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              validator: controller.validateDescription,
            ),
            const SizedBox(height: 16),

            // Category
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MaintenanceCategory.values.map((cat) {
                  final isSelected = controller.category.value == cat;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat.icon,
                          size: 16,
                          color: isSelected ? Colors.white : cat.color,
                        ),
                        const SizedBox(width: 4),
                        Text(cat.displayName),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => controller.setCategory(cat),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Priority
            Text(
              'Priority',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: MaintenancePriority.values.map((prio) {
                  final isSelected = controller.priority.value == prio;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: prio != MaintenancePriority.urgent ? 8 : 0,
                      ),
                      child: ChoiceChip(
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            prio.displayName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => controller.setPriority(prio),
                        selectedColor: prio.color,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Scheduled Date
            Text(
              'Scheduled Date (Optional)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => InkWell(
                onTap: () => _selectDate(context, controller),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        controller.scheduledDate.value != null
                            ? dateFormat.format(controller.scheduledDate.value!)
                            : 'Select a date',
                        style: TextStyle(
                          color: controller.scheduledDate.value != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      if (controller.scheduledDate.value != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => controller.setScheduledDate(null),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Assigned To
            TextFormField(
              controller: controller.assignedToController,
              decoration: const InputDecoration(
                labelText: 'Assigned To (Optional)',
                hintText: 'Contractor or maintenance person',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Estimated Cost
            TextFormField(
              controller: controller.estimatedCostController,
              decoration: const InputDecoration(
                labelText: 'Estimated Cost (Optional)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: controller.notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Additional notes or instructions',
                alignLabelWithHint: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Submit button
            Obx(
              () => AppButton(
                label:
                    controller.isEditing ? 'Update Request' : 'Create Request',
                isLoading: controller.isSubmitting.value,
                onPressed: controller.submit,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    MaintenanceFormController controller,
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

  final MaintenanceFormController controller;

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
          'Property *',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<int>(
            initialValue: widget.controller.selectedPropertyId.value,
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
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PropertyOption {
  const _PropertyOption({required this.id, required this.title});

  final int id;
  final String title;
}
