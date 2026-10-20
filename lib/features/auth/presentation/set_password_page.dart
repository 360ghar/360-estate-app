import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mandatory (non-skippable) set-password step shown after an OTP-verified
/// login for an account that has no password yet, or after a forgot/reset OTP
/// verify. The user must set a password before entering the app. Backing out
/// signs them out.
class SetPasswordPage extends ConsumerStatefulWidget {
  const SetPasswordPage({super.key});

  @override
  ConsumerState<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends ConsumerState<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .completeSetPassword(_passwordController.text.trim());
    if (!mounted || ok) return;
    // On success the router redirect moves on (home, add phone, ...).
    final message = ref.read(authControllerProvider).errorMessage;
    if (message != null) context.showSnack(message);
  }

  Future<void> _confirmLeave() async {
    final l10n = context.l10n;
    final leave = await context.confirm(
      title: l10n.authLeaveTitle,
      message: l10n.authLeaveBody,
      confirmLabel: l10n.commonSignOut,
      destructive: true,
    );
    if (leave) {
      await ref.read(authControllerProvider.notifier).cancelSetPassword();
    }
  }

  /// The account this password is for, masked: r•••@mail.com or •••••• 3210.
  static String? _masked(AuthState state) {
    final email = state.user?.email?.trim();
    if (email != null && email.isNotEmpty && isEmailIdentifier(email)) {
      final at = email.indexOf('@');
      return '${at > 0 ? email[0] : ''}•••${email.substring(at)}';
    }
    final phone = (state.user?.phone ?? state.phone)?.trim();
    if (phone == null || phone.isEmpty) return null;
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 4
        ? '•••••• ${digits.substring(digits.length - 4)}'
        : '••••';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);
    final isReset = ref
        .read(authControllerProvider.notifier)
        .setPasswordIsReset;
    final masked = _masked(state);
    final body = isReset
        ? l10n.authResetPasswordBody
        : l10n.authSetPasswordBody;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: AuthScaffold(
        title: isReset
            ? l10n.authResetPasswordTitle
            : l10n.authSetPasswordTitle,
        subtitle: Text(
          masked == null ? body : '$body ${l10n.authPasswordFor(masked)}.',
        ),
        card: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthPasswordField(
                  controller: _passwordController,
                  label: l10n.authNewPassword,
                  helperText: l10n.authNewPasswordHelper,
                  newPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v?.trim().length ?? 0) < 6
                      ? l10n.authPasswordTooShort
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthPasswordField(
                  controller: _confirmController,
                  label: l10n.authConfirmPassword,
                  newPassword: true,
                  onSubmitted: (_) => _submit(),
                  validator: (v) {
                    final text = v?.trim() ?? '';
                    if (text.isEmpty) return l10n.authConfirmPasswordRequired;
                    return text == _passwordController.text.trim()
                        ? null
                        : l10n.authPasswordsDiffer;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AuthPrimaryButton(
                  label: isReset
                      ? l10n.authResetPasswordAction
                      : l10n.authSetPasswordAction,
                  busy: state.isBusy,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
        footer: Center(
          child: TextButton(
            onPressed: state.isBusy ? null : _confirmLeave,
            child: Text(l10n.authUseDifferentAccount),
          ),
        ),
      ),
    );
  }
}
