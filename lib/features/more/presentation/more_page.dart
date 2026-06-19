import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
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

          const SizedBox(height: AppSpacing.xl),

          // Account Security Section
          AppSectionCard(
            title: 'Account Security',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF3B82F6),
            contentPadding: EdgeInsets.zero,
            children: [
              _MenuTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF3B82F6),
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => context.push('/more/profile/change-password'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Preferences Section with Working Theme & Language
          AppSectionCard(
            title: 'Preferences',
            icon: Icons.tune_outlined,
            iconColor: const Color(0xFFF59E0B),
            contentPadding: EdgeInsets.zero,
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
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Management Section
          AppSectionCard(
            title: 'Management',
            icon: Icons.dashboard_outlined,
            iconColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
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
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Finance Section
          AppSectionCard(
            title: 'Finance',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF10B981),
            contentPadding: EdgeInsets.zero,
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
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Documents & Reports Section
          AppSectionCard(
            title: 'Documents & Reports',
            icon: Icons.folder_outlined,
            iconColor: const Color(0xFF0EA5E9),
            contentPadding: EdgeInsets.zero,
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
              _MenuTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF0EA5E9),
                title: 'Help Center',
                subtitle: 'FAQs & guides',
                onTap: () => context.push('/more/profile/help'),
              ),
              _MenuTile(
                icon: Icons.contact_support_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Contact Us',
                subtitle: 'Get support',
                onTap: () => context.push('/more/profile/contact'),
              ),
              _MenuTile(
                icon: Icons.bug_report_outlined,
                iconColor: const Color(0xFFEF4444),
                title: 'Report a Bug',
                subtitle: 'Found an issue?',
                onTap: () =>
                    context.push('/more/profile/contact?category=technical'),
              ),
              _MenuTile(
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFF59E0B),
                title: 'Request a Feature',
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
                onTap: () => context.push('/more/profile/settings/terms-of-service'),
              ),
              _MenuTile(
                icon: Icons.policy_outlined,
                iconColor: const Color(0xFF64748B),
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () => context.push('/more/profile/settings/privacy-policy'),
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

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

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    unawaited(showDialog<void>(
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
    ));
  }
}

// Enhanced Profile Card with gradient background
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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppShadows.sm,
            ),
            child: AppAvatar(
              imageUrl: avatarUrl,
              name: userName,
              size: AppAvatarSize.lg,
              onTap: onEditTap,
            ),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onEditTap,
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              tooltip: 'Edit profile',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                _IconCircle(
                  icon: Icons.palette_outlined,
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Current: $modeLabel',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppDurations.fast,
                  curve: AppDurations.defaultCurve,
                  child: Icon(
                    Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                _ThemeOptionCard(
                  label: 'System',
                  icon: Icons.brightness_auto_outlined,
                  isSelected: widget.currentMode == ThemeMode.system,
                  onTap: () {
                    widget.onSelected(ThemeMode.system);
                    setState(() => _expanded = false);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ThemeOptionCard(
                  label: 'Light',
                  icon: Icons.light_mode_outlined,
                  isSelected: widget.currentMode == ThemeMode.light,
                  onTap: () {
                    widget.onSelected(ThemeMode.light);
                    setState(() => _expanded = false);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ThemeOptionCard(
                  label: 'Dark',
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
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: AppDurations.medium,
          sizeCurve: AppDurations.defaultCurve,
        ),
      ],
    );
  }
}

// Visual theme option card
class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
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
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppDurations.defaultCurve,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : isDark
                    ? AppColors.darkSurfaceSecondary
                    : AppColors.surfaceSecondary,
            borderRadius: AppRadii.md,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.4)
                  : isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
              width: isSelected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                _IconCircle(
                  icon: Icons.translate_outlined,
                  color: const Color(0xFF8B5CF6),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Current: $localeLabel',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppDurations.fast,
                  curve: AppDurations.defaultCurve,
                  child: Icon(
                    Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
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
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: AppDurations.medium,
          sizeCurve: AppDurations.defaultCurve,
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
          vertical: AppSpacing.sm,
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

// Colored icon circle for menu tiles
class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
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
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showBadge;
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _IconCircle(icon: icon, color: iconColor),
                    if (showBadge)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
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

// Sign Out Card - Red tinted background
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
