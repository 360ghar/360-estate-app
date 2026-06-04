import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Progress bar color types for semantic meaning.
enum AppProgressColor {
  /// Use primary theme color
  primary,

  /// Green - success, completed, high occupancy
  success,

  /// Orange - warning, pending, moderate
  warning,

  /// Red - danger, overdue, low occupancy
  danger,

  /// Neutral gray
  neutral,
}

/// Style variant for the progress bar.
enum AppProgressVariant {
  /// Standard linear progress bar
  linear,

  /// Thin progress bar for compact spaces
  thin,

  /// Circular progress indicator
  circular,

  /// Segmented/dashed progress bar
  segmented,
}

/// Progress bar component for visualizing metrics like occupancy, completion, etc.
///
/// Displays progress with:
/// - Linear or circular style
/// - Semantic color coding
/// - Optional label showing percentage
/// - Optional background track
/// - Smooth animations
///
/// Example:
/// ```dart
/// AppProgressBar(
///   value: 0.75, // 75%
///   color: AppProgressColor.success,
///   label: '75% Occupied',
/// )
///
/// AppProgressBar(
///   value: 0.93,
///   color: AppProgressColor.success,
///   showPercentage: true,
/// )
/// ```
class AppProgressBar extends StatelessWidget {
  /// Progress value between 0.0 and 1.0
  final double value;

  /// Color type for semantic meaning
  final AppProgressColor color;

  /// Visual style variant
  final AppProgressVariant variant;

  /// Optional label text to display
  final String? label;

  /// Show percentage label automatically
  final bool showPercentage;

  /// Height of the progress bar (for linear variants)
  final double? height;

  /// Background color for the track
  final Color? trackColor;

  /// Show animation on value change
  final bool animate;

  /// Duration of animation
  final Duration animationDuration;

  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppProgressColor.primary,
    this.variant = AppProgressVariant.linear,
    this.label,
    this.showPercentage = false,
    this.height,
    this.trackColor,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = value.clamp(0.0, 1.0);
    final effectiveColor = _getColor(context);
    final effectiveHeight = height ?? _getDefaultHeight();
    final displayLabel = label ?? (showPercentage ? '${(effectiveValue * 100).toInt()}%' : null);

    if (variant == AppProgressVariant.circular) {
      return _buildCircular(context, effectiveValue, effectiveColor);
    }

    final Widget bar = _buildLinear(context, effectiveValue, effectiveColor, effectiveHeight);

    if (displayLabel != null) {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                bar,
                if (label != null && showPercentage == false) ...[
                  const SizedBox(height: 6),
                  Text(
                    label!,
                    style: AppTextStyles.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showPercentage)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                displayLabel,
                style: AppTextStyles.labelMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
        ],
      );
    }

    return bar;
  }

  Widget _buildLinear(
    BuildContext context,
    double effectiveValue,
    Color effectiveColor,
    double effectiveHeight,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTrackColor = trackColor ??
        (isDark ? AppColors.darkSurfaceVariant : AppColors.borderLight);

    if (variant == AppProgressVariant.segmented) {
      return _buildSegmented(effectiveValue, effectiveColor, effectiveTrackColor, effectiveHeight);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveHeight / 2),
      child: Stack(
        children: [
          Container(
            height: effectiveHeight,
            decoration: BoxDecoration(
              color: effectiveTrackColor,
            ),
          ),
          if (animate)
            AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              height: effectiveHeight,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: effectiveValue,
                child: Container(
                  decoration: BoxDecoration(
                    color: effectiveColor,
                  ),
                ),
              ),
            )
          else
            FractionallySizedBox(
              widthFactor: effectiveValue,
              child: Container(
                height: effectiveHeight,
                decoration: BoxDecoration(
                  color: effectiveColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSegmented(
    double effectiveValue,
    Color effectiveColor,
    Color effectiveTrackColor,
    double effectiveHeight,
  ) {
    const segmentCount = 10;
    final filledSegments = (effectiveValue * segmentCount).floor();

    return Row(
      children: List.generate(segmentCount, (index) {
        final isFilled = index < filledSegments;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < segmentCount - 1 ? 4 : 0),
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              height: effectiveHeight,
              decoration: BoxDecoration(
                color: isFilled ? effectiveColor : effectiveTrackColor,
                borderRadius: BorderRadius.circular(effectiveHeight / 2),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCircular(
    BuildContext context,
    double effectiveValue,
    Color effectiveColor,
  ) {
    return SizedBox(
      width: height ?? 40,
      height: height ?? 40,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: effectiveValue,
            color: effectiveColor,
            backgroundColor: trackColor,
            strokeWidth: 4,
          ),
          if (showPercentage || label != null)
            Center(
              child: Text(
                label ?? '${(effectiveValue * 100).toInt()}%',
                style: AppTextStyles.labelSmall?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getDefaultHeight() {
    return switch (variant) {
      AppProgressVariant.thin => 4,
      AppProgressVariant.segmented => 6,
      AppProgressVariant.circular => 40,
      _ => 8,
    };
  }

  Color _getColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (color) {
      AppProgressColor.primary => Theme.of(context).colorScheme.primary,
      AppProgressColor.success => isDark ? AppColors.successLight : AppColors.success,
      AppProgressColor.warning => isDark ? AppColors.warningLight : AppColors.warning,
      AppProgressColor.danger => isDark ? AppColors.dangerLight : AppColors.danger,
      AppProgressColor.neutral => isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
    };
  }
}

/// Occupancy bar specifically for property occupancy display.
/// Shows progress with semantic color based on occupancy level.
class AppOccupancyBar extends StatelessWidget {
  final double occupancy; // 0.0 to 1.0
  final String? label;
  final bool showPercentage;

  const AppOccupancyBar({
    super.key,
    required this.occupancy,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on occupancy level
    final color = switch (occupancy) {
      >= 0.8 => AppProgressColor.success, // High occupancy - good
      >= 0.5 => AppProgressColor.warning, // Medium occupancy
      _ => AppProgressColor.danger, // Low occupancy - concerning
    };

    return AppProgressBar(
      value: occupancy,
      color: color,
      label: label,
      showPercentage: showPercentage,
    );
  }
}
