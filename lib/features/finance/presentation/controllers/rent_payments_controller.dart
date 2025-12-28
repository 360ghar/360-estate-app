import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:get/get.dart';

class RentPaymentsController extends GetxController {
  RentPaymentsController({required FinanceRepository repository})
      : _repository = repository;

  final FinanceRepository _repository;

  final RxList<RentPayment> items = <RentPayment>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  // Filters
  final Rxn<int> filterLeaseId = Rxn<int>();
  final Rxn<int> filterRentChargeId = Rxn<int>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadPayments());
  }

  Future<void> loadPayments() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getRentPayments(
        page: _page,
        limit: _pageSize,
        leaseId: filterLeaseId.value,
        rentChargeId: filterRentChargeId.value,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load payments', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getRentPayments(
        page: nextPage,
        limit: _pageSize,
        leaseId: filterLeaseId.value,
        rentChargeId: filterRentChargeId.value,
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
    await loadPayments();
  }

  void setLeaseFilter(int? leaseId) {
    filterLeaseId.value = leaseId;
    unawaited(loadPayments());
  }

  void setRentChargeFilter(int? rentChargeId) {
    filterRentChargeId.value = rentChargeId;
    unawaited(loadPayments());
  }

  void clearFilters() {
    filterLeaseId.value = null;
    filterRentChargeId.value = null;
    unawaited(loadPayments());
  }

  bool get hasActiveFilters =>
      filterLeaseId.value != null || filterRentChargeId.value != null;
}
