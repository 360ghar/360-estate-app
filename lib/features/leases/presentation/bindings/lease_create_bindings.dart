import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/presentation/controllers/lease_create_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:get/get.dart';

class LeaseCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaseCreateController>(
      () => LeaseCreateController(
        leasesRepository: Get.find<LeasesRepository>(),
        propertiesRepository: Get.find<PropertiesRepository>(),
        tenantsRepository: Get.find<TenantsRepository>(),
      ),
    );
  }
}
