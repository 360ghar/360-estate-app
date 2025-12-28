import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/handle_auth_redirect_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/observe_auth_state_usecase.dart';
import 'package:estate_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController({
    required AppConfig config,
    required GetCurrentUserUseCase getCurrentUser,
    required ObserveAuthStateUseCase observeAuthState,
    required SignOutUseCase signOut,
    required HandleAuthRedirectUseCase handleAuthRedirect,
    required DeepLinkService deepLinks,
  }) : _config = config,
       _getCurrentUser = getCurrentUser,
       _observeAuthState = observeAuthState,
       _signOut = signOut,
       _handleAuthRedirect = handleAuthRedirect,
       _deepLinks = deepLinks;

  final AppConfig _config;
  final GetCurrentUserUseCase _getCurrentUser;
  final ObserveAuthStateUseCase _observeAuthState;
  final SignOutUseCase _signOut;
  final HandleAuthRedirectUseCase _handleAuthRedirect;
  final DeepLinkService _deepLinks;

  final Rx<ViewState<AuthUser?>> state =
      const ViewState<AuthUser?>.loading().obs;

  StreamSubscription<AuthUser?>? _authSub;
  StreamSubscription<Uri>? _deepLinkSub;

  bool get isConfigured => _config.isSupabaseConfigured;
  bool get isAuthenticated => state.value.data != null;

  @override
  void onInit() {
    super.onInit();
    unawaited(_init());
  }

  Future<void> signOut() async {
    await _signOut();
  }

  Future<void> _init() async {
    if (!_config.isSupabaseConfigured) {
      state.value = ViewState.error(
        const UnknownFailure('Missing Supabase configuration'),
      );
      if (Get.currentRoute == Routes.splash) {
        unawaited(Get.offAllNamed<void>(Routes.enterPhone));
      }
      return;
    }

    try {
      final user = await _getCurrentUser();
      state.value = user == null
          ? const ViewState<AuthUser?>.empty()
          : ViewState<AuthUser?>.success(user);
    } catch (e, st) {
      AppLogger.w('Failed to read current user', error: e, stackTrace: st);
      state.value = const ViewState<AuthUser?>.empty();
    }

    await _authSub?.cancel();
    _authSub = _observeAuthState().listen(
      (user) {
        state.value = user == null
            ? const ViewState<AuthUser?>.empty()
            : ViewState<AuthUser?>.success(user);

        final current = Get.currentRoute;
        if (user == null) {
          if (current != Routes.enterPhone &&
              current != Routes.login &&
              current != Routes.signup) {
            unawaited(Get.offAllNamed<void>(Routes.enterPhone));
          }
          return;
        }

        if (current == Routes.enterPhone ||
            current == Routes.login ||
            current == Routes.signup ||
            current == Routes.splash) {
          unawaited(Get.offAllNamed<void>(Routes.home));
        }
      },
      onError: (Object e, StackTrace st) {
        AppLogger.w('Auth state stream error', error: e, stackTrace: st);
      },
    );

    await _deepLinkSub?.cancel();
    _deepLinkSub = _deepLinks.uriStream.listen((uri) async {
      final ok = await _handleAuthRedirect(uri);
      if (!ok) return;
      final current = Get.currentRoute;
      if (current == Routes.splash ||
          current == Routes.enterPhone ||
          current == Routes.login ||
          current == Routes.signup) {
        if (isAuthenticated) {
          unawaited(Get.offAllNamed<void>(Routes.home));
        }
      }
    });
  }

  @override
  void onClose() {
    final authSub = _authSub;
    if (authSub != null) unawaited(authSub.cancel());

    final deepLinkSub = _deepLinkSub;
    if (deepLinkSub != null) unawaited(deepLinkSub.cancel());

    super.onClose();
  }
}
