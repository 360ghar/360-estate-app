import 'package:estate_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> getCurrentUser();
  Stream<AuthUser?> observeAuthState();

  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<void> signOut();

  /// Best-effort check for whether a phone number is registered.
  ///
  /// Returns `null` when the backend doesn't support this check.
  Future<bool?> isPhoneRegistered(String phone);

  /// Handles magic link / OAuth callback deep links when enabled.
  ///
  /// Returns `true` if the URL was processed successfully.
  Future<bool> handleAuthRedirect(Uri uri);
}
