import 'package:estate_app/app/bindings/initial_bindings.dart';
import 'package:estate_app/app/routes/app_pages.dart';
import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/theme/app_theme.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: Get.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      initialBinding: InitialBindings(),
    );
  }
}
