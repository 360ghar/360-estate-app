import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_detail_controller.dart';
import 'package:get/get.dart';

class MaintenanceDetailBindings extends Bindings {
  @override
  void dependencies() {
    final requestId = int.parse(Get.parameters['id'] ?? '0');

    Get.lazyPut<MaintenanceDetailController>(
      () => MaintenanceDetailController(
        repository: Get.find<MaintenanceRepository>(),
        requestId: requestId,
      ),
    );
  }
}
