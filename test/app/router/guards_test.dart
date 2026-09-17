import 'package:estate_app/app/router/guards.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveRedirect 3-state', () {
    test('checking goes to splash unless already there', () {
      expect(
        resolveRedirect(
          location: '/home',
          isChecking: true,
          isLoggedIn: false,
          enablePublicApplications: true,
          enableApplicationsModule: true,
        ),
        '/splash',
      );
      expect(
        resolveRedirect(
          location: '/splash',
          isChecking: true,
          isLoggedIn: false,
          enablePublicApplications: true,
          enableApplicationsModule: true,
        ),
        isNull,
      );
    });

    test('logged out goes to enter-phone unless on auth route', () {
      expect(
        resolveRedirect(
          location: '/home',
          isChecking: false,
          isLoggedIn: false,
          enablePublicApplications: true,
          enableApplicationsModule: true,
        ),
        '/enter-phone',
      );
      expect(
        resolveRedirect(
          location: '/login',
          isChecking: false,
          isLoggedIn: false,
          enablePublicApplications: true,
          enableApplicationsModule: true,
        ),
        isNull,
      );
    });

    test('logged in on auth route goes home, no interstitial gates', () {
      for (final loc in [
        '/enter-phone',
        '/login',
        '/add-phone',
        '/set-password',
        '/profile-completion',
        '/onboarding',
        '/splash',
      ]) {
        expect(
          resolveRedirect(
            location: loc,
            isChecking: false,
            isLoggedIn: true,
            enablePublicApplications: true,
            enableApplicationsModule: true,
          ),
          '/home',
          reason: loc,
        );
      }
    });

    test('logged in on app route stays, pending deep link replays', () {
      expect(
        resolveRedirect(
          location: '/home',
          isChecking: false,
          isLoggedIn: true,
          enablePublicApplications: true,
          enableApplicationsModule: true,
        ),
        isNull,
      );
      expect(
        resolveRedirect(
          location: '/home',
          isChecking: false,
          isLoggedIn: true,
          enablePublicApplications: true,
          enableApplicationsModule: true,
          pendingPath: '/tasks/42',
        ),
        '/tasks/42',
      );
    });
  });
}
