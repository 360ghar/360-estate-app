import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/reports/data/datasources/reports_remote_data_source.dart';
import 'package:estate_app/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:estate_app/features/reports/domain/repositories/reports_repository.dart';
import 'package:estate_app/features/reports/presentation/controllers/reports_controller.dart';
import 'package:get/get.dart';

class ReportsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsRemoteDataSource>(
      () => ReportsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<ReportsRepository>(
      () => ReportsRepositoryImpl(
          dataSource: Get.find<ReportsRemoteDataSource>()),
    );

    Get.lazyPut<ReportsController>(
      () => ReportsController(repository: Get.find<ReportsRepository>()),
    );
  }
}
