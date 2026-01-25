import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Segmented button style options.
enum AppSegmentedStyle {
  /// Pill-shaped segments (fully rounded)
  pill,

  /// Rectangular with small radius
  rect,

  /// Underline style (like tabs)
  underline,
}

/// Segment definition for segmented button.
class AppSegment<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Widget? child;

  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
    this.child,
  });
}

/// Segmented button for mutually exclusive selection.
///
/// Use for:
/// - View toggles (List/Grid)
/// - Status filters
/// - Tab alternatives
/// - Settings toggles
///
/// Example:
/// ```dart
/// AppSegmentedButton<ViewMode>(
///   segments: [
///     AppSegment(value: ViewMode.list, label: 'List', icon: Icons.list),
///     AppSegment(value: ViewMode.grid, label: 'Grid', icon: Icons.grid_view),
///   ],
///   selected: viewMode,
///   onSelected: (mode) => setState(() => viewMode = mode),
/// )
/// ```
class AppSegmentedButton<T> extends StatelessWidget {
  final List<AppSegment<T>> segments;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final AppSegmentedStyle style;
  final bool fullWidth;

  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
    this.style = AppSegmentedStyle.pill,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();

    if (style == AppSegmentedStyle.underline) {
      return _buildUnderline(context);
    }

    return _buildSegmented(context);
  }

  Widget _buildSegmented(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width per segment
        final availableWidth = fullWidth ? constraints.maxWidth : null;
        final segmentWidth = availableWidth != null
            ? (availableWidth - (segments.length - 1)) / segments.length
            : null;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.borderLight,
            borderRadius: switch (style) {
              AppSegmentedStyle.pill => AppRadii.pill,
              AppSegmentedStyle.rect => AppRadii.md,
              AppSegmentedStyle.underline => AppRadii.md,
            },
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              for (int i = 0; i < segments.length; i++) ...[
                if (i > 0)
                  Container(
                    width: 1,
                    height: switch (style) {
                      AppSegmentedStyle.pill => 24,
                      AppSegmentedStyle.rect => 20,
                      AppSegmentedStyle.underline => 0,
                    },
                    margin: switch (style) {
                      AppSegmentedStyle.pill => const EdgeInsets.symmetric(horizontal: 2),
                      AppSegmentedStyle.rect => const EdgeInsets.symmetric(horizontal: 1),
                      AppSegmentedStyle.underline => EdgeInsets.zero,
                    },
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                fullWidth
                    ? Expanded(
                        child: _SegmentItem<T>(
                          segment: segments[i],
                          isSelected: segments[i].value == selected,
                          style: style,
                          width: segmentWidth,
                          onTap: () => onSelected(segments[i].value),
                        ),
                      )
                    : _SegmentItem<T>(
                        segment: segments[i],
                        isSelected: segments[i].value == selected,
                        style: style,
                        width: segmentWidth,
                        onTap: () => onSelected(segments[i].value),
                      ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnderline(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < segments.length; i++)
          _UnderlineSegmentItem<T>(
            segment: segments[i],
            isSelected: segments[i].value == selected,
            onTap: () => onSelected(segments[i].value),
          ),
      ],
    );
  }
}

class _SegmentItem<T> extends StatelessWidget {
  final AppSegment<T> segment;
  final bool isSelected;
  final AppSegmentedStyle style;
  final double? width;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.segment,
    required this.isSelected,
    required this.style,
    this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? (isDark ? AppColors.primaryLight : AppColors.primary)
        : Colors.transparent;
    final foregroundColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final borderRadius = switch (style) {
      AppSegmentedStyle.pill => AppRadii.pill,
      AppSegmentedStyle.rect => AppRadii.md,
      AppSegmentedStyle.underline => AppRadii.md,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (segment.icon != null) ...[
              Icon(
                segment.icon,
                size: 18,
                color: foregroundColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              segment.label,
              style: AppTextStyles.labelMedium?.copyWith(
                color: foregroundColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    return switch (style) {
      AppSegmentedStyle.pill => const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      AppSegmentedStyle.rect => const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
      AppSegmentedStyle.underline => const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
    };
  }
}

class _UnderlineSegmentItem<T> extends StatelessWidget {
  final AppSegment<T> segment;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnderlineSegmentItem({
    required this.segment,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final textColor = isSelected
        ? scheme.primary
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (segment.icon != null) ...[
                  Icon(
                    segment.icon,
                    size: 18,
                    color: textColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  segment.label,
                  style: AppTextStyles.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: isSelected ? 2 : 0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: AppRadii.xs,
            ),
          ),
        ],
      ),
    );
  }
}
