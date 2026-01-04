import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:get/get.dart';

class PropertyDetailController extends GetxController {
  PropertyDetailController({
    required PropertiesRepository repository,
    required int propertyId,
  })  : _repository = repository,
        _propertyId = propertyId;

  final PropertiesRepository _repository;
  final int _propertyId;

  final Rx<ViewState<Property>> state = const ViewState<Property>.idle().obs;
  final RxInt selectedTabIndex = 0.obs;

  int get propertyId => _propertyId;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadProperty());
  }

  Future<void> loadProperty() async {
    state.value = const ViewState.loading();

    try {
      final property = await _repository.getPropertyById(_propertyId);
      state.value = ViewState.success(property);
    } on Failure catch (f) {
      state.value = ViewState.error(f);
    } catch (e) {
      state.value = ViewState.error(
        UnknownFailure('Failed to load property', cause: e),
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadProperty();
  }

  Future<bool> updateProperty(Map<String, dynamic> updates) async {
    try {
      final property = await _repository.updateProperty(_propertyId, updates);
      state.value = ViewState.success(property);
      return true;
    } on Failure catch (f) {
      Get.snackbar('Update Failed', f.message);
      return false;
    } catch (e) {
      Get.snackbar('Update Failed', 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> deleteProperty() async {
    try {
      await _repository.deleteProperty(_propertyId);
      return true;
    } on Failure catch (f) {
      Get.snackbar('Deletion Failed', f.message);
      return false;
    } catch (e) {
      Get.snackbar('Deletion Failed', 'An unexpected error occurred');
      return false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
