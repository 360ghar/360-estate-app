import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';

abstract interface class FinanceRepository {
  // Rent Charges
  Future<Page<RentCharge>> getRentCharges({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? status,
  });

  Future<void> generateRentCharges({DateTime? forMonth});

  // Rent Payments
  Future<Page<RentPayment>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  });

  Future<RentPayment> recordPayment({
    required int rentChargeId,
    required int leaseId,
    required double amount,
    required DateTime paymentDate,
    required String paymentMethod,
    String? referenceNumber,
    String? notes,
  });

  // Expenses
  Future<Page<Expense>> getExpenses({
    required int page,
    required int limit,
    int? propertyId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Expense> createExpense({
    int? propertyId,
    required String category,
    required double amount,
    required DateTime expenseDate,
    required String description,
    String? vendor,
    String? notes,
  });

  Future<Expense> updateExpense(int id, Map<String, dynamic> updates);
}
