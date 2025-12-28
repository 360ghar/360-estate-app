import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:get/get.dart';

class ApplicationFormController extends GetxController {
  ApplicationFormController({
    required ApplicationsRepository repository,
    this.propertyId,
  }) : _repository = repository;

  final ApplicationsRepository _repository;
  final int? propertyId;

  final selectedPropertyId = Rxn<int>();
  final expiryDate = Rxn<DateTime>();
  final customFields = <ApplicationFormField>[].obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedPropertyId.value = propertyId;
  }

  void setPropertyId(int? id) {
    selectedPropertyId.value = id;
  }

  void setExpiryDate(DateTime? date) {
    expiryDate.value = date;
  }

  void addCustomField({
    required String label,
    required String fieldType,
    bool isRequired = false,
    List<String>? options,
  }) {
    customFields.add(ApplicationFormField(
      id: DateTime.now().millisecondsSinceEpoch,
      label: label,
      fieldType: fieldType,
      isRequired: isRequired,
      options: options ?? [],
    ));
  }

  void removeCustomField(int index) {
    if (index >= 0 && index < customFields.length) {
      customFields.removeAt(index);
    }
  }

  bool get canSubmit => selectedPropertyId.value != null;

  Future<ApplicationForm?> submit() async {
    if (!canSubmit || isSubmitting.value) return null;

    isSubmitting.value = true;

    try {
      final result = await _repository.createApplicationForm(
        propertyId: selectedPropertyId.value!,
        customFields: customFields.isNotEmpty ? customFields.toList() : null,
        expiresAt: expiryDate.value,
      );

      Get.snackbar('Success', 'Application form created');
      return result;
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create form');
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }
}
