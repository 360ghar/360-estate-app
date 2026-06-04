import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
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
/// - Icon or leading widget with gradient background
/// - Large value with optional currency formatting
/// - Label/title
/// - Optional trend indicator (up/down percentage)
/// - Optional subtitle
/// - Tap handler with scale feedback
/// - Colored left accent border
///
/// Example:
/// ```dart
/// AppKpiCard(
///   title: 'Total Collected',
///   value: '₹2,45,000',
///   trend: AppKpiTrend.positive(12.5),
///   icon: Icons.currency_rupee,
///   accentColor: AppColors.success,
///   onTap: () => navigateToCollections(),
/// )
/// ```
class AppKpiCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final AppKpiTrend? trend;
  final IconData? icon;
  final Widget? leading;
  final AppKpiVariant variant;
  final VoidCallback? onTap;
  final Color? valueColor;
  final Color? accentColor;
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
    this.accentColor,
    this.isLoading = false,
  });

  @override
  State<AppKpiCard> createState() => _AppKpiCardState();
}

class _AppKpiCardState extends State<AppKpiCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: AppDurations.pressCurve),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveLeading = widget.leading ??
        (widget.icon != null ? _buildIcon(context, isDark) : null);

    Widget card = _buildContent(context, effectiveLeading, isDark);

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: card,
        ),
      );
    }

    return card;
  }

  Widget _buildIcon(BuildContext context, bool isDark) {
    final iconSize = _getIconSize();
    final color = widget.accentColor ?? AppColors.primary;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.15),
                ]
              : [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.06),
                ],
        ),
        borderRadius: switch (widget.variant) {
          AppKpiVariant.prominent => AppRadii.md,
          _ => AppRadii.sm,
        },
      ),
      child: Icon(
        widget.icon,
        size: iconSize * 0.5,
        color: isDark ? color.withValues(alpha: 0.9) : color,
      ),
    );
  }

  double _getIconSize() {
    return switch (widget.variant) {
      AppKpiVariant.compact => 32,
      AppKpiVariant.minimal => 0,
      _ => 40,
    };
  }

  Widget _buildContent(BuildContext context, Widget? leadingWidget, bool isDark) {
    final padding = switch (widget.variant) {
      AppKpiVariant.compact => const EdgeInsets.all(12),
      AppKpiVariant.minimal => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      _ => const EdgeInsets.all(16),
    };
    final showLeadingRow =
        widget.variant != AppKpiVariant.minimal && leadingWidget != null;
    final showInlineTrend = widget.trend != null &&
        !showLeadingRow &&
        widget.variant != AppKpiVariant.minimal;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored left accent border
            if (widget.accentColor != null)
              Container(
                width: 3,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: AppRadii.pill,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showLeadingRow)
                    Row(
                      children: [
                        leadingWidget,
                        const Spacer(),
                        if (widget.trend != null) _buildTrend(context, isDark),
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
                              widget.title,
                              style: AppTextStyles.labelMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.variant != AppKpiVariant.compact &&
                                widget.variant != AppKpiVariant.minimal)
                              const SizedBox(height: 4),
                            if (widget.variant == AppKpiVariant.compact)
                              const SizedBox(height: 6),
                            if (widget.isLoading)
                              SizedBox(
                                height: _getValueFontSize(),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Text(
                                widget.value,
                                style: _getValueStyle(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (widget.subtitle != null &&
                                widget.variant != AppKpiVariant.compact) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                style: AppTextStyles.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrend(BuildContext context, bool isDark) {
    if (widget.trend == null) return const SizedBox.shrink();

    final trendData = widget.trend!;
    final trendColor = switch (trendData.direction) {
      AppKpiTrendDirection.up => AppColors.success,
      AppKpiTrendDirection.down => AppColors.danger,
      AppKpiTrendDirection.flat => AppColors.textSecondary,
      AppKpiTrendDirection.neutral => AppColors.textSecondary,
    };

    final trendIcon = switch (trendData.direction) {
      AppKpiTrendDirection.up => Icons.trending_up_rounded,
      AppKpiTrendDirection.down => Icons.trending_down_rounded,
      AppKpiTrendDirection.flat => Icons.trending_flat_rounded,
      AppKpiTrendDirection.neutral => Icons.trending_flat_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadii.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trendIcon, size: 14, color: trendColor),
          const SizedBox(width: 2),
          Text(
            '${trendData.value.abs().toStringAsFixed(1)}%',
            style: AppTextStyles.labelSmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _getValueFontSize() {
    return switch (widget.variant) {
      AppKpiVariant.prominent => 28,
      AppKpiVariant.compact => 20,
      AppKpiVariant.minimal => 16,
      _ => 24,
    };
  }

  TextStyle _getValueStyle(BuildContext context) {
    final fontSize = _getValueFontSize();
    final defaultColor = widget.valueColor ?? Theme.of(context).colorScheme.onSurface;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      height: 1.15,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: defaultColor,
    );
  }
}
