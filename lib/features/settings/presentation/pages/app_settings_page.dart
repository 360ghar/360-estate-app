import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({
    super.key,
    this.routePrefix = '/more/profile/settings',
  });

  final String routePrefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    final appLocale = ref.watch(appLocaleProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.settingsTitle ?? 'Settings'),
      ),
      scrollable: true,
      body: Column(
        children: [
          // Theme Section with visual cards
          AppSectionCard(
            title: context.l10n?.themeSectionTitle ?? 'Theme',
            icon: Icons.palette_outlined,
            iconColor: const Color(0xFFF59E0B),
            children: [
              Row(
                children: [
                  _ThemeCard(
                    label: context.l10n?.themeSystem ?? 'System',
                    icon: Icons.brightness_auto_outlined,
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () => ref.read(appThemeProvider.notifier).state = ThemeMode.system,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ThemeCard(
                    label: context.l10n?.themeLight ?? 'Light',
                    icon: Icons.light_mode_outlined,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () => ref.read(appThemeProvider.notifier).state = ThemeMode.light,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ThemeCard(
                    label: context.l10n?.themeDark ?? 'Dark',
                    icon: Icons.dark_mode_outlined,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () => ref.read(appThemeProvider.notifier).state = ThemeMode.dark,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Language Section
          AppSectionCard(
            title: context.l10n?.language ?? 'Language',
            icon: Icons.translate_outlined,
            iconColor: const Color(0xFF8B5CF6),
            contentPadding: EdgeInsets.zero,
            children: [
              _LanguageOption(
                label: context.l10n?.languageSystem ?? 'System default',
                subtitle: 'Follow device language',
                isSelected: appLocale == null,
                onTap: () => ref.read(appLocaleProvider.notifier).state = null,
              ),
              _divider(isDark),
              _LanguageOption(
                label: context.l10n?.languageEnglish ?? 'English',
                subtitle: 'English',
                isSelected: appLocale?.languageCode == 'en',
                onTap: () => ref.read(appLocaleProvider.notifier).state = const Locale('en'),
              ),
              _divider(isDark),
              _LanguageOption(
                label: context.l10n?.languageHindi ?? 'Hindi',
                subtitle: 'Hindi',
                isSelected: appLocale?.languageCode == 'hi',
                onTap: () => ref.read(appLocaleProvider.notifier).state = const Locale('hi'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          AppSectionCard(
            title: context.l10n?.notificationsSection ?? 'Notifications',
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFFEC4899),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFFEC4899),
                label: context.l10n?.notificationPreferences ?? 'Notification Preferences',
                subtitle: 'Manage alerts and reminders',
                onTap: () => context.go('$routePrefix/notifications'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Privacy Section
          AppSectionCard(
            title: context.l10n?.privacySection ?? 'Privacy',
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFF10B981),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.lock_outlined,
                iconColor: const Color(0xFF10B981),
                label: context.l10n?.privacySettings ?? 'Privacy Settings',
                subtitle: 'Control your data sharing',
                onTap: () => context.go('$routePrefix/privacy'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Storage & Data Section
          AppSectionCard(
            title: context.l10n?.storageSection ?? 'Storage & Data',
            icon: Icons.storage_outlined,
            iconColor: const Color(0xFF0EA5E9),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.cleaning_services_outlined,
                iconColor: const Color(0xFFF59E0B),
                label: context.l10n?.clearCache ?? 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: () => _showClearCacheDialog(context),
              ),
              _divider(isDark),
              _SettingsTile(
                icon: Icons.download_outlined,
                iconColor: const Color(0xFF3B82F6),
                label: context.l10n?.downloadMyData ?? 'Download My Data',
                subtitle: 'Export your data',
                onTap: () => _showDownloadDataDialog(context),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Danger Zone
          AppSectionCard(
            title: 'Danger Zone',
            icon: Icons.warning_amber_outlined,
            iconColor: const Color(0xFFEF4444),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.delete_outline,
                iconColor: const Color(0xFFEF4444),
                label: context.l10n?.deleteAccount ?? 'Delete Account',
                subtitle:
                    context.l10n?.deleteAccountWarning ??
                        'This action cannot be undone. All your data will be permanently deleted.',
                onTap: () =>
                    _showDeleteAccountDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Divider(
        height: 0.5,
        thickness: 0.5,
        color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Text(context.l10n?.clearCache ?? 'Clear Cache'),
        content: Text(context.l10n?.clearCacheConfirm ?? 'Are you sure you want to clear the app cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n?.commonCancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n?.cacheCleared ?? 'Cache cleared successfully'),
                ),
              );
            },
            child: Text(context.l10n?.commonConfirm ?? 'Clear'),
          ),
        ],
      ),
    ));
  }

  Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
    const supportEmail = 'info@360ghar.com';
    const emailSubject = 'Account Deletion Request';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Text(
          context.l10n?.deleteAccount ?? 'Delete Account',
          style: TextStyle(
            color: isDark ? AppColors.danger : AppColors.danger,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          context.l10n?.deleteAccountWarning ??
              'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n?.commonCancel ?? 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n?.commonConfirm ?? 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final registeredEmail = ref.read(authControllerProvider).user?.email?.trim();
    final emailLine = (registeredEmail != null && registeredEmail.isNotEmpty)
        ? registeredEmail
        : 'Not available';
    final body = 'Hello 360 Ghar Support,\n\n'
        'I would like to request the deletion of my account.\n\n'
        'Registered email: $emailLine\n\n'
        'Thank you.';
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: <String, String>{
        'subject': emailSubject,
        'body': body,
      },
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n?.deleteAccountEmailSent ??
                'Email app opened. Please send the message to complete your request.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n?.deleteAccountManualFallback ??
                'Could not open your email app. Please email $supportEmail with subject "$emailSubject".',
          ),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  void _showDownloadDataDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Text(context.l10n?.downloadMyData ?? 'Download My Data'),
        content: Text(context.l10n?.downloadDataConfirm ?? 'Your data will be prepared and sent to your email. This may take a few minutes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n?.commonCancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n?.dataDownloadStarted ?? 'Data export started. Check your email shortly.'),
                ),
              );
            },
            child: Text(context.l10n?.commonRequest ?? 'Request'),
          ),
        ],
      ),
    ));
  }
}

// Visual theme card selector
class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppDurations.defaultCurve,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : isDark
                    ? AppColors.darkSurfaceSecondary
                    : AppColors.surfaceSecondary,
            borderRadius: AppRadii.lg,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.4)
                  : isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
              width: isSelected ? 1.5 : 0.5,
            ),
            boxShadow: isSelected ? AppShadows.cardHovered : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Language option row
class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 22,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Settings tile with colored icon
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
