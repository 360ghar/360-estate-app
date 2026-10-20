import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which alerts the user wants. Push is not wired yet (see
/// docs/unimplemented-features.md), so the page says the choices are saved on
/// this phone.
class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final prefs = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);
    final all = prefs['notificationsEnabled'] ?? true;

    Widget toggle(String key, String title, String subtitle, {bool? enabled}) {
      final on = enabled ?? all;
      return SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: prefs[key] ?? false,
        onChanged: on ? (v) => notifier.setPreference(key, v) : null,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsNotificationPrefs)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            l10n.notifPrefsNote,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LinkGroup(
            children: [
              toggle(
                'notificationsEnabled',
                l10n.notifPrefsAllTitle,
                l10n.notifPrefsAllDesc,
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.notifPrefsAlertsTitle,
            dividerIndent: AppSpacing.lg,
            children: [
              toggle(
                'rentRemindersEnabled',
                l10n.notifPrefRent,
                l10n.rentRemindersDesc,
              ),
              toggle(
                'paymentAlertsEnabled',
                l10n.notifPrefPayments,
                l10n.paymentAlertsDesc,
              ),
              toggle(
                'leaseExpiryAlertsEnabled',
                l10n.notifPrefLeases,
                l10n.leaseExpiryAlertsDesc,
              ),
              toggle(
                'maintenanceAlertsEnabled',
                l10n.notifPrefMaintenance,
                l10n.maintenanceAlertsDesc,
              ),
              toggle(
                'inspectionRemindersEnabled',
                l10n.notifPrefInspections,
                l10n.inspectionRemindersDesc,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.notifPrefsEmailTitle,
            children: [
              toggle(
                'marketingEmailsEnabled',
                l10n.notifPrefMarketing,
                l10n.marketingEmailsDesc,
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Notification preferences provider, persisted through AppPreferences so
// toggles survive app restarts (they previously lived only in memory).
final notificationPreferencesProvider =
    StateNotifierProvider<NotificationPreferencesNotifier, Map<String, bool>>(
      (ref) =>
          NotificationPreferencesNotifier(ref.read(appPreferencesProvider)),
    );

class NotificationPreferencesNotifier extends StateNotifier<Map<String, bool>> {
  NotificationPreferencesNotifier(this._prefs) : super(_loadInitial(_prefs));

  final AppPreferences _prefs;

  static const Map<String, bool> _defaults = {
    'notificationsEnabled': true,
    'rentRemindersEnabled': true,
    'paymentAlertsEnabled': true,
    'leaseExpiryAlertsEnabled': true,
    'maintenanceAlertsEnabled': true,
    'inspectionRemindersEnabled': true,
    'marketingEmailsEnabled': false,
  };

  /// Maps the UI-facing preference key to its persisted [PrefKeys] entry.
  static const Map<String, String> _prefKeys = {
    'notificationsEnabled': PrefKeys.notificationsEnabled,
    'rentRemindersEnabled': PrefKeys.rentRemindersEnabled,
    'paymentAlertsEnabled': PrefKeys.paymentAlertsEnabled,
    'leaseExpiryAlertsEnabled': PrefKeys.leaseExpiryAlertsEnabled,
    'maintenanceAlertsEnabled': PrefKeys.maintenanceAlertsEnabled,
    'inspectionRemindersEnabled': PrefKeys.inspectionRemindersEnabled,
    'marketingEmailsEnabled': PrefKeys.marketingEmailsEnabled,
  };

  static Map<String, bool> _loadInitial(AppPreferences prefs) {
    return _defaults.map(
      (key, fallback) =>
          MapEntry(key, prefs.getBool(_prefKeys[key]!) ?? fallback),
    );
  }

  void setPreference(String key, bool value) {
    state = {...state, key: value};
    final prefKey = _prefKeys[key];
    if (prefKey != null) {
      // Fire-and-forget: SharedPreferences writes are queued internally; a
      // failed write is non-fatal for a settings toggle.
      unawaited(_prefs.setBool(prefKey, value));
    }
  }
}
