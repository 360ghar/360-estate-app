import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:estate_app/features/settings/data/datasources/user_profile_data_source.dart';
import 'package:estate_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:estate_app/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:estate_app/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:estate_app/features/settings/domain/usecases/get_locale_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/set_locale_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:estate_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBindings extends Bindings {
  SettingsBindings();

  @override
  void dependencies() {
    void lazyPutIfAbsent<T>(T Function() builder) {
      if (Get.isRegistered<T>()) return;
      Get.lazyPut<T>(builder, fenix: true);
    }

    // Settings local data source
    lazyPutIfAbsent<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(Get.find<AppPreferences>()),
    );
    lazyPutIfAbsent<SettingsRepository>(
      () => SettingsRepositoryImpl(Get.find<SettingsLocalDataSource>()),
    );

    // User profile data source (backend API)
    lazyPutIfAbsent<UserProfileDataSource>(
      () => UserProfileDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    lazyPutIfAbsent<UserProfileRepository>(
      () => UserProfileRepositoryImpl(Get.find<UserProfileDataSource>()),
    );

    // Use cases
    lazyPutIfAbsent<GetThemeModeUseCase>(
      () => GetThemeModeUseCase(Get.find<SettingsRepository>()),
    );
    lazyPutIfAbsent<SetThemeModeUseCase>(
      () => SetThemeModeUseCase(Get.find<SettingsRepository>()),
    );
    lazyPutIfAbsent<GetLocaleUseCase>(
      () => GetLocaleUseCase(Get.find<SettingsRepository>()),
    );
    lazyPutIfAbsent<SetLocaleUseCase>(
      () => SetLocaleUseCase(Get.find<SettingsRepository>()),
    );

    if (!Get.isRegistered<SettingsController>()) {
      Get.put<SettingsController>(
        SettingsController(
          getThemeMode: Get.find<GetThemeModeUseCase>(),
          setThemeMode: Get.find<SetThemeModeUseCase>(),
          getLocale: Get.find<GetLocaleUseCase>(),
          setLocale: Get.find<SetLocaleUseCase>(),
          profileRepository: Get.find<UserProfileRepository>(),
        ),
        permanent: true,
      );
    }
  }
}
