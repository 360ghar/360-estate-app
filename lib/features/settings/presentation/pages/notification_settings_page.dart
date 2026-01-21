import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification settings page with comprehensive notification preferences
class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPreferencesProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.notificationPreferences ?? 'Notification Preferences'),
      ),
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Push Notifications Section
          _SettingsSection(
            title: context.l10n?.pushNotifications ?? 'Push Notifications',
            children: [
            SwitchListTile(
              title: Text(context.l10n?.enablePushNotifications ?? 'Enable Push Notifications'),
              subtitle: Text(context.l10n?.pushNotificationsDesc ?? 'Receive notifications on your device'),
              value: prefs['notificationsEnabled'] ?? true,
              onChanged: (value) {
                ref.read(notificationPreferencesProvider.notifier).setPreference('notificationsEnabled', value);
              },
            ),
          ]),

          // Alert Types Section
          _SettingsSection(
            title: context.l10n?.alertTypes ?? 'Alert Types',
            children: [
              SwitchListTile(
                title: Text(context.l10n?.rentReminders ?? 'Rent Due Reminders'),
                subtitle: Text(context.l10n?.rentRemindersDesc ?? 'Get reminded before rent is due'),
                value: prefs['rentRemindersEnabled'] ?? true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('rentRemindersEnabled', value);
                },
              ),
              SwitchListTile(
                title: Text(context.l10n?.paymentAlerts ?? 'Payment Received Alerts'),
                subtitle: Text(context.l10n?.paymentAlertsDesc ?? 'Know when payments are received'),
                value: prefs['paymentAlertsEnabled'] ?? true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('paymentAlertsEnabled', value);
                },
              ),
              SwitchListTile(
                title: Text(context.l10n?.leaseExpiryAlerts ?? 'Lease Expiry Alerts'),
                subtitle: Text(context.l10n?.leaseExpiryAlertsDesc ?? 'Get notified before leases expire'),
                value: prefs['leaseExpiryAlertsEnabled'] ?? true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('leaseExpiryAlertsEnabled', value);
                },
              ),
              SwitchListTile(
                title: Text(context.l10n?.maintenanceAlerts ?? 'Maintenance Updates'),
                subtitle: Text(context.l10n?.maintenanceAlertsDesc ?? 'Updates on maintenance requests'),
                value: prefs['maintenanceAlertsEnabled'] ?? true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('maintenanceAlertsEnabled', value);
                },
              ),
              SwitchListTile(
                title: Text(context.l10n?.inspectionReminders ?? 'Inspection Reminders'),
                subtitle: Text(context.l10n?.inspectionRemindersDesc ?? 'Reminders for upcoming inspections'),
                value: prefs['inspectionRemindersEnabled'] ?? true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('inspectionRemindersEnabled', value);
                },
              ),
            ],
          ),

          // Email Notifications Section
          _SettingsSection(
            title: context.l10n?.emailNotifications ?? 'Email Notifications',
            children: [
              SwitchListTile(
                title: Text(context.l10n?.marketingEmails ?? 'Marketing Emails'),
                subtitle: Text(context.l10n?.marketingEmailsDesc ?? 'Receive updates and promotional content'),
                value: prefs['marketingEmailsEnabled'] ?? false,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('marketingEmailsEnabled', value);
                },
              ),
            ],
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
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

// Simple notification preferences provider
final notificationPreferencesProvider = StateNotifierProvider<NotificationPreferencesNotifier, Map<String, bool>>((ref) {
  return NotificationPreferencesNotifier();
});

class NotificationPreferencesNotifier extends StateNotifier<Map<String, bool>> {
  NotificationPreferencesNotifier() : super({
    'notificationsEnabled': true,
    'rentRemindersEnabled': true,
    'paymentAlertsEnabled': true,
    'leaseExpiryAlertsEnabled': true,
    'maintenanceAlertsEnabled': true,
    'inspectionRemindersEnabled': true,
    'marketingEmailsEnabled': false,
  });

  void setPreference(String key, bool value) {
    state = {...state, key: value};
    // TODO: Save to storage
  }
}
