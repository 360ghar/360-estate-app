import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepository(ref.read(apiClientProvider));
});

final expensesListProvider = FutureProvider<List<Expense>>((ref) {
  return ref.read(expensesRepositoryProvider).list();
});
