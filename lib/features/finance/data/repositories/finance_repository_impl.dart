import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';

final class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._remoteDataSource);

  final FinanceRemoteDataSource _remoteDataSource;

  @override
  Future<Page<RentCharge>> getRentCharges({
    required int page,
    required int limit,
    int? propertyId,
    int? leaseId,
    String? status,
  }) async {
    final dtoPage = await _remoteDataSource.getRentCharges(
      page: page,
      limit: limit,
      propertyId: propertyId,
      leaseId: leaseId,
      status: status,
    );

    return Page<RentCharge>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<void> generateRentCharges({DateTime? forMonth}) async {
    await _remoteDataSource.generateRentCharges(forMonth: forMonth);
  }

  @override
  Future<Page<RentPayment>> getRentPayments({
    required int page,
    required int limit,
    int? leaseId,
    int? rentChargeId,
  }) async {
    final dtoPage = await _remoteDataSource.getRentPayments(
      page: page,
      limit: limit,
      leaseId: leaseId,
      rentChargeId: rentChargeId,
    );

    return Page<RentPayment>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<RentPayment> recordPayment({
    required int rentChargeId,
    required int leaseId,
    required double amount,
    required DateTime paymentDate,
    required String paymentMethod,
    String? referenceNumber,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      'rent_charge_id': rentChargeId,
      'lease_id': leaseId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String().split('T')[0],
      'payment_method': paymentMethod,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (notes != null) 'notes': notes,
    };

    final dto = await _remoteDataSource.recordPayment(data);
    return dto.toEntity();
  }

  @override
  Future<Page<Expense>> getExpenses({
    required int page,
    required int limit,
    int? propertyId,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dtoPage = await _remoteDataSource.getExpenses(
      page: page,
      limit: limit,
      propertyId: propertyId,
      category: category,
      startDate: startDate,
      endDate: endDate,
    );

    return Page<Expense>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<Expense> createExpense({
    int? propertyId,
    required String category,
    required double amount,
    required DateTime expenseDate,
    required String description,
    String? vendor,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      if (propertyId != null) 'property_id': propertyId,
      'category': category,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String().split('T')[0],
      'description': description,
      if (vendor != null) 'vendor': vendor,
      if (notes != null) 'notes': notes,
    };

    final dto = await _remoteDataSource.createExpense(data);
    return dto.toEntity();
  }

  @override
  Future<Expense> updateExpense(int id, Map<String, dynamic> updates) async {
    final dto = await _remoteDataSource.updateExpense(id, updates);
    return dto.toEntity();
  }
}
