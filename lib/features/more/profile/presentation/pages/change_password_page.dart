import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Current password, then the new one twice. The rules tick off as you type.
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .changePassword(
            currentPassword: _current.text,
            newPassword: _new.text,
          );
      if (!mounted) return;
      context.showSnack(context.l10n.passwordChangedShort);
      context.pop();
    } catch (_) {
      if (!mounted) return;
      context.showSnack(
        ref.read(authControllerProvider).errorMessage ??
            context.l10n.passwordChangeFailedShort,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreChangePassword)),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              Text(
                l10n.passwordPageIntro,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSectionCard(
                children: [
                  _PasswordField(
                    controller: _current,
                    label: l10n.passwordCurrentLabel,
                    autofill: AutofillHints.password,
                    validator: (v) => v == null || v.isEmpty
                        ? l10n.validationCurrentPasswordRequired
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PasswordField(
                    controller: _new,
                    label: l10n.passwordNewLabel,
                    autofill: AutofillHints.newPassword,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.validationNewPasswordRequired;
                      }
                      return v.length < 8 ? l10n.passwordTooShort8 : null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ListenableBuilder(
                    listenable: _new,
                    builder: (context, _) => _Rules(password: _new.text),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PasswordField(
                    controller: _confirm,
                    // The short label: at 1.5x text the long one ellipsizes
                    // inside the field.
                    label: l10n.authConfirmPassword,
                    autofill: AutofillHints.newPassword,
                    last: true,
                    onSubmitted: _isSaving ? null : _submit,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.validationConfirmPasswordRequired;
                      }
                      return v != _new.text
                          ? l10n.validationPasswordsDoNotMatch
                          : null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.moreChangePassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A password field with a show / hide toggle.
class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.autofill,
    required this.validator,
    this.last = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String autofill;
  final FormFieldValidator<String> validator;
  final bool last;
  final VoidCallback? onSubmitted;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: _hidden,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: [widget.autofill],
    textInputAction: widget.last ? TextInputAction.done : TextInputAction.next,
    onFieldSubmitted: (_) => widget.onSubmitted?.call(),
    validator: widget.validator,
    decoration: InputDecoration(
      labelText: widget.label,
      suffixIcon: IconButton(
        tooltip: _hidden
            ? context.l10n.passwordShow
            : context.l10n.passwordHide,
        icon: Icon(
          _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () => setState(() => _hidden = !_hidden),
      ),
    ),
  );
}

/// The rules a new password must meet, each with a mark and a word, so the
/// state never rests on colour alone.
class _Rules extends StatelessWidget {
  const _Rules({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = [
      (l10n.requirementMinLength, password.length >= 8),
      (l10n.requirementUppercase, password.contains(RegExp('[A-Z]'))),
      (l10n.requirementLowercase, password.contains(RegExp('[a-z]'))),
      (l10n.requirementNumber, password.contains(RegExp('[0-9]'))),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.passwordRules, style: context.text.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        for (final (label, met) in rules)
          Semantics(
            label:
                '$label, ${met ? l10n.passwordRuleMet : l10n.passwordRuleMissing}',
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(
                    met
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: met
                        ? context.palette.success
                        : context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.bodySmall?.copyWith(
                        color: met
                            ? context.palette.success
                            : context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
