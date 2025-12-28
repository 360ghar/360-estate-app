import 'dart:async';

import 'package:estate_app/app/app.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/config/env_loader.dart';
import 'package:estate_app/core/crash_reporting/crash_reporter.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final envLoaded = await EnvLoader.load();

  final config = AppConfig.fromEnvironment();
  AppLogger.init(config);
  if (!envLoaded) {
    AppLogger.w('No .env asset found; falling back to --dart-define values');
  }

  final preferences = await AppPreferences.create();
  final secureStore = SecureKvStore();

  final CrashReporter crashReporter = config.enableCrashReporting
      ? ConsoleCrashReporter()
      : NoopCrashReporter();
  await crashReporter.init();
  CrashReporterGuard(crashReporter).install();

  Get
    ..put<AppConfig>(config, permanent: true)
    ..put<AppPreferences>(preferences, permanent: true)
    ..put<SecureKvStore>(secureStore, permanent: true)
    ..put<CrashReporter>(crashReporter, permanent: true);

  await runZonedGuarded(
    () async {
      if (config.isSupabaseConfigured) {
        await Supabase.initialize(
          url: config.supabaseUrl,
          anonKey: config.supabaseAnonKey,
          debug: config.enableDebugLogs,
          authOptions: const FlutterAuthClientOptions(
            detectSessionInUri: false,
          ),
        );
      }

      Get.put<DeepLinkService>(DeepLinkService(), permanent: true);

      runApp(const App());
    },
    (error, stackTrace) {
      unawaited(
        crashReporter.recordError(
          error,
          stackTrace,
          fatal: true,
          reason: 'runZonedGuarded',
        ),
      );
    },
  );
}
