import 'package:estate_app/app/router/routes.dart';

/// 3-state router guard. Pure function, unit-testable.
/// Only states: checking | unauthenticated | authenticated.
String? resolveRedirect({
  required String location,
  required bool isChecking,
  required bool isLoggedIn,
  required bool enablePublicApplications,
  required bool enableApplicationsModule,
  String? pendingPath,
}) {
  final isSplash = location == Routes.splash;
  final isAddPhone = location == Routes.addPhone;
  final isSetPassword = location == Routes.setPassword;
  final isProfileCompletion = location == Routes.profileCompletion;
  final isOnboarding = location == Routes.onboarding;
  final isAuthRoute =
      location == Routes.enterPhone ||
      location == Routes.login ||
      location == Routes.otp ||
      location == Routes.signup ||
      isAddPhone ||
      isSetPassword ||
      isProfileCompletion ||
      isOnboarding;
  final isPublicRoute =
      location.startsWith('/public') || location.startsWith('/legal/');
  final isApplicationsRoute = location.startsWith(Routes.applications);

  if (isPublicRoute) {
    if (!enablePublicApplications) {
      if (!isLoggedIn) return Routes.enterPhone;
      return Routes.home;
    }
    return null;
  }

  if (isChecking) {
    return isSplash ? null : Routes.splash;
  }

  if (isLoggedIn && !isSplash && !isAuthRoute) {
    if (pendingPath != null && pendingPath != location) {
      return pendingPath;
    }
  }

  if (!isLoggedIn) {
    return isAuthRoute ? null : Routes.enterPhone;
  }

  // 3-state model: no mandatory interstitial gates.

  if (!enableApplicationsModule && isApplicationsRoute) {
    return Routes.more;
  }

  if (isAuthRoute || isSplash) {
    return Routes.home;
  }

  return null;
}
