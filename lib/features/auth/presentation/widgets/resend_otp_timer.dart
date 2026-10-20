import 'dart:async';

import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Standard cooldown (in seconds) before an OTP can be resent. Shared by every
/// OTP step (phone verify, email verify, add-phone) so the behaviour is
/// identical everywhere.
const int kResendOtpCooldownSeconds = 30;

/// Mixin that adds a single reusable resend countdown to any [State].
///
/// Call [startResendCountdown] right after an OTP is (re)sent. While the
/// countdown is active, [canResend] is `false` and [resendSeconds] holds the
/// remaining seconds (for display). When it reaches `0`, [canResend] becomes
/// `true`. The host widget rebuilds on each tick via [setState].
mixin ResendOtpTimer<T extends StatefulWidget> on State<T> {
  Timer? _resendTimer;
  int _resendSeconds = 0;

  /// Remaining cooldown seconds (0 when resend is allowed).
  int get resendSeconds => _resendSeconds;

  /// Whether the user may resend the OTP now.
  bool get canResend => _resendSeconds <= 0;

  /// Starts (or restarts) the [kResendOtpCooldownSeconds] countdown.
  void startResendCountdown([int seconds = kResendOtpCooldownSeconds]) {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = seconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds -= 1);
      }
    });
  }

  /// Cancels any running countdown (e.g. when leaving the step).
  void stopResendCountdown() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}

/// "Didn't get the code?  Resend in 24s": the countdown is visible, and the
/// button turns on when it reaches zero.
class ResendOtpButton extends StatelessWidget {
  const ResendOtpButton({
    super.key,
    required this.canResend,
    required this.remainingSeconds,
    required this.isBusy,
    required this.onResend,
  });

  final bool canResend;
  final int remainingSeconds;
  final bool isBusy;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.authDidNotGetCode,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: canResend && !isBusy ? onResend : null,
          child: Text(
            canResend
                ? l10n.authResendCode
                : l10n.authResendIn(remainingSeconds),
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
