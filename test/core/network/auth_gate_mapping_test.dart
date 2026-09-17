import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapGateStageToAuthStatus', () {
    test('identifier_verification -> unauthenticated', () {
      expect(
        mapGateStageToAuthStatus('identifier_verification'),
        AuthStatus.unauthenticated,
      );
    });

    test('password_setup -> needsPassword (mandatory set-password gate)', () {
      expect(
        mapGateStageToAuthStatus('password_setup'),
        AuthStatus.needsPassword,
      );
    });

    test('profile_completion -> authenticated (in-app prompt, not gate)', () {
      expect(
        mapGateStageToAuthStatus('profile_completion'),
        AuthStatus.authenticated,
      );
    });

    test('app_onboarding -> authenticated (in-app prompt, not gate)', () {
      expect(
        mapGateStageToAuthStatus('app_onboarding'),
        AuthStatus.authenticated,
      );
    });

    test('active -> authenticated', () {
      expect(mapGateStageToAuthStatus('active'), AuthStatus.authenticated);
    });

    test('unknown stage defaults to authenticated (never lock out)', () {
      expect(mapGateStageToAuthStatus('bogus'), AuthStatus.authenticated);
      expect(mapGateStageToAuthStatus(''), AuthStatus.authenticated);
    });
  });
}
