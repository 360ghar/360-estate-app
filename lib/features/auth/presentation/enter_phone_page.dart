import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/apple_sign_in_button.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:estate_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
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
  bool _isChecking = false;

  /// The phone-number hint picker exists on Android only.
  bool get _supportsPhoneHint =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Sign in with Apple is offered on iOS only (Apple platform requirement when
  /// Google sign-in is also offered).
  bool get _supportsApple =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  String? _validateIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return context.l10n.authIdentifierRequired;
    if (isEmailIdentifier(text) || isValidPhone(text)) return null;
    return context.l10n.authIdentifierInvalid;
  }

  Future<void> _showPhoneHintPicker() async {
    try {
      final res = await SmartAuth.instance.requestPhoneNumberHint();
      final hint = res.data;
      if (hint != null && hint.isNotEmpty && mounted) {
        _identifierController.text = hint;
      }
    } catch (_) {
      // Picker unavailable or dismissed: the user types the number instead.
    }
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final raw = _identifierController.text.trim();
    final isEmail = isEmailIdentifier(raw);
    final identifier = isEmail ? raw.toLowerCase() : normalizePhone(raw);
    final l10n = context.l10n;

    setState(() => _isChecking = true);
    try {
      final status = await ref
          .read(authControllerProvider.notifier)
          .checkIdentifierStatus(identifier)
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () => throw TimeoutException(l10n.authCheckFailed),
          );
      if (!mounted) return;

      final encoded = Uri.encodeComponent(identifier);

      // Verified existing account with a password -> password screen.
      // Everything else (unverified, unknown, passwordless) -> OTP first.
      if (status.exists && status.nextStep == IdentifierNextStep.password) {
        context.go('/login?identifier=$encoded');
        return;
      }

      // OTP-first path. The account must set a password afterwards when it
      // has none: an existing passwordless account or a brand new one.
      final requireParam = status.hasPassword ? '' : '&requirePassword=true';

      if (status.exists && !status.verified) {
        context.showSnack(l10n.authUnverifiedNotice);
      }

      if (isEmail) {
        // Only allow account creation when the backend reports a new email.
        final sent = await _sendEmailOtp(
          identifier,
          shouldCreateUser: !status.exists,
        );
        if (!mounted || !sent) return;
        context.go('/otp?identifier=$encoded&channel=email$requireParam');
        return;
      }

      // An unknown phone goes to the signup form first; a known one gets the
      // login OTP without creating a user.
      if (!status.exists) {
        context.go('/signup?identifier=$encoded');
        return;
      }
      final sent = await _sendPhoneOtp(identifier);
      if (!mounted || !sent) return;
      context.go('/otp?identifier=$encoded&channel=phone$requireParam');
    } catch (error) {
      if (!mounted) return;
      // Prefer the controller-mapped text; never show error.toString().
      final fromState = ref.read(authControllerProvider).errorMessage;
      context.showSnack(
        fromState != null && fromState.isNotEmpty
            ? fromState
            : error is Failure
            ? error.message
            : error is TimeoutException
            ? l10n.authCheckFailed
            : l10n.errorSomethingWentWrong,
      );
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
    return _reportError();
  }

  // Phone OTP-first only runs for an existing account (new numbers route to
  // /signup), so it never needs to create a user.
  Future<bool> _sendPhoneOtp(String phone) async {
    await ref.read(authControllerProvider.notifier).requestOtp(phone);
    return _reportError();
  }

  /// Shows the controller's error, if any. True when there was none.
  bool _reportError() {
    final message = ref.read(authControllerProvider).errorMessage;
    if (message == null) return true;
    if (mounted) context.showSnack(message);
    return false;
  }

  void _onSocialResult(bool failed) {
    if (!mounted || !failed) return;
    // Navigation on success is handled by the router auth redirect.
    _reportError();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final controller = ref.read(authControllerProvider.notifier);
    final lastHint = _lastUsedHint(
      controller.lastAuthMethod,
      controller.lastAuthIdentifierMasked,
    );

    return AuthScaffold(
      brand: true,
      title: l10n.authEntryHeadline,
      subtitle: Text(l10n.authEntrySubtitle),
      card: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                autocorrect: false,
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.telephoneNumber,
                ],
                onFieldSubmitted: (_) => _continue(),
                validator: _validateIdentifier,
                decoration: InputDecoration(
                  labelText: l10n.authIdentifierLabel,
                  hintText: l10n.authIdentifierHint,
                  helperText: lastHint ?? l10n.authCodeHelper,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  suffixIcon: _supportsPhoneHint
                      ? IconButton(
                          tooltip: l10n.authUseMyNumber,
                          onPressed: _showPhoneHintPicker,
                          icon: const Icon(Icons.contact_phone_outlined),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AuthPrimaryButton(
                label: l10n.commonContinue,
                busy: _isChecking,
                onPressed: _continue,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.authOrContinueWith,
                textAlign: TextAlign.center,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GoogleSignInButton(
                enabled: !_isChecking,
                onResult: (o) =>
                    _onSocialResult(o == GoogleSignInOutcome.error),
              ),
              if (_supportsApple) ...[
                const SizedBox(height: AppSpacing.md),
                AppleSignInButton(
                  enabled: !_isChecking,
                  onResult: (o) =>
                      _onSocialResult(o == AppleSignInOutcome.error),
                ),
              ],
            ],
          ),
        ),
      ),
      footer: AuthLegalText(sentence: l10n.authTermsSentence),
    );
  }

  String? _lastUsedHint(AuthMethod? method, String? masked) {
    if (method == null || masked == null) return null;
    final l10n = context.l10n;
    return switch (method) {
      AuthMethod.google => l10n.authLastUsedGoogle,
      AuthMethod.apple => l10n.authLastUsedApple,
      _ => l10n.authLastUsedEmail(masked),
    };
  }
}
