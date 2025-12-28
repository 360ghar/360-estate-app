import 'dart:async';

import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/features/auth/presentation/controllers/enter_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterPhonePage extends StatelessWidget {
  const EnterPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnterPhoneController>();

    String? phoneErrorText(PhoneValidationError? error) {
      return switch (error) {
        PhoneValidationError.required => context.l10n.validationPhoneRequired,
        PhoneValidationError.missingPlus =>
          context.l10n.validationPhoneInternational,
        PhoneValidationError.tooShort => context.l10n.validationPhoneTooShort,
        null => null,
      };
    }

    return Obx(() {
      final state = controller.state.value;
      if (!controller.isConfigured) {
        return AppScaffold(
          appBar: AppBar(title: Text(context.l10n.enterPhoneTitle)),
          body: AppErrorView(
            title: context.l10n.errorMissingConfigTitle,
            message: context.l10n.errorMissingConfigBody,
          ),
        );
      }

      final isLoading = state.status == ViewStatus.loading;
      final failure = state.failure;

      return AppScaffold(
        appBar: AppBar(title: Text(context.l10n.enterPhoneTitle)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              labelText: context.l10n.phoneNumberLabel,
              hintText: context.l10n.phoneNumberHint,
              semanticsLabel: context.l10n.phoneNumberLabel,
              errorText: phoneErrorText(controller.phoneError.value),
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
              label: context.l10n.commonContinue,
              semanticsLabel: context.l10n.commonContinue,
              isLoading: isLoading,
              onPressed: () => unawaited(controller.continueFlow()),
            ),
          ],
        ),
      );
    });
  }
}
