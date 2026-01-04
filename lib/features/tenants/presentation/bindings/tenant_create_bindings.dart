import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenant_create_controller.dart';
import 'package:get/get.dart';

class TenantCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantCreateController>(
      () => TenantCreateController(
        repository: Get.find<TenantsRepository>(),
      ),
    );
  }
}
