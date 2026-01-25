import 'dart:ui';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Premium login page with glassmorphism design.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _prefilled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final phoneParam = widget.phone?.trim();
    final normalizedParam = phoneParam == null ? null : normalizePhone(phoneParam);
    final lockPhone = normalizedParam != null && normalizedParam.isNotEmpty;

    if (lockPhone && !_prefilled) {
      _phoneController.text = normalizedParam!;
      _prefilled = true;
    }

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.errorMessage != next.errorMessage && next.errorMessage != null) {
        if (!mounted) return;
        GlassToast.showError(
          context,
          next.errorMessage!,
        );
      }
    });

    return PremiumAuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: PremiumFadeTransition(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top bar
                      _buildTopBar(normalizedParam),

                      const SizedBox(height: 24),

                      // Title
                      _buildTitle(),

                      const SizedBox(height: 32),

                      // Login form card
                      PremiumGlassCard(
                        padding: const EdgeInsets.all(24),
                        borderRadius: 24,
                        blur: 24,
                        opacity: 0.15,
                        child: Column(
                          children: [
                            // Phone field
                            _PhoneField(
                              controller: _phoneController,
                              lockPhone: lockPhone,
                              normalizedParam: normalizedParam,
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            _PasswordField(
                              controller: _passwordController,
                              obscure: _obscurePassword,
                              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                              error: state.errorMessage != null ? 'Invalid phone or password' : null,
                            ),
                            const SizedBox(height: 12),

                            // Forgot password
                            _buildForgotPassword(state, normalizedParam, lockPhone),
                            const SizedBox(height: 20),

                            // Sign in button
                            _buildSignInButton(state, normalizedParam, lockPhone),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign up link
                      _buildSignUpLink(normalizedParam, lockPhone, state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(String? normalizedParam) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => context.go('/enter-phone'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const Spacer(),
        // Step indicator
        const PremiumStepIndicator(currentStep: 1, totalSteps: 3),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to 360° Estate',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(AuthState state, String? normalizedParam, bool lockPhone) {
    return PremiumGlassButton(
      label: 'Sign In',
      onPressed: state.isBusy
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                ref.read(authControllerProvider.notifier).signInWithPassword(
                      phone: lockPhone ? normalizedParam! : normalizePhone(_phoneController.text),
                      password: _passwordController.text.trim(),
                    );
              }
            },
      isLoading: state.isBusy,
    );
  }

  Widget _buildForgotPassword(AuthState state, String? normalizedParam, bool lockPhone) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: state.isBusy
            ? null
            : () async {
                final prefill = _prefillPhone(lockPhone ? normalizedParam : _phoneController.text);
                final phone = await _promptForgotPasswordPhone(prefill: prefill);
                if (phone == null || phone.isEmpty) return;
                await ref.read(authControllerProvider.notifier).requestOtp(phone);
                if (!mounted) return;
                if (ref.read(authControllerProvider).errorMessage != null) return;
                final encoded = Uri.encodeComponent(phone);
                context.go('/otp?phone=$encoded');
              },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: const Color(0xFF3B82F6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(String? normalizedParam, bool lockPhone, AuthState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New here? ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: state.isBusy
              ? null
              : () {
                  final encoded = normalizedParam == null ? null : Uri.encodeComponent(normalizedParam);
                  final target = (lockPhone && encoded != null) ? '/signup?phone=$encoded' : '/signup';
                  context.go(target);
                },
          child: Text(
            'Create Account',
            style: const TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _prefillPhone(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  Future<String?> _promptForgotPasswordPhone({String? prefill}) async {
    final controller = TextEditingController(text: prefill ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reset password',
            style: TextStyle(color: Colors.white),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                const AuthPhoneNumberFormatter(),
              ],
              decoration: authInputDecoration(
                dialogContext,
                hintText: '00000 00000',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  child: AuthCountryPrefix(),
                ),
              ),
              style: authInputTextStyle(dialogContext)?.copyWith(
                letterSpacing: 1.5,
              ),
              validator: (value) {
                if (!isValidPhone(value ?? '')) {
                  return 'Enter a valid phone number.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                final normalized = normalizePhone(controller.text);
                Navigator.pop(dialogContext, normalized);
              },
              child: const Text('Send OTP'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool lockPhone;
  final String? normalizedParam;

  const _PhoneField({
    required this.controller,
    required this.lockPhone,
    required this.normalizedParam,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE NUMBER',
          style: _labelStyle,
        ),
        const SizedBox(height: 10),
        if (lockPhone)
          _LockedPhoneDisplay(phone: normalizedParam!)
        else
          _GlassInputField(
            controller: controller,
            hint: '00000 00000',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              _PhoneFormatter(),
            ],
          ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? error;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.error,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PASSWORD',
          style: _labelStyle,
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.error != null
                          ? const Color(0xFFEF4444)
                          : _isFocused
                              ? const Color(0xFF3B82F6)
                              : Colors.white.withValues(alpha: 0.1),
                      width: _isFocused || widget.error != null ? 1.5 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    obscureText: widget.obscure,
                    style: _inputStyle,
                    cursorColor: const Color(0xFF3B82F6),
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: _hintStyle,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: widget.onToggle,
                        child: Icon(
                          widget.obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      errorText: widget.error,
                      errorStyle: TextStyle(
                        color: const Color(0xFFEF4444),
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LockedPhoneDisplay extends StatelessWidget {
  final String phone;

  const _LockedPhoneDisplay({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: 18,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              phone,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/enter-phone'),
            child: Text(
              'Change',
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _GlassInputField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<_GlassInputField> createState() => _GlassInputFieldState();
}

class _GlassInputFieldState extends State<_GlassInputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFocused
                      ? const Color(0xFF3B82F6)
                      : Colors.white.withValues(alpha: 0.1),
                  width: _isFocused ? 1.5 : 1,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                style: _inputStyle,
                cursorColor: const Color(0xFF3B82F6),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: _hintStyle,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 20,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Styles
TextStyle get _labelStyle => TextStyle(
      color: Colors.white.withValues(alpha: 0.7),
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    );

TextStyle get _inputStyle => const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

TextStyle get _hintStyle => TextStyle(
      color: Colors.white.withValues(alpha: 0.3),
      fontSize: 16,
    );

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
