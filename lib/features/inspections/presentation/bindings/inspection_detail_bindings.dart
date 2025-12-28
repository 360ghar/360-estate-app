import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspection_detail_controller.dart';
import 'package:get/get.dart';

class InspectionDetailBindings extends Bindings {
  @override
  void dependencies() {
    final inspectionId = int.parse(Get.parameters['id'] ?? '0');

    Get.lazyPut<InspectionDetailController>(
      () => InspectionDetailController(
        repository: Get.find<InspectionsRepository>(),
        inspectionId: inspectionId,
      ),
    );
  }
}
