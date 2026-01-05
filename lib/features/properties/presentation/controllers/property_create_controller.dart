import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyCreateController extends GetxController {
  PropertyCreateController({
    required PropertiesRepository repository,
  }) : _repository = repository;

  final PropertiesRepository _repository;

  // Stepper State
  final currentStep = 0.obs;
  final formKeyBasic = GlobalKey<FormState>();
  final formKeyAddress = GlobalKey<FormState>();
  final formKeySpecs = GlobalKey<FormState>();

  // Use separate keys for validation per step, validation logic needs care.
  // Actually, we can validate per step.

  // Basic Info
  final titleController = TextEditingController();
  final nicknameController = TextEditingController();
  final notesController = TextEditingController();
  final propertyType = 'apartment'.obs;
  final propertyCategory = 'residential'.obs;

  // Address
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // Specs
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final balconyController = TextEditingController();
  final areaController = TextEditingController();
  final rentController = TextEditingController();
  final depositController = TextEditingController();
  final maintenanceController = TextEditingController();
  final paymentDayController = TextEditingController(text: '1');

  // Media
  final selectedFiles = <PlatformFile>[].obs;
  final isLoading = false.obs;

  // Track validated steps (forms are disposed when stepping away)
  final validatedSteps = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      final authController = Get.find<AuthController>();
      final role = authController.state.value.data?.role;

      if (role == null || (role != UserRole.admin && role != UserRole.agent)) {
        // Delay to allow UI to build before navigating back
        await Future.delayed(const Duration(milliseconds: 100));
        Get.back();
        Get.snackbar('Access Denied',
            'Only Property Owners and Managers can create properties');
      }
    } catch (e) {
      // AuthController might not be found in testing
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    nicknameController.dispose();
    notesController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    bedroomController.dispose();
    bathroomController.dispose();
    balconyController.dispose();
    areaController.dispose();
    rentController.dispose();
    depositController.dispose();
    maintenanceController.dispose();
    paymentDayController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        selectedFiles.addAll(result.files);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(PlatformFile file) {
    selectedFiles.remove(file);
  }

  bool validateStep(int step) {
    bool isValid;
    switch (step) {
      case 0: // Basic
        isValid =
            formKeyBasic.currentState?.validate() ?? validatedSteps.contains(0);
        break;
      case 1: // Address
        isValid = formKeyAddress.currentState?.validate() ??
            validatedSteps.contains(1);
        break;
      case 2: // Specs
        isValid =
            formKeySpecs.currentState?.validate() ?? validatedSteps.contains(2);
        break;
      case 3: // Media - Optional
        isValid = true;
        break;
      default:
        isValid = true;
    }

    if (isValid) {
      validatedSteps.add(step);
    }
    return isValid;
  }

  Future<void> submit() async {
    // Check if all required steps were validated during the wizard flow
    if (!validatedSteps.contains(0) ||
        !validatedSteps.contains(1) ||
        !validatedSteps.contains(2)) {
      Get.snackbar('Error', 'Please complete all steps before submitting');
      return;
    }

    isLoading.value = true;
    final List<String> imageUrls = [];

    try {
      // 1. Upload Images
      for (final file in selectedFiles) {
        if (file.path != null) {
          final url = await _repository.uploadPropertyImage(file.path!);
          imageUrls.add(url);
        }
      }

      // 2. Create Property
      await _repository.createProperty(
        title: titleController.text.trim(),
        nickname: nicknameController.text.trim().isNotEmpty
            ? nicknameController.text.trim()
            : null,
        addressLine: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim().isNotEmpty
            ? stateController.text.trim()
            : null,
        pincode: pincodeController.text.trim().isNotEmpty
            ? pincodeController.text.trim()
            : null,
        propertyType: propertyType.value,
        propertyCategory: propertyCategory.value,
        bedroomCount: int.tryParse(bedroomController.text),
        bathroomCount: int.tryParse(bathroomController.text),
        balconyCount: int.tryParse(balconyController.text),
        floorAreaSqft: double.tryParse(areaController.text),
        monthlyRentInr: int.tryParse(rentController.text) ?? 0,
        securityDeposit: double.tryParse(depositController.text),
        maintenanceCharges: double.tryParse(maintenanceController.text),
        paymentDueDay: int.tryParse(paymentDayController.text) ?? 1,
        notes: notesController.text.trim().isNotEmpty
            ? notesController.text.trim()
            : null,
        images: imageUrls,
      );

      Get.back<void>();
      Get.snackbar('Success', 'Property created successfully');
    } catch (e) {
      AppLogger.e('Failed to create property', error: e);
      Get.snackbar('Error', 'Failed to create property');
    } finally {
      isLoading.value = false;
    }
  }
}
