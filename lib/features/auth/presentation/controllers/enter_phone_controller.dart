import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/auth/domain/usecases/check_phone_registered_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PhoneValidationError { required, tooShort }

class EnterPhoneController extends GetxController {
  EnterPhoneController({
    required AppConfig config,
    required CheckPhoneRegisteredUseCase checkPhoneRegistered,
  })  : _config = config,
        _checkPhoneRegistered = checkPhoneRegistered;

  final AppConfig _config;
  final CheckPhoneRegisteredUseCase _checkPhoneRegistered;

  // Country code is displayed separately in the UI
  static const String countryCode = '+91';

  // User only enters digits (without country code)
  final TextEditingController phoneController = TextEditingController();
  final Rx<ViewState<void>> state = const ViewState<void>.idle().obs;
  final Rxn<PhoneValidationError> phoneError = Rxn<PhoneValidationError>();

  bool get isConfigured => _config.isSupabaseConfigured;

  /// Returns the full phone number with country code
  String get fullPhoneNumber => '$countryCode${phoneController.text.trim()}';

  PhoneValidationError? _validatePhone(String digits) {
    final value = digits.trim();
    if (value.isEmpty) return PhoneValidationError.required;
    if (value.length < 10) return PhoneValidationError.tooShort;
    return null;
  }

  Future<void> continueFlow() async {
    if (!isConfigured) {
      state.value = ViewState.error(
        const UnknownFailure('Missing Supabase configuration'),
      );
      return;
    }

    final digits = phoneController.text.trim();
    final error = _validatePhone(digits);
    phoneError.value = error;
    if (error != null) return;

    // Combine country code with entered digits
    final phone = fullPhoneNumber;

    state.value = const ViewState<void>.loading();
    try {
      final exists = await _checkPhoneRegistered(phone);
      state.value = const ViewState<void>.success(null);

      if (exists == false) {
        unawaited(
          Get.toNamed<void>(Routes.signup, arguments: {'phone': phone}),
        );
        return;
      }

      // Unknown backend support defaults to login to avoid accidental sign-ups.
      unawaited(
        Get.toNamed<void>(Routes.login, arguments: {'phone': phone}),
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
