import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenant_detail_controller.dart';
import 'package:get/get.dart';

class TenantDetailBindings extends Bindings {
  @override
  void dependencies() {
    final tenantId = Get.parameters['id'] ?? '';

    Get.lazyPut<TenantDetailController>(
      () => TenantDetailController(
        repository: Get.find<TenantsRepository>(),
        tenantId: tenantId,
      ),
    );
  }
}
