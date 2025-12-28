import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_form_controller.dart';
import 'package:get/get.dart';

class MaintenanceFormBindings extends Bindings {
  @override
  void dependencies() {
    final existingRequest = Get.arguments?['request'] as MaintenanceRequest?;
    final propertyId = Get.arguments?['propertyId'] as int?;
    final leaseId = Get.arguments?['leaseId'] as int?;

    Get.lazyPut<MaintenanceFormController>(
      () => MaintenanceFormController(
        repository: Get.find<MaintenanceRepository>(),
        existingRequest: existingRequest,
        propertyId: propertyId,
        leaseId: leaseId,
      ),
    );
  }
}
