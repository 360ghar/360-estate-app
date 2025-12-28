import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:estate_app/features/finance/presentation/controllers/expense_form_controller.dart';
import 'package:get/get.dart';

class ExpenseFormBindings extends Bindings {
  @override
  void dependencies() {
    // Arguments can be Expense for editing, int for propertyId, or null for new expense
    final args = Get.arguments;
    Expense? existingExpense;
    int? propertyId;

    if (args is Expense) {
      existingExpense = args;
    } else if (args is int) {
      propertyId = args;
    } else if (args is Map<String, dynamic>) {
      existingExpense = args['expense'] as Expense?;
      propertyId = args['propertyId'] as int?;
    }

    Get.lazyPut<ExpenseFormController>(
      () => ExpenseFormController(
        repository: Get.find<FinanceRepository>(),
        existingExpense: existingExpense,
        propertyId: propertyId,
      ),
    );
  }
}
