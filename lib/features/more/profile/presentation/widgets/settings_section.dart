import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

/// A reusable section widget with a title and a list of settings tiles
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    this.tiles,
    this.children,
    this.isDanger = false,
  });

  final String title;
  final List<SettingsTile>? tiles;
  final List<Widget>? children;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final items = children ?? tiles ?? <Widget>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDanger
                      ? AppColors.danger
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
        ),

        // Section content
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: AppRadii.md,
            border: Border.all(
              color: isDanger
                  ? AppColors.danger.withOpacity(0.3)
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final isLast = index == items.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : AppSpacing.xs,
                ),
                child: items[index],
              );
            }),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Individual settings tile with icon, label, and trailing widget
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.showTrailing = true,
    this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final bool showTrailing;
  final VoidCallback? onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final iconColor = isDanger
        ? AppColors.danger
        : Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: isDanger ? AppColors.danger : null,
          fontSize: 15,
        ),
      ),
      subtitle: value != null
          ? Text(
              value!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: trailing ??
          (showTrailing
              ? Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDanger
                      ? AppColors.danger
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                )
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.sm,
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border(
    //       bottom: BorderSide(
    //         color: Theme.of(context).colorScheme.outlineVariant,
    //         width: 0.5,
    //       ),
    //     ),
    //   ),
    //   child: ListTile(
    //     leading: Icon(icon, color: iconColor, size: 22),
    //     title: Text(label, style: TextStyle(color: isDanger ? AppColors.danger : null)),
    //     subtitle: value != null
    //         ? Text(
    //             value!,
    //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
    //                   color: Theme.of(context).colorScheme.onSurfaceVariant,
    //                 ),
    //           )
    //         : null,
    //     trailing: trailing ??
    //         (showTrailing
    //             ? Icon(
    //                 Icons.chevron_right,
    //                 size: 20,
    //                 color: isDanger
    //                     ? AppColors.danger
    //                     : Theme.of(context).colorScheme.onSurfaceVariant,
    //               )
    //             : null),
    //     onTap: onTap,
    //     contentPadding: const EdgeInsets.symmetric(
    //       horizontal: AppSpacing.md,
    //       vertical: AppSpacing.xs,
    //     ),
    //   ),
    // );
  }
}

/// Settings tile with a switch toggle
class SettingsTileWithSwitch extends StatelessWidget {
  const SettingsTileWithSwitch({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.onChanged,
    this.isEnabled = true,
  });

  final IconData icon;
  final String label;
  final bool value;
  final String? subtitle;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(label),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: isEnabled ? onChanged : null,
      ),
      onTap: isEnabled ? () => onChanged?.call(!value) : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
