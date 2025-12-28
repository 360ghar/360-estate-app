import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:get/get.dart';

class MaintenanceDetailController extends GetxController {
  MaintenanceDetailController({
    required MaintenanceRepository repository,
    required this.requestId,
  }) : _repository = repository;

  final MaintenanceRepository _repository;
  final int requestId;

  final Rx<ViewState<MaintenanceRequest>> state =
      Rx<ViewState<MaintenanceRequest>>(const ViewState.loading());

  final RxBool isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadRequest());
  }

  Future<void> loadRequest() async {
    state.value = const ViewState.loading();

    try {
      final request = await _repository.getRequestById(requestId);
      state.value = ViewState.success(request);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load maintenance request', cause: e),
      );
    }
  }

  Future<void> updateStatus(MaintenanceStatus newStatus) async {
    if (isUpdatingStatus.value) return;

    isUpdatingStatus.value = true;

    try {
      await _repository.updateStatus(requestId, newStatus.apiValue);
      await loadRequest();
      Get.snackbar(
        'Success',
        'Status updated to ${newStatus.displayName}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Failure catch (f) {
      Get.snackbar(
        'Error',
        f.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update status: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  Future<void> markInProgress() => updateStatus(MaintenanceStatus.inProgress);
  Future<void> markOnHold() => updateStatus(MaintenanceStatus.onHold);
  Future<void> markCompleted() => updateStatus(MaintenanceStatus.completed);
  Future<void> markCancelled() => updateStatus(MaintenanceStatus.cancelled);
}
