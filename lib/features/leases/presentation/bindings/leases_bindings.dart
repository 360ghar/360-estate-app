import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/leases/data/datasources/leases_remote_data_source.dart';
import 'package:estate_app/features/leases/data/repositories/leases_repository_impl.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/presentation/controllers/leases_controller.dart';
import 'package:get/get.dart';

class LeasesBindings extends Bindings {
  @override
  void dependencies() {
    void lazyPutIfAbsent<T>(T Function() builder) {
      if (Get.isRegistered<T>()) return;
      Get.lazyPut<T>(builder, fenix: true);
    }

    lazyPutIfAbsent<LeasesRemoteDataSource>(
      () => ApiLeasesRemoteDataSource(Get.find<ApiClient>()),
    );

    lazyPutIfAbsent<LeasesRepository>(
      () => LeasesRepositoryImpl(
        dataSource: Get.find<LeasesRemoteDataSource>(),
      ),
    );

    if (!Get.isRegistered<LeasesController>()) {
      Get.put<LeasesController>(
        LeasesController(
          repository: Get.find<LeasesRepository>(),
        ),
      );
    }
  }
}
