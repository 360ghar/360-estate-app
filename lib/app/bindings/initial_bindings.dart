import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/features/auth/data/datasources/backend_auth_data_source.dart';
import 'package:estate_app/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:estate_app/features/settings/presentation/bindings/settings_bindings.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  InitialBindings();

  @override
  void dependencies() {
    final config = Get.find<AppConfig>();

    Get.put<NetworkInfo>(NetworkInfoImpl(), permanent: true);

    // Register backend auth data source first (needed by CompositeAuthTokenProvider)
    Get.put<BackendAuthDataSource>(
      BackendAuthDataSourceImpl(apiClient: ApiClient(
        baseUrl: config.apiBaseUrl,
        networkInfo: NetworkInfoImpl(),
        tokenProvider: const SupabaseAuthTokenProvider(), // Use Supabase token for backend login itself
        enableLogging: config.enableDebugLogs,
      )),
      permanent: true,
    );

    // Use composite token provider that supports both Supabase and backend tokens
    Get.put<AuthTokenProvider>(
      CompositeAuthTokenProvider(
        backendAuth: Get.find<BackendAuthDataSource>(),
      ),
      permanent: true,
    );

    Get.put<ApiClient>(
      ApiClient(
        baseUrl: config.apiBaseUrl,
        networkInfo: Get.find<NetworkInfo>(),
        tokenProvider: Get.find<AuthTokenProvider>(),
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
