import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:get/get.dart';

class InspectionFormController extends GetxController {
  InspectionFormController({
    required InspectionsRepository repository,
    this.existingInspection,
    this.propertyId,
  }) : _repository = repository;

  final InspectionsRepository _repository;
  final Inspection? existingInspection;
  final int? propertyId;

  final inspectionType = Rxn<InspectionType>();
  final scheduledDate = Rxn<DateTime>();
  final inspectorName = ''.obs;
  final notes = ''.obs;
  final selectedPropertyId = Rxn<int>();
  final isSubmitting = false.obs;

  bool get isEditing => existingInspection != null;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    if (existingInspection != null) {
      inspectionType.value = existingInspection!.inspectionType;
      scheduledDate.value = existingInspection!.scheduledDate;
      inspectorName.value = existingInspection!.inspectorName ?? '';
      notes.value = existingInspection!.notes ?? '';
      selectedPropertyId.value = existingInspection!.propertyId;
    } else {
      selectedPropertyId.value = propertyId;
      inspectionType.value = InspectionType.routine;
      scheduledDate.value = DateTime.now().add(const Duration(days: 1));
    }
  }

  void setInspectionType(InspectionType type) {
    inspectionType.value = type;
  }

  void setScheduledDate(DateTime date) {
    scheduledDate.value = date;
  }

  void setInspectorName(String value) {
    inspectorName.value = value;
  }

  void setNotes(String value) {
    notes.value = value;
  }

  void setPropertyId(int? id) {
    selectedPropertyId.value = id;
  }

  bool get canSubmit =>
      inspectionType.value != null &&
      scheduledDate.value != null &&
      selectedPropertyId.value != null;

  Future<Inspection?> submit() async {
    if (!canSubmit || isSubmitting.value) return null;

    isSubmitting.value = true;

    try {
      Inspection result;

      if (isEditing) {
        final updates = <String, dynamic>{};

        if (inspectionType.value != existingInspection!.inspectionType) {
          updates['inspection_type'] = inspectionType.value!.apiValue;
        }
        if (scheduledDate.value != existingInspection!.scheduledDate) {
          updates['scheduled_date'] =
              scheduledDate.value!.toIso8601String().split('T')[0];
        }
        if (inspectorName.value != (existingInspection!.inspectorName ?? '')) {
          updates['inspector_name'] = inspectorName.value.isEmpty
              ? null
              : inspectorName.value;
        }
        if (notes.value != (existingInspection!.notes ?? '')) {
          updates['notes'] = notes.value.isEmpty ? null : notes.value;
        }

        if (updates.isEmpty) {
          return existingInspection;
        }

        result = await _repository.updateInspection(
          existingInspection!.id,
          updates,
        );
      } else {
        result = await _repository.createInspection(
          propertyId: selectedPropertyId.value!,
          inspectionType: inspectionType.value!,
          scheduledDate: scheduledDate.value!,
          inspectorName: inspectorName.value.isEmpty ? null : inspectorName.value,
          notes: notes.value.isEmpty ? null : notes.value,
        );
      }

      Get.snackbar(
        'Success',
        isEditing ? 'Inspection updated' : 'Inspection scheduled',
      );
      return result;
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to save inspection');
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }
}
