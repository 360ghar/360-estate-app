import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/apple_sign_in_button.dart';
import 'package:estate_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_auth/smart_auth.dart';

/// Unified entry page: a single identifier field (email or phone) plus a
/// native Google sign-in button. Resolves the identifier against the backend
/// login state machine and branches to password / OTP / signup.
class EnterPhonePage extends ConsumerStatefulWidget {
  const EnterPhonePage({super.key});

  @override
  ConsumerState<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends ConsumerState<EnterPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final SmartAuth _smartAuth = SmartAuth.instance;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  bool _isChecking = false;
  bool _prefilledMasked = false;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(Routes.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(Routes.privacyPolicy);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  String? _validateIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter your email or phone number.';
    if (isEmailIdentifier(text)) return null;
    if (isValidPhone(text)) return null;
    return 'Enter a valid email or phone number.';
  }

  /// Android-only phone-number hint picker (Smart Auth / Google Identity).
  Future<void> _showPhoneHintPicker() async {
    try {
      final res = await _smartAuth.requestPhoneNumberHint();
      final hint = res.data;
      if (hint != null && hint.isNotEmpty && mounted) {
        _identifierController.text = hint;
      }
    } catch (_) {
      // Picker unavailable / dismissed — ignore.
    }
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final raw = _identifierController.text.trim();
    final isEmail = isEmailIdentifier(raw);
    final identifier = isEmail ? raw.toLowerCase() : normalizePhone(raw);

    setState(() => _isChecking = true);
    try {
      final status = await ref
          .read(authControllerProvider.notifier)
          .checkIdentifierStatus(identifier)
          .timeout(const Duration(seconds: 8), onTimeout: () => null);
      if (!mounted) return;

      final encoded = Uri.encodeComponent(identifier);

      // Verified existing account with a password -> password screen.
      // Everything else (unverified, unknown, passwordless) -> OTP first.
      final goToPassword =
          status != null &&
          status.exists &&
          status.nextStep == IdentifierNextStep.password;

      if (goToPassword) {
        context.go('/login?identifier=$encoded');
        return;
      }

      // OTP-first path. The account must set a password afterwards (req 6) when
      // it has none — i.e. an existing passwordless account, or an unknown /
      // unreachable status (treated as a brand-new account).
      final requirePassword = status == null || !status.hasPassword;
      final requireParam = requirePassword ? '&requirePassword=true' : '';

      if (isEmail) {
        // Email OTP-first flow. Only allow account creation when the backend
        // positively reports the email is new; an unknown/unreachable status
        // must NOT silently create an account.
        final isNewEmail = status != null && !status.exists;
        final sent = await _sendEmailOtp(
          identifier,
          shouldCreateUser: isNewEmail,
        );
        if (!mounted || !sent) return;
        context.go('/otp?identifier=$encoded&channel=email$requireParam');
        return;
      }

      // Phone OTP-first flow. Unknown -> signup form (collect name/password
      // first as today); otherwise this is an existing account, so send the
      // login OTP without creating a user.
      if (status != null && status.exists == false) {
        context.go('/signup?identifier=$encoded');
        return;
      }
      final sent = await _sendPhoneOtp(identifier);
      if (!mounted || !sent) return;
      context.go('/otp?identifier=$encoded&channel=phone$requireParam');
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(error.toString());
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<bool> _sendEmailOtp(
    String email, {
    bool shouldCreateUser = false,
  }) async {
    await ref
        .read(authControllerProvider.notifier)
        .sendEmailOtp(email, shouldCreateUser: shouldCreateUser);
    final st = ref.read(authControllerProvider);
    if (st.errorMessage != null) {
      _showErrorSnackBar(st.errorMessage!);
      return false;
    }
    return true;
  }

  // Phone OTP-first only runs for an existing account (new numbers route to
  // /signup), so it never needs to create a user (requestOtp defaults to
  // shouldCreateUser: false).
  Future<bool> _sendPhoneOtp(String phone) async {
    await ref.read(authControllerProvider.notifier).requestOtp(phone);
    final st = ref.read(authControllerProvider);
    if (st.errorMessage != null) {
      _showErrorSnackBar(st.errorMessage!);
      return false;
    }
    return true;
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

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    if (!config.isSupabaseConfigured) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: const AppErrorView(
          title: 'Missing Supabase configuration',
          message:
              'Add SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY to your .env file.',
        ),
      );
    }

    final controller = ref.read(authControllerProvider.notifier);
    final lastMethod = controller.lastAuthMethod;
    final lastMasked = controller.lastAuthIdentifierMasked;

    // One-time prefill of the last-used identifier mask as a hint.
    if (!_prefilledMasked && lastMasked != null && lastMasked.isNotEmpty) {
      _prefilledMasked = true;
    }

    return SimplePremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: PremiumFadeTransition(
                slideOffset: const Offset(0, 0.05),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 32),
                        PremiumGlassCard(
                          padding: const EdgeInsets.all(28),
                          borderRadius: 24,
                          opacity: 0.15,
                          child: Column(
                            children: [
                              GoogleSignInButton(
                                enabled: !_isChecking,
                                onResult: _onGoogleResult,
                              ),
                              if (_supportsApple) ...[
                                const SizedBox(height: 12),
                                AppleSignInButton(
                                  enabled: !_isChecking,
                                  onResult: _onAppleResult,
                                ),
                              ],
                              const SizedBox(height: 20),
                              _buildDivider(),
                              const SizedBox(height: 20),
                              _buildIdentifierInput(),
                              if (lastMethod != null && lastMasked != null) ...[
                                const SizedBox(height: 10),
                                _buildLastMethodHint(lastMethod, lastMasked),
                              ] else ...[
                                _buildHelperText(),
                              ],
                              const SizedBox(height: 24),
                              _buildContinueButton(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTermsText(),
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

  /// Sign in with Apple is offered on iOS only (Apple platform requirement when
  /// Google sign-in is also offered).
  bool get _supportsApple => !kIsWeb && Platform.isIOS;

  void _onGoogleResult(GoogleSignInOutcome outcome) {
    if (!mounted) return;
    if (outcome == GoogleSignInOutcome.error) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) _showErrorSnackBar(msg);
    }
    // Navigation on success is handled by the router auth redirect.
  }

  void _onAppleResult(AppleSignInOutcome outcome) {
    if (!mounted) return;
    if (outcome == AppleSignInOutcome.error) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) _showErrorSnackBar(msg);
    }
    // Navigation on success is handled by the router auth redirect.
  }

  Widget _buildLogo() {
    return PremiumScaleAnimation(
      duration: const Duration(milliseconds: 600),
      beginScale: 0.5,
      bounce: true,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.home_rounded, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Welcome to 360° Estate',
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
        const SizedBox(height: 12),
        Text(
          'Continue with Google, or your email / phone',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.12),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.12),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildIdentifierInput() {
    final supportsPhoneHint = !kIsWeb && Platform.isAndroid;
    return _AnimatedIdentifierField(
      controller: _identifierController,
      onFieldSubmitted: (_) => _continue(),
      validator: _validateIdentifier,
      onPhoneHintTap: supportsPhoneHint ? _showPhoneHintPicker : null,
    );
  }

  Widget _buildLastMethodHint(AuthMethod method, String masked) {
    final label = switch (method) {
      AuthMethod.google => 'Last time you used Google',
      AuthMethod.apple => 'Last time you used Apple',
      AuthMethod.emailPassword ||
      AuthMethod.emailOtp => 'Last used email $masked',
      AuthMethod.phonePassword ||
      AuthMethod.phoneOtp => 'Last used phone $masked',
    };
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            size: 14,
            color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperText() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        "We'll send you a verification code",
        style: _helperStyle(context),
      ),
    );
  }

  Widget _buildContinueButton() {
    return PremiumGlassButton(
      label: 'Continue',
      onPressed: _isChecking ? null : _continue,
      isLoading: _isChecking,
      icon: Icons.arrow_forward_rounded,
    );
  }

  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: _helperStyle(context),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: _helperEmphasisColor(context),
              fontWeight: FontWeight.w500,
            ),
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: _helperEmphasisColor(context),
              fontWeight: FontWeight.w500,
            ),
            recognizer: _privacyRecognizer,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Identifier input (email or phone) with animated focus glow and autofill.
class _AnimatedIdentifierField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final VoidCallback? onPhoneHintTap;

  const _AnimatedIdentifierField({
    required this.controller,
    this.onFieldSubmitted,
    this.validator,
    this.onPhoneHintTap,
  });

  @override
  State<_AnimatedIdentifierField> createState() =>
      _AnimatedIdentifierFieldState();
}

class _AnimatedIdentifierFieldState extends State<_AnimatedIdentifierField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _focusGlowController;
  late final Animation<double> _glowAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnimation = CurvedAnimation(
      parent: _focusGlowController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _focusGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('EMAIL OR PHONE', style: _labelStyle(context)),
            const Spacer(),
            if (widget.onPhoneHintTap != null)
              GestureDetector(
                onTap: widget.onPhoneHintTap,
                child: Row(
                  children: [
                    const Icon(
                      Icons.contact_phone_outlined,
                      size: 14,
                      color: Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Use my number',
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
            if (hasFocus) {
              _focusGlowController.forward();
            } else {
              _focusGlowController.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        const Color(0xFF3B82F6).withValues(alpha: 0.0),
                        const Color(0xFF3B82F6).withValues(alpha: 0.25),
                        _glowAnimation.value,
                      )!,
                      blurRadius: 20 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isFocused
                          ? const Color(0xFF3B82F6)
                          : Colors.white.withValues(alpha: 0.1),
                      width: _isFocused ? 1.5 : 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.telephoneNumber,
                    ],
                    onFieldSubmitted: widget.onFieldSubmitted,
                    validator: widget.validator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: _inputStyle(context),
                    cursorColor: const Color(0xFF3B82F6),
                    decoration: InputDecoration(
                      hintText: 'you@example.com or 00000 00000',
                      hintStyle: _hintStyle(context),
                      prefixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.alternate_email_rounded,
                          key: ValueKey(_isFocused),
                          color: _isFocused
                              ? const Color(0xFF3B82F6)
                              : _iconColor(context),
                          size: 22,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      errorStyle: const TextStyle(
                        color: Color(0xFFFCA5A5),
                        fontSize: 12,
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

bool _isLightTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

TextStyle _labelStyle(BuildContext context) => TextStyle(
  color: _isLightTheme(context)
      ? const Color(0xFF64748B)
      : Colors.white.withValues(alpha: 0.7),
  fontSize: 13,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

TextStyle _inputStyle(BuildContext context) => TextStyle(
  color: _isLightTheme(context) ? const Color(0xFF0F172A) : Colors.white,
  fontSize: 17,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);

TextStyle _hintStyle(BuildContext context) => TextStyle(
  color: _isLightTheme(context)
      ? const Color(0xFF94A3B8)
      : Colors.white.withValues(alpha: 0.3),
  fontSize: 14,
);

Color _iconColor(BuildContext context) => _isLightTheme(context)
    ? const Color(0xFF94A3B8)
    : Colors.white.withValues(alpha: 0.5);

TextStyle _helperStyle(BuildContext context) => TextStyle(
  color: _isLightTheme(context)
      ? const Color(0xFF64748B)
      : Colors.white.withValues(alpha: 0.5),
  fontSize: 13,
);

Color _helperEmphasisColor(BuildContext context) => _isLightTheme(context)
    ? const Color(0xFF0F172A)
    : Colors.white.withValues(alpha: 0.8);
