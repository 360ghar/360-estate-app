import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/inspections/data/datasources/inspections_remote_data_source.dart';
import 'package:estate_app/features/inspections/data/repositories/inspections_repository_impl.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspections_controller.dart';
import 'package:get/get.dart';

class InspectionsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionsRemoteDataSource>(
      () => ApiInspectionsRemoteDataSource(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<InspectionsRepository>(
      () => InspectionsRepositoryImpl(
        dataSource: Get.find<InspectionsRemoteDataSource>(),
      ),
    );

    Get.lazyPut<InspectionsController>(
      () => InspectionsController(repository: Get.find<InspectionsRepository>()),
    );
  }
}
