import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';

/// A glassmorphism step indicator for authentication flow.
///
/// Features:
/// - Glass container with blur effect
/// - Animated width: 32px (current), 10px (inactive)
/// - Gradient fill for active steps
/// - Smooth 200ms transitions
///
/// Example:
/// ```dart
/// GlassStepIndicator(
///   currentStep: 1,
///   totalSteps: 3,
/// )
/// ```
class GlassStepIndicator extends StatelessWidget {
  /// Current step index (0-based)
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// Blur sigma value for glass effect
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Active step color
  final Color? activeColor;

  /// Inactive step color
  final Color? inactiveColor;

  const GlassStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.blur = AppGlassBlur.light,
    this.opacity = AppGlassColors.opacityMedium,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              final isCurrent = index == currentStep;

              return _StepDot(
                isActive: isActive,
                isCurrent: isCurrent,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                isLast: index == totalSteps - 1,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;
  final bool isCurrent;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isLast;

  const _StepDot({
    required this.isActive,
    required this.isCurrent,
    this.activeColor,
    this.inactiveColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.accent;
    final effectiveInactiveColor =
        inactiveColor ?? Colors.white.withOpacity(0.3);

    final width = isCurrent ? 32.0 : 10.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: width,
      height: 10,
      margin: EdgeInsets.only(right: isLast ? 0 : 6),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [
                  effectiveActiveColor,
                  effectiveActiveColor.withOpacity(0.8),
                ],
              )
            : null,
        color: isActive ? null : effectiveInactiveColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: effectiveActiveColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}

/// A circular glass step indicator variant.
///
/// Displays steps as numbered circles with glass effect.
class GlassStepIndicatorCircular extends StatelessWidget {
  /// Current step index (0-based)
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// Blur sigma value for glass effect
  final double blur;

  /// Size of each circle
  final double circleSize;

  const GlassStepIndicatorCircular({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.blur = AppGlassBlur.light,
    this.circleSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircularStepDot(
              step: index + 1,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              blur: blur,
              size: circleSize,
            ),
            if (index < totalSteps - 1)
              Container(
                width: 40,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: isCompleted || isCurrent
                      ? LinearGradient(
                          colors: [
                            AppColors.accent,
                            AppColors.accent.withOpacity(0.3),
                          ],
                        )
                      : null,
                  color: isCompleted || isCurrent
                      ? null
                      : Colors.white.withOpacity(0.2),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _CircularStepDot extends StatelessWidget {
  final int step;
  final bool isCompleted;
  final bool isCurrent;
  final double blur;
  final double size;

  const _CircularStepDot({
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
    required this.blur,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isCompleted || isCurrent
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF2563EB),
                ],
              )
            : null,
        color: isCompleted || isCurrent
            ? null
            : Colors.white.withOpacity(0.1),
        border: Border.all(
          color: isCompleted || isCurrent
              ? Colors.transparent
              : Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : Text(
                step.toString(),
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
