import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:get/get.dart';

class MaintenanceController extends GetxController {
  MaintenanceController({required MaintenanceRepository repository})
      : _repository = repository;

  final MaintenanceRepository _repository;

  final RxList<MaintenanceRequest> items = <MaintenanceRequest>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  // Filters
  final Rxn<int> filterPropertyId = Rxn<int>();
  final Rxn<MaintenanceStatus> filterStatus = Rxn<MaintenanceStatus>();
  final Rxn<MaintenancePriority> filterPriority = Rxn<MaintenancePriority>();
  final Rxn<MaintenanceCategory> filterCategory = Rxn<MaintenanceCategory>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadRequests());
  }

  Future<void> loadRequests() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getRequests(
        page: _page,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        status: filterStatus.value?.apiValue,
        priority: filterPriority.value?.name,
        category: filterCategory.value?.name,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value =
          UnknownFailure('Failed to load maintenance requests', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getRequests(
        page: nextPage,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        status: filterStatus.value?.apiValue,
        priority: filterPriority.value?.name,
        category: filterCategory.value?.name,
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
    await loadRequests();
  }

  void setPropertyFilter(int? propertyId) {
    filterPropertyId.value = propertyId;
    unawaited(loadRequests());
  }

  void setStatusFilter(MaintenanceStatus? status) {
    filterStatus.value = status;
    unawaited(loadRequests());
  }

  void setPriorityFilter(MaintenancePriority? priority) {
    filterPriority.value = priority;
    unawaited(loadRequests());
  }

  void setCategoryFilter(MaintenanceCategory? category) {
    filterCategory.value = category;
    unawaited(loadRequests());
  }

  void clearFilters() {
    filterPropertyId.value = null;
    filterStatus.value = null;
    filterPriority.value = null;
    filterCategory.value = null;
    unawaited(loadRequests());
  }

  bool get hasActiveFilters =>
      filterPropertyId.value != null ||
      filterStatus.value != null ||
      filterPriority.value != null ||
      filterCategory.value != null;

  // Quick stats
  int get openCount =>
      items.where((r) => r.status == MaintenanceStatus.open).length;
  int get inProgressCount =>
      items.where((r) => r.status == MaintenanceStatus.inProgress).length;
  int get urgentCount =>
      items.where((r) => r.priority == MaintenancePriority.urgent).length;
}
