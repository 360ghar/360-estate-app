import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapGateStageToAuthStatus', () {
    test('identifier_verification -> unauthenticated', () {
      expect(
        mapGateStageToAuthStatus(AuthGateStage.identifierVerification),
        AuthStatus.unauthenticated,
      );
    });

    test('password_setup -> needsPassword (mandatory set-password gate)', () {
      expect(
        mapGateStageToAuthStatus(AuthGateStage.passwordSetup),
        AuthStatus.needsPassword,
      );
    });

    test('profile_completion -> authenticated (in-app prompt, not gate)', () {
      expect(
        mapGateStageToAuthStatus(AuthGateStage.profileCompletion),
        AuthStatus.authenticated,
      );
    });

    test('app_onboarding -> authenticated (in-app prompt, not gate)', () {
      expect(
        mapGateStageToAuthStatus(AuthGateStage.appOnboarding),
        AuthStatus.authenticated,
      );
    });

    test('active -> authenticated', () {
      expect(
        mapGateStageToAuthStatus(AuthGateStage.active),
        AuthStatus.authenticated,
      );
    });

    test('unknown stage reads as null and enters the app (never lock out)', () {
      expect(AuthGateStage.fromJson('bogus'), isNull);
      expect(
        mapGateStageToAuthStatus(AuthGateStage.fromJson('bogus')),
        AuthStatus.authenticated,
      );
      expect(mapGateStageToAuthStatus(null), AuthStatus.authenticated);
    });
  });
}
