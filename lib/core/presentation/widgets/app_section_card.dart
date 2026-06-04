import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

/// A grouped card container for form sections and detail page sections.
///
/// Provides consistent visual grouping with:
/// - Optional title row with icon and label
/// - Optional divider below title
/// - Padded content area
///
/// Example:
/// ```dart
/// AppSectionCard(
///   title: 'Personal Information',
///   icon: Icons.person_outline,
///   children: [
///     AppTextField(label: 'Name'),
///     AppTextField(label: 'Email'),
///   ],
/// )
/// ```
class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.trailing,
    this.contentPadding = const EdgeInsets.all(AppSpacing.lg),
    this.children = const [],
    this.child,
  });

  /// Section title displayed in the header
  final String? title;

  /// Leading icon in the header
  final IconData? icon;

  /// Color for the icon background circle
  final Color? iconColor;

  /// Optional trailing widget in the header (e.g., action button)
  final Widget? trailing;

  /// Padding applied to the content area
  final EdgeInsetsGeometry contentPadding;

  /// Content widgets displayed in a Column
  final List<Widget> children;

  /// Single child widget (alternative to [children])
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final hasHeader = title != null;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (iconColor ?? scheme.primary).withValues(alpha: 
                          isDark ? 0.15 : 0.08,
                        ),
                        borderRadius: AppRadii.sm,
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: iconColor ?? scheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      title!,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            ),
          ],
          Padding(
            padding: contentPadding,
            child: child ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
          ),
        ],
      ),
    );
  }
}
