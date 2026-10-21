import 'package:estate_app/core/presentation/theme/app_theme.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shown instead of the app when the build has no Supabase settings
/// (`bootstrap.dart` mounts it before anything else starts). The settings are
/// bundled at build time, so a retry button could not help: the page says
/// what to fix, and [message] carries the exact missing value.
class ConfigErrorPage extends StatelessWidget {
  const ConfigErrorPage({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: SafeArea(
              child: AppErrorView(
                title: l10n.errorMissingConfigTitle,
                message: [
                  l10n.configErrorBody,
                  if (message != null && message!.trim().isNotEmpty) message!,
                ].join('\n\n'),
              ),
            ),
          );
        },
      ),
    );
  }
}
