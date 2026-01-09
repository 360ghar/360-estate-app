import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:estate_app/features/auth/data/datasources/backend_auth_data_source.dart';
import 'package:estate_app/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:estate_app/features/settings/presentation/bindings/settings_bindings.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  InitialBindings();

  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    final secureStore = Get.find<SecureKvStore>();

    // Register NetworkInfo first
    final networkInfo = NetworkInfoImpl();
    Get.put<NetworkInfo>(networkInfo, permanent: true);

    // Create shared ApiClient for backend authentication
    // This uses Supabase token for the initial backend login
    final authApiClient = ApiClient(
      baseUrl: config.apiBaseUrl,
      networkInfo: networkInfo,
      tokenProvider: const SupabaseAuthTokenProvider(),
      secureStore: secureStore,
      enableLogging: config.enableDebugLogs,
    );

    // Register backend auth data source with the shared client
    Get.put<BackendAuthDataSource>(
      BackendAuthDataSourceImpl(apiClient: authApiClient),
      permanent: true,
    );

    // Use composite token provider that supports both Supabase and backend tokens
    Get.put<AuthTokenProvider>(
      CompositeAuthTokenProvider(
        backendAuth: Get.find<BackendAuthDataSource>(),
      ),
      permanent: true,
    );

    // Register the main ApiClient with the composite token provider
    // This client will be used for all authenticated API calls
    Get.put<ApiClient>(
      ApiClient(
        baseUrl: config.apiBaseUrl,
        networkInfo: networkInfo,
        tokenProvider: Get.find<AuthTokenProvider>(),
        secureStore: secureStore,
        enableLogging: config.enableDebugLogs,
      ),
      permanent: true,
    );

    final deepLinks = Get.find<DeepLinkService>();
    deepLinks.start();

    SettingsBindings().dependencies();
    AuthBindings().dependencies();
  }
}
