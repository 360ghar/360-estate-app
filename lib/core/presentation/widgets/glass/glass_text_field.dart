import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:estate_app/core/presentation/animations/animations.dart';

/// A glassmorphism text field with focus glow animation.
///
/// Provides premium input styling with animated focus states,
/// error handling, and customizable decoration.
///
/// Example:
/// ```dart
/// GlassTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   prefixIcon: Icons.email_outlined,
///   onChanged: (value) => print(value),
/// )
/// ```
class GlassTextField extends StatefulWidget {
  /// Label text displayed above the field
  final String? label;

  /// Hint text displayed when field is empty
  final String? hint;

  /// Optional prefix icon
  final IconData? prefixIcon;

  /// Optional suffix icon
  final IconData? suffixIcon;

  /// Callback for suffix icon tap
  final VoidCallback? onSuffixTap;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when user submits
  final ValueChanged<String>? onSubmitted;

  /// Callback when user taps the field
  final VoidCallback? onTap;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Maximum number of lines
  final int maxLines;

  /// Minimum number of lines
  final int minLines;

  /// Maximum text length
  final int? maxLength;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Initial text value
  final String? initialValue;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Error message to display
  final String? error;

  /// Helper text to display below the field
  final String? helperText;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the field
  final double borderRadius;

  /// Custom text color
  final Color? textColor;

  /// Custom hint color
  final Color? hintColor;

  /// Custom label color
  final Color? labelColor;

  /// Custom cursor color
  final Color? cursorColor;

  const GlassTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.inputFormatters,
    this.error,
    this.helperText,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 12,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.cursorColor,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void didUpdateWidget(GlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultTextColor = isDark ? Colors.white : AppColors.textPrimary;
    final defaultHintColor = isDark
        ? AppGlassColors.textSecondaryOnDark
        : AppColors.textSecondary;

    final effectiveTextColor = widget.textColor ?? defaultTextColor;
    final effectiveHintColor = widget.hintColor ?? defaultHintColor;
    final effectiveLabelColor = widget.labelColor ?? effectiveHintColor;

    return InputFocusAnimation(
      focusNode: _focusNode,
      hasError: widget.error != null,
      borderRadius: widget.borderRadius,
      child: Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 6),
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      color: effectiveLabelColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              _buildTextFieldContent(
                isDark,
                effectiveTextColor,
                effectiveHintColor,
              ),
              if (widget.error != null || widget.helperText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 6),
                  child: Text(
                    widget.error ?? widget.helperText!,
                    style: TextStyle(
                      color: widget.error != null
                          ? AppColors.dangerLight
                          : effectiveHintColor,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextFieldContent(
    bool isDark,
    Color textColor,
    Color hintColor,
  ) {
    final hasError = widget.error != null;
    final borderColor = hasError
        ? AppGlassColors.borderError
        : (_isFocused ? AppGlassColors.borderFocus : null);

    final textField = Container(
      decoration: BoxDecoration(
        color: (isDark
                ? AppGlassColors.glassSurfaceDark(widget.opacity)
                : AppGlassColors.glassSurfaceLight(widget.opacity))
            .withOpacity(widget.enabled ? 1 : 0.5),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: borderColor != null
            ? Border.all(
                color: borderColor,
                width: _isFocused ? 1.5 : 1,
              )
            : Border.all(
                color: isDark
                    ? AppGlassColors.borderDark
                    : AppGlassColors.borderLight,
                width: 1,
              ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        style: TextStyle(
          color: textColor.withOpacity(widget.enabled ? 1 : 0.5),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: widget.cursorColor ?? AppColors.accent,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: hintColor.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: hintColor,
                  size: 20,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixTap,
                  child: Icon(
                    widget.suffixIcon,
                    color: hintColor,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          counterText: '',
        ),
      ),
    );

    if (widget.blur <= 0) return textField;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
        child: textField,
      ),
    );
  }
}

/// A glass password field with visibility toggle.
class GlassPasswordField extends StatefulWidget {
  /// Label text displayed above the field
  final String? label;

  /// Hint text displayed when field is empty
  final String? hint;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when user submits
  final ValueChanged<String>? onSubmitted;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Whether the field is enabled
  final bool enabled;

  /// Error message to display
  final String? error;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  const GlassPasswordField({
    super.key,
    this.label,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.error,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
  });

  @override
  State<GlassPasswordField> createState() => _GlassPasswordFieldState();
}

class _GlassPasswordFieldState extends State<GlassPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return GlassTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscureText: _obscureText,
      enabled: widget.enabled,
      error: widget.error,
      blur: widget.blur,
      opacity: widget.opacity,
      suffixIcon: _obscureText ? Icons.visibility_outlined : Icons.visibility_off,
      onSuffixTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}

/// A glass search field with search icon.
class GlassSearchField extends StatelessWidget {
  /// Hint text
  final String? hint;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when user submits
  final ValueChanged<String>? onSubmitted;

  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Whether the field is enabled
  final bool enabled;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  const GlassSearchField({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
  });

  @override
  Widget build(BuildContext context) {
    return GlassTextField(
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      prefixIcon: Icons.search_outlined,
      blur: blur,
      opacity: opacity,
    );
  }
}
