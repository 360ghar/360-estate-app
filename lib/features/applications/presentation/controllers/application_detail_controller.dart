import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';
import 'package:get/get.dart';

class ApplicationDetailController extends GetxController {
  ApplicationDetailController({
    required ApplicationsRepository repository,
    required this.applicationId,
  }) : _repository = repository;

  final ApplicationsRepository _repository;
  final int applicationId;

  final state = Rx<ViewState<Application>>(const ViewState.loading());
  final isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadApplication());
  }

  Future<void> loadApplication() async {
    state.value = const ViewState.loading();

    try {
      final application = await _repository.getApplicationById(applicationId);
      state.value = ViewState.success(application);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load application', cause: e),
      );
    }
  }

  Future<void> startReview() async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.reviewApplication(applicationId);
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Application moved to review');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start review');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> approve({String? notes}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.approveApplication(
        applicationId,
        notes: notes,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Application approved');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve application');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> reject({String? notes}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.rejectApplication(
        applicationId,
        notes: notes,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Application rejected');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject application');
    } finally {
      isActionLoading.value = false;
    }
  }
}
