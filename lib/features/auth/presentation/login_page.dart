import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The password step of the unified sign-in flow, for an email or a phone
/// identifier. The identifier arrives from the entry page and is locked.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.identifier});

  final String? identifier;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Whether the locked identifier is an email (vs phone).
  bool get _isEmail => isEmailIdentifier(widget.identifier?.trim() ?? '');

  /// The identifier from the entry page, normalised; null when none came.
  String? get _locked {
    final raw = widget.identifier?.trim();
    if (raw == null || raw.isEmpty) return null;
    return _isEmail ? raw.toLowerCase() : normalizePhone(raw);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final notifier = ref.read(authControllerProvider.notifier);
    final password = _passwordController.text.trim();
    final locked = _locked;
    if (_isEmail && locked != null) {
      notifier.signInWithEmailPassword(email: locked, password: password);
    } else {
      notifier.signInWithPassword(
        phone: locked ?? normalizePhone(_phoneController.text),
        password: password,
      );
    }
  }

  /// Forgot-password reset for both channels: an email gets a reset code at
  /// the locked address; a phone gets one at the locked (or asked-for)
  /// number. A reset never creates an account. The OTP screen then forces a
  /// new password.
  Future<void> _onForgotPassword() async {
    final notifier = ref.read(authControllerProvider.notifier);
    final l10n = context.l10n;
    final locked = _locked;
    final String identifier;
    if (_isEmail && locked != null) {
      identifier = locked;
    } else {
      final phone = await _askPhone(locked ?? _phoneController.text);
      if (phone == null) return;
      identifier = phone;
    }
    try {
      final status = await notifier.checkIdentifierStatus(identifier);
      if (!mounted) return;
      if (!status.exists) {
        context.showSnack(l10n.authNoAccount);
        return;
      }
      if (_isEmail) {
        await notifier.sendEmailOtp(identifier);
      } else {
        await notifier.requestOtp(identifier);
      }
      if (!mounted) return;
      if (ref.read(authControllerProvider).errorMessage != null) return;
      final channel = _isEmail ? 'email' : 'phone';
      context.go(
        '/otp?identifier=${Uri.encodeComponent(identifier)}'
        '&channel=$channel&flow=reset',
      );
    } catch (_) {
      if (!mounted) return;
      context.showSnack(
        ref.read(authControllerProvider).errorMessage ?? l10n.authCheckFailed,
      );
    }
  }

  /// Asks which phone gets the reset code. Returns it normalised, or null.
  Future<String?> _askPhone(String prefill) async {
    final digits = prefill.replaceAll(RegExp(r'\D'), '');
    final controller = TextEditingController(
      text: const AuthPhoneNumberFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
              text: digits.length > 10
                  ? digits.substring(digits.length - 10)
                  : digits,
            ),
          )
          .text,
    );
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final l10n = dialogContext.l10n;
        void submit() {
          if (!(formKey.currentState?.validate() ?? false)) return;
          Navigator.pop(dialogContext, normalizePhone(controller.text));
        }

        return AlertDialog(
          title: Text(l10n.authResetTitle),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.authResetBody),
                const SizedBox(height: AppSpacing.lg),
                AuthPhoneField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => submit(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(onPressed: submit, child: Text(l10n.authSendCode)),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);
    final locked = _locked;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && previous?.errorMessage != message && mounted) {
        context.showSnack(message);
      }
    });

    return AuthScaffold(
      onBack: () => context.go('/enter-phone'),
      title: l10n.authLoginTitle,
      subtitle: locked == null
          ? Text(l10n.authLoginSubtitle)
          : AuthIdentityLine(
              identifier: locked,
              onChange: state.isBusy ? null : () => context.go('/enter-phone'),
            ),
      card: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (locked == null) ...[
                AuthPhoneField(controller: _phoneController),
                const SizedBox(height: AppSpacing.lg),
              ],
              AuthPasswordField(
                controller: _passwordController,
                label: l10n.authPassword,
                onSubmitted: (_) => _signIn(),
                validator: (value) => (value?.trim().length ?? 0) < 6
                    ? l10n.authPasswordInvalid
                    : null,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: state.isBusy ? null : _onForgotPassword,
                  child: Text(l10n.authForgotPassword),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AuthPrimaryButton(
                label: l10n.signInCta,
                busy: state.isBusy,
                onPressed: _signIn,
              ),
            ],
          ),
        ),
      ),
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            l10n.authNewHere,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: state.isBusy
                ? null
                : () => context.go(
                    locked == null || _isEmail
                        ? '/signup'
                        : '/signup?identifier=${Uri.encodeComponent(locked)}',
                  ),
            child: Text(l10n.createAccountCta),
          ),
        ],
      ),
    );
  }
}
