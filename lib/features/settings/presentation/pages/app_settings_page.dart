import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.settingsTitle ?? 'Settings'),
      ),
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Appearance Section
          _SettingsSection(
            title: context.l10n?.themeSectionTitle ?? 'Appearance',
            children: [
              _ThemeModeTile(
                currentMode: themeMode,
                onTap: (mode) {
                  ref.read(appThemeProvider.notifier).state = mode;
                },
              ),
              _LanguageTile(
                currentLocale: appLocale,
                onTap: (locale) {
                  ref.read(appLocaleProvider.notifier).state = locale;
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          _SettingsSection(
            title: context.l10n?.notificationsSection ?? 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: context.l10n?.notificationPreferences ?? 'Notification Preferences',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('$routePrefix/notifications'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Privacy Section
          _SettingsSection(
            title: context.l10n?.privacySection ?? 'Privacy',
            children: [
              _SettingsTile(
                icon: Icons.lock_outlined,
                label: context.l10n?.privacySettings ?? 'Privacy Settings',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('$routePrefix/privacy'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Storage & Data Section
          _SettingsSection(
            title: context.l10n?.storageSection ?? 'Storage & Data',
            children: [
              _SettingsTile(
                icon: Icons.cleaning_services_outlined,
                label: context.l10n?.clearCache ?? 'Clear Cache',
                onTap: () => _showClearCacheDialog(context),
              ),
              _SettingsTile(
                icon: Icons.download_outlined,
                label: context.l10n?.downloadMyData ?? 'Download My Data',
                onTap: () => _showDownloadDataDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.currentMode,
    required this.onTap,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (currentMode) {
      ThemeMode.light => context.l10n?.themeLight ?? 'Light',
      ThemeMode.dark => context.l10n?.themeDark ?? 'Dark',
      ThemeMode.system => context.l10n?.themeSystem ?? 'System',
    };

    return _SettingsTile(
      icon: Icons.palette_outlined,
      label: context.l10n?.themeMode ?? 'Theme Mode',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: () => onTap(currentMode),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.currentLocale,
    required this.onTap,
  });

  final Locale? currentLocale;
  final ValueChanged<Locale?> onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (currentLocale?.languageCode) {
      'en' => context.l10n?.languageEnglish ?? 'English',
      'hi' => context.l10n?.languageHindi ?? 'Hindi',
      _ => context.l10n?.languageSystem ?? 'System default',
    };

    return _SettingsTile(
      icon: Icons.language_outlined,
      label: context.l10n?.language ?? 'Language',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: () => onTap(currentLocale),
    );
  }
}
