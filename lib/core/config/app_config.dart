import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { dev, staging, prod }

bool? _parseBool(String? raw) {
  if (raw == null) return null;
  final v = raw.trim().toLowerCase();
  if (v.isEmpty) return null;
  if (v == 'true' || v == '1' || v == 'yes' || v == 'y') return true;
  if (v == 'false' || v == '0' || v == 'no' || v == 'n') return false;
  return null;
}

final class FeatureFlags {
  const FeatureFlags({
    required this.enableApplicationsModule,
    required this.enablePublicApplications,
  });

  final bool enableApplicationsModule;
  final bool enablePublicApplications;

  factory FeatureFlags.fromEnvironment(AppEnvironment env) {
    const enableApplicationsModuleDefine = String.fromEnvironment(
      'ENABLE_APPLICATIONS_MODULE',
    );
    const enablePublicApplicationsDefine = String.fromEnvironment(
      'ENABLE_PUBLIC_APPLICATIONS',
    );

    final enableApplicationsModule = _parseBool(
          enableApplicationsModuleDefine.trim().isNotEmpty
              ? enableApplicationsModuleDefine
              : dotenv.env['ENABLE_APPLICATIONS_MODULE'],
        ) ??
        true;

    final enablePublicApplications = _parseBool(
          enablePublicApplicationsDefine.trim().isNotEmpty
              ? enablePublicApplicationsDefine
              : dotenv.env['ENABLE_PUBLIC_APPLICATIONS'],
        ) ??
        true;

    return FeatureFlags(
      enableApplicationsModule: enableApplicationsModule,
      enablePublicApplications: enablePublicApplications,
    );
  }
}

final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.enableCrashReporting,
    required this.enableDebugLogs,
    required this.featureFlags,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableCrashReporting;
  final bool enableDebugLogs;
  final FeatureFlags featureFlags;

  bool get isProd => environment == AppEnvironment.prod;

  bool get isSupabaseConfigured =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static AppEnvironment _parseEnv(String value) {
    switch (value.trim().toLowerCase()) {
      case 'prod':
      case 'production':
        return AppEnvironment.prod;
      case 'stage':
      case 'staging':
        return AppEnvironment.staging;
      case 'dev':
      default:
        return AppEnvironment.dev;
    }
  }

  factory AppConfig.fromEnvironment() {
    const envDefine = String.fromEnvironment('APP_ENV');
    final envRaw = envDefine.trim().isNotEmpty
        ? envDefine
        : (dotenv.env['APP_ENV'] ?? 'dev');
    final environment = _parseEnv(envRaw);

    const apiBaseUrlDefine = String.fromEnvironment('API_BASE_URL');
    final apiBaseUrl = apiBaseUrlDefine.trim().isNotEmpty
        ? apiBaseUrlDefine
        : (dotenv.env['API_BASE_URL'] ?? '');

    const supabaseUrlDefine = String.fromEnvironment('SUPABASE_URL');
    final supabaseUrl = supabaseUrlDefine.trim().isNotEmpty
        ? supabaseUrlDefine
        : (dotenv.env['SUPABASE_URL'] ?? '');

    const supabaseAnonKeyDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
    final supabaseAnonKey = supabaseAnonKeyDefine.trim().isNotEmpty
        ? supabaseAnonKeyDefine
        : (dotenv.env['SUPABASE_ANON_KEY'] ?? '');

    const enableCrashReportingDefine = String.fromEnvironment(
      'ENABLE_CRASH_REPORTING',
    );
    final enableCrashReporting =
        _parseBool(
          enableCrashReportingDefine.trim().isNotEmpty
              ? enableCrashReportingDefine
              : dotenv.env['ENABLE_CRASH_REPORTING'],
        ) ??
        false;

    const enableDebugLogsDefine = String.fromEnvironment('ENABLE_DEBUG_LOGS');
    final enableDebugLogsDefault =
        !kReleaseMode && environment != AppEnvironment.prod;
    final enableDebugLogs =
        _parseBool(
          enableDebugLogsDefine.trim().isNotEmpty
              ? enableDebugLogsDefine
              : dotenv.env['ENABLE_DEBUG_LOGS'],
        ) ??
        enableDebugLogsDefault;

    final featureFlags = FeatureFlags.fromEnvironment(environment);

    return AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      enableCrashReporting: enableCrashReporting,
      enableDebugLogs: enableDebugLogs,
      featureFlags: featureFlags,
    );
  }
}
