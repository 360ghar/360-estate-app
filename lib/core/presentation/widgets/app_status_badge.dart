import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Semantic status types for consistent color usage across the app.
/// Colors are used ONLY for status communication, not decoration.
enum AppStatusType {
  /// Success state - Paid, Completed, Active, Approved
  success,

  /// Warning state - Due, Pending, Expiring
  warning,

  /// Danger state - Overdue, Critical, Rejected, Failed
  danger,

  /// Info state - Information, Notes, Neutral
  info,

  /// Neutral state - Default, Disabled
  neutral,
}

/// Status badge variant for different visual styles.
enum AppStatusVariant {
  /// Filled background with contrasting text
  filled,

  /// Outlined with colored border and text
  outline,

  /// Subtle background with tinted text
  subtle,

  /// Small dot indicator with text label
  dot,
}

/// Color-coded status badge for semantic status display.
///
/// Used for payment status, task status, property status, etc.
/// Colors follow semantic meaning:
/// - Green (Success): Paid, Completed, Active
/// - Orange (Warning): Due, Pending, Expiring
/// - Red (Danger): Overdue, Critical, Rejected
/// - Blue (Info): Information, Notes
/// - Gray (Neutral): Default, Disabled
///
/// Example:
/// ```dart
/// AppStatusBadge(
///   label: 'PAID',
///   type: AppStatusType.success,
/// )
///
/// AppStatusBadge(
///   label: 'OVERDUE',
///   type: AppStatusType.danger,
///   variant: AppStatusVariant.outline,
/// )
/// ```
class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatusType type;
  final AppStatusVariant variant;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.variant = AppStatusVariant.filled,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final effectiveIcon = icon;

    Widget badge = Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: colors.background,
        border: variant == AppStatusVariant.outline
            ? Border.all(color: colors.foreground)
            : null,
        borderRadius: AppRadii.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (variant == AppStatusVariant.dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colors.foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (effectiveIcon != null) ...[
            Icon(effectiveIcon, size: 14, color: colors.foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.statusLabel.copyWith(
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      badge = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.pill,
          child: badge,
        ),
      );
    }

    return badge;
  }

  EdgeInsets _getPadding() {
    if (variant == AppStatusVariant.dot) {
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    }
    return switch ((variant, icon != null)) {
      (AppStatusVariant.outline, true) => const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
      (AppStatusVariant.outline, false) => const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
      (AppStatusVariant.subtle, _) => const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
      (AppStatusVariant.filled, true) => const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
      (AppStatusVariant.filled, false) => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      (AppStatusVariant.dot, _) => const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
    };
  }

  _StatusColors _getColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (type) {
      AppStatusType.success => switch (variant) {
          AppStatusVariant.filled => _StatusColors(
              background: isDark ? AppColors.successLight : AppColors.success,
              foreground: Colors.white,
            ),
          AppStatusVariant.outline => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.successLight : AppColors.success,
            ),
          AppStatusVariant.subtle => _StatusColors(
              background: isDark
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.success.withValues(alpha: 0.1),
              foreground: isDark ? AppColors.successLight : AppColors.success,
            ),
          AppStatusVariant.dot => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.successLight : AppColors.success,
            ),
        },

      AppStatusType.warning => switch (variant) {
          AppStatusVariant.filled => _StatusColors(
              background: isDark ? AppColors.warningLight : AppColors.warning,
              foreground: Colors.white,
            ),
          AppStatusVariant.outline => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.warningLight : AppColors.warning,
            ),
          AppStatusVariant.subtle => _StatusColors(
              background: isDark
                  ? AppColors.warning.withValues(alpha: 0.15)
                  : AppColors.warning.withValues(alpha: 0.1),
              foreground: isDark ? AppColors.warningLight : AppColors.warning,
            ),
          AppStatusVariant.dot => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.warningLight : AppColors.warning,
            ),
        },

      AppStatusType.danger => switch (variant) {
          AppStatusVariant.filled => _StatusColors(
              background: isDark ? AppColors.dangerLight : AppColors.danger,
              foreground: Colors.white,
            ),
          AppStatusVariant.outline => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.dangerLight : AppColors.danger,
            ),
          AppStatusVariant.subtle => _StatusColors(
              background: isDark
                  ? AppColors.danger.withValues(alpha: 0.15)
                  : AppColors.danger.withValues(alpha: 0.1),
              foreground: isDark ? AppColors.dangerLight : AppColors.danger,
            ),
          AppStatusVariant.dot => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.dangerLight : AppColors.danger,
            ),
        },

      AppStatusType.info => switch (variant) {
          AppStatusVariant.filled => _StatusColors(
              background: isDark ? AppColors.infoLight : AppColors.info,
              foreground: Colors.white,
            ),
          AppStatusVariant.outline => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.infoLight : AppColors.info,
            ),
          AppStatusVariant.subtle => _StatusColors(
              background: isDark
                  ? AppColors.info.withValues(alpha: 0.15)
                  : AppColors.info.withValues(alpha: 0.1),
              foreground: isDark ? AppColors.infoLight : AppColors.info,
            ),
          AppStatusVariant.dot => _StatusColors(
              background: Colors.transparent,
              foreground: isDark ? AppColors.infoLight : AppColors.info,
            ),
        },

      AppStatusType.neutral => switch (variant) {
          AppStatusVariant.filled => _StatusColors(
              background: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.borderLight,
              foreground: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          AppStatusVariant.outline => _StatusColors(
              background: Colors.transparent,
              foreground: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          AppStatusVariant.subtle => _StatusColors(
              background: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.borderLight,
              foreground: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          AppStatusVariant.dot => _StatusColors(
              background: Colors.transparent,
              foreground: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
        },
    };
  }
}

class _StatusColors {
  final Color background;
  final Color foreground;

  const _StatusColors({
    required this.background,
    required this.foreground,
  });
}
