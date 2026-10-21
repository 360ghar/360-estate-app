import 'package:estate_app/app/router/guards.dart';
import 'package:flutter_test/flutter_test.dart';

String? go({
  String location = '/home',
  bool isChecking = false,
  bool isLoggedIn = false,
  String? gateRoute,
  bool enablePublicApplications = true,
  bool enableApplicationsModule = true,
  String? pendingPath,
}) => resolveRedirect(
  location: location,
  isChecking: isChecking,
  isLoggedIn: isLoggedIn,
  gateRoute: gateRoute,
  enablePublicApplications: enablePublicApplications,
  enableApplicationsModule: enableApplicationsModule,
  pendingPath: pendingPath,
);

void main() {
  group('resolveRedirect', () {
    test('checking goes to splash unless already there', () {
      expect(go(isChecking: true), '/splash');
      expect(go(location: '/splash', isChecking: true), isNull);
    });

    test('enabled public links render while checking (link is not queued)', () {
      expect(
        go(location: '/public/applications/some-slug', isChecking: true),
        isNull,
      );
    });

    test('checking wins over disabled public applications (no auth flash)', () {
      expect(
        go(
          location: '/public/applications/some-slug',
          isChecking: true,
          enablePublicApplications: false,
        ),
        '/splash',
      );
    });

    test('logged out goes to enter-phone unless on auth route', () {
      expect(go(), '/enter-phone');
      expect(go(location: '/login'), isNull);
      expect(go(location: '/otp'), isNull);
      expect(go(location: '/signup'), isNull);
    });

    test('logged out on a gate screen goes back to enter-phone', () {
      for (final loc in [
        '/set-password',
        '/add-phone',
        '/profile-completion',
        '/onboarding',
      ]) {
        expect(go(location: loc), '/enter-phone', reason: loc);
      }
    });

    test('legal routes always bypass every gate', () {
      for (final loggedIn in [false, true]) {
        for (final flagOn in [true, false]) {
          for (final checking in [false, true]) {
            expect(
              go(
                location: '/legal/privacy-policy',
                isLoggedIn: loggedIn,
                enablePublicApplications: flagOn,
                isChecking: checking,
              ),
              isNull,
              reason: 'loggedIn=$loggedIn flagOn=$flagOn checking=$checking',
            );
          }
        }
      }
    });

    test('disabled public applications gate by flag and auth', () {
      // Flag off + logged out -> enter-phone.
      expect(
        go(location: '/public/applications/x', enablePublicApplications: false),
        '/enter-phone',
      );
      // Flag off + logged in -> home.
      expect(
        go(
          location: '/public/applications/x',
          isLoggedIn: true,
          enablePublicApplications: false,
        ),
        '/home',
      );
      // Flag on -> render for anyone (even logged out).
      expect(go(location: '/public/applications/x'), isNull);
      expect(go(location: '/public/applications/x/success'), isNull);
    });

    test('a gate route pins the user to its screen', () {
      const gates = {
        'set-password': '/set-password',
        'add-phone': '/add-phone',
        'profile-completion': '/profile-completion',
        'onboarding': '/onboarding',
      };
      for (final gate in gates.values) {
        // From anywhere app-side -> the gate screen.
        expect(go(isLoggedIn: true, gateRoute: gate), gate);
        expect(
          go(location: '/splash', isLoggedIn: true, gateRoute: gate),
          gate,
        );
        // Already there -> stay.
        expect(go(location: gate, isLoggedIn: true, gateRoute: gate), isNull);
        // Deep links do not replay during a gate step.
        expect(
          go(
            location: gate,
            isLoggedIn: true,
            gateRoute: gate,
            pendingPath: '/tasks/42',
          ),
          isNull,
        );
      }
    });

    test('logged in without a gate leaves the auth screens for home', () {
      for (final loc in [
        '/enter-phone',
        '/login',
        '/add-phone',
        '/profile-completion',
        '/onboarding',
        '/splash',
      ]) {
        expect(go(location: loc, isLoggedIn: true), '/home', reason: loc);
      }
    });

    test('logged in on app route stays, pending deep link replays', () {
      expect(go(isLoggedIn: true), isNull);
      expect(go(isLoggedIn: true, pendingPath: '/tasks/42'), '/tasks/42');
      // Pending equal to current location is a no-op (already there).
      expect(
        go(location: '/tasks/42', isLoggedIn: true, pendingPath: '/tasks/42'),
        isNull,
      );
    });

    test('disabled applications module redirects applications routes', () {
      expect(
        go(
          location: '/more/applications',
          isLoggedIn: true,
          enableApplicationsModule: false,
        ),
        '/more',
      );
      expect(
        go(
          location: '/more/applications/42',
          isLoggedIn: true,
          enableApplicationsModule: false,
        ),
        '/more',
      );
      // Flag on -> render.
      expect(go(location: '/more/applications', isLoggedIn: true), isNull);
    });
  });
}
