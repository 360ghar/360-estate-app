import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspection_form_controller.dart';
import 'package:get/get.dart';

class InspectionFormBindings extends Bindings {
  @override
  void dependencies() {
    final existingInspection = Get.arguments?['inspection'] as Inspection?;
    final propertyId = Get.arguments?['propertyId'] as int?;

    Get.lazyPut<InspectionFormController>(
      () => InspectionFormController(
        repository: Get.find<InspectionsRepository>(),
        existingInspection: existingInspection,
        propertyId: propertyId,
      ),
    );
  }
}
