import 'dart:async';

import 'package:estate_app/app/app.dart';
import 'package:estate_app/app/config_error_page.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/config/env_loader.dart';
import 'package:estate_app/core/crash_reporting/crash_reporter.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  CrashReporter? crashReporter;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final envLoaded = await EnvLoader.load();

      // fromEnvironment throws StateError on missing values (fresh checkout
      // with an empty .env). Mount the config-error UI instead of dying
      // before first frame in the zoned error handler.
      late final AppConfig config;
      try {
        config = AppConfig.fromEnvironment();
      } on StateError catch (e) {
        runApp(ConfigErrorPage(message: e.message));
        return;
      }
      AppLogger.init(config);
      if (!envLoaded) {
        AppLogger.w(
          'No .env asset found; falling back to --dart-define values',
        );
      }

      if (!config.isSupabaseConfigured) {
        runApp(
          const ConfigErrorPage(
            message:
                'SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY is empty.\n'
                'Copy .env.example to .env and fill the values,\n'
                'then restart the app.',
          ),
        );
        return;
      }
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabasePublishableKey,
      );

      final preferences = await AppPreferences.create();
      final secureStore = SecureKvStore();

      // Crash reporting can be enabled via env (`ENABLE_CRASH_REPORTING`) or
      // toggled by the user in Privacy settings (persisted preference).
      final crashReportingEnabled =
          config.enableCrashReporting ||
          preferences.getBool(PrefKeys.crashReportingEnabled) == true;
      crashReporter = crashReportingEnabled
          ? ConsoleCrashReporter()
          : NoopCrashReporter();
      await crashReporter!.init();
      CrashReporterGuard(crashReporter!).install();

      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            appPreferencesProvider.overrideWithValue(preferences),
            secureStoreProvider.overrideWithValue(secureStore),
            crashReporterProvider.overrideWithValue(crashReporter!),
          ],
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      final reporter = crashReporter ?? NoopCrashReporter();
      unawaited(
        reporter.recordError(
          error,
          stackTrace,
          fatal: true,
          reason: 'runZonedGuarded',
        ),
      );
    },
  );
}
