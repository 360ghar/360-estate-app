import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/mocks/mock_maintenance_data_source.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_controller.dart';
import 'package:get/get.dart';

class MaintenanceBindings extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();

    Get.lazyPut<MaintenanceRemoteDataSource>(
      () => config.useMockApi
          ? MockMaintenanceRemoteDataSource()
          : ApiMaintenanceRemoteDataSource(Get.find<ApiClient>()),
    );

    Get.lazyPut<MaintenanceRepository>(
      () => MaintenanceRepositoryImpl(Get.find<MaintenanceRemoteDataSource>()),
    );

    Get.lazyPut<MaintenanceController>(
      () => MaintenanceController(repository: Get.find<MaintenanceRepository>()),
    );
  }
}

