import 'dart:async';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// About page with app version, license info, and legal links
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.about ?? 'About'),
      ),
      scrollable: true,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          // App Icon with shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: AppShadows.cardElevated,
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.home_work,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // App Name
          Text(
            _packageInfo?.appName ?? context.l10n?.appName ?? '360 Estate',
            style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Tagline
          Text(
            context.l10n?.tagline ?? 'Complete Property Management Solution',
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Version info card
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
              borderRadius: AppRadii.pill,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${context.l10n?.version ?? 'Version'} ${_packageInfo?.version ?? '1.0.0'} (${_packageInfo?.buildNumber ?? '1'})',
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Legal Section
          AppSectionCard(
            title: context.l10n?.legal ?? 'Legal',
            icon: Icons.gavel_outlined,
            iconColor: const Color(0xFF64748B),
            contentPadding: EdgeInsets.zero,
            children: [
              _AboutTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.termsOfService ?? 'Terms of Service',
                onTap: () => _launchUrl('https://360estate.app/terms'),
              ),
              _tileDivider(isDark),
              _AboutTile(
                icon: Icons.policy_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: context.l10n?.privacyPolicy ?? 'Privacy Policy',
                onTap: () => _launchUrl('https://360estate.app/privacy'),
              ),
              _tileDivider(isDark),
              _AboutTile(
                icon: Icons.copyright_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: context.l10n?.licenses ?? 'Licenses',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: _packageInfo?.appName ?? '360 Estate',
                  applicationVersion: _packageInfo?.version ?? '1.0.0',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Support Section
          AppSectionCard(
            title: context.l10n?.support ?? 'Support',
            icon: Icons.support_agent_outlined,
            iconColor: const Color(0xFF0EA5E9),
            contentPadding: EdgeInsets.zero,
            children: [
              _AboutTile(
                icon: Icons.language_outlined,
                iconColor: const Color(0xFF10B981),
                title: context.l10n?.website ?? 'Website',
                subtitle: 'www.360estate.app',
                onTap: () => _launchUrl('https://360estate.app'),
              ),
              _tileDivider(isDark),
              _AboutTile(
                icon: Icons.email_outlined,
                iconColor: const Color(0xFF3B82F6),
                title: context.l10n?.contactSupport ?? 'Contact Support',
                subtitle: 'support@360estate.app',
                onTap: () => _launchUrl('mailto:support@360estate.app'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Social Section
          AppSectionCard(
            title: context.l10n?.followUs ?? 'Follow Us',
            icon: Icons.share_outlined,
            iconColor: const Color(0xFFEC4899),
            contentPadding: EdgeInsets.zero,
            children: [
              _AboutTile(
                icon: Icons.chat_outlined,
                iconColor: const Color(0xFF0EA5E9),
                title: 'Twitter',
                subtitle: '@360estate',
                onTap: () => _launchUrl('https://twitter.com/360estate'),
              ),
              _tileDivider(isDark),
              _AboutTile(
                icon: Icons.business_outlined,
                iconColor: const Color(0xFF3B82F6),
                title: 'LinkedIn',
                onTap: () => _launchUrl('https://linkedin.com/company/360estate'),
              ),
              _tileDivider(isDark),
              _AboutTile(
                icon: Icons.facebook_outlined,
                iconColor: const Color(0xFF1877F2),
                title: 'Facebook',
                onTap: () => _launchUrl('https://facebook.com/360estate'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Footer
          Text(
            context.l10n?.madeWithLove ?? 'Made with love for property managers',
            style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '2024 360 Estate. ${context.l10n?.allRightsReserved ?? 'All rights reserved.'}',
            style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n?.couldNotLaunchUrl ?? 'Could not launch $url')),
        );
      }
    }
  }
}

// About tile styled as a menu tile with colored icon
class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
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
