import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/crash_reporting/crash_reporter.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig must be overridden in bootstrap.');
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  throw UnimplementedError('AppPreferences must be overridden in bootstrap.');
});

final secureStoreProvider = Provider<SecureKvStore>((ref) {
  throw UnimplementedError('SecureKvStore must be overridden in bootstrap.');
});

final crashReporterProvider = Provider<CrashReporter>((ref) {
  throw UnimplementedError('CrashReporter must be overridden in bootstrap.');
});

final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

final cacheStoreProvider = Provider<CacheStore>((ref) => CacheStore());

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage(ref.read(secureStoreProvider));
});

final authTokenProvider = Provider<AuthTokenProvider>((ref) {
  final storage = ref.read(authTokenStorageProvider);
  return RefreshingAuthTokenProvider(storage);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.read(appConfigProvider);
  return ApiClient(
    baseUrl: config.apiBaseUrl,
    networkInfo: ref.read(networkInfoProvider),
    tokenProvider: ref.read(authTokenProvider),
    enableLogging: config.enableDebugLogs,
  );
});

final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  return FileUploadService(ref.read(apiClientProvider));
});

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService();
  ref.onDispose(service.dispose);
  return service;
});
