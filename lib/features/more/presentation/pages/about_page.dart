import 'dart:async';

import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart'
    show AuthLogo;
import 'package:estate_app/features/more/presentation/pages/contact_support_page.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// The app, its version, the legal texts, and how to reach 360Ghar.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static const _website = 'https://360ghar.com';

  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _info = info);
  }

  Future<void> _launch(Uri uri) async {
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) context.showSnack(context.l10n.legalOpenFailed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info = _info;
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          const Center(child: AuthLogo(height: 72)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.appName,
            textAlign: TextAlign.center,
            style: context.text.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.aboutTagline,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          if (info != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.aboutVersion(info.version, info.buildNumber),
              textAlign: TextAlign.center,
              style: muted,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          LinkGroup(
            title: l10n.legal,
            children: [
              LinkRow(
                icon: Icons.description_outlined,
                title: l10n.legalTerms,
                onTap: () => context.push(Routes.termsOfService),
              ),
              LinkRow(
                icon: Icons.policy_outlined,
                title: l10n.legalPrivacyPolicy,
                onTap: () => context.push(Routes.privacyPolicy),
              ),
              LinkRow(
                icon: Icons.code_rounded,
                title: l10n.aboutLicenses,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appName,
                  applicationVersion: info?.version,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.aboutContactTitle,
            children: [
              LinkRow(
                icon: Icons.language_rounded,
                title: l10n.website,
                subtitle: '360ghar.com',
                trailing: const ExcludeSemantics(
                  child: Icon(Icons.open_in_new_rounded, size: 20),
                ),
                onTap: () => _launch(Uri.parse(_website)),
              ),
              LinkRow(
                icon: Icons.mail_outline_rounded,
                title: l10n.profileEmail,
                subtitle: kSupportEmail,
                trailing: const ExcludeSemantics(
                  child: Icon(Icons.open_in_new_rounded, size: 20),
                ),
                onTap: () =>
                    _launch(Uri(scheme: 'mailto', path: kSupportEmail)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.aboutMadeFor, textAlign: TextAlign.center, style: muted),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.aboutCopyright('${DateTime.now().year}'),
            textAlign: TextAlign.center,
            style: muted,
          ),
        ],
      ),
    );
  }
}
