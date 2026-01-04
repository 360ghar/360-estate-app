import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/features/auth/presentation/controllers/enter_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterPhonePage extends StatefulWidget {
  const EnterPhonePage({super.key});

  @override
  State<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends State<EnterPhonePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnterPhoneController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

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
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkAuthGradient
                  : AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: AppErrorView(
                title: context.l10n.errorMissingConfigTitle,
                message: context.l10n.errorMissingConfigBody,
              ),
            ),
          ),
        );
      }

      final isLoading = state.status == ViewStatus.loading;
      final failure = state.failure;

      return Scaffold(
        body: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkAuthGradient
                  : AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  const SizedBox(height: 60),
                  // Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Icon
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.home_work_rounded,
                              size: 36,
                              color: AppColors.brand,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          context.l10n.enterPhoneTitle,
                          style: AppTextStyles.heroTitle(context),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your phone number to get started with 360 Estate',
                          style: AppTextStyles.heroSubtitle(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Form Card
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.colorScheme.surface.withOpacity(0.9)
                              : Colors.white,
                          borderRadius: AppRadii.xl,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              labelText: context.l10n.phoneNumberLabel,
                              hintText: context.l10n.phoneNumberHint,
                              semanticsLabel: context.l10n.phoneNumberLabel,
                              errorText:
                                  phoneErrorText(controller.phoneError.value),
                              enabled: !isLoading,
                              prefixIcon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 24),
                            if (failure != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error
                                      .withOpacity(0.1),
                                  borderRadius: AppRadii.md,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.colorScheme.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        failure.localizedMessage(context.l10n),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            AppButton(
                              label: context.l10n.commonContinue,
                              semanticsLabel: context.l10n.commonContinue,
                              isLoading: isLoading,
                              variant: AppButtonVariant.gradient,
                              fullWidth: true,
                              onPressed: () =>
                                  unawaited(controller.continueFlow()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
