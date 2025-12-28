import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:estate_app/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:estate_app/features/home/domain/repositories/dashboard_repository.dart';
import 'package:estate_app/features/home/domain/usecases/get_dashboard_overview_usecase.dart';
import 'package:estate_app/features/home/domain/usecases/get_recent_activity_usecase.dart';
import 'package:estate_app/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  HomeBindings();

  @override
  void dependencies() {
    Get.lazyPut<DashboardRemoteDataSource>(
      () => ApiDashboardRemoteDataSource(Get.find<ApiClient>()),
    );

    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        dataSource: Get.find<DashboardRemoteDataSource>(),
      ),
    );

    Get.lazyPut<GetDashboardOverviewUseCase>(
      () => GetDashboardOverviewUseCase(Get.find<DashboardRepository>()),
    );

    Get.lazyPut<GetRecentActivityUseCase>(
      () => GetRecentActivityUseCase(Get.find<DashboardRepository>()),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(
        getDashboardOverview: Get.find<GetDashboardOverviewUseCase>(),
        getRecentActivity: Get.find<GetRecentActivityUseCase>(),
      ),
    );
  }
}
