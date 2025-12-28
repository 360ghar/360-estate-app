import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:get/get.dart';

class ExpensesController extends GetxController {
  ExpensesController({required FinanceRepository repository})
      : _repository = repository;

  final FinanceRepository _repository;

  final RxList<Expense> items = <Expense>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  // Filters
  final Rxn<int> filterPropertyId = Rxn<int>();
  final Rxn<ExpenseCategory> filterCategory = Rxn<ExpenseCategory>();
  final Rxn<DateTime> filterStartDate = Rxn<DateTime>();
  final Rxn<DateTime> filterEndDate = Rxn<DateTime>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadExpenses());
  }

  Future<void> loadExpenses() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getExpenses(
        page: _page,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        category: filterCategory.value?.name,
        startDate: filterStartDate.value,
        endDate: filterEndDate.value,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load expenses', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getExpenses(
        page: nextPage,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        category: filterCategory.value?.name,
        startDate: filterStartDate.value,
        endDate: filterEndDate.value,
      );

      items.addAll(page.items);
      _page = nextPage;
      hasMore.value = page.hasMore;
    } catch (_) {
      // Silently fail for load more
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadExpenses();
  }

  void setPropertyFilter(int? propertyId) {
    filterPropertyId.value = propertyId;
    unawaited(loadExpenses());
  }

  void setCategoryFilter(ExpenseCategory? category) {
    filterCategory.value = category;
    unawaited(loadExpenses());
  }

  void setDateRange(DateTime? start, DateTime? end) {
    filterStartDate.value = start;
    filterEndDate.value = end;
    unawaited(loadExpenses());
  }

  void clearFilters() {
    filterPropertyId.value = null;
    filterCategory.value = null;
    filterStartDate.value = null;
    filterEndDate.value = null;
    unawaited(loadExpenses());
  }

  bool get hasActiveFilters =>
      filterPropertyId.value != null ||
      filterCategory.value != null ||
      filterStartDate.value != null ||
      filterEndDate.value != null;

  double get totalExpenses =>
      items.fold(0.0, (sum, expense) => sum + expense.amount);
}
