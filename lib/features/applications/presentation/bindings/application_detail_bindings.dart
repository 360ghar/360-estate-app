import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:estate_app/features/applications/presentation/controllers/application_detail_controller.dart';
import 'package:get/get.dart';

class ApplicationDetailBindings extends Bindings {
  @override
  void dependencies() {
    final applicationId = int.parse(Get.parameters['id'] ?? '0');

    Get.lazyPut<ApplicationDetailController>(
      () => ApplicationDetailController(
        repository: Get.find<ApplicationsRepository>(),
        applicationId: applicationId,
      ),
    );
  }
}
