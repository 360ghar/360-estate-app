import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:get/get.dart';

class RentChargesController extends GetxController {
  RentChargesController({required FinanceRepository repository})
      : _repository = repository;

  final FinanceRepository _repository;

  final RxList<RentCharge> items = <RentCharge>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();
  final RxBool isGenerating = false.obs;

  // Filters
  final Rxn<int> filterPropertyId = Rxn<int>();
  final Rxn<int> filterLeaseId = Rxn<int>();
  final Rxn<RentChargeStatus> filterStatus = Rxn<RentChargeStatus>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadCharges());
  }

  Future<void> loadCharges() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getRentCharges(
        page: _page,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        leaseId: filterLeaseId.value,
        status: filterStatus.value?.name,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load rent charges', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getRentCharges(
        page: nextPage,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        leaseId: filterLeaseId.value,
        status: filterStatus.value?.name,
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
    await loadCharges();
  }

  void setPropertyFilter(int? propertyId) {
    filterPropertyId.value = propertyId;
    unawaited(loadCharges());
  }

  void setLeaseFilter(int? leaseId) {
    filterLeaseId.value = leaseId;
    unawaited(loadCharges());
  }

  void setStatusFilter(RentChargeStatus? status) {
    filterStatus.value = status;
    unawaited(loadCharges());
  }

  void clearFilters() {
    filterPropertyId.value = null;
    filterLeaseId.value = null;
    filterStatus.value = null;
    unawaited(loadCharges());
  }

  bool get hasActiveFilters =>
      filterPropertyId.value != null ||
      filterLeaseId.value != null ||
      filterStatus.value != null;

  Future<void> generateCharges({DateTime? forMonth}) async {
    try {
      isGenerating.value = true;
      await _repository.generateRentCharges(forMonth: forMonth);
      await loadCharges();
      Get.snackbar(
        'Success',
        'Rent charges generated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate rent charges: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGenerating.value = false;
    }
  }
}
