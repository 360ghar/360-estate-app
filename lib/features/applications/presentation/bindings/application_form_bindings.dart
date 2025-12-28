import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:estate_app/features/applications/presentation/controllers/application_form_controller.dart';
import 'package:get/get.dart';

class ApplicationFormBindings extends Bindings {
  @override
  void dependencies() {
    final propertyId = Get.arguments?['propertyId'] as int?;

    Get.lazyPut<ApplicationFormController>(
      () => ApplicationFormController(
        repository: Get.find<ApplicationsRepository>(),
        propertyId: propertyId,
      ),
    );
  }
}
