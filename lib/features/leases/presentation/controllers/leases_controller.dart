import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:get/get.dart';

class LeasesController extends GetxController {
  LeasesController({
    required LeasesRepository repository,
  }) : _repository = repository;

  final LeasesRepository _repository;

  final RxList<Lease> items = <Lease>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();
  final Rxn<int> filterPropertyId = Rxn<int>();
  final Rxn<String> filterStatus = Rxn<String>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadLeases());
  }

  Future<void> loadLeases() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getLeases(
        page: _page,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        status: filterStatus.value,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load leases', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getLeases(
        page: nextPage,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        status: filterStatus.value,
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
    await loadLeases();
  }

  void setPropertyFilter(int? propertyId) {
    filterPropertyId.value = propertyId;
    unawaited(loadLeases());
  }

  void setStatusFilter(String? status) {
    filterStatus.value = status;
    unawaited(loadLeases());
  }

  void clearFilters() {
    filterPropertyId.value = null;
    filterStatus.value = null;
    unawaited(loadLeases());
  }
}
