import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:get/get.dart';

class TenantDetailController extends GetxController {
  TenantDetailController({
    required TenantsRepository repository,
    required String tenantUserId,
  })  : _repository = repository,
        _tenantUserId = tenantUserId;

  final TenantsRepository _repository;
  final String _tenantUserId;

  final Rx<ViewState<Tenant>> state = const ViewState<Tenant>.idle().obs;

  String get tenantUserId => _tenantUserId;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadTenant());
  }

  Future<void> loadTenant() async {
    state.value = const ViewState.loading();

    try {
      final tenant = await _repository.getTenantByUserId(_tenantUserId);
      state.value = ViewState.success(tenant);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load tenant', cause: e),
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadTenant();
  }
}
