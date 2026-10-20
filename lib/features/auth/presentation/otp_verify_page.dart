import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:estate_app/features/auth/presentation/widgets/resend_otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// OTP verification for both SMS (phone) and email codes, with Android SMS
/// autofill via [CodeAutoFill].
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
  /// the user is routed to the mandatory set-password step.
  final bool requirePassword;

  /// When true, this is a forgot/reset flow: after a successful verify the user
  /// is forced to set a NEW password (`updateUser(password)`).
  final bool isResetFlow;

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage>
    with CodeAutoFill, ResendOtpTimer {
  String _otp = '';
  String? _autofilledCode;

  @override
  void initState() {
    super.initState();
    // SMS autofill only applies to the phone channel (Android-gated inside the
    // mixin).
    if (!widget.isEmailChannel) listenForCode();
    // The OTP was already sent before navigating here, so begin the cooldown.
    startResendCountdown();
  }

  @override
  void codeUpdated() {
    final value = code;
    if (value == null || !mounted) return;
    setState(() => _autofilledCode = value);
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  /// Resends must keep the first send's intent: create a user only for a
  /// new-account signup, never for login or reset.
  Future<void> _resend() async {
    final notifier = ref.read(authControllerProvider.notifier);
    if (widget.isEmailChannel) {
      await notifier.sendEmailOtp(
        widget.identifier,
        shouldCreateUser: widget.isSignupFlow,
      );
    } else {
      await notifier.requestOtp(
        widget.identifier,
        shouldCreateUser: widget.isSignupFlow,
      );
    }
    if (!mounted) return;
    // Only restart the cooldown if the send didn't error out.
    if (ref.read(authControllerProvider).errorMessage == null) {
      startResendCountdown();
    }
  }

  Future<void> _verify(String otp) async {
    final router = GoRouter.of(context);
    final notifier = ref.read(authControllerProvider.notifier);

    // Forgot/reset: verify, then force a NEW password (both channels).
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
      // Email OTP signs the user in directly; the set-password step is
      // handled inside the controller when [requirePassword].
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
      router.go('/login?identifier=${Uri.encodeComponent(widget.identifier)}');
      return;
    }

    await notifier.verifyOtp(
      phone: widget.identifier,
      otp: otp,
      requirePassword: widget.requirePassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && previous?.errorMessage != message && mounted) {
        context.showSnack(message);
      }
    });

    return AuthScaffold(
      onBack: () => context.go('/enter-phone'),
      title: widget.isEmailChannel
          ? l10n.authVerifyEmailTitle
          : l10n.authVerifyPhoneTitle,
      subtitle: Text(l10n.authCodeSentTo(displayIdentifier(widget.identifier))),
      card: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpCodeField(
            incomingCode: _autofilledCode,
            enabled: !state.isBusy,
            hasError: state.errorMessage != null && _otp.length == 6,
            onChanged: (value) => setState(() => _otp = value),
            onCompleted: _verify,
          ),
          const SizedBox(height: AppSpacing.xl),
          AuthPrimaryButton(
            label: l10n.authVerify,
            busy: state.isBusy,
            onPressed: _otp.length == 6 ? () => _verify(_otp) : null,
          ),
          const SizedBox(height: AppSpacing.md),
          ResendOtpButton(
            canResend: canResend,
            remainingSeconds: resendSeconds,
            isBusy: state.isBusy,
            onResend: _resend,
          ),
        ],
      ),
    );
  }
}
