import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:get/get.dart';

class InspectionDetailController extends GetxController {
  InspectionDetailController({
    required InspectionsRepository repository,
    required this.inspectionId,
  }) : _repository = repository;

  final InspectionsRepository _repository;
  final int inspectionId;

  final state = Rx<ViewState<Inspection>>(const ViewState.loading());
  final isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadInspection());
  }

  Future<void> loadInspection() async {
    state.value = const ViewState.loading();

    try {
      final inspection = await _repository.getInspectionById(inspectionId);
      state.value = ViewState.success(inspection);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load inspection', cause: e),
      );
    }
  }

  Future<void> startInspection() async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.startInspection(inspectionId);
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Inspection started');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start inspection');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> completeInspection({String? notes}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.completeInspection(
        inspectionId,
        notes: notes,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Inspection completed');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete inspection');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> signInspection({
    required String signatureType,
    required String signature,
  }) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.signInspection(
        inspectionId,
        signatureType: signatureType,
        signature: signature,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Inspection signed');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign inspection');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> cancelInspection({String? reason}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      await _repository.cancelInspection(inspectionId, reason: reason);
      await loadInspection();
      Get.snackbar('Success', 'Inspection cancelled');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel inspection');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> addItem({
    required String area,
    required String item,
    required String condition,
    String? notes,
  }) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.addInspectionItem(
        inspectionId,
        area: area,
        item: item,
        condition: condition,
        notes: notes,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Item added');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> updateItem(
    int itemId, {
    String? condition,
    String? notes,
  }) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    try {
      final updated = await _repository.updateInspectionItem(
        inspectionId,
        itemId,
        condition: condition,
        notes: notes,
      );
      state.value = ViewState.success(updated);
      Get.snackbar('Success', 'Item updated');
    } on Failure catch (f) {
      Get.snackbar('Error', f.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item');
    } finally {
      isActionLoading.value = false;
    }
  }
}
