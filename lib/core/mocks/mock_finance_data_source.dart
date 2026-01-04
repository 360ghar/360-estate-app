/// Mock implementation of FinanceRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:estate_app/features/finance/data/models/expense_dto.dart';
import 'package:estate_app/features/finance/data/models/rent_charge_dto.dart';
import 'package:estate_app/features/finance/data/models/rent_payment_dto.dart';

final class MockFinanceRemoteDataSource implements FinanceRemoteDataSource {
  MockFinanceRemoteDataSource();

  // Local mutable copies for CRUD operations
  final List<Map<String, dynamic>> _rentCharges = 
      List<Map<String, dynamic>>.from(MockDataFactory.rentCharges);
  final List<Map<String, dynamic>> _expenses = 
      List<Map<String, dynamic>>.from(MockDataFactory.expenses);
  final List<Map<String, dynamic>> _payments = [];

  int _nextChargeId = 100;
  int _nextExpenseId = 100;
  int _nextPaymentId = 1;

  // ============================================================
  // Rent Charges
  // ============================================================
  @override
  Future<Page<RentChargeDto>> getRentCharges({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _rentCharges.toList();

    // Apply filters
    if (propertyId != null) {
      filtered = filtered.where((c) => c['property_id'] == propertyId).toList();
    }
    if (leaseId != null) {
      filtered = filtered.where((c) => c['lease_id'] == leaseId).toList();
    }
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((c) => c['status'] == status).toList();
    }

    // Sort by due_date descending
    filtered.sort((a, b) {
      final aDate = DateTime.parse(a['due_date'] as String);
      final bDate = DateTime.parse(b['due_date'] as String);
      return bDate.compareTo(aDate);
    });

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map((c) => RentChargeDto.fromJson(c)).toList();

    return Page<RentChargeDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<void> generateRentCharges({DateTime? forMonth}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final month = forMonth ?? DateTime.now();
    final periodStart = DateTime(month.year, month.month);
    final periodEnd = DateTime(month.year, month.month + 1, 0);

    // Get active leases
    final activeLeases = MockDataFactory.leases.where((l) => l['status'] == 'active');

    for (final lease in activeLeases) {
      final leaseId = lease['id'] as int;
      
      // Check if charge already exists for this period
      final exists = _rentCharges.any((c) =>
          c['lease_id'] == leaseId &&
          (c['period_start'] as String).startsWith('${month.year}-${month.month.toString().padLeft(2, '0')}'),);
      
      if (exists) continue;

      final rentDueDay = lease['rent_due_day'] as int? ?? 1;
      final dueDate = DateTime(month.year, month.month, rentDueDay);

      final now = DateTime.now().toIso8601String();
      final newCharge = {
        'id': _nextChargeId++,
        'lease_id': leaseId,
        'property_id': lease['property_id'],
        'property_title': lease['property_title'],
        'tenant_name': lease['tenant_name'],
        'period_start': periodStart.toIso8601String().split('T')[0],
        'period_end': periodEnd.toIso8601String().split('T')[0],
        'due_date': dueDate.toIso8601String().split('T')[0],
        'amount_due': lease['monthly_rent'],
        'amount_paid': 0.0,
        'late_fee': 0.0,
        'status': 'pending',
        'created_at': now,
        'updated_at': now,
      };

      _rentCharges.insert(0, newCharge);
    }
  }

  // ============================================================
  // Rent Payments
  // ============================================================
  @override
  Future<Page<RentPaymentDto>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    var filtered = _payments.toList();

    if (leaseId != null) {
      filtered = filtered.where((p) => p['lease_id'] == leaseId).toList();
    }
    if (rentChargeId != null) {
      filtered = filtered.where((p) => p['rent_charge_id'] == rentChargeId).toList();
    }

    // Sort by payment_date descending
    filtered.sort((a, b) {
      final aDate = DateTime.parse(a['payment_date'] as String);
      final bDate = DateTime.parse(b['payment_date'] as String);
      return bDate.compareTo(aDate);
    });

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map((p) => RentPaymentDto.fromJson(p)).toList();

    return Page<RentPaymentDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<RentPaymentDto> recordPayment(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();
    final rentChargeId = data['rent_charge_id'] as int;
    final amount = (data['amount'] as num).toDouble();

    // Update the rent charge
    final chargeIndex = _rentCharges.indexWhere((c) => c['id'] == rentChargeId);
    if (chargeIndex != -1) {
      final charge = Map<String, dynamic>.from(_rentCharges[chargeIndex]);
      final currentPaid = (charge['amount_paid'] as num).toDouble();
      final newPaid = currentPaid + amount;
      final amountDue = (charge['amount_due'] as num).toDouble();
      final lateFee = (charge['late_fee'] as num).toDouble();
      final totalDue = amountDue + lateFee;

      charge['amount_paid'] = newPaid;
      charge['status'] = newPaid >= totalDue ? 'paid' : 'partially_paid';
      charge['updated_at'] = now;

      _rentCharges[chargeIndex] = charge;
    }

    final newPayment = {
      'id': _nextPaymentId++,
      'rent_charge_id': rentChargeId,
      'lease_id': data['lease_id'],
      'amount': amount,
      'payment_date': data['payment_date'] ?? now.split('T')[0],
      'payment_method': data['payment_method'] ?? 'bank_transfer',
      'reference_number': data['reference_number'],
      'notes': data['notes'],
      'created_at': now,
      'updated_at': now,
    };

    _payments.insert(0, newPayment);
    return RentPaymentDto.fromJson(newPayment);
  }

  @override
  Future<RentPaymentDto> submitTenantPaymentIntent({
    required int rentChargeId,
    required Map<String, dynamic> data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();
    final amount = (data['amount'] as num?) ?? 0.0;

    // Find the rent charge
    final charge = _rentCharges.firstWhere(
      (c) => c['id'] == rentChargeId,
      orElse: () => throw Exception('Rent charge not found: $rentChargeId'),
    );

    final newPayment = {
      'id': _nextPaymentId++,
      'rent_charge_id': rentChargeId,
      'lease_id': charge['lease_id'],
      'amount': amount,
      'payment_date': now.split('T')[0],
      'payment_method': data['payment_method'] ?? 'upi',
      'reference_number': data['screenshot_url'] ?? 'pending',
      'notes': 'Tenant payment intent - pending verification',
      'status': 'pending',
      'created_at': now,
      'updated_at': now,
    };

    _payments.insert(0, newPayment);
    return RentPaymentDto.fromJson(newPayment);
  }

  // ============================================================
  // Expenses
  // ============================================================
  @override
  Future<Page<ExpenseDto>> getExpenses({
    required int page,
    required int limit,
    int? propertyId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _expenses.toList();

    // Apply filters
    if (propertyId != null) {
      filtered = filtered.where((e) => e['property_id'] == propertyId).toList();
    }
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((e) => e['category'] == category).toList();
    }
    if (startDate != null) {
      filtered = filtered.where((e) {
        final date = DateTime.parse(e['expense_date'] as String);
        return !date.isBefore(startDate);
      }).toList();
    }
    if (endDate != null) {
      filtered = filtered.where((e) {
        final date = DateTime.parse(e['expense_date'] as String);
        return !date.isAfter(endDate);
      }).toList();
    }

    // Sort by expense_date descending
    filtered.sort((a, b) {
      final aDate = DateTime.parse(a['expense_date'] as String);
      final bDate = DateTime.parse(b['expense_date'] as String);
      return bDate.compareTo(aDate);
    });

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map((e) => ExpenseDto.fromJson(e)).toList();

    return Page<ExpenseDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<ExpenseDto> createExpense(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();
    final propertyId = data['property_id'] as int?;
    
    // Find property title if property_id provided
    String? propertyTitle;
    if (propertyId != null) {
      final property = MockDataFactory.findPropertyById(propertyId);
      propertyTitle = property?['title'] as String?;
    }

    final newExpense = {
      'id': _nextExpenseId++,
      'property_id': propertyId,
      'property_title': propertyTitle,
      'category': data['category'] ?? 'other',
      'amount': (data['amount'] as num).toDouble(),
      'expense_date': data['expense_date'] ?? now.split('T')[0],
      'description': data['description'] ?? '',
      'vendor': data['vendor'],
      'receipt_url': null,
      'notes': data['notes'],
      'created_at': now,
      'updated_at': now,
    };

    _expenses.insert(0, newExpense);
    return ExpenseDto.fromJson(newExpense);
  }

  @override
  Future<ExpenseDto> updateExpense(int id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _expenses.indexWhere((e) => e['id'] == id);
    if (index == -1) {
      throw Exception('Expense not found: $id');
    }

    final updated = Map<String, dynamic>.from(_expenses[index]);
    updates.forEach((key, value) {
      final snakeKey = key.replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '_${m.group(0)!.toLowerCase()}',
      );
      updated[snakeKey] = value;
    });
    updated['updated_at'] = DateTime.now().toIso8601String();

    _expenses[index] = updated;
    return ExpenseDto.fromJson(updated);
  }
}
