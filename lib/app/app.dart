import 'package:estate_app/app/router/app_router.dart';
import 'package:estate_app/core/presentation/theme/app_theme.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Start the deep link stream after the first frame so that the router
    // is registered with the provider. The router binding happens during
    // build, so we capture it lazily and replay any pending path.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final deepLinkService = ref.read(deepLinkServiceProvider);
      final router = ref.read(appRouterProvider);
      deepLinkService.bindRouter(router);
      deepLinkService.init();
    });
  }

  @override
  void dispose() {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: '360 Estate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: appLocale,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
