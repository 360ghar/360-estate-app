import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/tenants/data/datasources/tenants_remote_data_source.dart';
import 'package:estate_app/features/tenants/data/repositories/tenants_repository_impl.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:estate_app/features/tenants/domain/usecases/get_tenants_page_usecase.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenants_controller.dart';
import 'package:get/get.dart';

class TenantsBindings extends Bindings {
  @override
  void dependencies() {
    void lazyPutIfAbsent<T>(T Function() builder) {
      if (Get.isRegistered<T>()) return;
      Get.lazyPut<T>(builder, fenix: true);
    }

    lazyPutIfAbsent<TenantsRemoteDataSource>(
      () => ApiTenantsRemoteDataSource(Get.find<ApiClient>()),
    );

    lazyPutIfAbsent<TenantsRepository>(
      () => TenantsRepositoryImpl(
        dataSource: Get.find<TenantsRemoteDataSource>(),
      ),
    );

    lazyPutIfAbsent<GetTenantsPageUseCase>(
      () => GetTenantsPageUseCase(Get.find<TenantsRepository>()),
    );

    if (!Get.isRegistered<TenantsController>()) {
      Get.put<TenantsController>(
        TenantsController(
          getTenantsPage: Get.find<GetTenantsPageUseCase>(),
        ),
      );
    }
  }
}
