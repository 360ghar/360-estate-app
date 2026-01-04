import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:get/get.dart';

class TenantDetailController extends GetxController {
  TenantDetailController({
    required TenantsRepository repository,
    required String tenantId,
  })  : _repository = repository,
        _tenantId = tenantId;

  final TenantsRepository _repository;
  final String _tenantId;

  final Rx<ViewState<Tenant>> state = const ViewState<Tenant>.idle().obs;

  String get tenantId => _tenantId;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadTenant());
  }

  Future<void> loadTenant() async {
    state.value = const ViewState.loading();

    try {
      final tenant = await _repository.getTenantById(_tenantId);
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
