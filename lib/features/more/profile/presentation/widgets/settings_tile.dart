import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

/// Simple settings tile for use in lists
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
    this.backgroundColor,
    this.contentPadding,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final bool showTrailing;
  final VoidCallback? onTap;
  final bool isDanger;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
          child: Row(
            children: [
              // Icon
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: AppSpacing.md),

              // Label and value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isDanger ? colorScheme.error : null,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        value!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing
              if (trailing != null)
                trailing!
              else if (showTrailing)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
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
    this.contentPadding,
  });

  final IconData icon;
  final String label;
  final bool value;
  final String? subtitle;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () => onChanged?.call(!value) : null,
        child: Padding(
          padding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
          child: Row(
            children: [
              // Icon
              Icon(icon, size: 22),
              const SizedBox(width: AppSpacing.md),

              // Label and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Switch
              Switch(
                value: value,
                onChanged: isEnabled ? onChanged : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
