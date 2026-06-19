import 'dart:ui';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Premium signup page with glassmorphism design. Reached for an unknown phone
/// identifier; collects name/email/phone/password then verifies via SMS OTP.
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key, this.identifier});

  final String? identifier;

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _prefilled = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final identifierParam = widget.identifier?.trim();
    final normalizedParam = identifierParam == null || identifierParam.isEmpty
        ? null
        : normalizePhone(identifierParam);
    final lockPhone = normalizedParam != null && normalizedParam.isNotEmpty;

    if (lockPhone && !_prefilled) {
      _phoneController.text = normalizedParam;
      _prefilled = true;
    }

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.errorMessage != next.errorMessage &&
          next.errorMessage != null) {
        if (!mounted) return;
        _showErrorSnackBar(next.errorMessage!);
      }
    });

    return SimplePremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: PremiumFadeTransition(
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back button and step indicator
                        _buildTopBar(normalizedParam),

                        const SizedBox(height: 24),

                        // Title
                        _buildTitle(),

                        const SizedBox(height: 32),

                        // Form card with staggered field entrance
                        PremiumGlassCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 24,
                          opacity: 0.15,
                          child: PremiumStaggeredList(
                            itemCount: 7,
                            staggerDelay: const Duration(milliseconds: 100),
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _FullNameField(
                                      controller: _fullNameController,
                                    ),
                                  );
                                case 1:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _EmailField(
                                      controller: _emailController,
                                    ),
                                  );
                                case 2:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: !lockPhone
                                        ? _PhoneField(
                                            controller: _phoneController,
                                            lockPhone: lockPhone,
                                            normalizedParam: normalizedParam,
                                            validator: (value) {
                                              if (!isValidPhone(value ?? '')) {
                                                return 'Enter a valid phone number.';
                                              }
                                              return null;
                                            },
                                          )
                                        : _LockedPhoneDisplay(
                                            phone: normalizedParam,
                                          ),
                                  );
                                case 3:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _PasswordField(
                                      controller: _passwordController,
                                      label: 'PASSWORD',
                                      hint: 'Enter password',
                                      obscure: _obscurePassword,
                                      onToggle: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                      validator: (value) {
                                        final text = value?.trim() ?? '';
                                        if (text.length < 6) {
                                          return 'Password must be 6+ characters.';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                case 4:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _PasswordField(
                                      controller: _confirmController,
                                      label: 'CONFIRM PASSWORD',
                                      hint: 'Confirm password',
                                      obscure: _obscureConfirm,
                                      onToggle: () => setState(
                                        () =>
                                            _obscureConfirm = !_obscureConfirm,
                                      ),
                                      validator: (value) {
                                        final text = value?.trim() ?? '';
                                        if (text.isEmpty) {
                                          return 'Confirm your password.';
                                        }
                                        if (text !=
                                            _passwordController.text.trim()) {
                                          return 'Passwords do not match.';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                case 5:
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: _TermsCheckbox(
                                      accepted: _termsAccepted,
                                      onChanged: (v) =>
                                          setState(() => _termsAccepted = v),
                                    ),
                                  );
                                default:
                                  return _buildCreateAccountButton(
                                    state.isBusy,
                                    normalizedParam,
                                    lockPhone,
                                  );
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login link
                        _buildLoginLink(
                          normalizedParam,
                          lockPhone,
                          state.isBusy,
                        ),
                      ],
                    ),
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
        const PremiumStepIndicator(currentStep: 1),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Create Account',
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
          'Sign up to get started with 360° Estate',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(
    bool isBusy,
    String? normalizedParam,
    bool lockPhone,
  ) {
    return PremiumGlassButton(
      label: 'Create Account',
      onPressed: (isBusy || !_termsAccepted)
          ? null
          : () async {
              if (_formKey.currentState?.validate() ?? false) {
                final phone = lockPhone
                    ? normalizedParam!
                    : normalizePhone(_phoneController.text);
                final success = await ref
                    .read(authControllerProvider.notifier)
                    .signUpWithPassword(
                      phone: phone,
                      password: _passwordController.text.trim(),
                      fullName: _fullNameController.text.trim(),
                      email: _emailController.text.trim(),
                    );
                if (!mounted || !success) return;
                final encoded = Uri.encodeComponent(phone);
                context.go(
                  '/otp?identifier=$encoded&channel=phone&flow=signup',
                );
              }
            },
      isLoading: isBusy,
    );
  }

  Widget _buildLoginLink(String? normalizedParam, bool lockPhone, bool isBusy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: isBusy
              ? null
              : () {
                  final encoded = normalizedParam == null
                      ? null
                      : Uri.encodeComponent(normalizedParam);
                  final target = (lockPhone && encoded != null)
                      ? '/login?identifier=$encoded'
                      : '/login';
                  context.go(target);
                },
          child: Text(
            'Sign In',
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _FullNameField extends StatelessWidget {
  final TextEditingController controller;

  const _FullNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FULL NAME', style: _labelStyle(context)),
        const SizedBox(height: 10),
        _GlassInputField(
          controller: controller,
          hint: 'Your full name',
          prefixIcon: Icons.person_outline,
          autofillHints: const [AutofillHints.name],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name.';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EMAIL', style: _labelStyle(context)),
        const SizedBox(height: 10),
        _GlassInputField(
          controller: controller,
          hint: 'you@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email.';
            }
            final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Enter a valid email address.';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool lockPhone;
  final String? normalizedParam;
  final String? Function(String?)? validator;

  const _PhoneField({
    required this.controller,
    required this.lockPhone,
    required this.normalizedParam,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MOBILE NUMBER', style: _labelStyle(context)),
        const SizedBox(height: 10),
        _GlassInputField(
          controller: controller,
          hint: '00000 00000',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
            _PhoneFormatter(),
          ],
          validator: validator,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MOBILE NUMBER', style: _labelStyle(context)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                    color: _inputTextColor(context),
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
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
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
        Text(widget.label, style: _labelStyle(context)),
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
                      color: _isFocused
                          ? const Color(0xFF3B82F6)
                          : Colors.white.withValues(alpha: 0.1),
                      width: _isFocused ? 1.5 : 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    obscureText: widget.obscure,
                    autofillHints: const [AutofillHints.newPassword],
                    style: _inputStyle(context),
                    cursorColor: const Color(0xFF3B82F6),
                    validator: widget.validator,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: _hintStyle(context),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: _iconColor(context),
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: widget.onToggle,
                        child: Icon(
                          widget.obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _iconColor(context),
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      errorStyle: const TextStyle(
                        color: Color(0xFFFCA5A5),
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
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

class _GlassInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  const _GlassInputField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.autofillHints,
    this.validator,
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
              child: TextFormField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                autofillHints: widget.autofillHints,
                style: _inputStyle(context),
                cursorColor: const Color(0xFF3B82F6),
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: _hintStyle(context),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _iconColor(context),
                          size: 20,
                        )
                      : null,
                  border: InputBorder.none,
                  errorStyle: const TextStyle(
                    color: Color(0xFFFCA5A5),
                    fontSize: 12,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;

  const _TermsCheckbox({required this.accepted, required this.onChanged});

  Future<void> _launchPolicy(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    const linkColor = Color(0xFF3B82F6);
    final linkStyle = const TextStyle(
      color: linkColor,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: accepted,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: linkColor,
            checkColor: Colors.white,
            side: BorderSide(color: _mutedTextColor(context)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchPolicy(
                      'https://360ghar.com/policies/terms-of-service',
                    ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchPolicy(
                      'https://360ghar.com/policies/privacy-policy',
                    ),
                ),
              ],
              style: TextStyle(
                color: _mutedTextColor(context),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Styles
bool _isLightTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Color _inputTextColor(BuildContext context) =>
    _isLightTheme(context) ? const Color(0xFF0F172A) : Colors.white;

Color _mutedTextColor(BuildContext context) => _isLightTheme(context)
    ? const Color(0xFF64748B)
    : Colors.white.withValues(alpha: 0.7);

Color _hintTextColor(BuildContext context) => _isLightTheme(context)
    ? const Color(0xFF94A3B8)
    : Colors.white.withValues(alpha: 0.3);

Color _iconColor(BuildContext context) => _isLightTheme(context)
    ? const Color(0xFF94A3B8)
    : Colors.white.withValues(alpha: 0.5);

TextStyle _labelStyle(BuildContext context) => TextStyle(
  color: _mutedTextColor(context),
  fontSize: 13,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

TextStyle _inputStyle(BuildContext context) => TextStyle(
  color: _inputTextColor(context),
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle _hintStyle(BuildContext context) =>
    TextStyle(color: _hintTextColor(context), fontSize: 16);

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newDigits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < newDigits.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(newDigits[i]);
    }
    final formatted = buffer.toString();

    final selection = _computeSelection(newValue, formatted);

    return TextEditingValue(
      text: formatted,
      selection: selection,
    );
  }

  TextSelection _computeSelection(
    TextEditingValue newValue,
    String formatted,
  ) {
    final selection = newValue.selection;
    if (!selection.isValid) {
      return TextSelection.collapsed(offset: formatted.length);
    }

    final rawOffset = selection.baseOffset.clamp(0, newValue.text.length);
    final textBeforeCursor = newValue.text.substring(0, rawOffset);
    final digitCount = textBeforeCursor.replaceAll(' ', '').length;

    final formattedOffset = digitCount + (digitCount > 5 ? 1 : 0);

    return TextSelection.collapsed(
      offset: formattedOffset.clamp(0, formatted.length),
    );
  }
}
