import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Signup for an unknown phone: name, email, password, then an SMS code.
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key, this.identifier});

  final String? identifier;

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _termsAccepted = false;
  bool _showTermsError = false;

  String? get _locked {
    final raw = widget.identifier?.trim();
    return raw == null || raw.isEmpty ? null : normalizePhone(raw);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    setState(() => _showTermsError = !_termsAccepted);
    if (!valid || !_termsAccepted) return;
    final phone = _locked ?? normalizePhone(_phoneController.text);
    final success = await ref
        .read(authControllerProvider.notifier)
        .signUpWithPassword(
          phone: phone,
          password: _passwordController.text.trim(),
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
        );
    if (!mounted || !success) return;
    context.go(
      '/otp?identifier=${Uri.encodeComponent(phone)}&channel=phone&flow=signup',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = ref.watch(authControllerProvider.select((s) => s.isBusy));
    final locked = _locked;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && previous?.errorMessage != message && mounted) {
        context.showSnack(message);
      }
    });

    const gap = SizedBox(height: AppSpacing.lg);
    return AuthScaffold(
      onBack: () => context.go('/enter-phone'),
      title: l10n.authSignupTitle,
      subtitle: locked == null
          ? Text(l10n.authSignupSubtitle)
          : AuthIdentityLine(
              identifier: locked,
              onChange: busy ? null : () => context.go('/enter-phone'),
            ),
      card: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: InputDecoration(
                  labelText: l10n.authFullName,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? l10n.authFullNameRequired
                    : null,
              ),
              gap,
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: l10n.authEmail,
                  prefixIcon: const Icon(Icons.mail_outline_rounded),
                ),
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return l10n.authEmailRequired;
                  return _email.hasMatch(text) ? null : l10n.authEmailInvalid;
                },
              ),
              if (locked == null) ...[
                gap,
                AuthPhoneField(controller: _phoneController),
              ],
              gap,
              AuthPasswordField(
                controller: _passwordController,
                label: l10n.authPassword,
                helperText: l10n.authNewPasswordHelper,
                newPassword: true,
                textInputAction: TextInputAction.next,
                validator: (v) => (v?.trim().length ?? 0) < 6
                    ? l10n.authPasswordTooShort
                    : null,
              ),
              gap,
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
              const SizedBox(height: AppSpacing.md),
              _TermsCheck(
                accepted: _termsAccepted,
                showError: _showTermsError && !_termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthPrimaryButton(
                label: l10n.createAccountCta,
                busy: busy,
                onPressed: _submit,
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
            l10n.alreadyHaveAccountCta,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () => context.go(
                    locked == null
                        ? '/login'
                        : '/login?identifier=${Uri.encodeComponent(locked)}',
                  ),
            child: Text(l10n.signInCta),
          ),
        ],
      ),
    );
  }
}

/// The terms checkbox. Its error shows under it after a submit without it.
class _TermsCheck extends StatelessWidget {
  const _TermsCheck({
    required this.accepted,
    required this.showError,
    required this.onChanged,
  });

  final bool accepted;
  final bool showError;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: accepted,
              isError: showError,
              onChanged: (v) => onChanged(v ?? false),
            ),
            Expanded(
              child: AuthLegalText(
                sentence: l10n.authAgreeTerms,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        if (showError)
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 48),
              child: Text(
                l10n.authAcceptTerms,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
