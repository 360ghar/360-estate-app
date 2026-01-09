import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final emailSent = false.obs;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    // Validate phone number
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => phoneError = 'Phone number is required');
      return;
    }
    if (phone.length < 10) {
      setState(() => phoneError = 'Please enter a valid phone number');
      return;
    }

    setState(() => phoneError = null);
    isLoading.value = true;

    try {
      // TODO: Integrate with your backend API for password reset
      // For now, simulate a successful request
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      emailSent.value = true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back<void>(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkAuthGradient,
        ),
        child: SafeArea(
          child: Obx(() {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Icon Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.authAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          emailSent.value ? Icons.check_circle : Icons.lock_reset,
                          size: 50,
                          color: AppColors.authAccent,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      emailSent.value ? 'Reset Link Sent!' : 'Forgot Password?',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      emailSent.value
                          ? 'We\'ve sent a password reset link to your registered mobile number'
                          : 'Enter your phone number to receive a password reset link',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (!emailSent.value) ...[
                    // Phone Input Form
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? theme.colorScheme.surface.withValues(alpha: 0.9)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Country Code + Phone Input
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: phoneError != null
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                color: isDark
                                    ? theme.colorScheme.surfaceContainerHighest
                                    : Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  // Country Code Section
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        // India Flag
                                        Container(
                                          width: 24,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      color: const Color(
                                                          0xFFFF9933))),
                                              Expanded(
                                                  child: Container(
                                                      color: Colors.white)),
                                              Expanded(
                                                  child: Container(
                                                      color: const Color(
                                                          0xFF138808))),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '+91',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Divider
                                  Container(
                                    height: 24,
                                    width: 1,
                                    color: theme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                  ),

                                  // Phone Input
                                  Expanded(
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.onSurface,
                                        letterSpacing: 1,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter phone number',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      enabled: !isLoading.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Error Text
                            if (phoneError != null) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  phoneError!,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Send Reset Link Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Obx(
                                () => FilledButton(
                                  onPressed: isLoading.value
                                      ? null
                                      : _sendResetLink,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.authAccent,
                                    disabledBackgroundColor: AppColors.authAccent
                                        .withValues(alpha: 0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading.value
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Send Reset Link',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Success State
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: AppButton(
                        label: 'Back to Login',
                        variant: AppButtonVariant.primary,
                        fullWidth: true,
                        onPressed: () => Get.back<void>(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Try Different Method
                  if (!emailSent.value)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextButton(
                        onPressed: () {
                          Get.back<void>(); // Back to login
                        },
                        child: Text(
                          'Remember your password? Login',
                          style: TextStyle(
                            color: AppColors.authAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
