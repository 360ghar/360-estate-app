import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Step definition for wizard progress indicator.
class WizardStep {
  final String label;
  final String? subtitle;
  final IconData icon;

  const WizardStep({
    required this.label,
    this.subtitle,
    required this.icon,
  });
}

/// Wizard progress indicator showing current step in sequence.
///
/// Features:
/// - Horizontal step indicator with icons
/// - Active, completed, and pending states
/// - Optional step labels below icons
/// - Animated transitions
///
/// Example:
/// ```dart
/// WizardProgressIndicator(
///   steps: const [
///     WizardStep(label: 'Basic', icon: Icons.info_outline),
///     WizardStep(label: 'Location', icon: Icons.location_on_outlined),
///     WizardStep(label: 'Details', icon: Icons.list_alt_outlined),
///   ],
///   currentStep: 1,
/// )
/// ```
class WizardProgressIndicator extends StatelessWidget {
  final List<WizardStep> steps;
  final int currentStep;
  final bool showLabels;

  const WizardProgressIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar at top
        _buildProgressBar(context),

        if (showLabels) ...[
          const SizedBox(height: AppSpacing.sm),
          // Step labels with icons
          _buildStepLabels(context),
        ],
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stepWidth = (constraints.maxWidth - (steps.length - 1) * AppSpacing.sm) / steps.length;

        return Row(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              if (i > 0)
                SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StepIndicator(
                  stepNumber: i + 1,
                  icon: steps[i].icon,
                  isCompleted: i < currentStep,
                  isActive: i == currentStep,
                  isPending: i > currentStep,
                  width: stepWidth,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStepLabels(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < steps.length; i++)
          Flexible(
            child: _StepLabel(
              label: steps[i].label,
              subtitle: steps[i].subtitle,
              isActive: i == currentStep,
              isCompleted: i < currentStep,
            ),
          ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int stepNumber;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;
  final bool isPending;
  final double width;

  const _StepIndicator({
    required this.stepNumber,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
    required this.isPending,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    double elevation = 0;

    if (isCompleted) {
      backgroundColor = scheme.primary;
      elevation = 2;
    } else if (isActive) {
      backgroundColor = scheme.primary.withValues(alpha: 0.15);
      elevation = 1;
    } else {
      backgroundColor = isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.borderLight;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadii.pill,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.3),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isActive;
  final bool isCompleted;

  const _StepLabel({
    required this.label,
    this.subtitle,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isActive
        ? scheme.primary
        : isCompleted
            ? scheme.primary
            : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final fontWeight = isActive || isCompleted ? FontWeight.w600 : FontWeight.w500;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall?.copyWith(
            color: textColor,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: AppTextStyles.labelSmall?.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Vertical wizard progress indicator for side-by-side layouts.
class WizardProgressIndicatorVertical extends StatelessWidget {
  final List<WizardStep> steps;
  final int currentStep;

  const WizardProgressIndicatorVertical({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _VerticalStepItem(
            step: steps[i],
            stepNumber: i + 1,
            isCompleted: i < currentStep,
            isActive: i == currentStep,
            isLast: i == steps.length - 1,
          ),
        ],
      ],
    );
  }
}

class _VerticalStepItem extends StatelessWidget {
  final WizardStep step;
  final int stepNumber;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const _VerticalStepItem({
    required this.step,
    required this.stepNumber,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final circleColor = isCompleted || isActive
        ? scheme.primary
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.borderLight);
    final iconColor = isCompleted || isActive
        ? Colors.white
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);
    final textColor = isCompleted || isActive
        ? scheme.primary
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circle with icon/number
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : Icon(
                        step.icon,
                        size: 16,
                        color: iconColor,
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: isCompleted
                    ? scheme.primary.withValues(alpha: 0.5)
                    : (isDark ? AppColors.darkBorder : AppColors.border),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        // Label
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            child: Text(
              step.label,
              style: AppTextStyles.labelMedium?.copyWith(
                color: textColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
