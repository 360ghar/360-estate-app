import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart' show SimplePremiumBackground;
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Premium OTP verification page with glassmorphism design.
class OtpVerifyPage extends ConsumerStatefulWidget {
  const OtpVerifyPage({
    super.key,
    required this.phone,
    this.isSignupFlow = false,
  });

  final String phone;
  final bool isSignupFlow;

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  final _formKey = GlobalKey<FormState>();
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.errorMessage != next.errorMessage && next.errorMessage != null) {
        if (!mounted) return;
        GlassToast.showError(
          context,
          next.errorMessage!,
        );
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
                      // Back button and step indicator
                      _buildTopBar(),

                      const SizedBox(height: 24),

                      // Title
                      _buildTitle(),

                      const SizedBox(height: 48),

                      // OTP card
                      PremiumGlassCard(
                        padding: const EdgeInsets.all(28),
                        borderRadius: 24,
                        blur: 24,
                        opacity: 0.15,
                        child: Column(
                          children: [
                            // OTP Input
                            PremiumOtpInput(
                              length: 6,
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

                            // Verify button (manual trigger)
                            PremiumGlassButton(
                              label: 'Verify',
                              onPressed: state.isBusy || _otp.length != 6
                                  ? null
                                  : () => _verifyOtp(_otp),
                              isLoading: state.isBusy,
                            ),

                            const SizedBox(height: 24),

                            // Resend section
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
        const PremiumStepIndicator(currentStep: 2, totalSteps: 3),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Verify Your Phone',
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
          'Enter the 6-digit code sent to',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.phone,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3B82F6),
            letterSpacing: 1,
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
        GestureDetector(
          onTap: state.isBusy
              ? null
              : () {
                  ref.read(authControllerProvider.notifier).requestOtp(widget.phone);
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: state.isBusy
                      ? Colors.white.withValues(alpha: 0.3)
                      : const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Resend Code',
                  style: TextStyle(
                    color: state.isBusy
                        ? Colors.white.withValues(alpha: 0.3)
                        : const Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _verifyOtp(String otp) async {
    final router = GoRouter.of(context);
    if (widget.isSignupFlow) {
      final success = await ref
          .read(authControllerProvider.notifier)
          .verifyOtpForSignup(phone: widget.phone, otp: otp);
      if (!mounted || !success) return;
      final encoded = Uri.encodeComponent(widget.phone);
      router.go('/login?phone=$encoded');
      return;
    }
    await ref.read(authControllerProvider.notifier).verifyOtp(
          phone: widget.phone,
          otp: otp,
        );
  }
}
