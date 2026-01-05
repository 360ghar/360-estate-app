import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenantCreateController extends GetxController {
  TenantCreateController({required TenantsRepository repository})
      : _repository = repository;

  final TenantsRepository _repository;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Current step
  final currentStep = 0.obs;
  static const int totalSteps = 4;

  // Form controllers - Step 1: Personal Info
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Form controllers - Step 2: Emergency Contact
  final emergencyContactController = TextEditingController();
  final emergencyPhoneController = TextEditingController();

  // Form controllers - Step 3: ID Verification
  final governmentIdType = Rxn<String>();
  final governmentIdNumberController = TextEditingController();

  // Form controllers - Step 4: Notes
  final notesController = TextEditingController();

  // State
  final state = Rx<ViewState<Tenant>>(ViewState.idle());

  // ID type options
  static const idTypes = [
    'Aadhaar Card',
    'PAN Card',
    'Passport',
    'Driving License',
    'Voter ID',
  ];

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    emergencyContactController.dispose();
    emergencyPhoneController.dispose();
    governmentIdNumberController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Personal Info
        return fullNameController.text.trim().isNotEmpty;
      case 1: // Emergency Contact - optional
        return true;
      case 2: // ID Verification - optional
        return true;
      case 3: // Notes - optional
        return true;
      default:
        return true;
    }
  }

  Future<void> submit() async {
    if (!validateCurrentStep()) return;

    state.value = ViewState.loading();

    try {
      final data = {
        'full_name': fullNameController.text.trim(),
        'email': emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        'phone': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'emergency_contact': emergencyContactController.text.trim().isEmpty
            ? null
            : emergencyContactController.text.trim(),
        'emergency_phone': emergencyPhoneController.text.trim().isEmpty
            ? null
            : emergencyPhoneController.text.trim(),
        'government_id_type': governmentIdType.value,
        'government_id_number': governmentIdNumberController.text.trim().isEmpty
            ? null
            : governmentIdNumberController.text.trim(),
        'notes': notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        'status': 'active',
      };

      final tenant = await _repository.createTenant(data);
      state.value = ViewState.success(tenant);

      Get.back<bool>(result: true);
      Get.snackbar(
        'Success',
        'Tenant created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      state.value = ViewState.idle();
      Get.snackbar(
        'Error',
        'Failed to create tenant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void reset() {
    currentStep.value = 0;
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    emergencyContactController.clear();
    emergencyPhoneController.clear();
    governmentIdType.value = null;
    governmentIdNumberController.clear();
    notesController.clear();
    state.value = ViewState.idle();
  }
}
