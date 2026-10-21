import 'package:estate_app/app/router/routes.dart';

/// Router guard. Pure function, unit-testable.
///
/// States: checking | unauthenticated | gated | authenticated. A gated user
/// (set-password, add-phone, profile-completion, onboarding) is held on
/// [gateRoute] until that step completes.
String? resolveRedirect({
  required String location,
  required bool isChecking,
  required bool isLoggedIn,
  String? gateRoute,
  required bool enablePublicApplications,
  required bool enableApplicationsModule,
  String? pendingPath,
}) {
  final isSplash = location == Routes.splash;
  // Entry screens a signed-out user may see.
  final isEntryRoute =
      location == Routes.enterPhone ||
      location == Routes.login ||
      location == Routes.otp ||
      location == Routes.signup;
  final isAuthRoute =
      isEntryRoute ||
      location == Routes.addPhone ||
      location == Routes.setPassword ||
      location == Routes.profileCompletion ||
      location == Routes.onboarding;

  // Legal consent pages must always render: even logged out and even when
  // public applications are disabled (sign-up consent links live on the
  // entry screens).
  if (location.startsWith('/legal/')) {
    return null;
  }

  // Public application links need no session, so they render while the
  // session is still being checked; the deep link is not queued, so sending
  // it to the splash would lose it.
  final isPublic = location.startsWith('/public');
  if (isPublic && enablePublicApplications) {
    return null;
  }

  // Checking wins over everything else: never flash the auth screen for a
  // restorable session while the gate state is still loading.
  if (isChecking) {
    return isSplash ? null : Routes.splash;
  }

  if (isPublic) {
    return isLoggedIn ? Routes.home : Routes.enterPhone;
  }

  // Signed out: only the entry screens. A gate screen left open after
  // sign-out (for example /set-password) goes back to the start.
  if (!isLoggedIn) {
    return isEntryRoute ? null : Routes.enterPhone;
  }

  // Gate step (set-password is mandatory and backing out signs the user out;
  // add-phone is skippable).
  if (gateRoute != null) {
    return location == gateRoute ? null : gateRoute;
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
