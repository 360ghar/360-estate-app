import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:get/get.dart';

class InspectionsController extends GetxController {
  InspectionsController({required InspectionsRepository repository})
      : _repository = repository;

  final InspectionsRepository _repository;

  final items = <Inspection>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final failure = Rxn<Failure>();
  final filterType = Rxn<InspectionType>();
  final filterStatus = Rxn<InspectionStatus>();

  int _currentPage = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  // Public getter for hasMore
  RxBool get hasMore => _hasMore.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadInspections());
  }

  bool get hasActiveFilters =>
      filterType.value != null || filterStatus.value != null;

  Future<void> loadInspections() async {
    if (isLoading.value) return;

    isLoading.value = true;
    failure.value = null;
    _currentPage = 1;

    try {
      final page = await _repository.getInspections(
        page: _currentPage,
        limit: _pageSize,
        inspectionType: filterType.value,
        status: filterStatus.value,
      );

      items.assignAll(page.items);
      _hasMore = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load inspections', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !_hasMore) return;

    isLoadingMore.value = true;

    try {
      _currentPage++;
      final page = await _repository.getInspections(
        page: _currentPage,
        limit: _pageSize,
        inspectionType: filterType.value,
        status: filterStatus.value,
      );

      items.addAll(page.items);
      _hasMore = page.hasMore;
    } on Failure catch (f) {
      _currentPage--;
      failure.value = f;
    } catch (e) {
      _currentPage--;
      failure.value = UnknownFailure('Failed to load more', cause: e);
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadInspections();
  }

  void setTypeFilter(InspectionType? type) {
    if (filterType.value == type) {
      filterType.value = null;
    } else {
      filterType.value = type;
    }
    unawaited(loadInspections());
  }

  void setStatusFilter(InspectionStatus? status) {
    if (filterStatus.value == status) {
      filterStatus.value = null;
    } else {
      filterStatus.value = status;
    }
    unawaited(loadInspections());
  }

  void clearFilters() {
    filterType.value = null;
    filterStatus.value = null;
    unawaited(loadInspections());
  }

  // Stats
  int get scheduledCount =>
      items.where((i) => i.status == InspectionStatus.scheduled).length;
  int get inProgressCount =>
      items.where((i) => i.status == InspectionStatus.inProgress).length;
  int get pendingReviewCount =>
      items.where((i) => i.status == InspectionStatus.pendingReview).length;
  int get completedCount =>
      items.where((i) => i.status == InspectionStatus.completed).length;
}
