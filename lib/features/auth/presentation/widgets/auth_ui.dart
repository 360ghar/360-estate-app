import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/receipt_edge.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// The logo mark without its white square: the light or the dark cut,
/// so it sits on any surface with nothing behind it.
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.height = 48});

  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? 'assets/images/logo_mark_dark.png' : 'assets/images/logo_mark.png',
      height: height,
      semanticLabel: context.l10n.appName,
    );
  }
}

/// The frame of every sign-in screen. The form sits on a receipt-edged card
/// (the app's signature shape). The entry screen ([brand]) opens with the
/// logo and a large headline; the later steps open with a back button and a
/// step headline.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.card,
    this.subtitle,
    this.footer,
    this.onBack,
    this.brand = false,
  });

  final String title;
  final Widget? subtitle;
  final Widget card;
  final Widget? footer;
  final VoidCallback? onBack;
  final bool brand;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Scaffold(
      body: SafeArea(
        // The entry screen sits in the middle; the steps start at the top so
        // the back button stays where the thumb expects it.
        child: Align(
          alignment: brand ? Alignment.center : Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (brand) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        const AuthLogo(),
                        const SizedBox(width: AppSpacing.md),
                        ExcludeSemantics(
                          child: Text(
                            context.l10n.appName,
                            style: text.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ] else
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: AppSpacing.md,
                        ),
                        child: onBack == null
                            ? const SizedBox(height: 48)
                            : IconButton(
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                alignment: AlignmentDirectional.centerStart,
                                tooltip: context.l10n.commonBack,
                                onPressed: onBack,
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                      ),
                    ),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: brand ? text.displaySmall : text.headlineLarge,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    DefaultTextStyle.merge(
                      style: text.bodyLarge?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      child: subtitle!,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Material(
                    color: context.palette.card,
                    shape: const ReceiptEdgeBorder(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.xl,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      child: card,
                    ),
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An Indian mobile number as people read it: +91 98765 43210. Emails and
/// other numbers come back unchanged.
String displayIdentifier(String value) {
  final match = RegExp(r'^\+91(\d{5})(\d{5})$').firstMatch(value);
  return match == null ? value : '+91\u00A0${match[1]}\u00A0${match[2]}';
}

/// "Signing in as X  Change": who this step is for, and the way back.
class AuthIdentityLine extends StatelessWidget {
  const AuthIdentityLine({
    super.key,
    required this.identifier,
    required this.onChange,
  });

  final String identifier;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: AppSpacing.xs,
    children: [
      Text(
        displayIdentifier(identifier),
        style: context.text.titleMedium?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      if (onChange != null)
        TextButton(onPressed: onChange, child: Text(context.l10n.authChange)),
    ],
  );
}

/// A full-width primary action that shows progress while [busy].
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: context.colors.onSurfaceVariant,
                semanticsLabel: context.l10n.commonLoading,
              ),
            )
          : Text(label),
    ),
  );
}

/// A password field with a show / hide toggle. Password managers and paste
/// work as usual.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
    this.validator,
    this.newPassword = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? helperText;
  final String? Function(String?)? validator;

  /// Asks the password manager to suggest a new password.
  final bool newPassword;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      autofillHints: [
        widget.newPassword ? AutofillHints.newPassword : AutofillHints.password,
      ],
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: _obscure ? l10n.authShowPassword : l10n.authHidePassword,
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}

/// An Indian mobile number: +91 prefix, ten digits shown as 98765 43210.
class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        const AuthPhoneNumberFormatter(),
      ],
      validator: (value) =>
          isValidPhone(value ?? '') ? null : l10n.authPhoneInvalid,
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      decoration: InputDecoration(
        labelText: l10n.authPhone,
        hintText: l10n.authPhoneHint,
        prefixIcon: const Icon(Icons.phone_outlined),
        prefixText: '+91 ',
        suffixIcon: suffix,
      ),
    );
  }
}

/// Shows ten digits as "98765 43210" and keeps the cursor on the digit the
/// user typed, also for edits in the middle.
class AuthPhoneNumberFormatter extends TextInputFormatter {
  const AuthPhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final all = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Ten digits at most, counted after the grouping space is removed.
    final digits = all.length > 10 ? all.substring(0, 10) : all;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    final selection = newValue.selection;
    if (!selection.isValid) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    final before = newValue.text
        .substring(0, selection.baseOffset.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'\D'), '')
        .length
        .clamp(0, digits.length);
    final offset = before + (before > 5 ? 1 : 0);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset.clamp(0, text.length)),
    );
  }
}

/// A sentence with the Terms of Service and Privacy Policy as links. They
/// open the in-app legal pages, which work before sign-in.
class AuthLegalText extends StatefulWidget {
  const AuthLegalText({
    super.key,
    required this.sentence,
    this.textAlign = TextAlign.center,
  });

  /// Builds the sentence around the two link texts.
  final String Function(String terms, String privacy) sentence;
  final TextAlign textAlign;

  @override
  State<AuthLegalText> createState() => _AuthLegalTextState();
}

class _AuthLegalTextState extends State<AuthLegalText> {
  late final _terms = TapGestureRecognizer()
    ..onTap = () => context.push(Routes.publicTermsOfService);
  late final _privacy = TapGestureRecognizer()
    ..onTap = () => context.push(Routes.publicPrivacyPolicy);

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const termsMark = '\u0001';
    const privacyMark = '\u0002';
    final link = TextStyle(
      color: context.colors.primary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: context.colors.primary,
    );
    final spans = <InlineSpan>[];
    final pattern = RegExp('[$termsMark$privacyMark]');
    final source = widget.sentence(termsMark, privacyMark);
    var start = 0;
    for (final match in pattern.allMatches(source)) {
      spans.add(TextSpan(text: source.substring(start, match.start)));
      final isTerms = match.group(0) == termsMark;
      spans.add(
        TextSpan(
          text: isTerms ? l10n.termsOfService : l10n.privacyPolicy,
          style: link,
          recognizer: isTerms ? _terms : _privacy,
        ),
      );
      start = match.end;
    }
    spans.add(TextSpan(text: source.substring(start)));
    return Text.rich(
      TextSpan(children: spans),
      textAlign: widget.textAlign,
      style: context.text.bodySmall?.copyWith(
        color: context.colors.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }
}
