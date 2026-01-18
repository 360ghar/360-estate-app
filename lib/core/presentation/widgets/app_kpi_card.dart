import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Trend direction for KPI metrics.
enum AppKpiTrendDirection {
  up,
  down,
  flat,
  neutral,
}

/// KPI card variant for different display styles.
enum AppKpiVariant {
  /// Standard card with icon, value, and label
  standard,

  /// Compact version for smaller spaces
  compact,

  /// Prominent version for key metrics
  prominent,

  /// Minimal version with just value and label
  minimal,
}

/// Trend data for KPI display.
class AppKpiTrend {
  final double value;
  final AppKpiTrendDirection direction;
  final String? label;

  const AppKpiTrend({
    required this.value,
    required this.direction,
    this.label,
  });

  factory AppKpiTrend.positive(double percent, {String? label}) {
    return AppKpiTrend(value: percent, direction: AppKpiTrendDirection.up, label: label);
  }

  factory AppKpiTrend.negative(double percent, {String? label}) {
    return AppKpiTrend(value: percent, direction: AppKpiTrendDirection.down, label: label);
  }

  factory AppKpiTrend.neutral({String? label}) {
    return AppKpiTrend(value: 0, direction: AppKpiTrendDirection.flat, label: label);
  }
}

/// KPI (Key Performance Indicator) card for dashboard metrics.
///
/// Displays a metric with:
/// - Icon or leading widget
/// - Large value with optional currency formatting
/// - Label/title
/// - Optional trend indicator (up/down percentage)
/// - Optional subtitle
/// - Tap handler for navigation
///
/// Example:
/// ```dart
/// AppKpiCard(
///   title: 'Total Collected',
///   value: '₹2,45,000',
///   trend: AppKpiTrend.positive(12.5),
///   icon: Icons.currency_rupee,
///   onTap: () => navigateToCollections(),
/// )
/// ```
class AppKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final AppKpiTrend? trend;
  final IconData? icon;
  final Widget? leading;
  final AppKpiVariant variant;
  final VoidCallback? onTap;
  final Color? valueColor;
  final bool isLoading;

  const AppKpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.icon,
    this.leading,
    this.variant = AppKpiVariant.standard,
    this.onTap,
    this.valueColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveLeading = leading ??
        (icon != null
            ? _buildIcon(context, isDark)
            : null);

    Widget card = _buildContent(context, effectiveLeading, isDark);

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.md,
          child: card,
        ),
      );
    }

    return card;
  }

  Widget _buildIcon(BuildContext context, bool isDark) {
    return Container(
      width: _getIconSize(),
      height: _getIconSize(),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryLight.withOpacity(0.2)
            : AppColors.primarySoft,
        borderRadius: switch (variant) {
          AppKpiVariant.prominent => AppRadii.md,
          _ => AppRadii.sm,
        },
      ),
      child: Icon(
        icon,
        size: _getIconSize() * 0.5,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
      ),
    );
  }

  double _getIconSize() {
    return switch (variant) {
      AppKpiVariant.compact => 32,
      AppKpiVariant.minimal => 0,
      _ => 40,
    };
  }

  Widget _buildContent(BuildContext context, Widget? leadingWidget, bool isDark) {
    final padding = switch (variant) {
      AppKpiVariant.compact => const EdgeInsets.all(12),
      AppKpiVariant.minimal => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      _ => const EdgeInsets.all(16),
    };
    final showLeadingRow = variant != AppKpiVariant.minimal && leadingWidget != null;
    final showInlineTrend = trend != null && !showLeadingRow && variant != AppKpiVariant.minimal;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.border,
          width: 0.5,
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLeadingRow)
            Row(
              children: [
                leadingWidget,
                const Spacer(),
                if (trend != null) _buildTrend(context, isDark),
              ],
            ),
          if (showLeadingRow) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (variant != AppKpiVariant.compact && variant != AppKpiVariant.minimal)
                      const SizedBox(height: 4),
                    if (variant == AppKpiVariant.compact) const SizedBox(height: 6),
                    if (isLoading)
                      SizedBox(
                        height: _getValueFontSize(),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    else
                      Text(
                        value,
                        style: _getValueStyle(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (subtitle != null && variant != AppKpiVariant.compact) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (showInlineTrend)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildTrend(context, isDark),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrend(BuildContext context, bool isDark) {
    if (trend == null) return const SizedBox.shrink();

    final trendData = trend!;
    final trendColor = switch (trendData.direction) {
      AppKpiTrendDirection.up => AppColors.success,
      AppKpiTrendDirection.down => AppColors.danger,
      AppKpiTrendDirection.flat => AppColors.textSecondary,
      AppKpiTrendDirection.neutral => AppColors.textSecondary,
    };

    final icon = switch (trendData.direction) {
      AppKpiTrendDirection.up => Icons.arrow_upward_rounded,
      AppKpiTrendDirection.down => Icons.arrow_downward_rounded,
      AppKpiTrendDirection.flat => Icons.remove_rounded,
      AppKpiTrendDirection.neutral => Icons.remove_rounded,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: trendColor,
        ),
        const SizedBox(width: 2),
        Text(
          '${trendData.value.abs().toStringAsFixed(1)}%',
          style: AppTextStyles.labelSmall?.copyWith(
            color: trendColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  double _getValueFontSize() {
    return switch (variant) {
      AppKpiVariant.prominent => 28,
      AppKpiVariant.compact => 20,
      AppKpiVariant.minimal => 16,
      _ => 24,
    };
  }

  TextStyle _getValueStyle(BuildContext context) {
    final fontSize = _getValueFontSize();
    final defaultColor = valueColor ?? Theme.of(context).colorScheme.onSurface;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 1.15,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: defaultColor,
    );
  }
}
