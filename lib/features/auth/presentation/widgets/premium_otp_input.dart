import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_colors.dart';

/// Premium OTP input with smooth animations and glassmorphism design.
///
/// Features:
/// - Individual digit fields with animated borders
/// - Glow effect on active field
/// - Smooth focus transitions
/// - Auto-advance to next field
/// - Backspace support
/// - Bounce animation on completion
class PremiumOtpInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool isLoading;

  const PremiumOtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.isLoading = false,
  });

  @override
  State<PremiumOtpInput> createState() => _PremiumOtpInputState();
}

class _PremiumOtpInputState extends State<PremiumOtpInput>
    with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<AnimationController> _focusControllers;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode()..addListener(() => setState(() {})),
    );
    _focusControllers = List.generate(
      widget.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _focusControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      _focusControllers[index].forward();
    }

    _updateOtp();
  }

  void _updateOtp() {
    setState(() {
      _otp = _controllers.map((c) => c.text).join();
    });
    widget.onChanged?.call(_otp);
    if (_otp.length == widget.length) {
      widget.onCompleted(_otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = (constraints.maxWidth / widget.length - 4).clamp(
          36.0,
          48.0,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < widget.length; i++)
              SizedBox(
                width: fieldWidth,
                child: _OtpDigitField(
                  index: i,
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  focusAnimation: _focusControllers[i],
                  isFocused: _focusNodes[i].hasFocus,
                  isDark: isDark,
                  onChanged: (value) => _onDigitChanged(i, value),
                  isLoading: widget.isLoading && _otp.length == widget.length,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final AnimationController focusAnimation;
  final bool isFocused;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final bool isLoading;

  const _OtpDigitField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.focusAnimation,
    required this.isFocused,
    required this.isDark,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  State<_OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<_OtpDigitField>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Trigger bounce when field gains focus with value
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus && widget.controller.text.isNotEmpty) {
      _bounceController.forward().then((_) => _bounceController.reverse());
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: AnimatedBuilder(
        animation: widget.focusAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: widget.isFocused
                  ? [
                      BoxShadow(
                        color: const Color(
                          0xFF3B82F6,
                        ).withValues(alpha: 0.3 * widget.focusAnimation.value),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppGlassColors.glassSurfaceDark(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.isFocused
                          ? const Color(0xFF3B82F6)
                          : AppGlassColors.borderDark,
                      width: widget.isFocused ? 1.5 : 1,
                    ),
                  ),
                  child: widget.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        )
                      : TextField(
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                          cursorColor: const Color(0xFF3B82F6),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: widget.onChanged,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Premium step indicator with animated progress.
///
/// Smooth animated transitions between steps with
/// gradient fill and glow effects.
class PremiumStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PremiumStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalSteps; i++) ...[
          _StepDot(
            isActive: i == currentStep,
            isCompleted: i < currentStep,
            delay: Duration(milliseconds: i * 100),
          ),
          if (i < totalSteps - 1)
            Container(
              width: 40,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: LinearProgressIndicator(
                value: i < currentStep ? 1.0 : 0.0,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF3B82F6),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _StepDot extends StatefulWidget {
  final bool isActive;
  final bool isCompleted;
  final Duration delay;

  const _StepDot({
    required this.isActive,
    required this.isCompleted,
    required this.delay,
  });

  @override
  State<_StepDot> createState() => _StepDotState();
}

class _StepDotState extends State<_StepDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });

    // Re-animate when state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isActive) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(_StepDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.isActive ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: widget.isActive || widget.isCompleted
                  ? const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    )
                  : null,
              color: widget.isActive || widget.isCompleted
                  ? null
                  : Colors.white.withValues(alpha: 0.2),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: const Color(
                          0xFF3B82F6,
                        ).withValues(alpha: 0.5 * _glowAnimation.value),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }
}
