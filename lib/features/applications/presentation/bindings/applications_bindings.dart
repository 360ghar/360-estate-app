import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/applications/data/datasources/applications_remote_data_source.dart';
import 'package:estate_app/features/applications/data/repositories/applications_repository_impl.dart';
import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:estate_app/features/applications/presentation/controllers/applications_controller.dart';
import 'package:get/get.dart';

class ApplicationsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationsRemoteDataSource>(
      () => ApiApplicationsRemoteDataSource(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<ApplicationsRepository>(
      () => ApplicationsRepositoryImpl(
        dataSource: Get.find<ApplicationsRemoteDataSource>(),
      ),
    );

    Get.lazyPut<ApplicationsController>(
      () => ApplicationsController(
          repository: Get.find<ApplicationsRepository>()),
    );
  }
}
