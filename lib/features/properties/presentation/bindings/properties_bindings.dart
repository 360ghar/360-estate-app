import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:estate_app/features/properties/data/repositories/properties_repository_impl.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/domain/usecases/get_properties_page_usecase.dart';
import 'package:estate_app/features/properties/presentation/controllers/properties_controller.dart';
import 'package:estate_app/features/properties/presentation/controllers/property_create_controller.dart';
import 'package:get/get.dart';

class PropertiesBindings extends Bindings {
  PropertiesBindings();

  @override
  void dependencies() {
    void lazyPutIfAbsent<T>(T Function() builder) {
      if (Get.isRegistered<T>()) return;
      Get.lazyPut<T>(builder, fenix: true);
    }

    lazyPutIfAbsent<PropertiesRemoteDataSource>(
      () => ApiPropertiesRemoteDataSource(Get.find<ApiClient>()),
    );

    lazyPutIfAbsent<PropertiesRepository>(
      () => PropertiesRepositoryImpl(
        dataSource: Get.find<PropertiesRemoteDataSource>(),
      ),
    );

    lazyPutIfAbsent<GetPropertiesPageUseCase>(
      () => GetPropertiesPageUseCase(Get.find<PropertiesRepository>()),
    );

    if (!Get.isRegistered<PropertiesController>()) {
      Get.put<PropertiesController>(
        PropertiesController(
          getPropertiesPage: Get.find<GetPropertiesPageUseCase>(),
        ),
      );
    }

    Get.lazyPut<PropertyCreateController>(
      () => PropertyCreateController(
        repository: Get.find<PropertiesRepository>(),
      ),
      fenix: true,
    );
  }
}
