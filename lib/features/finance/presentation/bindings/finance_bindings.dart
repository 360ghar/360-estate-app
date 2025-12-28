import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:estate_app/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:estate_app/features/finance/presentation/controllers/expenses_controller.dart';
import 'package:estate_app/features/finance/presentation/controllers/rent_charges_controller.dart';
import 'package:estate_app/features/finance/presentation/controllers/rent_payments_controller.dart';
import 'package:get/get.dart';

class FinanceBindings extends Bindings {
  @override
  void dependencies() {
    // Data source
    Get.lazyPut<FinanceRemoteDataSource>(
      () => ApiFinanceRemoteDataSource(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<FinanceRepository>(
      () => FinanceRepositoryImpl(Get.find<FinanceRemoteDataSource>()),
    );

    // Controllers
    Get.lazyPut<RentChargesController>(
      () => RentChargesController(repository: Get.find<FinanceRepository>()),
    );

    Get.lazyPut<RentPaymentsController>(
      () => RentPaymentsController(repository: Get.find<FinanceRepository>()),
    );

    Get.lazyPut<ExpensesController>(
      () => ExpensesController(repository: Get.find<FinanceRepository>()),
    );
  }
}
