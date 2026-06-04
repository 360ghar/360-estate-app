import 'dart:async';

import 'package:estate_app/app/app.dart';
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

      final config = AppConfig.fromEnvironment();
      AppLogger.init(config);
      if (!envLoaded) {
        AppLogger.w('No .env asset found; falling back to --dart-define values');
      }

      if (!config.isSupabaseConfigured) {
        throw StateError(
          'Missing SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY for auth/session handling.',
        );
      }
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseAnonKey,
      );

      final preferences = await AppPreferences.create();
      final secureStore = SecureKvStore();

      crashReporter = config.enableCrashReporting
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
