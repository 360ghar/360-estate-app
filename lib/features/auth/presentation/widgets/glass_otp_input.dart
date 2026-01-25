import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';

/// A glassmorphism OTP input with bounce animation.
///
/// Features:
/// - Individual digit fields with glass containers
/// - Focus glow effect on active field
/// - Bounce animation on completion
/// - Auto-advance to next field
/// - Backspace support
///
/// Example:
/// ```dart
/// GlassOtpInput(
///   length: 6,
///   onCompleted: (otp) => print('OTP: $otp'),
/// )
/// ```
class GlassOtpInput extends StatefulWidget {
  /// Number of OTP digits
  final int length;

  /// Callback when OTP is completed
  final ValueChanged<String>? onCompleted;

  /// Callback when OTP changes
  final ValueChanged<String>? onChanged;

  /// Blur sigma value for glass effect
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of each digit field
  final double borderRadius;

  /// Size of each digit field
  final double fieldSize;

  /// Text style for the digits
  final TextStyle? textStyle;

  const GlassOtpInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 12,
    this.fieldSize = 48,
    this.textStyle,
  });

  @override
  State<GlassOtpInput> createState() => _GlassOtpInputState();
}

class _GlassOtpInputState extends State<GlassOtpInput>
    with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<AnimationController> _bounceControllers;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode()..addListener(() => _onFocusChange(index)),
    );
    _bounceControllers = List.generate(
      widget.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _onFocusChange(int index) {
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var bounceController in _bounceControllers) {
      bounceController.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isEmpty) {
      // Handle backspace
      if (_otp.length > index && index > 0) {
        setState(() {
          _otp = _otp.substring(0, index);
          _controllers[index].clear();
        });
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      // New digit entered
      setState(() {
        if (index < _otp.length) {
          _otp = _otp.substring(0, index) + value + _otp.substring(index + 1);
        } else {
          _otp += value;
        }
      });

      widget.onChanged?.call(_otp);

      // Trigger bounce animation
      _bounceControllers[index].forward().then((_) {
        _bounceControllers[index].reverse();
      });

      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All digits entered
        _focusNodes[index].unfocus();
        widget.onCompleted?.call(_otp);
      }
    }
  }

  void _onKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _OtpDigitField(
            index: index,
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            bounceController: _bounceControllers[index],
            onChanged: (value) => _onDigitChanged(value, index),
            onKeyDown: (event) => _onKeyDown(event, index),
            blur: widget.blur,
            opacity: widget.opacity,
            borderRadius: widget.borderRadius,
            size: widget.fieldSize,
            textStyle: widget.textStyle,
          ),
        );
      }),
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final AnimationController bounceController;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyDown;
  final double blur;
  final double opacity;
  final double borderRadius;
  final double size;
  final TextStyle? textStyle;

  const _OtpDigitField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.bounceController,
    required this.onChanged,
    required this.onKeyDown,
    required this.blur,
    required this.opacity,
    required this.borderRadius,
    required this.size,
    this.textStyle,
  });

  @override
  State<_OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<_OtpDigitField> {
  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    final hasValue = widget.controller.text.isNotEmpty;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) => widget.onKeyDown(event),
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: widget.bounceController,
          builder: (context, child) {
            final scale = 1.0 + (widget.bounceController.value * 0.1);

            return Transform.scale(
              scale: scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blur,
                    sigmaY: widget.blur,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: (isFocused || hasValue)
                          ? Colors.white.withOpacity(widget.opacity + 0.1)
                          : Colors.white.withOpacity(widget.opacity),
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: isFocused
                            ? AppColors.accent.withOpacity(0.6)
                            : Colors.white.withOpacity(0.2),
                        width: isFocused ? 1.5 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onChanged: widget.onChanged,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: widget.textStyle ??
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A glass OTP input with circle-shaped fields.
///
/// Alternative to the standard rectangular OTP fields.
class GlassOtpInputCircle extends StatefulWidget {
  /// Number of OTP digits
  final int length;

  /// Callback when OTP is completed
  final ValueChanged<String>? onCompleted;

  /// Callback when OTP changes
  final ValueChanged<String>? onChanged;

  /// Size of each circle
  final double size;

  const GlassOtpInputCircle({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.size = 48,
  });

  @override
  State<GlassOtpInputCircle> createState() => _GlassOtpInputCircleState();
}

class _GlassOtpInputCircleState extends State<GlassOtpInputCircle> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isEmpty) {
      if (_otp.length > index && index > 0) {
        setState(() {
          _otp = _otp.substring(0, index);
          _controllers[index].clear();
        });
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      setState(() {
        if (index < _otp.length) {
          _otp = _otp.substring(0, index) + value + _otp.substring(index + 1);
        } else {
          _otp += value;
        }
      });

      widget.onChanged?.call(_otp);

      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        widget.onCompleted?.call(_otp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _CircleDigitField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onDigitChanged(value, index),
            size: widget.size,
          ),
        );
      }),
    );
  }
}

class _CircleDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final double size;

  const _CircleDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppGlassBlur.medium, sigmaY: AppGlassBlur.medium),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isFocused || hasValue)
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            border: Border.all(
              color: isFocused
                  ? AppColors.accent.withOpacity(0.6)
                  : Colors.white.withOpacity(0.2),
              width: isFocused ? 2 : 1.5,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              maxLength: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}
