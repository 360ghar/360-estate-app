import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Thrown when the user dismisses the Apple sign-in sheet. Callers should treat
/// this as a silent no-op (not an error to surface).
class AppleSignInCancelled implements Exception {
  const AppleSignInCancelled();
}

/// The tokens returned by a successful native Apple sign-in, ready to be
/// exchanged with Supabase via `signInWithIdToken`.
class AppleAuthTokens {
  const AppleAuthTokens({
    required this.idToken,
    required this.rawNonce,
    this.fullName,
    this.email,
  });

  /// The Apple-issued OpenID Connect ID token. Passed to Supabase as `idToken`.
  final String idToken;

  /// The un-hashed nonce. Its SHA-256 is embedded in the ID token; Supabase
  /// re-hashes [rawNonce] to validate it.
  final String rawNonce;

  /// The user's full name, only present on the FIRST authorization for an
  /// Apple ID (Apple never returns it again).
  final String? fullName;

  /// The user's email, only present on the first authorization (or null when
  /// the user chose to hide it / on subsequent sign-ins).
  final String? email;
}

/// Wraps `sign_in_with_apple` v8 for the native Apple ID-token flow on iOS.
class AppleSignInService {
  const AppleSignInService();

  /// Whether Sign in with Apple is available on this device (iOS 13+/macOS).
  Future<bool> isAvailable() => SignInWithApple.isAvailable();

  static String _generateRawNonce([int length = 32]) {
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static String _sha256Hex(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Triggers the native Apple sign-in sheet and returns the resulting tokens.
  ///
  /// Throws [AppleSignInCancelled] on user cancel, or a [Failure] otherwise.
  Future<AppleAuthTokens> signIn() async {
    final rawNonce = _generateRawNonce();
    final hashedNonce = _sha256Hex(rawNonce);

    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AppleSignInCancelled();
      }
      throw UnknownFailure(
        e.message.trim().isNotEmpty
            ? e.message.trim()
            : 'Apple Sign-In failed.',
        cause: e,
      );
    } on SignInWithAppleException catch (e) {
      throw UnknownFailure('Apple Sign-In failed.', cause: e);
    }

    final idToken = credential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw const UnknownFailure(
        'Apple Sign-In did not return an identity token.',
      );
    }

    final givenName = credential.givenName?.trim() ?? '';
    final familyName = credential.familyName?.trim() ?? '';
    final fullName = [
      givenName,
      familyName,
    ].where((part) => part.isNotEmpty).join(' ').trim();

    return AppleAuthTokens(
      idToken: idToken,
      rawNonce: rawNonce,
      fullName: fullName.isEmpty ? null : fullName,
      email: credential.email,
    );
  }
}
