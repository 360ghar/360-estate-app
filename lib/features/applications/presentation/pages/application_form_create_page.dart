import 'dart:async';

import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/presentation/controllers/application_form_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ApplicationFormCreatePage extends StatelessWidget {
  const ApplicationFormCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ApplicationFormCreateView();
  }
}

class _ApplicationFormCreateView extends StatelessWidget {
  const _ApplicationFormCreateView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationFormController>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Create Application Form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Property selector
          if (controller.propertyId == null)
            _PropertySelector(controller: controller),

          // Expiry Date
          Text(
            'Form Expiry Date (Optional)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => InkWell(
                onTap: () => _selectExpiryDate(context, controller),
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
                        controller.expiryDate.value != null
                            ? dateFormat.format(controller.expiryDate.value!)
                            : 'No expiry date',
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.expiryDate.value != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      if (controller.expiryDate.value != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => controller.setExpiryDate(null),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),

          // Custom Fields Section
          Row(
            children: [
              Text(
                'Custom Fields',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddFieldDialog(context, controller),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Field'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.customFields.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No custom fields added',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The form will use standard fields only',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: List.generate(controller.customFields.length, (index) {
                final field = controller.customFields[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(_getFieldTypeIcon(field.fieldType)),
                    title: Text(field.label),
                    subtitle: Text(
                      '${_getFieldTypeName(field.fieldType)}${field.isRequired ? ' • Required' : ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeCustomField(index),
                    ),
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: 32),

          // Submit button
          Obx(() => AppButton(
                label: 'Create Application Form',
                isLoading: controller.isSubmitting.value,
                onPressed: controller.canSubmit
                    ? () async {
                        final result = await controller.submit();
                        if (result != null) {
                          Get.back<ApplicationForm>(result: result);
                        }
                      }
                    : null,
              )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _selectExpiryDate(
    BuildContext context,
    ApplicationFormController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.expiryDate.value ??
          DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.setExpiryDate(picked);
    }
  }

  IconData _getFieldTypeIcon(String fieldType) {
    switch (fieldType) {
      case 'text':
        return Icons.text_fields;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'number':
        return Icons.numbers;
      case 'date':
        return Icons.calendar_today;
      case 'select':
        return Icons.list;
      case 'checkbox':
        return Icons.check_box;
      default:
        return Icons.text_fields;
    }
  }

  String _getFieldTypeName(String fieldType) {
    switch (fieldType) {
      case 'text':
        return 'Text';
      case 'email':
        return 'Email';
      case 'phone':
        return 'Phone';
      case 'number':
        return 'Number';
      case 'date':
        return 'Date';
      case 'select':
        return 'Dropdown';
      case 'checkbox':
        return 'Checkbox';
      default:
        return fieldType;
    }
  }

  void _showAddFieldDialog(
    BuildContext context,
    ApplicationFormController controller,
  ) {
    final labelController = TextEditingController();
    final selectedType = 'text'.obs;
    final isRequired = false.obs;
    final optionsController = TextEditingController();

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Field'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Field Label',
                  hintText: 'e.g., Previous Landlord Reference',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Field Type'),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedType.value,
                    items: const [
                      DropdownMenuItem(value: 'text', child: Text('Text')),
                      DropdownMenuItem(value: 'email', child: Text('Email')),
                      DropdownMenuItem(value: 'phone', child: Text('Phone')),
                      DropdownMenuItem(value: 'number', child: Text('Number')),
                      DropdownMenuItem(value: 'date', child: Text('Date')),
                      DropdownMenuItem(
                        value: 'select',
                        child: Text('Dropdown'),
                      ),
                      DropdownMenuItem(
                        value: 'checkbox',
                        child: Text('Checkbox'),
                      ),
                    ],
                    onChanged: (value) => selectedType.value = value!,
                  )),
              Obx(() {
                if (selectedType.value == 'select') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      TextField(
                        controller: optionsController,
                        decoration: const InputDecoration(
                          labelText: 'Options (comma separated)',
                          hintText: 'e.g., Option 1, Option 2, Option 3',
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                    title: const Text('Required field'),
                    value: isRequired.value,
                    onChanged: (value) => isRequired.value = value!,
                    contentPadding: EdgeInsets.zero,
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (labelController.text.isEmpty) {
                Get.snackbar('Error', 'Please enter a field label');
                return;
              }

              List<String>? options;
              if (selectedType.value == 'select' &&
                  optionsController.text.isNotEmpty) {
                options = optionsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
              }

              controller.addCustomField(
                label: labelController.text,
                fieldType: selectedType.value,
                isRequired: isRequired.value,
                options: options,
              );

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ));
  }
}

class _PropertySelector extends StatefulWidget {
  const _PropertySelector({required this.controller});

  final ApplicationFormController controller;

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
