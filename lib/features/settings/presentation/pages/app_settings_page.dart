import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:estate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Theme, language, alerts, privacy, and account deletion.
class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({
    super.key,
    this.routePrefix = '/more/profile/settings',
  });

  final String routePrefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(appThemeProvider);
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          AppSectionCard(
            title: l10n.themeSectionTitle,
            children: [
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (modes) =>
                    ref.read(appThemeProvider.notifier).state = modes.first,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            title: l10n.language,
            contentPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: RadioGroup<String>(
              groupValue: locale?.languageCode ?? '',
              onChanged: (code) => ref.read(appLocaleProvider.notifier).state =
                  code == null || code.isEmpty ? null : Locale(code),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: '',
                    title: Text(l10n.languageSystem),
                    subtitle: Text(l10n.settingsLanguageSystemDesc),
                  ),
                  RadioListTile<String>(
                    value: 'en',
                    title: Text(l10n.settingsLanguageEnglish),
                  ),
                  RadioListTile<String>(
                    value: 'hi',
                    title: Text(l10n.settingsLanguageHindi),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.settingsAlertsTitle,
            children: [
              LinkRow(
                icon: Icons.notifications_none_rounded,
                title: l10n.settingsNotificationPrefs,
                onTap: () => context.push('$routePrefix/notifications'),
              ),
              LinkRow(
                icon: Icons.shield_outlined,
                title: l10n.settingsPrivacy,
                onTap: () => context.push('$routePrefix/privacy'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.moreSectionAccount,
            children: [
              LinkRow(
                icon: Icons.delete_outline_rounded,
                title: l10n.settingsDeleteAccount,
                subtitle: l10n.settingsDeleteAccountDesc,
                destructive: true,
                onTap: () => context.push('$routePrefix/delete-account'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
