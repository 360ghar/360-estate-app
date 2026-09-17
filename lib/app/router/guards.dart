import 'package:estate_app/app/router/routes.dart';

/// Router guard. Pure function, unit-testable.
///
/// States: checking | unauthenticated | needsPassword | authenticated.
/// Phone, profile-completion, and onboarding are in-app prompts, not gates:
/// an authenticated user reaches the app and the shell surfaces the prompts.
String? resolveRedirect({
  required String location,
  required bool isChecking,
  required bool isLoggedIn,
  required bool needsPassword,
  required bool enablePublicApplications,
  required bool enableApplicationsModule,
  String? pendingPath,
}) {
  final isSplash = location == Routes.splash;
  final isSetPassword = location == Routes.setPassword;
  final isAuthRoute =
      location == Routes.enterPhone ||
      location == Routes.login ||
      location == Routes.otp ||
      location == Routes.signup ||
      location == Routes.addPhone ||
      isSetPassword ||
      location == Routes.profileCompletion ||
      location == Routes.onboarding;

  // Legal consent pages must always render — even logged out and even when
  // public applications are disabled (sign-up consent links live on the
  // entry screens).
  if (location.startsWith('/legal/')) {
    return null;
  }

  // Checking wins over everything else: never flash the auth screen for a
  // restorable session while the gate state is still loading.
  if (isChecking) {
    return isSplash ? null : Routes.splash;
  }

  if (location.startsWith('/public')) {
    if (!enablePublicApplications) {
      return isLoggedIn ? Routes.home : Routes.enterPhone;
    }
    return null;
  }

  if (!isLoggedIn) {
    return isAuthRoute ? null : Routes.enterPhone;
  }

  // Mandatory set-password (req 6): an OTP-verified account without a
  // password must set one before entering the app. Non-skippable; backing
  // out signs the user out.
  if (needsPassword) {
    return isSetPassword ? null : Routes.setPassword;
  }

  // Replay a queued deep link once it can actually be served.
  if (!isSplash && !isAuthRoute) {
    if (pendingPath != null && pendingPath != location) {
      return pendingPath;
    }
  }

  if (!enableApplicationsModule && location.startsWith(Routes.applications)) {
    return Routes.more;
  }

  if (isAuthRoute || isSplash) {
    return Routes.home;
  }

  return null;
}
