import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:get/get.dart';

class LeaseDetailController extends GetxController {
  LeaseDetailController({
    required LeasesRepository repository,
    required int leaseId,
  })  : _repository = repository,
        _leaseId = leaseId;

  final LeasesRepository _repository;
  final int _leaseId;

  final Rx<ViewState<Lease>> state = const ViewState<Lease>.idle().obs;

  int get leaseId => _leaseId;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadLease());
  }

  Future<void> loadLease() async {
    state.value = const ViewState.loading();

    try {
      final lease = await _repository.getLeaseById(_leaseId);
      state.value = ViewState.success(lease);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load lease', cause: e),
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadLease();
  }

  Future<bool> renewLease({
    required DateTime newEndDate,
    double? newMonthlyRent,
  }) async {
    try {
      final lease = await _repository.renewLease(
        leaseId: _leaseId,
        newEndDate: newEndDate,
        newMonthlyRent: newMonthlyRent,
      );
      state.value = ViewState.success(lease);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> terminateLease({String? reason}) async {
    try {
      await _repository.terminateLease(_leaseId, reason: reason);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadSignedDocument(String filePath) async {
    try {
      final lease = await _repository.uploadSignedLease(_leaseId, filePath);
      state.value = ViewState.success(lease);
      return true;
    } catch (e) {
      return false;
    }
  }
}
