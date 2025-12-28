import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:estate_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:estate_app/features/auth/domain/usecases/check_phone_registered_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/handle_auth_redirect_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/observe_auth_state_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/sign_in_with_phone_password_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/sign_up_with_phone_password_usecase.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/controllers/enter_phone_controller.dart';
import 'package:estate_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:estate_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  AuthBindings();

  @override
  void dependencies() {
    void lazyPutIfAbsent<T>(T Function() builder) {
      if (Get.isRegistered<T>()) return;
      Get.lazyPut<T>(builder, fenix: true);
    }

    lazyPutIfAbsent<SupabaseAuthDataSource>(SupabaseAuthDataSourceImpl.new);
    lazyPutIfAbsent<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<SupabaseAuthDataSource>()),
    );
    lazyPutIfAbsent<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<ObserveAuthStateUseCase>(
      () => ObserveAuthStateUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<SignInWithPhonePasswordUseCase>(
      () => SignInWithPhonePasswordUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<SignUpWithPhonePasswordUseCase>(
      () => SignUpWithPhonePasswordUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<SignOutUseCase>(
      () => SignOutUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<CheckPhoneRegisteredUseCase>(
      () => CheckPhoneRegisteredUseCase(Get.find<AuthRepository>()),
    );
    lazyPutIfAbsent<HandleAuthRedirectUseCase>(
      () => HandleAuthRedirectUseCase(Get.find<AuthRepository>()),
    );

    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          config: Get.find<AppConfig>(),
          getCurrentUser: Get.find<GetCurrentUserUseCase>(),
          observeAuthState: Get.find<ObserveAuthStateUseCase>(),
          signOut: Get.find<SignOutUseCase>(),
          handleAuthRedirect: Get.find<HandleAuthRedirectUseCase>(),
          deepLinks: Get.find<DeepLinkService>(),
        ),
        permanent: true,
      );
    }

    lazyPutIfAbsent<EnterPhoneController>(
      () => EnterPhoneController(
        config: Get.find<AppConfig>(),
        checkPhoneRegistered: Get.find<CheckPhoneRegisteredUseCase>(),
      ),
    );
    lazyPutIfAbsent<LoginController>(
      () => LoginController(
        config: Get.find<AppConfig>(),
        signIn: Get.find<SignInWithPhonePasswordUseCase>(),
      ),
    );
    lazyPutIfAbsent<SignupController>(
      () => SignupController(
        config: Get.find<AppConfig>(),
        signUp: Get.find<SignUpWithPhonePasswordUseCase>(),
      ),
    );
  }
}
