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
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      if (status != null) 'status': status,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/rent/charges',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [])
        .map((e) => RentChargeDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return Page<RentChargeDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<void> generateRentCharges({DateTime? forMonth}) async {
    final data = <String, dynamic>{};
    if (forMonth != null) {
      data['for_month'] = forMonth.toIso8601String().split('T')[0];
    }

    await _apiClient.post<void>(
      '/pm/rent/charges/generate',
      data: data,
    );
  }

  @override
  Future<Page<RentPaymentDto>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  }) async {
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (leaseId != null) 'lease_id': leaseId,
      if (rentChargeId != null) 'rent_charge_id': rentChargeId,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/rent/payments',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [])
        .map((e) => RentPaymentDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return Page<RentPaymentDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<RentPaymentDto> recordPayment(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/rent/payments',
      data: data,
    );

    return RentPaymentDto.fromJson(response.data!);
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
    final offset = (page - 1) * limit;
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (category != null) 'category': category,
      if (startDate != null) 'start': startDate.toIso8601String().split('T')[0],
      if (endDate != null) 'end': endDate.toIso8601String().split('T')[0],
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/expenses',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items = (data['items'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [])
        .map((e) => ExpenseDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as int? ?? items.length;
    final hasMore = offset + items.length < total;

    return Page<ExpenseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<ExpenseDto> createExpense(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/expenses',
      data: data,
    );

    return ExpenseDto.fromJson(response.data!);
  }

  @override
  Future<ExpenseDto> updateExpense(int id, Map<String, dynamic> updates) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/expenses/$id',
      data: updates,
    );

    return ExpenseDto.fromJson(response.data!);
  }
}
