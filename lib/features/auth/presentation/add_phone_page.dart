import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:estate_app/features/auth/presentation/widgets/premium_otp_input.dart';
import 'package:estate_app/features/auth/presentation/widgets/resend_otp_timer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// Skippable add-phone interstitial shown after a passwordless Google sign-in
/// when the account has no verified phone. Always completes as a Google user.
class AddPhonePage extends ConsumerStatefulWidget {
  const AddPhonePage({super.key});

  @override
  ConsumerState<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends ConsumerState<AddPhonePage>
    with CodeAutoFill, ResendOtpTimer {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final SmartAuth _smartAuth = SmartAuth.instance;

  bool _otpSent = false;
  String _phone = '';
  String _otp = '';
  String? _autofilledCode;

  @override
  void dispose() {
    cancel();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void codeUpdated() {
    final value = code;
    if (value == null || !mounted) return;
    setState(() {
      _autofilledCode = value;
      _otp = value;
    });
  }

  bool get _supportsPhoneHint => !kIsWeb && Platform.isAndroid;

  Future<void> _showPhoneHintPicker() async {
    try {
      final res = await _smartAuth.requestPhoneNumberHint();
      final hint = res.data;
      if (hint != null && hint.isNotEmpty && mounted) {
        _phoneController.text = hint;
      }
    } catch (_) {
      // ignore
    }
  }

  Future<void> _sendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizePhone(_phoneController.text);
    final notifier = ref.read(authControllerProvider.notifier);
    final ok = await notifier.requestAddPhoneOtp(phone);
    if (!mounted) return;
    if (!ok) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) GlassToast.showError(context, msg);
      return;
    }
    listenForCode();
    setState(() {
      _phone = phone;
      _otpSent = true;
    });
    startResendCountdown();
  }

  Future<void> _resendOtp() async {
    final notifier = ref.read(authControllerProvider.notifier);
    final ok = await notifier.requestAddPhoneOtp(_phone);
    if (!mounted) return;
    if (!ok) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) GlassToast.showError(context, msg);
      return;
    }
    startResendCountdown();
  }

  Future<void> _verifyOtp(String otp) async {
    final notifier = ref.read(authControllerProvider.notifier);
    final ok = await notifier.verifyAddedPhone(phone: _phone, otp: otp);
    if (!mounted) return;
    if (!ok) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) GlassToast.showError(context, msg);
    }
    // On success the router redirect moves to /home.
  }

  Future<void> _skip() async {
    await ref.read(authControllerProvider.notifier).skipAddPhone();
  }

  String? _validatePhone(String? value) {
    if (!isValidPhone(value ?? '')) return 'Enter a valid phone number.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

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
                        _buildHeader(),
                        const SizedBox(height: 32),
                        PremiumGlassCard(
                          padding: const EdgeInsets.all(28),
                          borderRadius: 24,
                          opacity: 0.15,
                          child: _otpSent
                              ? _buildOtpStep(state)
                              : _buildPhoneStep(state),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: state.isBusy ? null : _skip,
                          child: Text(
                            'Skip for now',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.phone_iphone_rounded,
            size: 36,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Add your phone',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Optional — add a verified phone number for account recovery and faster sign-in.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneStep(AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'MOBILE NUMBER',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            if (_supportsPhoneHint)
              GestureDetector(
                onTap: _showPhoneHintPicker,
                child: const Text(
                  'Use my number',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: _validatePhone,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                cursorColor: const Color(0xFF3B82F6),
                onFieldSubmitted: (_) => _sendOtp(),
                decoration: InputDecoration(
                  hintText: '00000 00000',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
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
        const SizedBox(height: 20),
        PremiumGlassButton(
          label: 'Send code',
          onPressed: state.isBusy ? null : _sendOtp,
          isLoading: state.isBusy,
          icon: Icons.send_rounded,
        ),
      ],
    );
  }

  Widget _buildOtpStep(AuthState state) {
    return Column(
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
        const SizedBox(height: 24),
        PremiumGlassButton(
          label: 'Verify & continue',
          onPressed: state.isBusy || _otp.length != 6
              ? null
              : () => _verifyOtp(_otp),
          isLoading: state.isBusy,
        ),
        const SizedBox(height: 20),
        ResendOtpButton(
          canResend: canResend,
          remainingSeconds: resendSeconds,
          isBusy: state.isBusy,
          onResend: _resendOtp,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: state.isBusy
              ? null
              : () {
                  cancel();
                  stopResendCountdown();
                  setState(() {
                    _otpSent = false;
                    _otp = '';
                    _autofilledCode = null;
                  });
                },
          child: Text(
            'Change number',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
