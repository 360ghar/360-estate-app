import 'dart:async';

import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The one privacy choice the app acts on (crash reports, read by bootstrap
/// at launch) and the legal texts.
class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrivacy)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          LinkGroup(
            title: l10n.privacyDiagnosticsTitle,
            children: [
              SwitchListTile(
                title: Text(l10n.privacyCrashTitle),
                subtitle: Text(l10n.privacyCrashDesc),
                value: ref.watch(crashReportsProvider),
                onChanged: (v) =>
                    ref.read(crashReportsProvider.notifier).state = v,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.legal,
            children: [
              LinkRow(
                icon: Icons.policy_outlined,
                title: l10n.legalPrivacyPolicy,
                onTap: () => context.push(Routes.privacyPolicy),
              ),
              LinkRow(
                icon: Icons.description_outlined,
                title: l10n.legalTerms,
                onTap: () => context.push(Routes.termsOfService),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Whether crash reports are on. Stored as a bool: bootstrap reads it with
/// `getBool` before the first frame.
final crashReportsProvider = NotifierProvider<CrashReportsNotifier, bool>(
  CrashReportsNotifier.new,
);

class CrashReportsNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(appPreferencesProvider);
    try {
      return prefs.getBool(PrefKeys.crashReportingEnabled) ?? false;
    } on TypeError {
      // Older builds stored the text 'true' / 'false'. Rewrite it as a bool.
      final legacy = prefs.getString(PrefKeys.crashReportingEnabled) == 'true';
      unawaited(prefs.setBool(PrefKeys.crashReportingEnabled, legacy));
      return legacy;
    }
  }

  @override
  set state(bool on) {
    super.state = on;
    unawaited(
      ref
          .read(appPreferencesProvider)
          .setBool(PrefKeys.crashReportingEnabled, on),
    );
  }
}
