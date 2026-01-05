import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/finance/data/models/expense_dto.dart';
import 'package:estate_app/features/finance/data/models/rent_charge_dto.dart';
import 'package:estate_app/features/finance/data/models/rent_payment_dto.dart';

abstract interface class FinanceRemoteDataSource {
  // Rent Charges
  Future<Page<RentChargeDto>> getRentCharges({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? status,
  });

  Future<void> generateRentCharges({DateTime? forMonth});

  // Rent Payments
  Future<Page<RentPaymentDto>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  });

  Future<RentPaymentDto> recordPayment(Map<String, dynamic> data);

  // Tenant Payment Intent
  Future<RentPaymentDto> submitTenantPaymentIntent({
    required int rentChargeId,
    required Map<String, dynamic> data,
  });

  // Expenses
  Future<Page<ExpenseDto>> getExpenses({
    required int page,
    required int limit,
    int? propertyId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ExpenseDto> createExpense(Map<String, dynamic> data);

  Future<ExpenseDto> updateExpense(int id, Map<String, dynamic> updates);
}

final class ApiFinanceRemoteDataSource implements FinanceRemoteDataSource {
  ApiFinanceRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<RentChargeDto>> getRentCharges({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? status,
  }) async {
    // NOTE: /pm/rent/charges endpoint does NOT exist in the current backend
    // This is a placeholder implementation until the PM module is added
    AppLogger.w(' /pm/rent/charges endpoint not available in backend');
    AppLogger.d(' Returning empty list - PM module pending implementation');

    return Page<RentChargeDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<void> generateRentCharges({DateTime? forMonth}) async {
    // NOTE: /pm/rent/charges/generate endpoint does NOT exist
    AppLogger.w(' /pm/rent/charges/generate endpoint not available');
    throw UnsupportedError(
      'Rent charge generation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<Page<RentPaymentDto>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  }) async {
    // NOTE: /pm/rent/payments endpoint does NOT exist
    AppLogger.w(' /pm/rent/payments endpoint not available in backend');
    AppLogger.d(' Returning empty list - PM module pending implementation');

    return Page<RentPaymentDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<RentPaymentDto> recordPayment(Map<String, dynamic> data) async {
    // NOTE: POST /pm/rent/payments endpoint does NOT exist
    AppLogger.w(' POST /pm/rent/payments endpoint not available');
    throw UnsupportedError(
      'Payment recording is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<RentPaymentDto> submitTenantPaymentIntent({
    required int rentChargeId,
    required Map<String, dynamic> data,
  }) async {
    // NOTE: /pm/rent/charges/{id}/tenant-payment-intent endpoint does NOT exist
    AppLogger.w(' Tenant payment intent endpoint not available');
    throw UnsupportedError(
      'Payment intent submission is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<Page<ExpenseDto>> getExpenses({
    required int page,
    required int limit,
    int? propertyId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // NOTE: /pm/expenses endpoint does NOT exist
    AppLogger.w(' /pm/expenses endpoint not available in backend');
    AppLogger.d(' Returning empty list - PM module pending implementation');

    return Page<ExpenseDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<ExpenseDto> createExpense(Map<String, dynamic> data) async {
    // NOTE: POST /pm/expenses endpoint does NOT exist
    AppLogger.w(' POST /pm/expenses endpoint not available');
    throw UnsupportedError(
      'Expense creation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ExpenseDto> updateExpense(int id, Map<String, dynamic> updates) async {
    // NOTE: PATCH /pm/expenses/{id} endpoint does NOT exist
    AppLogger.w(' PATCH /pm/expenses/$id endpoint not available');
    throw UnsupportedError(
      'Expense update is not yet available. PM module pending backend implementation.',
    );
  }
}
