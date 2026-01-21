import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Privacy settings page with privacy and data sharing preferences
class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.privacySettings ?? 'Privacy Settings'),
      ),
      scrollable: false,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile Visibility Section
          _SettingsSection(
            title: context.l10n?.profileVisibilitySection ?? 'Profile Visibility',
            children: [
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPublic ?? 'Public'),
                subtitle: Text(context.l10n?.visibilityPublicDesc ?? 'Anyone can see your profile'),
                value: 'public',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityContacts ?? 'Contacts Only'),
                subtitle: Text(context.l10n?.visibilityContactsDesc ?? 'Only your contacts can see your profile'),
                value: 'contacts',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPrivate ?? 'Private'),
                subtitle: Text(context.l10n?.visibilityPrivateDesc ?? 'Only you can see your profile'),
                value: 'private',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'profileVisibility', value),
              ),
            ],
          ),

          // Phone Number Visibility Section
          _SettingsSection(
            title: context.l10n?.phoneVisibilitySection ?? 'Phone Number Visibility',
            children: [
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPublic ?? 'Public'),
                value: 'public',
                groupValue: 'contacts',
                onChanged: (value) => _updatePrivacy(ref, 'phoneVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityContacts ?? 'Contacts Only'),
                value: 'contacts',
                groupValue: 'contacts',
                onChanged: (value) => _updatePrivacy(ref, 'phoneVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPrivate ?? 'Private'),
                value: 'private',
                groupValue: 'contacts',
                onChanged: (value) => _updatePrivacy(ref, 'phoneVisibility', value),
              ),
            ],
          ),

          // Email Visibility Section
          _SettingsSection(
            title: context.l10n?.emailVisibilitySection ?? 'Email Visibility',
            children: [
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPublic ?? 'Public'),
                value: 'public',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'emailVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityContacts ?? 'Contacts Only'),
                value: 'contacts',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'emailVisibility', value),
              ),
              RadioListTile<String>(
                title: Text(context.l10n?.visibilityPrivate ?? 'Private'),
                value: 'private',
                groupValue: 'public',
                onChanged: (value) => _updatePrivacy(ref, 'emailVisibility', value),
              ),
            ],
          ),

          // Data & Analytics Section
          _SettingsSection(
            title: context.l10n?.dataAnalyticsSection ?? 'Data & Analytics',
            children: [
              SwitchListTile(
                title: Text(context.l10n?.analyticsTitle ?? 'Analytics'),
                subtitle: Text(context.l10n?.analyticsDesc ?? 'Help improve the app by sharing usage data'),
                value: true,
                onChanged: (value) => _updatePrivacy(ref, 'analyticsEnabled', value ? 'true' : 'false'),
              ),
              SwitchListTile(
                title: Text(context.l10n?.crashReporting ?? 'Crash Reporting'),
                subtitle: Text(context.l10n?.crashReportingDesc ?? 'Automatically report crashes to help us fix bugs'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement crash reporting toggle
                },
              ),
            ],
          ),

          // Data Management Section
          _SettingsSection(
            title: context.l10n?.dataManagementSection ?? 'Data Management',
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: Text(context.l10n?.downloadMyData ?? 'Download My Data'),
                subtitle: Text(context.l10n?.downloadDataDesc ?? 'Get a copy of all your data'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDownloadDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Clear Activity History'),
                subtitle: Text(context.l10n?.clearActivityDesc ?? 'Clear your recent activity'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearHistoryDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePrivacy(WidgetRef ref, String key, String? value) {
    if (value == null) return;
    // TODO: Save to storage via privacy preferences provider
    // ref.read(privacyPreferencesProvider.notifier).setPreference(key, value);
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              backgroundColor: Colors.red,
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
