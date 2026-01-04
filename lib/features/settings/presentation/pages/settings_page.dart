import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/entities/user_profile.dart';
import 'package:estate_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
        elevation: 0,
        actions: [
          // Refresh profile button
          IconButton(
            onPressed: () => unawaited(controller.refreshProfile()),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: Obx(
        () {
          final authUser = authController.state.value.data;
          final profile = controller.userProfile.value;
          final isLoadingProfile = controller.isLoadingProfile.value;

          return RefreshIndicator(
            onRefresh: controller.refreshProfile,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Section - Use backend profile if available, fallback to auth user
                if (authUser != null || profile != null) ...[
                  _ProfileHeader(
                    profile: profile,
                    authUser: authUser,
                    isLoading: isLoadingProfile,
                  ),
                  const SizedBox(height: 24),
                ],

                // Account Section
                _SectionTitle(title: 'Account'),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',
                        onTap: () => _showEditProfileDialog(context, controller, profile),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: profile?.notificationSettings != null
                            ? 'Push: ${profile!.notificationSettings!.pushEnabled ? "On" : "Off"}'
                            : 'Manage push notifications',
                        onTap: () => _showComingSoon(context),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Privacy & Security',
                        subtitle: 'Manage your data and privacy',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Appearance Section
                _SectionTitle(title: context.l10n.themeSectionTitle),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ThemeOptionTile(
                        icon: Icons.brightness_auto,
                        title: context.l10n.themeSystem,
                        isSelected: controller.themeMode.value == AppThemeMode.system,
                        onTap: () => unawaited(controller.setTheme(AppThemeMode.system)),
                      ),
                      const Divider(height: 1),
                      _ThemeOptionTile(
                        icon: Icons.light_mode_outlined,
                        title: context.l10n.themeLight,
                        isSelected: controller.themeMode.value == AppThemeMode.light,
                        onTap: () => unawaited(controller.setTheme(AppThemeMode.light)),
                      ),
                      const Divider(height: 1),
                      _ThemeOptionTile(
                        icon: Icons.dark_mode_outlined,
                        title: context.l10n.themeDark,
                        isSelected: controller.themeMode.value == AppThemeMode.dark,
                        onTap: () => unawaited(controller.setTheme(AppThemeMode.dark)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Language Section
                _SectionTitle(title: context.l10n.languageSectionTitle),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LanguageOptionTile(
                        flag: '🌐',
                        title: context.l10n.languageSystem,
                        isSelected: controller.locale.value?.languageCode == null,
                        onTap: () => unawaited(controller.setAppLocale(null)),
                      ),
                      const Divider(height: 1),
                      _LanguageOptionTile(
                        flag: '🇬🇧',
                        title: context.l10n.languageEnglish,
                        isSelected: controller.locale.value?.languageCode == 'en',
                        onTap: () => unawaited(
                          controller.setAppLocale(const AppLocale(languageCode: 'en')),
                        ),
                      ),
                      const Divider(height: 1),
                      _LanguageOptionTile(
                        flag: '🇮🇳',
                        title: context.l10n.languageHindi,
                        isSelected: controller.locale.value?.languageCode == 'hi',
                        onTap: () => unawaited(
                          controller.setAppLocale(const AppLocale(languageCode: 'hi')),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Support Section
                _SectionTitle(title: 'Support'),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'FAQs and support articles',
                        onTap: () => _showComingSoon(context),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.bug_report_outlined,
                        title: 'Report a Bug',
                        subtitle: 'Help us improve the app',
                        onTap: () => _showBugReportDialog(context),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.mail_outline,
                        title: 'Contact Us',
                        subtitle: 'Get in touch with our team',
                        onTap: () => _launchEmail(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // About Section
                _SectionTitle(title: 'About'),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        onTap: () => _showComingSoon(context),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () => _showComingSoon(context),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: 'App Version',
                        trailing: Text(
                          '1.0.0',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout Button
                _LogoutButton(
                  onPressed: () => _showLogoutConfirmation(context, authController),
                ),

                const SizedBox(height: 32),

                // App Branding
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_work_rounded,
                        size: 40,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '360 Estate',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Made with ❤️ in India',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, SettingsController controller, UserProfile? profile) {
    final nameController = TextEditingController(text: profile?.fullName ?? '');
    final emailController = TextEditingController(text: profile?.email ?? '');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final success = await controller.updateProfile(
                fullName: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
                email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Profile updated!' : 'Failed to update profile'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const Text(
          'Please describe the issue you encountered. We appreciate your feedback!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _launchEmail(subject: 'Bug Report - 360 Estate App');
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail({String? subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@360estate.com',
      queryParameters: subject != null ? {'subject': subject} : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showLogoutConfirmation(BuildContext context, AuthController authController) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(authController.signOut());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// Profile Header Widget - Now uses backend profile when available
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.authUser,
    required this.isLoading,
  });

  final UserProfile? profile;
  final AuthUser? authUser;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use profile data if available, fallback to auth user
    final displayName = profile?.displayName ?? authUser?.phone ?? 'User';
    final roleLabel = profile?.roleLabel ?? _getRoleLabel(authUser?.role);
    final email = profile?.email ?? authUser?.email;
    final phone = profile?.phone ?? authUser?.phone;
    final isVerified = profile?.isVerified ?? false;
    final avatarUrl = profile?.avatarUrl;

    IconData roleIcon = switch (authUser?.role) {
      UserRole.admin => Icons.business,
      UserRole.agent => Icons.support_agent,
      UserRole.user => Icons.person,
      _ => Icons.person_outline,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadii.xl,
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientEnd.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      image: avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: avatarUrl == null
                        ? Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Icon(
                                    roleIcon,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                          )
                        : null,
                  ),
                  if (isVerified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified,
                          color: AppColors.success,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: AppRadii.sm,
                      ),
                      child: Text(
                        roleLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Copy ID button
              if (authUser != null)
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: authUser!.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('User ID copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.content_copy,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  tooltip: 'Copy User ID',
                ),
            ],
          ),
          // Contact info row
          if (phone != null || email != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Row(
              children: [
                if (phone != null) ...[
                  Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    phone,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (email != null) ...[
                  Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
          // Profile load error indicator
          if (profile == null && !isLoading) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: AppRadii.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pull to refresh profile',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRoleLabel(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Property Owner';
      case UserRole.agent:
        return 'Relationship Manager';
      case UserRole.user:
        return 'Tenant';
      default:
        return 'User';
    }
  }
}

// Section Title Widget
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// Settings Tile Widget
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: AppRadii.sm,
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                )
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// Theme Option Tile
class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// Language Option Tile
class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.flag,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// Logout Button
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.md,
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: theme.colorScheme.error.withOpacity(0.05),
        borderRadius: AppRadii.md,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadii.md,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: theme.colorScheme.error,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sign Out',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
