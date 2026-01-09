import 'package:dio/dio.dart';
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
    AppLogger.d(' Fetching rent charges from /pm/rent/charges');

    final response = await _apiClient.get<dynamic>(
      '/pm/rent/charges',
      queryParameters: <String, dynamic>{
        'offset': page * limit,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (leaseId != null) 'lease_id': leaseId,
        if (status != null) 'status': status,
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      // Backend returns list of RentChargeWithTotals
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue =
          data['charges'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];

      final hasMore = data['has_more'];
      if (hasMore is bool) explicitHasMore = hasMore;
      final total = data['total'] as int?;
      if (total != null) explicitHasMore = ((page + 1) * limit) < total;
    } else {
      rawItems = <dynamic>[];
    }

    final bool hasMore = explicitHasMore ?? rawItems.length == limit;

    // Parse RentChargeWithTotals format from backend
    final items = rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(_parseRentChargeWithTotals)
        .toList(growable: false);

    AppLogger.d(' Fetched ${items.length} rent charges');

    return Page<RentChargeDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  /// Parse the RentChargeWithTotals response from backend
  RentChargeDto _parseRentChargeWithTotals(Map<String, dynamic> json) {
    // Check if this is wrapped in a 'charge' object (RentChargeWithTotals format)
    final chargeData = json['charge'] as Map<String, dynamic>? ?? json;

    // Extract totals if available
    final amountPaidTotal = _parseDouble(json['amount_paid_total']);

    return RentChargeDto(
      id: chargeData['id'] as int,
      leaseId: chargeData['lease_id'] as int? ?? 0,
      propertyId: chargeData['property_id'] as int? ?? 0,
      propertyTitle: '',
      tenantName: '',
      periodStart: DateTime.parse(
        chargeData['period_start'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      periodEnd: DateTime.parse(
        chargeData['period_end'] as String? ?? DateTime.now().toIso8601String(),
      ),
      dueDate: DateTime.parse(
        chargeData['due_date'] as String? ?? DateTime.now().toIso8601String(),
      ),
      amountDue: _parseDouble(chargeData['amount_due']),
      amountPaid: amountPaidTotal,
      lateFee: _parseDouble(chargeData['late_fee_assessed']),
      status: chargeData['status'] as String? ?? 'pending',
      createdAt: chargeData['created_at'] != null
          ? DateTime.parse(chargeData['created_at'] as String)
          : null,
      updatedAt: chargeData['updated_at'] != null
          ? DateTime.parse(chargeData['updated_at'] as String)
          : null,
    );
  }

  @override
  Future<void> generateRentCharges({DateTime? forMonth}) async {
    AppLogger.d(' Generating rent charges at /pm/rent/charges/generate');

    await _apiClient.post<dynamic>(
      '/pm/rent/charges/generate',
      data: <String, dynamic>{
        if (forMonth != null)
          'start_month': forMonth.toIso8601String().split('T')[0],
        'months': 1,
      },
      options: Options(responseType: ResponseType.json),
    );

    AppLogger.d(' Rent charges generated successfully');
  }

  @override
  Future<Page<RentPaymentDto>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  }) async {
    AppLogger.d(' Fetching rent payments from /pm/rent/payments');

    final response = await _apiClient.get<dynamic>(
      '/pm/rent/payments',
      queryParameters: <String, dynamic>{
        'offset': page * limit,
        'limit': limit,
        if (leaseId != null) 'lease_id': leaseId,
        if (rentChargeId != null) 'charge_id': rentChargeId,
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue =
          data['payments'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];

      final hasMore = data['has_more'];
      if (hasMore is bool) explicitHasMore = hasMore;
      final total = data['total'] as int?;
      if (total != null) explicitHasMore = ((page + 1) * limit) < total;
    } else {
      rawItems = <dynamic>[];
    }

    final bool hasMore = explicitHasMore ?? rawItems.length == limit;

    final items = rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(_parseRentPayment)
        .toList(growable: false);

    AppLogger.d(' Fetched ${items.length} rent payments');

    return Page<RentPaymentDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  /// Parse RentPayment from backend response
  RentPaymentDto _parseRentPayment(Map<String, dynamic> json) {
    return RentPaymentDto(
      id: json['id'] as int,
      rentChargeId: json['charge_id'] as int? ?? 0,
      leaseId: json['lease_id'] as int? ?? 0,
      amount: _parseDouble(json['amount_paid']),
      paymentDate: DateTime.parse(
        json['paid_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      paymentMethod: json['payment_method'] as String? ?? 'other',
      referenceNumber: json['reference'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  Future<RentPaymentDto> recordPayment(Map<String, dynamic> data) async {
    AppLogger.d(' Recording payment at /pm/rent/payments');

    // Transform the data to match backend schema (RentPaymentCreate)
    final payload = <String, dynamic>{
      'charge_id': data['charge_id'] ?? data['rent_charge_id'] ?? data['rentChargeId'],
      'amount_paid': data['amount_paid'] ?? data['amount'],
      if (data['paid_at'] != null) 'paid_at': data['paid_at'],
      if (data['payment_date'] != null) 'paid_at': data['payment_date'],
      if (data['payment_method'] != null)
        'payment_method': data['payment_method'],
      if (data['reference'] != null) 'reference': data['reference'],
      if (data['reference_number'] != null) 'reference': data['reference_number'],
      if (data['notes'] != null) 'notes': data['notes'],
      if (data['receipt_document_id'] != null)
        'receipt_document_id': data['receipt_document_id'],
    };

    final response = await _apiClient.post<dynamic>(
      '/pm/rent/payments',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return _parseRentPayment(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return _parseRentPayment(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<RentPaymentDto> submitTenantPaymentIntent({
    required int rentChargeId,
    required Map<String, dynamic> data,
  }) async {
    AppLogger.d(
        ' Submitting tenant payment intent for charge ID: $rentChargeId');

    // Transform the data to match backend schema
    final payload = <String, dynamic>{
      'charge_id': rentChargeId,
      'amount_paid': data['amount_paid'] ?? data['amount'],
      if (data['paid_at'] != null) 'paid_at': data['paid_at'],
      if (data['payment_method'] != null)
        'payment_method': data['payment_method'],
      if (data['reference'] != null) 'reference': data['reference'],
      if (data['notes'] != null) 'notes': data['notes'],
      if (data['receipt_document_id'] != null)
        'receipt_document_id': data['receipt_document_id'],
    };

    final response = await _apiClient.post<dynamic>(
      '/pm/rent/charges/$rentChargeId/tenant-payment-intent',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return _parseRentPayment(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return _parseRentPayment(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
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
    AppLogger.d(' Fetching expenses from /pm/expenses/');

    final response = await _apiClient.get<dynamic>(
      '/pm/expenses/',
      queryParameters: <String, dynamic>{
        'offset': page * limit,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (category != null) 'category': category,
        if (startDate != null)
          'start_date': startDate.toIso8601String().split('T')[0],
        if (endDate != null)
          'end_date': endDate.toIso8601String().split('T')[0],
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;
    bool? explicitHasMore;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue =
          data['expenses'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];

      final hasMore = data['has_more'];
      if (hasMore is bool) explicitHasMore = hasMore;
      final total = data['total'] as int?;
      if (total != null) explicitHasMore = ((page + 1) * limit) < total;
    } else {
      rawItems = <dynamic>[];
    }

    final bool hasMore = explicitHasMore ?? rawItems.length == limit;

    final items = rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(ExpenseDto.fromJson)
        .toList(growable: false);

    AppLogger.d(' Fetched ${items.length} expenses');

    return Page<ExpenseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<ExpenseDto> createExpense(Map<String, dynamic> data) async {
    AppLogger.d(' Creating expense at /pm/expenses/');

    // Transform the data to match backend schema (ExpenseCreate)
    final payload = <String, dynamic>{
      'property_id': data['property_id'] ?? data['propertyId'],
      'category': data['category'],
      'amount': data['amount'],
      'expense_date': data['expense_date'] ??
          data['expenseDate'] ??
          DateTime.now().toIso8601String().split('T')[0],
      if (data['description'] != null) 'description': data['description'],
      if (data['notes'] != null) 'notes': data['notes'],
      if (data['receipt_document_id'] != null)
        'receipt_document_id': data['receipt_document_id'],
      if (data['is_recurring'] != null) 'is_recurring': data['is_recurring'],
      if (data['recurrence_rule'] != null)
        'recurrence_rule': data['recurrence_rule'],
      if (data['next_due_date'] != null)
        'next_due_date': data['next_due_date'],
    };

    final response = await _apiClient.post<dynamic>(
      '/pm/expenses/',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ExpenseDto.fromJson(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return ExpenseDto.fromJson(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  @override
  Future<ExpenseDto> updateExpense(int id, Map<String, dynamic> updates) async {
    AppLogger.d(' Updating expense at /pm/expenses/$id');

    // Transform the data to match backend schema (ExpenseUpdate)
    final payload = <String, dynamic>{
      if (updates['property_id'] != null) 'property_id': updates['property_id'],
      if (updates['category'] != null) 'category': updates['category'],
      if (updates['amount'] != null) 'amount': updates['amount'],
      if (updates['expense_date'] != null)
        'expense_date': updates['expense_date'],
      if (updates['description'] != null) 'description': updates['description'],
      if (updates['notes'] != null) 'notes': updates['notes'],
      if (updates['receipt_document_id'] != null)
        'receipt_document_id': updates['receipt_document_id'],
      if (updates['is_recurring'] != null)
        'is_recurring': updates['is_recurring'],
      if (updates['recurrence_rule'] != null)
        'recurrence_rule': updates['recurrence_rule'],
      if (updates['next_due_date'] != null)
        'next_due_date': updates['next_due_date'],
    };

    final response = await _apiClient.patch<dynamic>(
      '/pm/expenses/$id',
      data: payload,
      options: Options(responseType: ResponseType.json),
    );

    final Object? responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ExpenseDto.fromJson(responseData);
    } else if (responseData is Map<dynamic, dynamic>) {
      return ExpenseDto.fromJson(responseData.cast<String, dynamic>());
    }
    throw Exception('Invalid response format');
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
