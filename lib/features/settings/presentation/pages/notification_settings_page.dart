import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification settings page with comprehensive notification preferences
class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPreferencesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final masterEnabled = prefs['notificationsEnabled'] ?? true;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.notificationPreferences ?? 'Notification Preferences'),
      ),
      scrollable: true,
      body: Column(
        children: [
          // Master toggle at the top
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
              boxShadow: AppShadows.cardResting,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFFEC4899),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n?.enablePushNotifications ?? 'Push Notifications',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        context.l10n?.pushNotificationsDesc ?? 'Receive notifications on your device',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: masterEnabled,
                  onChanged: (value) {
                    ref.read(notificationPreferencesProvider.notifier).setPreference('notificationsEnabled', value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Alert Types Section
          AppSectionCard(
            title: context.l10n?.alertTypes ?? 'Alert Types',
            icon: Icons.campaign_outlined,
            iconColor: const Color(0xFF3B82F6),
            contentPadding: EdgeInsets.zero,
            children: [
              _NotificationToggleTile(
                icon: Icons.payments_outlined,
                iconColor: const Color(0xFF10B981),
                title: context.l10n?.rentReminders ?? 'Rent Due Reminders',
                description: context.l10n?.rentRemindersDesc ?? 'Get reminded before rent is due',
                value: prefs['rentRemindersEnabled'] ?? true,
                enabled: masterEnabled,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('rentRemindersEnabled', value);
                },
              ),
              _tileDivider(isDark),
              _NotificationToggleTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF059669),
                title: context.l10n?.paymentAlerts ?? 'Payment Received Alerts',
                description: context.l10n?.paymentAlertsDesc ?? 'Know when payments are received',
                value: prefs['paymentAlertsEnabled'] ?? true,
                enabled: masterEnabled,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('paymentAlertsEnabled', value);
                },
              ),
              _tileDivider(isDark),
              _NotificationToggleTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: context.l10n?.leaseExpiryAlerts ?? 'Lease Expiry Alerts',
                description: context.l10n?.leaseExpiryAlertsDesc ?? 'Get notified before leases expire',
                value: prefs['leaseExpiryAlertsEnabled'] ?? true,
                enabled: masterEnabled,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('leaseExpiryAlertsEnabled', value);
                },
              ),
              _tileDivider(isDark),
              _NotificationToggleTile(
                icon: Icons.build_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: context.l10n?.maintenanceAlerts ?? 'Maintenance Updates',
                description: context.l10n?.maintenanceAlertsDesc ?? 'Updates on maintenance requests',
                value: prefs['maintenanceAlertsEnabled'] ?? true,
                enabled: masterEnabled,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('maintenanceAlertsEnabled', value);
                },
              ),
              _tileDivider(isDark),
              _NotificationToggleTile(
                icon: Icons.fact_check_outlined,
                iconColor: const Color(0xFF0EA5E9),
                title: context.l10n?.inspectionReminders ?? 'Inspection Reminders',
                description: context.l10n?.inspectionRemindersDesc ?? 'Reminders for upcoming inspections',
                value: prefs['inspectionRemindersEnabled'] ?? true,
                enabled: masterEnabled,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('inspectionRemindersEnabled', value);
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Email Notifications Section
          AppSectionCard(
            title: context.l10n?.emailNotifications ?? 'Email Notifications',
            icon: Icons.email_outlined,
            iconColor: const Color(0xFF64748B),
            contentPadding: EdgeInsets.zero,
            children: [
              _NotificationToggleTile(
                icon: Icons.campaign_outlined,
                iconColor: const Color(0xFF64748B),
                title: context.l10n?.marketingEmails ?? 'Marketing Emails',
                description: context.l10n?.marketingEmailsDesc ?? 'Receive updates and promotional content',
                value: prefs['marketingEmailsEnabled'] ?? false,
                enabled: true,
                onChanged: (value) {
                  ref.read(notificationPreferencesProvider.notifier).setPreference('marketingEmailsEnabled', value);
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _tileDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Divider(
        height: 0.5,
        thickness: 0.5,
        color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
      ),
    );
  }
}

// Notification toggle tile with icon, title, description
class _NotificationToggleTile extends StatelessWidget {
  const _NotificationToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
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
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
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
