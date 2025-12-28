import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    String? passwordErrorText(PasswordValidationError? error) {
      return switch (error) {
        PasswordValidationError.required =>
          context.l10n.validationPasswordRequired,
        PasswordValidationError.tooShort =>
          context.l10n.validationPasswordTooShort,
        null => null,
      };
    }

    return Obx(() {
      final state = controller.state.value;
      if (!controller.isConfigured) {
        return AppScaffold(
          appBar: AppBar(title: Text(context.l10n.loginTitle)),
          body: AppErrorView(
            title: context.l10n.errorMissingConfigTitle,
            message: context.l10n.errorMissingConfigBody,
          ),
        );
      }

      final isLoading = state.status == ViewStatus.loading;
      final failure = state.failure;

      return AppScaffold(
        appBar: AppBar(title: Text(context.l10n.loginTitle)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.authPhoneSummary(controller.phone),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller.passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              labelText: context.l10n.passwordLabel,
              semanticsLabel: context.l10n.passwordLabel,
              errorText: passwordErrorText(controller.passwordError.value),
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            if (failure != null) ...[
              Text(
                failure.localizedMessage(context.l10n),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
            ],
            AppButton(
              label: context.l10n.signInCta,
              semanticsLabel: context.l10n.signInCta,
              isLoading: isLoading,
              onPressed: () => unawaited(controller.submit()),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: context.l10n.createAccountCta,
              semanticsLabel: context.l10n.createAccountCta,
              variant: AppButtonVariant.secondary,
              onPressed: isLoading
                  ? null
                  : () => Get.toNamed<void>(
                      Routes.signup,
                      arguments: {'phone': controller.phone},
                    ),
            ),
          ],
        ),
      );
    });
  }
}
