import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/presentation/controllers/property_detail_controller.dart';
import 'package:get/get.dart';

class PropertyDetailBindings extends Bindings {
  @override
  void dependencies() {
    final propertyId = int.parse(Get.parameters['id'] ?? '0');

    Get.lazyPut<PropertyDetailController>(
      () => PropertyDetailController(
        repository: Get.find<PropertiesRepository>(),
        propertyId: propertyId,
      ),
    );
  }
}
