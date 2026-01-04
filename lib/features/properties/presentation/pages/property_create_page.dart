import 'dart:io';

import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/properties/presentation/controllers/property_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyCreatePage extends StatelessWidget {
  const PropertyCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyCreateController>();

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
      ),
      body: Obx(() {
        return Stepper(
          currentStep: controller.currentStep.value,
          onStepTapped: (index) {
             if (controller.validateStep(controller.currentStep.value)) {
               controller.currentStep.value = index;
             }
          },
          onStepContinue: () {
            if (controller.currentStep.value < 3) {
              if (controller.validateStep(controller.currentStep.value)) {
                controller.currentStep.value++;
              }
            } else {
              controller.submit();
            }
          },
          onStepCancel: () {
            if (controller.currentStep.value > 0) {
              controller.currentStep.value--;
            }
          },
          controlsBuilder: (context, details) {
            final isLastStep = controller.currentStep.value == 3;
            return Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                children: [
                   Expanded(
                     child: FilledButton(
                      onPressed: controller.isLoading.value ? null : details.onStepContinue,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isLastStep ? 'SUBMIT PROPERTY' : 'CONTINUE'),
                     ),
                   ),
                   if (controller.currentStep.value > 0) ...[
                     const SizedBox(width: 12),
                     Expanded(
                       child: OutlinedButton(
                        onPressed: controller.isLoading.value ? null : details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('BACK'),
                      ),
                     ),
                   ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Basic Information'),
              state: _getStepState(0, controller.currentStep.value),
              isActive: controller.currentStep.value >= 0,
              content: _BasicInfoForm(controller: controller),
            ),
            Step(
              title: const Text('Location'),
              state: _getStepState(1, controller.currentStep.value),
              isActive: controller.currentStep.value >= 1,
              content: _LocationForm(controller: controller),
            ),
            Step(
              title: const Text('Specifications'),
              state: _getStepState(2, controller.currentStep.value),
              isActive: controller.currentStep.value >= 2,
              content: _SpecsForm(controller: controller),
            ),
             Step(
              title: const Text('Media'),
              state: _getStepState(3, controller.currentStep.value),
              isActive: controller.currentStep.value >= 3,
              content: _MediaForm(controller: controller),
            ),
          ],
        );
      }),
    );
  }

  StepState _getStepState(int index, int currentIndex) {
    if (currentIndex > index) return StepState.complete;
    if (currentIndex == index) return StepState.editing;
    return StepState.indexed;
  }
}

class _BasicInfoForm extends StatelessWidget {
  const _BasicInfoForm({required this.controller});

  final PropertyCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyBasic,
      child: Column(
        children: [
          TextFormField(
            controller: controller.titleController,
            decoration: const InputDecoration(
              labelText: 'Property Title *',
              hintText: 'e.g., 2BHK Apartment in Koramangala',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.nicknameController,
            decoration: const InputDecoration(
              labelText: 'Nickname (optional)',
              hintText: 'A short name for quick reference',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: controller.propertyType.value,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
              DropdownMenuItem(value: 'house', child: Text('House')),
              DropdownMenuItem(value: 'villa', child: Text('Villa')),
              DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
              DropdownMenuItem(value: 'land', child: Text('Land')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                controller.propertyType.value = value;
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: controller.propertyCategory.value,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'residential', child: Text('Residential')),
              DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                controller.propertyCategory.value = value;
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocationForm extends StatelessWidget {
  const _LocationForm({required this.controller});

  final PropertyCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyAddress,
      child: Column(
        children: [
          TextFormField(
            controller: controller.addressController,
            decoration: const InputDecoration(
              labelText: 'Address Line *',
              hintText: 'Street address',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.pincodeController,
            decoration: const InputDecoration(
              labelText: 'Pincode',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _SpecsForm extends StatelessWidget {
  const _SpecsForm({required this.controller});

  final PropertyCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeySpecs,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.bedroomController,
                  decoration: const InputDecoration(
                    labelText: 'Bedrooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.bathroomController,
                  decoration: const InputDecoration(
                    labelText: 'Bathrooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
           Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.balconyController,
                  decoration: const InputDecoration(
                    labelText: 'Balconies',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area (sq.ft)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
           Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.rentController,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Rent (₹)',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.paymentDayController,
                  decoration: const InputDecoration(
                    labelText: 'Rent Due Day',
                    hintText: '1-31',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.depositController,
                  decoration: const InputDecoration(
                    labelText: 'Security Deposit (₹)',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                     if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                       return 'Invalid amount';
                     }
                     return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.maintenanceController,
                  decoration: const InputDecoration(
                    labelText: 'Maintenance (₹)',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                     if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                       return 'Invalid amount';
                     }
                     return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _MediaForm extends StatelessWidget {
  const _MediaForm({required this.controller});

  final PropertyCreateController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: controller.pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Photos'),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.selectedFiles.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No images selected'),
            );
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedFiles.map((file) {
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: file.path != null
                          ? Image.file(
                              File(file.path!),
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(file),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
