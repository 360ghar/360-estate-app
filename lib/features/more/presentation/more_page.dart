import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Unified More page with Profile & Settings - All features in one modern page
class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
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
    final flags = ref.watch(appConfigProvider).featureFlags;
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    final themeMode = ref.watch(appThemeProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('More'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      padding: EdgeInsets.zero,
      scrollable: false,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Profile Header Card
          _ProfileCard(
            userName: user?.displayName ?? 'User',
            userEmail: user?.email ?? '',
            userPhone: user?.phone ?? '',
            avatarUrl: user?.avatarUrl,
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
              _MenuTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => context.push('/more/profile/change-password'),
              ),
              _MenuTile(
                icon: Icons.security_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Two-Factor Authentication',
                subtitle: 'Not enabled',
                trailing: const _StatusChip(value: 'Off', color: Color(0xFF64748B)),
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Preferences Section with Working Theme & Language
          _SectionHeader(
            title: 'Preferences',
            icon: Icons.tune_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              // Theme Selector - Inline
              _ThemeSelectorTile(
                currentMode: themeMode,
                onSelected: (mode) {
                  ref.read(appThemeProvider.notifier).state = mode;
                },
              ),
              // Language Selector - Inline
              _LanguageSelectorTile(
                currentLocale: appLocale,
                onSelected: (locale) {
                  ref.read(appLocaleProvider.notifier).state = locale;
                },
              ),
              _MenuTile(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFFEC4899),
                title: 'Notifications',
                subtitle: 'Manage alerts',
                onTap: () => context.push('/more/profile/settings/notifications'),
              ),
              _MenuTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: const Color(0xFF10B981),
                title: 'Privacy',
                subtitle: 'Privacy settings',
                onTap: () => context.push('/more/profile/settings/privacy'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Management Section
          _SectionHeader(
            title: 'Management',
            icon: Icons.dashboard_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              if (flags.enableApplicationsModule)
                _MenuTile(
                  icon: Icons.assignment_turned_in_outlined,
                  iconColor: AppColors.primary,
                  title: 'Applications',
                  subtitle: 'Rental applications',
                  onTap: () => context.push('/more/applications'),
                ),
              _MenuTile(
                icon: Icons.people_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'Tenants',
                subtitle: 'Directory',
                onTap: () => context.push('/more/tenants'),
              ),
              _MenuTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Leases',
                subtitle: 'Agreements',
                onTap: () => context.push('/more/leases'),
              ),
              _MenuTile(
                icon: Icons.fact_check_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: 'Inspections',
                subtitle: 'Property checks',
                onTap: () => context.push('/more/inspections'),
              ),
              _MenuTile(
                icon: Icons.notifications_active_outlined,
                iconColor: const Color(0xFFEC4899),
                title: 'Notifications',
                subtitle: 'Alerts & updates',
                showBadge: true,
                onTap: () => context.push('/more/notifications'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Finance Section
          _SectionHeader(
            title: 'Finance',
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _MenuTile(
                icon: Icons.payments_outlined,
                iconColor: const Color(0xFF10B981),
                title: 'Collections',
                subtitle: 'Payment tracking',
                onTap: () => context.push('/collections'),
              ),
              _MenuTile(
                icon: Icons.receipt_long_outlined,
                iconColor: const Color(0xFFEF4444),
                title: 'Expenses',
                subtitle: 'Track spending',
                onTap: () => context.push('/more/expenses'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Documents & Reports Section
          _SectionHeader(
            title: 'Documents & Reports',
            icon: Icons.folder_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _MenuTile(
                icon: Icons.folder_open_outlined,
                iconColor: const Color(0xFF0EA5E9),
                title: 'Documents',
                subtitle: 'All files',
                onTap: () => context.push('/more/documents'),
              ),
              _MenuTile(
                icon: Icons.bar_chart_outlined,
                iconColor: const Color(0xFFA855F7),
                title: 'Reports',
                subtitle: 'Analytics',
                onTap: () => context.push('/more/reports'),
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
              _MenuTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF64748B),
                title: 'Help Center',
                subtitle: 'FAQs & guides',
                onTap: () => context.push('/more/profile/help'),
              ),
              _MenuTile(
                icon: Icons.contact_support_outlined,
                iconColor: const Color(0xFF64748B),
                title: 'Contact Us',
                subtitle: 'Get support',
                onTap: () => context.push('/more/profile/contact'),
              ),
              _MenuTile(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFF64748B),
                title: 'Report a Problem',
                subtitle: 'Found an issue?',
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
              _MenuTile(
                icon: Icons.phone_android_outlined,
                iconColor: AppColors.primary,
                title: 'App Version',
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
                    'v${_packageInfo?.version ?? '...'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              _MenuTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF64748B),
                title: 'Terms of Service',
                subtitle: 'Legal terms',
                onTap: () => _showComingSoon(context),
              ),
              _MenuTile(
                icon: Icons.policy_outlined,
                iconColor: const Color(0xFF64748B),
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Sign Out Card
          _SignOutCard(
            isBusy: authState.isBusy,
            onTap: () => _showLogoutDialog(context, ref),
          ),

          const SizedBox(height: AppSpacing.xl * 2),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
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
              ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('Sign Out'),
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
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: avatarUrl,
            name: userName,
            size: AppAvatarSize.lg,
            onTap: onEditTap,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (userEmail.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    userEmail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (userPhone.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    userPhone,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEditTap,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profile',
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

// Theme Selector Tile - Inline working theme switcher
class _ThemeSelectorTile extends StatefulWidget {
  const _ThemeSelectorTile({
    required this.currentMode,
    required this.onSelected,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onSelected;

  @override
  State<_ThemeSelectorTile> createState() => _ThemeSelectorTileState();
}

class _ThemeSelectorTileState extends State<_ThemeSelectorTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final modeLabel = switch (widget.currentMode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: AppRadii.md,
          child: ListTile(
            leading: Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.12),
                borderRadius: AppRadii.md,
              ),
              child: const Icon(
                Icons.palette_outlined,
                color: Color(0xFFF59E0B),
                size: 22,
              ),
            ),
            title: Text(
              'Theme',
              style: AppTextStyles.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Current: $modeLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 18,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            child: Column(
              children: [
                _ThemeOption(
                  label: 'System Default',
                  icon: Icons.brightness_auto_outlined,
                  isSelected: widget.currentMode == ThemeMode.system,
                  onTap: () {
                    widget.onSelected(ThemeMode.system);
                    setState(() => _expanded = false);
                  },
                ),
                _ThemeOption(
                  label: 'Light Mode',
                  icon: Icons.light_mode_outlined,
                  isSelected: widget.currentMode == ThemeMode.light,
                  onTap: () {
                    widget.onSelected(ThemeMode.light);
                    setState(() => _expanded = false);
                  },
                ),
                _ThemeOption(
                  label: 'Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  isSelected: widget.currentMode == ThemeMode.dark,
                  onTap: () {
                    widget.onSelected(ThemeMode.dark);
                    setState(() => _expanded = false);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Theme Option
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Language Selector Tile - Inline working language switcher
class _LanguageSelectorTile extends StatefulWidget {
  const _LanguageSelectorTile({
    required this.currentLocale,
    required this.onSelected,
  });

  final Locale? currentLocale;
  final ValueChanged<Locale?> onSelected;

  @override
  State<_LanguageSelectorTile> createState() => _LanguageSelectorTileState();
}

class _LanguageSelectorTileState extends State<_LanguageSelectorTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final localeLabel = switch (widget.currentLocale?.languageCode) {
      'en' => 'English',
      'hi' => 'Hindi',
      _ => 'System Default',
    };

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: AppRadii.md,
          child: ListTile(
            leading: Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.12),
                borderRadius: AppRadii.md,
              ),
              child: const Icon(
                Icons.translate_outlined,
                color: Color(0xFF8B5CF6),
                size: 22,
              ),
            ),
            title: Text(
              'Language',
              style: AppTextStyles.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Current: $localeLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 18,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            child: Column(
              children: [
                _LanguageOption(
                  label: 'System Default',
                  subtitle: 'Follow device language',
                  isSelected: widget.currentLocale == null,
                  onTap: () {
                    widget.onSelected(null);
                    setState(() => _expanded = false);
                  },
                ),
                _LanguageOption(
                  label: 'English',
                  subtitle: 'English',
                  isSelected: widget.currentLocale?.languageCode == 'en',
                  onTap: () {
                    widget.onSelected(const Locale('en'));
                    setState(() => _expanded = false);
                  },
                ),
                _LanguageOption(
                  label: 'Hindi',
                  subtitle: 'Hindi',
                  isSelected: widget.currentLocale?.languageCode == 'hi',
                  onTap: () {
                    widget.onSelected(const Locale('hi'));
                    setState(() => _expanded = false);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Language Option
class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Menu Tile
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.showBadge = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
            if (showBadge)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                ),
              ),
          ],
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

// Status Chip
class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.value,
    required this.color,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadii.sm,
      ),
      child: Text(
        value,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
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
