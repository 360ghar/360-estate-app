import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:estate_app/features/auth/presentation/widgets/resend_otp_timer.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// Skippable add-phone step shown after a passwordless Google sign-in when the
/// account has no verified phone. Always completes as a Google user.
class AddPhonePage extends ConsumerStatefulWidget {
  const AddPhonePage({super.key});

  @override
  ConsumerState<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends ConsumerState<AddPhonePage>
    with CodeAutoFill, ResendOtpTimer {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _otpSent = false;
  String _phone = '';
  String _otp = '';
  String? _autofilledCode;

  bool get _supportsPhoneHint =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

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
    setState(() => _autofilledCode = value);
  }

  Future<void> _showPhoneHintPicker() async {
    try {
      final res = await SmartAuth.instance.requestPhoneNumberHint();
      final hint = res.data;
      if (hint != null && hint.isNotEmpty && mounted) {
        final digits = hint.replaceAll(RegExp(r'\D'), '');
        _phoneController.text = const AuthPhoneNumberFormatter()
            .formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(
                text: digits.length > 10
                    ? digits.substring(digits.length - 10)
                    : digits,
              ),
            )
            .text;
      }
    } catch (_) {
      // Picker unavailable or dismissed: the user types the number.
    }
  }

  /// Sends (or resends) the code. True when it went out.
  Future<bool> _send(String phone) async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .requestAddPhoneOtp(phone);
    if (!mounted) return false;
    if (!ok) {
      final message = ref.read(authControllerProvider).errorMessage;
      if (message != null) context.showSnack(message);
      return false;
    }
    startResendCountdown();
    return true;
  }

  Future<void> _sendFirst() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizePhone(_phoneController.text);
    if (!await _send(phone)) return;
    listenForCode();
    setState(() {
      _phone = phone;
      _otpSent = true;
    });
  }

  Future<void> _verify(String otp) async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .verifyAddedPhone(phone: _phone, otp: otp);
    if (!mounted || ok) return;
    // On success the router redirect moves to /home.
    final message = ref.read(authControllerProvider).errorMessage;
    if (message != null) context.showSnack(message);
  }

  void _changeNumber() {
    cancel();
    stopResendCountdown();
    setState(() {
      _otpSent = false;
      _otp = '';
      _autofilledCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = ref.watch(authControllerProvider.select((s) => s.isBusy));

    return AuthScaffold(
      title: l10n.authAddPhoneTitle,
      subtitle: Text(
        _otpSent
            ? l10n.authCodeSentTo(displayIdentifier(_phone))
            : l10n.authAddPhoneBody,
      ),
      card: _otpSent ? _codeStep(busy) : _phoneStep(busy),
      footer: Center(
        child: TextButton(
          onPressed: busy
              ? null
              : () => ref.read(authControllerProvider.notifier).skipAddPhone(),
          child: Text(l10n.authSkipForNow),
        ),
      ),
    );
  }

  Widget _phoneStep(bool busy) {
    final l10n = context.l10n;
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthPhoneField(
              controller: _phoneController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendFirst(),
              suffix: _supportsPhoneHint
                  ? IconButton(
                      tooltip: l10n.authUseMyNumber,
                      onPressed: _showPhoneHintPicker,
                      icon: const Icon(Icons.contact_phone_outlined),
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AuthPrimaryButton(
              label: l10n.authSendCode,
              busy: busy,
              onPressed: _sendFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget _codeStep(bool busy) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpCodeField(
          incomingCode: _autofilledCode,
          enabled: !busy,
          onChanged: (value) => setState(() => _otp = value),
          onCompleted: _verify,
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthPrimaryButton(
          label: l10n.authVerifyAndContinue,
          busy: busy,
          onPressed: _otp.length == 6 ? () => _verify(_otp) : null,
        ),
        const SizedBox(height: AppSpacing.md),
        ResendOtpButton(
          canResend: canResend,
          remainingSeconds: resendSeconds,
          isBusy: busy,
          onResend: () => _send(_phone),
        ),
        Center(
          child: TextButton(
            onPressed: busy ? null : _changeNumber,
            child: Text(l10n.authChangeNumber),
          ),
        ),
      ],
    );
  }
}
