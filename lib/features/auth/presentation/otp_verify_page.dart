import 'dart:async';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:estate_app/features/auth/presentation/widgets/resend_otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// Premium OTP verification page. Handles both SMS (phone) and email OTP, with
/// Android SMS autofill via [CodeAutoFill].
class OtpVerifyPage extends ConsumerStatefulWidget {
  const OtpVerifyPage({
    super.key,
    required this.identifier,
    this.isSignupFlow = false,
    this.isEmailChannel = false,
    this.requirePassword = false,
    this.isResetFlow = false,
  });

  /// The phone (E.164) or email the OTP was sent to.
  final String identifier;
  final bool isSignupFlow;
  final bool isEmailChannel;

  /// When true, the account has no password yet, so after a successful verify
  /// the user is routed to the mandatory set-password step (req 6).
  final bool requirePassword;

  /// When true, this is a forgot/reset flow: after a successful verify the user
  /// is forced to set a NEW password (`updateUser(password)`).
  final bool isResetFlow;

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage>
    with CodeAutoFill, ResendOtpTimer {
  final _formKey = GlobalKey<FormState>();
  String _otp = '';
  String? _autofilledCode;

  @override
  void initState() {
    super.initState();
    // SMS autofill only applies to the phone channel (Android-gated inside the
    // mixin); harmless to register for email too but we skip it for clarity.
    if (!widget.isEmailChannel) {
      listenForCode();
    }
    // The OTP was already sent before navigating here, so begin the cooldown.
    startResendCountdown();
  }

  @override
  void codeUpdated() {
    final value = code;
    if (value == null) return;
    if (!mounted) return;
    setState(() {
      _autofilledCode = value;
      _otp = value;
    });
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 24),
                      _buildTitle(),
                      const SizedBox(height: 48),
                      PremiumGlassCard(
                        padding: const EdgeInsets.all(28),
                        borderRadius: 24,
                        opacity: 0.15,
                        child: Column(
                          children: [
                            PremiumOtpInput(
                              incomingCode: _autofilledCode,
                              onCompleted: (otp) async {
                                setState(() => _otp = otp);
                                await _verifyOtp(otp);
                              },
                              onChanged: (value) {
                                if (_otp == value) return;
                                setState(() => _otp = value);
                              },
                              isLoading: state.isBusy && _otp.length == 6,
                            ),
                            const SizedBox(height: 32),
                            PremiumGlassButton(
                              label: 'Verify',
                              onPressed: state.isBusy || _otp.length != 6
                                  ? null
                                  : () => _verifyOtp(_otp),
                              isLoading: state.isBusy,
                            ),
                            const SizedBox(height: 24),
                            _buildResendSection(state),
                          ],
                        ),
                      ),
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

  Widget _buildTopBar() {
    return Row(
      children: [
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
        const PremiumStepIndicator(currentStep: 2),
      ],
    );
  }

  Widget _buildTitle() {
    final destinationLabel = widget.isEmailChannel
        ? 'Verify Your Email'
        : 'Verify Your Phone';
    final sentLabel = widget.isEmailChannel
        ? 'Enter the 6-digit code sent to your email'
        : 'Enter the 6-digit code sent to';
    return Column(
      children: [
        Text(
          destinationLabel,
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
          sentLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.identifier,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B82F6),
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResendSection(AuthState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Didn't receive the code?",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ResendOtpButton(
          canResend: canResend,
          remainingSeconds: resendSeconds,
          isBusy: state.isBusy,
          onResend: _resend,
        ),
      ],
    );
  }

  /// Resends must preserve the original send's [shouldCreateUser] intent:
  /// `true` only for a new-account signup, `false` for login and reset.
  bool get _shouldCreateUser => widget.isSignupFlow;

  Future<void> _resend() async {
    final notifier = ref.read(authControllerProvider.notifier);
    if (widget.isEmailChannel) {
      await notifier.sendEmailOtp(
        widget.identifier,
        shouldCreateUser: _shouldCreateUser,
      );
    } else {
      await notifier.requestOtp(
        widget.identifier,
        shouldCreateUser: _shouldCreateUser,
      );
    }
    if (!mounted) return;
    // Only restart the cooldown if the send didn't error out.
    if (ref.read(authControllerProvider).errorMessage == null) {
      startResendCountdown();
    }
  }

  Future<void> _verifyOtp(String otp) async {
    final router = GoRouter.of(context);
    final notifier = ref.read(authControllerProvider.notifier);

    // Forgot/reset flow: verify the OTP, then force a NEW password
    // (`updateUser(password)` via the set-password step). Works for both
    // channels.
    if (widget.isResetFlow) {
      if (widget.isEmailChannel) {
        await notifier.verifyEmailOtpForReset(
          email: widget.identifier,
          otp: otp,
        );
      } else {
        await notifier.verifyOtpForReset(phone: widget.identifier, otp: otp);
      }
      return;
    }

    if (widget.isEmailChannel) {
      // Email OTP signs the user in directly; the mandatory set-password step
      // (req 6) is handled inside the controller when [requirePassword].
      await notifier.verifyEmailOtp(
        email: widget.identifier,
        otp: otp,
        requirePassword: widget.requirePassword,
      );
      return;
    }

    if (widget.isSignupFlow) {
      final success = await notifier.verifyOtpForSignup(
        phone: widget.identifier,
        otp: otp,
      );
      if (!mounted || !success) return;
      final encoded = Uri.encodeComponent(widget.identifier);
      router.go('/login?identifier=$encoded');
      return;
    }

    await notifier.verifyOtp(
      phone: widget.identifier,
      otp: otp,
      requirePassword: widget.requirePassword,
    );
  }
}
