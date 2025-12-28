import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/presentation/controllers/lease_detail_controller.dart';
import 'package:get/get.dart';

class LeaseDetailBindings extends Bindings {
  @override
  void dependencies() {
    final leaseId = int.parse(Get.parameters['id'] ?? '0');

    Get.lazyPut<LeaseDetailController>(
      () => LeaseDetailController(
        repository: Get.find<LeasesRepository>(),
        leaseId: leaseId,
      ),
    );
  }
}
