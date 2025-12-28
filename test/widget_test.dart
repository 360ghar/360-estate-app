import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:estate_app/features/auth/domain/usecases/check_phone_registered_usecase.dart';
import 'package:estate_app/features/auth/presentation/controllers/enter_phone_controller.dart';
import 'package:estate_app/features/auth/presentation/pages/enter_phone_page.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('EnterPhonePage shows config error without Supabase keys', (
    WidgetTester tester,
  ) async {
    Get.testMode = true;
    Get.reset();

    const config = AppConfig(
      environment: AppEnvironment.dev,
      apiBaseUrl: '',
      supabaseUrl: '',
      supabaseAnonKey: '',
      enableCrashReporting: false,
      enableDebugLogs: true,
      featureFlags: FeatureFlags(
        enablePublicApplications: true,
      ),
    );

    Get.put<AppConfig>(config);
    Get.put<EnterPhoneController>(
      EnterPhoneController(
        config: config,
        checkPhoneRegistered: CheckPhoneRegisteredUseCase(
          _FakeAuthRepository(),
        ),
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const EnterPhonePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App configuration missing'), findsOneWidget);
  });
}

final class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Stream<AuthUser?> observeAuthState() async* {
    yield null;
  }

  @override
  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<bool?> isPhoneRegistered(String phone) async => null;

  @override
  Future<bool> handleAuthRedirect(Uri uri) async => false;
}
