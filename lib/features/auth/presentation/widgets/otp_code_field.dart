import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A one-time code entry. It is ONE text field (so paste, the keyboard's
/// one-time-code suggestion and SMS autofill all work), drawn as a row of
/// digit slots that share the width: it fits a 320 px screen.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 6,
    this.incomingCode,
    this.enabled = true,
    this.hasError = false,
  });

  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;

  /// A code from SMS autofill. A new value fills the field.
  final String? incomingCode;
  final bool enabled;
  final bool hasError;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant OtpCodeField old) {
    super.didUpdateWidget(old);
    final code = widget.incomingCode;
    if (code != null &&
        code != old.incomingCode &&
        RegExp('^\\d{${widget.length}}\$').hasMatch(code)) {
      _controller.text = code;
      _onChanged(code);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      _focus.unfocus();
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const none = InputBorder.none;
    final slotWidth = widget.length * 52.0 + (widget.length - 1) * 8;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: slotWidth),
        child: SizedBox(
          height: 56,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The real field takes the taps (and long-press paste); its own
              // text is invisible because the slots draw the digits.
              TextField(
                controller: _controller,
                focusNode: _focus,
                enabled: widget.enabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: (value) {
                  setState(() {});
                  _onChanged(value);
                },
                showCursor: false,
                style: const TextStyle(color: Colors.transparent),
                decoration: InputDecoration(
                  labelText: context.l10n.authCodeLabel,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(color: Colors.transparent),
                  border: none,
                  enabledBorder: none,
                  focusedBorder: none,
                  errorBorder: none,
                  focusedErrorBorder: none,
                  disabledBorder: none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              IgnorePointer(
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.sm),
                        Expanded(child: _slot(context, colors, i)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slot(BuildContext context, ColorScheme colors, int i) {
    final text = _controller.text;
    final active =
        _focus.hasFocus && i == text.length.clamp(0, widget.length - 1);
    final border = widget.hasError
        ? colors.error
        : active
        ? colors.primary
        : colors.outline;
    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: AppRadii.md,
        border: Border.all(color: border, width: active ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: Text(
        i < text.length ? text[i] : '',
        style: AppTextStyles.currencyMedium.copyWith(color: colors.onSurface),
      ),
    );
  }
}
