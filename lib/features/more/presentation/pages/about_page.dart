import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
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
    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.about ?? 'About'),
      ),
      scrollable: true,
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          // App Logo/Icon
          Container(
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
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.home_work,
              size: 50,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // App Name
          Text(
            _packageInfo?.appName ?? context.l10n?.appName ?? '360 Estate',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Tagline
          Text(
            context.l10n?.tagline ?? 'Complete Property Management Solution',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Version Info
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${context.l10n?.version ?? 'Version'} ${_packageInfo?.version ?? '1.0.0'} (${_packageInfo?.buildNumber ?? '1'})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Legal Section
          _Section(title: context.l10n?.legal ?? 'Legal', children: [
            _ListTile(
              icon: Icons.description_outlined,
              title: context.l10n?.termsOfService ?? 'Terms of Service',
              onTap: () => _launchUrl('https://360estate.app/terms'),
            ),
            _ListTile(
              icon: Icons.policy_outlined,
              title: context.l10n?.privacyPolicy ?? 'Privacy Policy',
              onTap: () => _launchUrl('https://360estate.app/privacy'),
            ),
            _ListTile(
              icon: Icons.copyright_outlined,
              title: context.l10n?.licenses ?? 'Licenses',
              onTap: () => showLicensePage(
                context: context,
                applicationName: _packageInfo?.appName ?? '360 Estate',
                applicationVersion: _packageInfo?.version ?? '1.0.0',
              ),
            ),
          ]),

          // Support Section
          _Section(title: context.l10n?.support ?? 'Support', children: [
            _ListTile(
              icon: Icons.language_outlined,
              title: context.l10n?.website ?? 'Website',
              subtitle: 'www.360estate.app',
              onTap: () => _launchUrl('https://360estate.app'),
            ),
            _ListTile(
              icon: Icons.email_outlined,
              title: context.l10n?.contactSupport ?? 'Contact Support',
              subtitle: 'support@360estate.app',
              onTap: () => _launchUrl('mailto:support@360estate.app'),
            ),
          ]),

          // Social Section
          _Section(title: context.l10n?.followUs ?? 'Follow Us', children: [
            _ListTile(
              icon: Icons.chat_outlined,
              title: 'Twitter',
              subtitle: '@360estate',
              onTap: () => _launchUrl('https://twitter.com/360estate'),
            ),
            _ListTile(
              icon: Icons.business_outlined,
              title: 'LinkedIn',
              onTap: () => _launchUrl('https://linkedin.com/company/360estate'),
            ),
            _ListTile(
              icon: Icons.facebook_outlined,
              title: 'Facebook',
              onTap: () => _launchUrl('https://facebook.com/360estate'),
            ),
          ]),

          const SizedBox(height: AppSpacing.xl),

          // Footer
          Text(
            context.l10n?.madeWithLove ?? 'Made with ❤️ for property managers',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            '© 2024 360 Estate. ${context.l10n?.allRightsReserved ?? 'All rights reserved.'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
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

class _Section extends StatelessWidget {
  const _Section({
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: List.generate(
              children.length,
              (index) => index < children.length - 1
                  ? Column(
                      children: [
                        children[index],
                        Divider(
                          height: 1,
                          indent: AppSpacing.md + 24 + AppSpacing.md,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ],
                    )
                  : children[index],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
