import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autofillHints,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.semanticsLabel,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.validator,
    this.onSubmitted,
    this.focusNode,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? semanticsLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (validator != null) {
      return Semantics(
        textField: true,
        label: semanticsLabel,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          autofillHints: autofillHints,
          onChanged: onChanged,
          enabled: enabled,
          readOnly: readOnly,
          onFieldSubmitted: onSubmitted,
          maxLines: obscureText ? 1 : maxLines,
          validator: validator,
          cursorColor: scheme.primary,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      );
    }

    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      cursorColor: scheme.primary,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );

    if (semanticsLabel == null) return field;
    return Semantics(textField: true, label: semanticsLabel, child: field);
  }
}
