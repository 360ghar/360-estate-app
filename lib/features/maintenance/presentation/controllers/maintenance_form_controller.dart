import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceFormController extends GetxController {
  MaintenanceFormController({
    required MaintenanceRepository repository,
    this.existingRequest,
    this.propertyId,
    this.leaseId,
  }) : _repository = repository;

  final MaintenanceRepository _repository;
  final MaintenanceRequest? existingRequest;
  final int? propertyId;
  final int? leaseId;

  bool get isEditing => existingRequest != null;

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final assignedToController = TextEditingController();
  final estimatedCostController = TextEditingController();
  final notesController = TextEditingController();

  final Rx<MaintenanceCategory> category = MaintenanceCategory.other.obs;
  final Rx<MaintenancePriority> priority = MaintenancePriority.medium.obs;
  final Rxn<DateTime> scheduledDate = Rxn<DateTime>();
  final Rxn<int> selectedPropertyId = Rxn<int>();

  final RxBool isSubmitting = false.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    selectedPropertyId.value = propertyId;

    if (existingRequest != null) {
      titleController.text = existingRequest!.title;
      descriptionController.text = existingRequest!.description;
      assignedToController.text = existingRequest!.assignedTo ?? '';
      if (existingRequest!.estimatedCost != null) {
        estimatedCostController.text =
            existingRequest!.estimatedCost!.toStringAsFixed(2);
      }
      notesController.text = existingRequest!.notes ?? '';
      category.value = existingRequest!.category;
      priority.value = existingRequest!.priority;
      scheduledDate.value = existingRequest!.scheduledDate;
      selectedPropertyId.value = existingRequest!.propertyId;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    assignedToController.dispose();
    estimatedCostController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void setCategory(MaintenanceCategory cat) {
    category.value = cat;
  }

  void setPriority(MaintenancePriority prio) {
    priority.value = prio;
  }

  void setScheduledDate(DateTime? date) {
    scheduledDate.value = date;
  }

  void setPropertyId(int? id) {
    selectedPropertyId.value = id;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedPropertyId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a property',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    failure.value = null;

    try {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final assignedTo = assignedToController.text.trim();
      final estimatedCostText = estimatedCostController.text.trim();
      final notes = notesController.text.trim();

      double? estimatedCost;
      if (estimatedCostText.isNotEmpty) {
        estimatedCost = double.tryParse(estimatedCostText);
      }

      MaintenanceRequest result;

      if (isEditing) {
        final updates = <String, dynamic>{
          'title': title,
          'description': description,
          'category': category.value.name,
          'priority': priority.value.name,
          if (assignedTo.isNotEmpty) 'assigned_to': assignedTo,
          if (estimatedCost != null) 'estimated_cost': estimatedCost,
          if (scheduledDate.value != null)
            'scheduled_date':
                scheduledDate.value!.toIso8601String().split('T')[0],
          if (notes.isNotEmpty) 'notes': notes,
        };
        result = await _repository.updateRequest(existingRequest!.id, updates);
      } else {
        result = await _repository.createRequest(
          propertyId: selectedPropertyId.value!,
          leaseId: leaseId,
          category: category.value.name,
          priority: priority.value.name,
          title: title,
          description: description,
          assignedTo: assignedTo.isNotEmpty ? assignedTo : null,
          estimatedCost: estimatedCost,
          scheduledDate: scheduledDate.value,
          notes: notes.isNotEmpty ? notes : null,
        );
      }

      Get.back<MaintenanceRequest>(result: result);
      Get.snackbar(
        'Success',
        isEditing
            ? 'Request updated successfully'
            : 'Request created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Failure catch (f) {
      failure.value = f;
      Get.snackbar(
        'Error',
        f.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      failure.value = UnknownFailure('Failed to save request', cause: e);
      Get.snackbar(
        'Error',
        'Failed to save request: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 5) {
      return 'Title must be at least 5 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }
}
