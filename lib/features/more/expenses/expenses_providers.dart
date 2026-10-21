import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  ref.watch(accountScopeProvider);
  return ExpensesRepository(ref.read(apiClientProvider));
});

/// Every expense of the account (all pages).
final expensesListProvider = FutureProvider<List<Expense>>((ref) {
  return ref.watch(expensesRepositoryProvider).listAll();
});

/// Property-scoped variant of [expensesListProvider]. Used by the
/// property-detail Expenses tab so the backend does the filtering (all pages).
final expensesForPropertyProvider = FutureProvider.family<List<Expense>, int>((
  ref,
  propertyId,
) {
  return ref.watch(expensesRepositoryProvider).listAll(propertyId: propertyId);
});
