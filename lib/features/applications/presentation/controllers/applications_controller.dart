import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:get/get.dart';

class ApplicationsController extends GetxController {
  ApplicationsController({required ApplicationsRepository repository})
      : _repository = repository;

  final ApplicationsRepository _repository;

  // Forms
  final forms = <ApplicationForm>[].obs;
  final isLoadingForms = false.obs;
  final formsFailure = Rxn<Failure>();

  // Applications
  final applications = <Application>[].obs;
  final isLoadingApplications = false.obs;
  final isLoadingMore = false.obs;
  final applicationsFailure = Rxn<Failure>();
  final filterStatus = Rxn<ApplicationStatus>();

  int _currentPage = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadForms());
    unawaited(loadApplications());
  }

  bool get hasActiveFilters => filterStatus.value != null;

  // Forms methods
  Future<void> loadForms() async {
    if (isLoadingForms.value) return;

    isLoadingForms.value = true;
    formsFailure.value = null;

    try {
      final page = await _repository.getApplicationForms(
        page: 1,
        limit: 100,
        isActive: true,
      );

      forms.assignAll(page.items);
    } on Failure catch (f) {
      formsFailure.value = f;
    } catch (e) {
      formsFailure.value = UnknownFailure('Failed to load forms', cause: e);
    } finally {
      isLoadingForms.value = false;
    }
  }

  Future<void> deactivateForm(int id) async {
    try {
      await _repository.deactivateApplicationForm(id);
      forms.removeWhere((f) => f.id == id);
      Get.snackbar('Success', 'Application form deactivated');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to deactivate form');
    }
  }

  // Applications methods
  Future<void> loadApplications() async {
    if (isLoadingApplications.value) return;

    isLoadingApplications.value = true;
    applicationsFailure.value = null;
    _currentPage = 1;

    try {
      final page = await _repository.getApplications(
        page: _currentPage,
        limit: _pageSize,
        status: filterStatus.value,
      );

      applications.assignAll(page.items);
      _hasMore = page.hasMore;
    } on Failure catch (f) {
      applicationsFailure.value = f;
    } catch (e) {
      applicationsFailure.value =
          UnknownFailure('Failed to load applications', cause: e);
    } finally {
      isLoadingApplications.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingApplications.value || isLoadingMore.value || !_hasMore) return;

    isLoadingMore.value = true;

    try {
      _currentPage++;
      final page = await _repository.getApplications(
        page: _currentPage,
        limit: _pageSize,
        status: filterStatus.value,
      );

      applications.addAll(page.items);
      _hasMore = page.hasMore;
    } on Failure catch (f) {
      _currentPage--;
      applicationsFailure.value = f;
    } catch (e) {
      _currentPage--;
      applicationsFailure.value =
          UnknownFailure('Failed to load more', cause: e);
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await Future.wait([
      loadForms(),
      loadApplications(),
    ]);
  }

  void setStatusFilter(ApplicationStatus? status) {
    if (filterStatus.value == status) {
      filterStatus.value = null;
    } else {
      filterStatus.value = status;
    }
    unawaited(loadApplications());
  }

  void clearFilters() {
    filterStatus.value = null;
    unawaited(loadApplications());
  }

  // Stats
  int get pendingCount =>
      applications.where((a) => a.status == ApplicationStatus.pending).length;
  int get underReviewCount => applications
      .where((a) => a.status == ApplicationStatus.underReview)
      .length;
  int get approvedCount =>
      applications.where((a) => a.status == ApplicationStatus.approved).length;
  int get rejectedCount =>
      applications.where((a) => a.status == ApplicationStatus.rejected).length;
}
