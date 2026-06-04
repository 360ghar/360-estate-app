import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// An animated input wrapper that provides focus glow effects.
///
/// When the input field gains focus, it shows a glowing border
/// and subtle shadow animation. Ideal for glassmorphism text fields.
///
/// Example:
/// ```dart
/// InputFocusAnimation(
///   child: TextField(
///     decoration: InputDecoration(
///       hintText: 'Enter your email',
///     ),
///   ),
/// )
/// ```
class InputFocusAnimation extends StatefulWidget {
  /// The child widget (typically a TextField or TextFormField)
  final Widget child;

  /// Focus node to observe (optional, will use child's if not provided)
  final FocusNode? focusNode;

  /// Custom glow color when focused (default blue)
  final Color? glowColor;

  /// Custom error glow color
  final Color? errorGlowColor;

  /// Whether the input has an error
  final bool hasError;

  /// Animation duration (default 200ms)
  final Duration duration;

  /// Border radius for the glow effect
  final double borderRadius;

  const InputFocusAnimation({
    super.key,
    required this.child,
    this.focusNode,
    this.glowColor,
    this.errorGlowColor,
    this.hasError = false,
    this.duration = const Duration(milliseconds: 200),
    this.borderRadius = 12,
  });

  @override
  State<InputFocusAnimation> createState() => _InputFocusAnimationState();
}

class _InputFocusAnimationState extends State<InputFocusAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  FocusNode? _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Use provided focus node or try to find one in the child
    _focusNode = widget.focusNode;
    if (_focusNode == null) {
      _focusNode = FocusNode();
      _focusNode!.addListener(_onFocusChange);
    } else {
      _focusNode!.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_focusNode == null) return;
    final wasFocused = _isFocused;
    _isFocused = _focusNode!.hasFocus;

    if (wasFocused != _isFocused) {
      if (_isFocused) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(InputFocusAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _focusNode = widget.focusNode;
      _focusNode?.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  Color get _glowColor {
    if (widget.hasError) {
      return widget.errorGlowColor ?? AppColors.danger;
    }
    return widget.glowColor ?? AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowOpacity = _glowAnimation.value;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: glowOpacity > 0
                ? [
                    BoxShadow(
                      color: _glowColor.withValues(alpha: 0.3 * glowOpacity),
                      blurRadius: 8 * glowOpacity,
                    ),
                    BoxShadow(
                      color: _glowColor.withValues(alpha: 0.15 * glowOpacity),
                      blurRadius: 16 * glowOpacity,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            border: glowOpacity > 0
                ? Border.all(
                    color: _glowColor.withValues(alpha: 0.5 * glowOpacity),
                    width: 1.5,
                  )
                : null,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A focus animation wrapper that animates the border color.
///
/// Simpler version that only animates the border, without the glow effect.
class FocusBorderAnimation extends StatefulWidget {
  /// The child widget to wrap
  final Widget child;

  /// Focus node to observe
  final FocusNode? focusNode;

  /// Border radius for the animated border
  final double borderRadius;

  /// Border width
  final double borderWidth;

  /// Focused border color
  final Color? focusColor;

  /// Unfocused border color
  final Color? unfocusedColor;

  /// Error border color
  final Color? errorColor;

  /// Whether the field has an error
  final bool hasError;

  /// Animation duration
  final Duration duration;

  const FocusBorderAnimation({
    super.key,
    required this.child,
    this.focusNode,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.focusColor,
    this.unfocusedColor,
    this.errorColor,
    this.hasError = false,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<FocusBorderAnimation> createState() => _FocusBorderAnimationState();
}

class _FocusBorderAnimationState extends State<FocusBorderAnimation> {
  FocusNode? _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode;
    _focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode == null) return;
    final wasFocused = _isFocused;
    _isFocused = _focusNode!.hasFocus;
    if (wasFocused != _isFocused) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(FocusBorderAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _focusNode = widget.focusNode;
      _focusNode?.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  Color get _borderColor {
    if (widget.hasError) {
      return widget.errorColor ?? AppColors.danger;
    }
    if (_isFocused) {
      return widget.focusColor ?? AppColors.accent;
    }
    return widget.unfocusedColor ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: widget.child,
    );
  }
}
