import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/auth/domain/usecases/check_phone_registered_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PhoneValidationError { required, missingPlus, tooShort }

class EnterPhoneController extends GetxController {
  EnterPhoneController({
    required AppConfig config,
    required CheckPhoneRegisteredUseCase checkPhoneRegistered,
  }) : _config = config,
       _checkPhoneRegistered = checkPhoneRegistered;

  final AppConfig _config;
  final CheckPhoneRegisteredUseCase _checkPhoneRegistered;

  final TextEditingController phoneController = TextEditingController(
    text: '+91',
  );
  final Rx<ViewState<void>> state = const ViewState<void>.idle().obs;
  final Rxn<PhoneValidationError> phoneError = Rxn<PhoneValidationError>();

  bool get isConfigured => _config.isSupabaseConfigured;

  PhoneValidationError? _validatePhone(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return PhoneValidationError.required;
    if (!value.startsWith('+')) return PhoneValidationError.missingPlus;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 10) return PhoneValidationError.tooShort;
    return null;
  }

  Future<void> continueFlow() async {
    if (!isConfigured) {
      state.value = ViewState.error(
        const UnknownFailure('Missing Supabase configuration'),
      );
      return;
    }

    final phone = phoneController.text;
    final error = _validatePhone(phone);
    phoneError.value = error;
    if (error != null) return;

    state.value = const ViewState<void>.loading();
    try {
      final exists = await _checkPhoneRegistered(phone.trim());
      state.value = const ViewState<void>.success(null);

      if (exists == false) {
        unawaited(
          Get.toNamed<void>(Routes.signup, arguments: {'phone': phone.trim()}),
        );
        return;
      }

      // Unknown backend support defaults to login to avoid accidental sign-ups.
      unawaited(
        Get.toNamed<void>(Routes.login, arguments: {'phone': phone.trim()}),
      );
    } on Failure catch (f) {
      state.value = ViewState<void>.error(f);
    } catch (e) {
      state.value = ViewState<void>.error(
        UnknownFailure('Unexpected error', cause: e),
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
