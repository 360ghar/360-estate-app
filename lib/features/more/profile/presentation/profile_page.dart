import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
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
    _loadPackageInfo();
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
      scrollable: false,
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

          const SizedBox(height: AppSpacing.lg),

          // Account Security Section
          _SectionHeader(
            title: 'Account Security',
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.changePassword ?? 'Change Password',
                subtitle: 'Update your password',
                onTap: () => context.push('/more/profile/change-password'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Preferences Section
          _SectionHeader(
            title: 'Preferences',
            icon: Icons.tune_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
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
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Support Section
          _SectionHeader(
            title: 'Support',
            icon: Icons.support_agent_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF64748B),
                title: context.l10n?.helpCenter ?? 'Help Center',
                subtitle: 'FAQs & guides',
                onTap: () => context.push('/more/profile/help'),
              ),
              _SettingsTile(
                icon: Icons.contact_support_outlined,
                iconColor: const Color(0xFF64748B),
                title: context.l10n?.contactUs ?? 'Contact Us',
                subtitle: 'Get support',
                onTap: () => context.push('/more/profile/contact'),
              ),
              _SettingsTile(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFF64748B),
                title: context.l10n?.reportProblem ?? 'Report a Problem',
                subtitle: 'Found an issue? Let us know',
                onTap: () => context.push('/more/profile/contact?report=true'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // About Section
          _SectionHeader(
            title: 'About',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
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
                    borderRadius: AppRadii.sm,
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
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

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
    showDialog(
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
    );
  }
}

// Enhanced Profile Card
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
        boxShadow: AppShadows.md,
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: AppShadows.sm,
                ),
                child: AppAvatar(
                  imageUrl: avatarUrl,
                  name: userName,
                  size: AppAvatarSize.xl,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.sm,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
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

// Section Header
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: AppRadii.sm,
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// Section Card
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          final isLast = index == children.length - 1;
          return Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : 1,
            ),
            child: children[index],
          );
        }),
      ),
    );
  }
}

// Settings Tile
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: AppRadii.md,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: trailing ??
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              size: 18,
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
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

    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: AppRadii.lg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.3),
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign Out',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.error,
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
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
