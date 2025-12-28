import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:estate_app/features/finance/presentation/controllers/record_payment_controller.dart';
import 'package:get/get.dart';

class RecordPaymentBindings extends Bindings {
  @override
  void dependencies() {
    final rentCharge = Get.arguments as RentCharge;

    Get.lazyPut<RecordPaymentController>(
      () => RecordPaymentController(
        repository: Get.find<FinanceRepository>(),
        rentCharge: rentCharge,
      ),
    );
  }
}
