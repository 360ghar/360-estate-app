import 'dart:async';
import 'dart:ui';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Premium login page with glassmorphism design. Handles both an email and a
/// phone identifier (password branch of the unified state machine).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.identifier});

  final String? identifier;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _prefilled = false;

  /// Whether the locked identifier is an email (vs phone).
  bool get _isEmail => isEmailIdentifier(widget.identifier?.trim() ?? '');

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (!isValidPhone(value ?? '')) return 'Enter a valid phone number.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 6) return 'Enter a valid password.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final identifierParam = widget.identifier?.trim();
    final normalizedParam = identifierParam == null || identifierParam.isEmpty
        ? null
        : (_isEmail
              ? identifierParam.toLowerCase()
              : normalizePhone(identifierParam));
    final lockPhone = normalizedParam != null && normalizedParam.isNotEmpty;

    if (lockPhone && !_prefilled) {
      _phoneController.text = normalizedParam;
      _prefilled = true;
    }

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.errorMessage != next.errorMessage &&
          next.errorMessage != null) {
        if (!mounted) return;
        GlassToast.showError(context, next.errorMessage!);
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
                          opacity: 0.15,
                          child: Column(
                            children: [
                              // Identifier field (phone or email)
                              _PhoneField(
                                controller: _phoneController,
                                lockPhone: lockPhone,
                                normalizedParam: normalizedParam,
                                isEmail: _isEmail,
                                validator: _isEmail ? null : _validatePhone,
                              ),
                              const SizedBox(height: 16),

                              // Password field
                              _PasswordField(
                                controller: _passwordController,
                                obscure: _obscurePassword,
                                onToggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                validator: _validatePassword,
                                highlightError: state.errorMessage != null,
                              ),
                              const SizedBox(height: 12),

                              // Forgot password
                              _buildForgotPassword(
                                state,
                                normalizedParam,
                                lockPhone,
                              ),
                              const SizedBox(height: 20),

                              // Sign in button
                              _buildSignInButton(
                                state,
                                normalizedParam,
                                lockPhone,
                              ),
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

  Widget _buildSignInButton(
    AuthState state,
    String? normalizedParam,
    bool lockPhone,
  ) {
    return PremiumGlassButton(
      label: 'Sign In',
      onPressed: state.isBusy
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                final notifier = ref.read(authControllerProvider.notifier);
                final password = _passwordController.text.trim();
                if (_isEmail && lockPhone) {
                  notifier.signInWithEmailPassword(
                    email: normalizedParam!,
                    password: password,
                  );
                } else {
                  notifier.signInWithPassword(
                    phone: lockPhone
                        ? normalizedParam!
                        : normalizePhone(_phoneController.text),
                    password: password,
                  );
                }
              }
            },
      isLoading: state.isBusy,
    );
  }

  Widget _buildForgotPassword(
    AuthState state,
    String? normalizedParam,
    bool lockPhone,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: state.isBusy
            ? null
            : () => _onForgotPassword(normalizedParam, lockPhone),
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

  /// Forgot-password reset. Supports BOTH channels:
  /// - email identifier -> send a reset email OTP for the locked email;
  /// - phone identifier -> reuse the locked phone, or prompt for one.
  /// Sends never create an account on reset (requestOtp/sendEmailOtp default to
  /// shouldCreateUser: false), then routes to the OTP screen in reset mode
  /// (which forces set-new-password).
  Future<void> _onForgotPassword(
    String? normalizedParam,
    bool lockPhone,
  ) async {
    final notifier = ref.read(authControllerProvider.notifier);

    if (_isEmail && lockPhone) {
      final email = normalizedParam!;
      await notifier.sendEmailOtp(email);
      if (!mounted) return;
      if (ref.read(authControllerProvider).errorMessage != null) return;
      final encoded = Uri.encodeComponent(email);
      context.go('/otp?identifier=$encoded&channel=email&flow=reset');
      return;
    }

    final prefill = _prefillPhone(
      lockPhone ? normalizedParam : _phoneController.text,
    );
    final phone = await _promptForgotPasswordPhone(prefill: prefill);
    if (phone == null || phone.isEmpty) return;
    await notifier.requestOtp(phone);
    if (!mounted) return;
    if (ref.read(authControllerProvider).errorMessage != null) return;
    final encoded = Uri.encodeComponent(phone);
    context.go('/otp?identifier=$encoded&channel=phone&flow=reset');
  }

  Widget _buildSignUpLink(
    String? normalizedParam,
    bool lockPhone,
    AuthState state,
  ) {
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
                  final encoded = normalizedParam == null
                      ? null
                      : Uri.encodeComponent(normalizedParam);
                  final target = (lockPhone && encoded != null)
                      ? '/signup?phone=$encoded'
                      : '/signup';
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
              style: authInputTextStyle(
                dialogContext,
              )?.copyWith(letterSpacing: 1.5),
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
  final bool isEmail;
  final String? Function(String?)? validator;

  const _PhoneField({
    required this.controller,
    required this.lockPhone,
    required this.normalizedParam,
    this.isEmail = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isEmail ? 'EMAIL' : 'MOBILE NUMBER', style: _labelStyle(context)),
        const SizedBox(height: 10),
        if (lockPhone)
          _LockedPhoneDisplay(phone: normalizedParam!)
        else if (isEmail)
          _GlassInputField(
            controller: controller,
            hint: 'you@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            validator: validator,
          )
        else
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
            textInputAction: TextInputAction.next,
            validator: validator,
          ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final bool highlightError;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.validator,
    this.highlightError = false,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  bool _prevHighlightError = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void didUpdateWidget(covariant _PasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake when highlightError transitions from false to true
    if (widget.highlightError && !_prevHighlightError) {
      _shakeController.forward(from: 0);
    }
    _prevHighlightError = widget.highlightError;
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PASSWORD', style: _labelStyle(context)),
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
                    : widget.highlightError
                    ? [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.highlightError
                            ? const Color(0xFFEF4444)
                            : _isFocused
                            ? const Color(0xFF3B82F6)
                            : Colors.white.withValues(alpha: 0.1),
                        width: _isFocused || widget.highlightError ? 1.5 : 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      obscureText: widget.obscure,
                      autofillHints: const [AutofillHints.password],
                      style: _inputStyle(context),
                      cursorColor: const Color(0xFF3B82F6),
                      validator: widget.validator,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
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
      ),
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
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  const _GlassInputField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
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
                textInputAction: widget.textInputAction,
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

    // Compute the cursor position in the formatted string. The raw selection
    // offset is relative to newValue.text (which may contain a space from
    // prior formatting). We first count how many digits appear before the
    // cursor, then map that digit count back to the formatted output.
    final selection = _computeSelection(newValue, formatted);

    return TextEditingValue(
      text: formatted,
      selection: selection,
    );
  }

  /// Maps the cursor from [newValue.text] space to [formatted] space so the
  /// cursor stays in the correct position for mid-string edits.
  TextSelection _computeSelection(
    TextEditingValue newValue,
    String formatted,
  ) {
    final selection = newValue.selection;
    if (!selection.isValid) {
      return TextSelection.collapsed(offset: formatted.length);
    }

    final rawOffset = selection.baseOffset.clamp(0, newValue.text.length);
    // Count digits (non-space chars) before the cursor in the raw input.
    final textBeforeCursor = newValue.text.substring(0, rawOffset);
    final digitCount = textBeforeCursor.replaceAll(' ', '').length;

    // A space is inserted after the 5th digit in the formatted output.
    final formattedOffset = digitCount + (digitCount > 5 ? 1 : 0);

    return TextSelection.collapsed(
      offset: formattedOffset.clamp(0, formatted.length),
    );
  }
}
