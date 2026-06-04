import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Profile & Settings page with modern, enhanced UI
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPackageInfo());
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _packageInfo = info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final profile = authState.user;
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.profileTitle ?? 'Profile & Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Enhanced Profile Header Card
          _ProfileCard(
            userName: profile?.displayName ?? 'User',
            userEmail: profile?.email ?? '',
            userPhone: profile?.phone ?? '',
            avatarUrl: profile?.avatarUrl,
            onEditTap: () => context.push('/more/profile/edit'),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Personal Information - Read-only fields
          AppSectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            iconColor: const Color(0xFF3B82F6),
            children: [
              _ReadOnlyField(
                label: context.l10n?.fullNameLabel ?? 'Full Name',
                value: profile?.displayName ?? '--',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: AppSpacing.md),
              _ReadOnlyField(
                label: context.l10n?.emailLabel ?? 'Email',
                value: profile?.email ?? '--',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              _ReadOnlyField(
                label: context.l10n?.phoneNumberLabel ?? 'Phone',
                value: profile?.phone ?? '--',
                icon: Icons.phone_outlined,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Account Security Section
          AppSectionCard(
            title: 'Account Security',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF8B5CF6),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.changePassword ?? 'Change Password',
                subtitle: 'Update your password',
                onTap: () => context.push('/more/profile/change-password'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Preferences Section
          AppSectionCard(
            title: 'Preferences',
            icon: Icons.tune_outlined,
            iconColor: const Color(0xFFF59E0B),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: context.l10n?.appearance ?? 'Appearance',
                subtitle: 'Theme, Language',
                onTap: () => context.push('/more/profile/settings'),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFFEC4899),
                title: context.l10n?.notifications ?? 'Notifications',
                subtitle: context.l10n?.manageAlerts ?? 'Manage alerts',
                onTap: () => context.push('/more/profile/settings/notifications'),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: const Color(0xFF10B981),
                title: context.l10n?.privacy ?? 'Privacy',
                subtitle: 'Privacy settings',
                onTap: () => context.push('/more/profile/settings/privacy'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Support Section
          AppSectionCard(
            title: 'Support',
            icon: Icons.support_agent_outlined,
            iconColor: const Color(0xFF64748B),
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF0EA5E9),
                title: context.l10n?.helpCenter ?? 'Help Center',
                subtitle: 'FAQs & guides',
                onTap: () => context.push('/more/profile/help'),
              ),
              _SettingsTile(
                icon: Icons.contact_support_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: context.l10n?.contactUs ?? 'Contact Us',
                subtitle: 'Get support',
                onTap: () => context.push('/more/profile/contact'),
              ),
              _SettingsTile(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFFEF4444),
                title: context.l10n?.reportBug ?? 'Report a Bug',
                subtitle: 'Found an issue? Let us know',
                onTap: () =>
                    context.push('/more/profile/contact?category=technical'),
              ),
              _SettingsTile(
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFF59E0B),
                title: context.l10n?.requestFeature ?? 'Request a Feature',
                subtitle: 'Suggest an improvement',
                onTap: () =>
                    context.push('/more/profile/contact?category=feature'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // About Section
          AppSectionCard(
            title: 'About',
            icon: Icons.info_outline,
            iconColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            children: [
              _SettingsTile(
                icon: Icons.phone_android_outlined,
                iconColor: AppColors.primary,
                title: context.l10n?.appVersion ?? 'App Version',
                subtitle: _packageInfo?.version ?? '...',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    _packageInfo?.version ?? '...',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: () {},
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Sign Out Button
          _SignOutCard(
            isBusy: authState.isBusy,
            onTap: () => _showLogoutDialog(context, ref),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Text(context.l10n?.signOutTitle ?? 'Sign Out'),
        content: Text(context.l10n?.signOutConfirm ?? 'Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n?.commonCancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
            child: Text(context.l10n?.commonSignOut ?? 'Sign Out'),
          ),
        ],
      ),
    ));
  }
}

// Enhanced Profile Card with gradient
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.avatarUrl,
    this.onEditTap,
  });

  final String userName;
  final String userEmail;
  final String userPhone;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: AppRadii.xl,
        boxShadow: AppShadows.cardElevated,
      ),
      child: Column(
        children: [
          // Avatar with shadow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: AppShadows.md,
            ),
            child: AppAvatar(
              imageUrl: avatarUrl,
              name: userName,
              size: AppAvatarSize.xl,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Name
          Text(
            userName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (userEmail.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              userEmail,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],

          if (userPhone.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              userPhone,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Edit Button
          FilledButton.tonalIcon(
            onPressed: onEditTap,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(context.l10n?.editProfile ?? 'Edit Profile'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Read-only styled field
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Tile with colored icon circles
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
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
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
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
                trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: 18,
                    ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 68),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            ),
          ),
      ],
    );
  }
}

// Sign Out Card
class _SignOutCard extends StatelessWidget {
  const _SignOutCard({
    required this.isBusy,
    required this.onTap,
  });

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: AppRadii.lg,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          gradient: AppGradients.dangerSubtle,
          color: isDark
              ? AppColors.danger.withValues(alpha: 0.08)
              : AppColors.danger.withValues(alpha: 0.04),
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: AppColors.danger.withValues(alpha: isDark ? 0.2 : 0.15),
          ),
          boxShadow: AppShadows.cardResting,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: AppColors.danger,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign Out',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isBusy) ...[
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.danger,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
