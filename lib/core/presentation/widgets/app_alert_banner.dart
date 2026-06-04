import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Alert banner type for semantic meaning.
enum AppAlertType {
  /// Informational message
  info,

  /// Success message - operation completed
  success,

  /// Warning message - attention needed
  warning,

  /// Error message - something went wrong
  danger,
}

/// Dismissible alert/banner for notifications and messages.
///
/// Features:
/// - Color-coded by type (info, success, warning, danger)
/// - Dismissible with close button
/// - Optional action button
/// - Icon indicator
/// - Semantic colors only for status
///
/// Example:
/// ```dart
/// AppAlertBanner(
///   title: '3 Overdue Payments',
///   message: 'Action required to avoid late fees',
///   type: AppAlertType.danger,
///   actionLabel: 'View',
///   onAction: () => navigateToOverdue(),
/// )
/// ```
class AppAlertBanner extends StatelessWidget {
  final String title;
  final String? message;
  final AppAlertType type;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const AppAlertBanner({
    super.key,
    required this.title,
    this.message,
    required this.type,
    this.onAction,
    this.actionLabel,
    this.isDismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final icon = _getIcon();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    message!,
                    style: AppTextStyles.bodySmall?.copyWith(
                      color: colors.text.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                if (onAction != null && actionLabel != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onAction,
                    borderRadius: AppRadii.sm,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        actionLabel!,
                        style: AppTextStyles.labelSmall?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isDismissible)
            InkWell(
              onTap: onDismiss,
              borderRadius: AppRadii.sm,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: colors.icon,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    return switch (type) {
      AppAlertType.info => Icons.info_outline_rounded,
      AppAlertType.success => Icons.check_circle_outline_rounded,
      AppAlertType.warning => Icons.warning_amber_rounded,
      AppAlertType.danger => Icons.error_outline_rounded,
    };
  }

  _AlertColors _getColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (type) {
      AppAlertType.info => _AlertColors(
          background: isDark
              ? AppColors.info.withValues(alpha: 0.15)
              : AppColors.info.withValues(alpha: 0.1),
          border: isDark
              ? AppColors.infoLight.withValues(alpha: 0.3)
              : AppColors.info.withValues(alpha: 0.2),
          icon: isDark ? AppColors.infoLight : AppColors.info,
          text: isDark ? AppColors.infoLight : AppColors.info,
        ),

      AppAlertType.success => _AlertColors(
          background: isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.success.withValues(alpha: 0.1),
          border: isDark
              ? AppColors.successLight.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.2),
          icon: isDark ? AppColors.successLight : AppColors.success,
          text: isDark ? AppColors.successLight : AppColors.success,
        ),

      AppAlertType.warning => _AlertColors(
          background: isDark
              ? AppColors.warning.withValues(alpha: 0.15)
              : AppColors.warning.withValues(alpha: 0.1),
          border: isDark
              ? AppColors.warningLight.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.2),
          icon: isDark ? AppColors.warningLight : AppColors.warning,
          text: isDark ? AppColors.warningLight : AppColors.warning,
        ),

      AppAlertType.danger => _AlertColors(
          background: isDark
              ? AppColors.danger.withValues(alpha: 0.15)
              : AppColors.danger.withValues(alpha: 0.1),
          border: isDark
              ? AppColors.dangerLight.withValues(alpha: 0.3)
              : AppColors.danger.withValues(alpha: 0.2),
          icon: isDark ? AppColors.dangerLight : AppColors.danger,
          text: isDark ? AppColors.dangerLight : AppColors.danger,
        ),
    };
  }
}

class _AlertColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color text;

  const _AlertColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
  });
}

/// Inline alert banner that shows at the top of content.
/// Good for page-level alerts.
class AppAlertBannerInline extends StatelessWidget {
  final String title;
  final String? message;
  final AppAlertType type;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const AppAlertBannerInline({
    super.key,
    required this.title,
    this.message,
    required this.type,
    this.onAction,
    this.actionLabel,
    this.isDismissible = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDismissible && onDismiss == null) {
      return AppAlertBanner(
        title: title,
        message: message,
        type: type,
        onAction: onAction,
        actionLabel: actionLabel,
      );
    }

    return Dismissible(
      key: key ?? UniqueKey(),
      onDismissed: (_) => onDismiss?.call(),
      child: AppAlertBanner(
        title: title,
        message: message,
        type: type,
        onAction: onAction,
        actionLabel: actionLabel,
        isDismissible: isDismissible,
        onDismiss: onDismiss,
      ),
    );
  }
}
