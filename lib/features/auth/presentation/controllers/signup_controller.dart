import 'dart:async';

import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/usecases/sign_up_with_phone_password_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PasswordValidationError { required, tooShort }

class SignupController extends GetxController {
  SignupController({
    required AppConfig config,
    required SignUpWithPhonePasswordUseCase signUp,
  }) : _config = config,
       _signUp = signUp;

  final AppConfig _config;
  final SignUpWithPhonePasswordUseCase _signUp;

  late final String phone;

  final TextEditingController passwordController = TextEditingController();

  final Rx<ViewState<AuthUser>> state = const ViewState<AuthUser>.idle().obs;
  final Rxn<PasswordValidationError> passwordError =
      Rxn<PasswordValidationError>();

  bool get isConfigured => _config.isSupabaseConfigured;

  @override
  void onInit() {
    super.onInit();
    final args = (Get.arguments as Map?)?.cast<String, dynamic>() ?? const {};
    phone = (args['phone'] as String?)?.trim() ?? '';
  }

  PasswordValidationError? _validatePassword(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return PasswordValidationError.required;
    if (v.length < 6) return PasswordValidationError.tooShort;
    return null;
  }

  Future<void> submit() async {
    if (!isConfigured) {
      state.value = ViewState<AuthUser>.error(
        const UnknownFailure('Missing Supabase configuration'),
      );
      return;
    }

    final error = _validatePassword(passwordController.text);
    passwordError.value = error;
    if (error != null) return;

    state.value = const ViewState<AuthUser>.loading();
    try {
      final user = await _signUp(
        phone: phone,
        password: passwordController.text,
      );
      state.value = ViewState<AuthUser>.success(user);
    } on Failure catch (f) {
      state.value = ViewState<AuthUser>.error(f);
    } catch (e) {
      state.value = ViewState<AuthUser>.error(
        UnknownFailure('Unexpected error', cause: e),
      );
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
