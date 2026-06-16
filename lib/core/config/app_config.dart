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

    final enableApplicationsModule =
        _parseBool(
          enableApplicationsModuleDefine.trim().isNotEmpty
              ? enableApplicationsModuleDefine
              : dotenv.env['ENABLE_APPLICATIONS_MODULE'],
        ) ??
        true;

    final enablePublicApplications =
        _parseBool(
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
    this.googlePlacesApiKey = '',
    this.googleWebClientId = '',
    this.googleIosClientId = '',
  });

  final AppEnvironment environment;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableCrashReporting;
  final bool enableDebugLogs;
  final FeatureFlags featureFlags;
  final String googlePlacesApiKey;

  /// Google OAuth Web client id. On Android this is used as the
  /// `serverClientId` for the native ID-token flow; it is also required for
  /// Supabase to validate the returned ID token.
  final String googleWebClientId;

  /// Google OAuth iOS client id, used as the `clientId` on iOS.
  final String googleIosClientId;

  bool get isProd => environment == AppEnvironment.prod;

  bool get isSupabaseConfigured =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  /// Google Sign-In can only be attempted when at least the web client id is
  /// configured (required as the Android `serverClientId` and for Supabase to
  /// validate the ID token). The iOS client id is additionally required on iOS.
  bool get isGoogleSignInConfigured => googleWebClientId.trim().isNotEmpty;

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

    const supabasePublishableKeyDefine = String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    );
    const supabaseAnonKeyDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
    final supabaseAnonKey = supabasePublishableKeyDefine.trim().isNotEmpty
        ? supabasePublishableKeyDefine
        : (supabaseAnonKeyDefine.trim().isNotEmpty
              ? supabaseAnonKeyDefine
              : (dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ??
                    dotenv.env['SUPABASE_ANON_KEY'] ??
                    ''));

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

    const googlePlacesApiKeyDefine = String.fromEnvironment(
      'GOOGLE_PLACES_API_KEY',
    );
    final googlePlacesApiKey = googlePlacesApiKeyDefine.trim().isNotEmpty
        ? googlePlacesApiKeyDefine
        : (dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '');

    const googleWebClientIdDefine = String.fromEnvironment(
      'GOOGLE_WEB_CLIENT_ID',
    );
    final googleWebClientId = googleWebClientIdDefine.trim().isNotEmpty
        ? googleWebClientIdDefine
        : (dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '');

    const googleIosClientIdDefine = String.fromEnvironment(
      'GOOGLE_IOS_CLIENT_ID',
    );
    final googleIosClientId = googleIosClientIdDefine.trim().isNotEmpty
        ? googleIosClientIdDefine
        : (dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '');

    final featureFlags = FeatureFlags.fromEnvironment(environment);

    if (apiBaseUrl.trim().isEmpty) {
      throw StateError('Missing API_BASE_URL configuration.');
    }
    if (supabaseUrl.trim().isEmpty || supabaseAnonKey.trim().isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY configuration.',
      );
    }

    return AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      enableCrashReporting: enableCrashReporting,
      enableDebugLogs: enableDebugLogs,
      featureFlags: featureFlags,
      googlePlacesApiKey: googlePlacesApiKey,
      googleWebClientId: googleWebClientId,
      googleIosClientId: googleIosClientId,
    );
  }
}
