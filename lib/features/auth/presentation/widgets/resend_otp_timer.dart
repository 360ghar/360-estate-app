import 'dart:async';

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

/// Shared "Resend code" control used by every OTP step. While the cooldown is
/// active (or a request is in flight) it is disabled and shows the remaining
/// seconds; once [canResend] is true it becomes tappable.
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

  static const Color _accent = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final enabled = canResend && !isBusy;
    final color = enabled ? _accent : Colors.white.withValues(alpha: 0.3);
    final label = canResend ? 'Resend Code' : 'Resend in ${remainingSeconds}s';

    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: GestureDetector(
        onTap: enabled ? onResend : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
