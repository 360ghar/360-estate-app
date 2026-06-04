import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Privacy settings page with privacy and data sharing preferences
class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.privacySettings ?? 'Privacy Settings'),
      ),
      scrollable: true,
      body: Column(
        children: [
          // Profile Visibility Section
          AppSectionCard(
            title: context.l10n?.profileVisibilitySection ?? 'Profile Visibility',
            icon: Icons.visibility_outlined,
            iconColor: const Color(0xFF3B82F6),
            contentPadding: EdgeInsets.zero,
            children: [
              _PrivacyRadioTile(
                icon: Icons.public_outlined,
                iconColor: const Color(0xFF10B981),
                title: context.l10n?.visibilityPublic ?? 'Public',
                description: context.l10n?.visibilityPublicDesc ?? 'Anyone can see your profile',
                value: 'public',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
              _tileDivider(isDark),
              _PrivacyRadioTile(
                icon: Icons.people_outline,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.visibilityContacts ?? 'Contacts Only',
                description: context.l10n?.visibilityContactsDesc ?? 'Only your contacts can see your profile',
                value: 'contacts',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
              _tileDivider(isDark),
              _PrivacyRadioTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF8B5CF6),
                title: context.l10n?.visibilityPrivate ?? 'Private',
                description: context.l10n?.visibilityPrivateDesc ?? 'Only you can see your profile',
                value: 'private',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Data & Analytics Section
          AppSectionCard(
            title: context.l10n?.dataAnalyticsSection ?? 'Data & Analytics',
            icon: Icons.analytics_outlined,
            iconColor: const Color(0xFFF59E0B),
            contentPadding: EdgeInsets.zero,
            children: [
              _PrivacyToggleTile(
                icon: Icons.insights_outlined,
                iconColor: const Color(0xFF0EA5E9),
                title: context.l10n?.analyticsTitle ?? 'Analytics',
                description: context.l10n?.analyticsDesc ?? 'Help improve the app by sharing usage data',
                value: true,
                onChanged: (value) => _updatePrivacy(ref, 'analyticsEnabled', value ? 'true' : 'false'),
              ),
              _tileDivider(isDark),
              _PrivacyToggleTile(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFFEF4444),
                title: context.l10n?.crashReporting ?? 'Crash Reporting',
                description: context.l10n?.crashReportingDesc ?? 'Automatically report crashes to help us fix bugs',
                value: true,
                onChanged: (value) {
                  // TODO: Implement crash reporting toggle
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Data Management Section
          AppSectionCard(
            title: context.l10n?.dataManagementSection ?? 'Data Management',
            icon: Icons.storage_outlined,
            iconColor: const Color(0xFF64748B),
            contentPadding: EdgeInsets.zero,
            children: [
              _PrivacyActionTile(
                icon: Icons.download_outlined,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.downloadMyData ?? 'Download My Data',
                description: context.l10n?.downloadDataDesc ?? 'Get a copy of all your data',
                onTap: () => _showDownloadDialog(context),
              ),
              _tileDivider(isDark),
              _PrivacyActionTile(
                icon: Icons.delete_outline,
                iconColor: const Color(0xFFEF4444),
                title: 'Clear Activity History',
                description: context.l10n?.clearActivityDesc ?? 'Clear your recent activity',
                onTap: () => _showClearHistoryDialog(context),
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

  void _updatePrivacy(WidgetRef ref, String key, String? value) {
    if (value == null) return;
    // TODO: Save to storage via privacy preferences provider
  }

  void _showDownloadDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Text(context.l10n?.downloadMyData ?? 'Download My Data'),
        content: Text(
          context.l10n?.downloadDataConfirm ??
              'Your data will be prepared and sent to your email. This may take a few minutes.',
        ),
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
                  content: Text(context.l10n?.dataDownloadStarted ?? 'Data export started'),
                ),
              );
            },
            child: Text(context.l10n?.commonRequest ?? 'Request'),
          ),
        ],
      ),
    ));
  }

  void _showClearHistoryDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: const Text('Clear Activity History'),
        content: const Text(
          'This will clear your recent activity history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n?.commonCancel ?? 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity history cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    ));
  }
}

// Privacy radio tile with icon
class _PrivacyRadioTile extends StatelessWidget {
  const _PrivacyRadioTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(value),
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
            Radio<String>(
              value: value,
              // ignore: deprecated_member_use
              groupValue: groupValue,
              // ignore: deprecated_member_use
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// Privacy toggle tile with icon
class _PrivacyToggleTile extends StatelessWidget {
  const _PrivacyToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
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
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Privacy action tile with chevron
class _PrivacyActionTile extends StatelessWidget {
  const _PrivacyActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
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
