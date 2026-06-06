import 'dart:async';
import 'dart:ui';
import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart' show SimplePremiumBackground;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Premium enter phone page with glassmorphism design and smooth animations.
class EnterPhonePage extends ConsumerStatefulWidget {
  const EnterPhonePage({super.key});

  @override
  ConsumerState<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends ConsumerState<EnterPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (!isValidPhone(value ?? '')) return 'Enter a valid phone number.';
    return null;
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizePhone(_phoneController.text);

    setState(() => _isChecking = true);
    try {
      final exists =
          await ref
              .read(authControllerProvider.notifier)
              .checkPhoneRegistered(phone)
              .timeout(const Duration(seconds: 6), onTimeout: () => null);
      if (!mounted) return;

      final encoded = Uri.encodeComponent(phone);
      if (exists == false) {
        context.go('/signup?phone=$encoded');
        return;
      }
      context.go('/login?phone=$encoded');
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(error.toString());
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
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
        appBar: AppBar(title: const Text('Enter phone')),
        body: const AppErrorView(
          title: 'Missing Supabase configuration',
          message:
              'Add SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY to your .env file.',
        ),
      );
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icon
                      _buildLogo(),

                      const SizedBox(height: 40),

                      // Title
                      _buildTitle(),

                      const SizedBox(height: 48),

                      // Phone input card
                      PremiumGlassCard(
                        padding: const EdgeInsets.all(28),
                        borderRadius: 24,
                        opacity: 0.15,
                        child: PremiumStaggeredList(
                          itemCount: 3,
                          staggerDelay: const Duration(milliseconds: 80),
                          itemBuilder: (context, index) {
                            if (index == 0) return _buildPhoneInput();
                            if (index == 1) return _buildHelperText();
                            return _buildContinueButton();
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Terms text
                      _buildTermsText(),
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
        child: const Icon(
          Icons.home_rounded,
          size: 40,
          color: Colors.white,
        ),
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
          'Enter your phone number to get started',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return _AnimatedPhoneField(
      controller: _phoneController,
      onFieldSubmitted: (_) => _continue(),
      validator: _validatePhone,
    );
  }

  Widget _buildHelperText() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'We\'ll send you a verification code',
        style: _helperStyle(context),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: PremiumGlassButton(
        label: 'Continue',
        onPressed: _isChecking ? null : _continue,
        isLoading: _isChecking,
        icon: Icons.arrow_forward_rounded,
      ),
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
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push(Routes.termsOfService),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: _helperEmphasisColor(context),
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push(Routes.privacyPolicy),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Phone input field with animated focus glow and border transition.
class _AnimatedPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;

  const _AnimatedPhoneField({
    required this.controller,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  State<_AnimatedPhoneField> createState() => _AnimatedPhoneFieldState();
}

class _AnimatedPhoneFieldState extends State<_AnimatedPhoneField>
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
        Text(
          'PHONE NUMBER',
          style: _labelStyle(context),
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
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    validator: widget.validator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      _PhoneNumberFormatter(),
                    ],
                    style: _inputStyle(context),
                    cursorColor: const Color(0xFF3B82F6),
                    decoration: InputDecoration(
                      hintText: '00000 00000',
                      hintStyle: _hintStyle(context),
                      prefixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.phone_outlined,
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

/// Phone number formatter for Indian format (XXXXX XXXXX)
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
    );

TextStyle _hintStyle(BuildContext context) => TextStyle(
      color: _isLightTheme(context)
          ? const Color(0xFF94A3B8)
          : Colors.white.withValues(alpha: 0.3),
      fontSize: 18,
      letterSpacing: 1,
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
