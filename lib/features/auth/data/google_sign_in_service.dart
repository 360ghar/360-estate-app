import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thrown when the user dismisses the Google account picker. Callers should
/// treat this as a silent no-op (not an error to surface).
class GoogleSignInCancelled implements Exception {
  const GoogleSignInCancelled();
}

/// The tokens returned by a successful native Google sign-in, ready to be
/// exchanged with Supabase via `signInWithIdToken`.
class GoogleAuthTokens {
  const GoogleAuthTokens({
    required this.idToken,
    required this.accessToken,
    required this.rawNonce,
  });

  /// The Google-issued OpenID Connect ID token. Passed to Supabase.
  final String idToken;

  /// The OAuth access token, when available. Supabase accepts a null/empty
  /// access token for the ID-token flow but providing it is preferred.
  final String? accessToken;

  /// The un-hashed nonce. The SHA-256 of this value is embedded in the ID
  /// token; Supabase re-hashes [rawNonce] to validate it.
  final String rawNonce;
}

/// Wraps `google_sign_in` v7 (`GoogleSignIn.instance`) for the native
/// ID-token flow. The plugin is a singleton and must be initialized exactly
/// once per process.
class GoogleSignInService {
  GoogleSignInService({required String webClientId, String? iosClientId})
    : _webClientId = webClientId,
      _iosClientId = iosClientId;

  /// Used as the Android `serverClientId` (and to validate the ID token in
  /// Supabase). On all platforms this must be the Google **Web** client id.
  final String _webClientId;

  /// The iOS OAuth client id. Required on iOS.
  final String? _iosClientId;

  bool _initialized = false;

  /// Whether the platform supports the interactive `authenticate()` flow.
  bool get supportsAuthenticate => GoogleSignIn.instance.supportsAuthenticate();

  String? get _clientId =>
      (_iosClientId != null && _iosClientId.trim().isNotEmpty)
      ? _iosClientId
      : null;

  void _assertConfigured() {
    if (_webClientId.trim().isEmpty) {
      throw const UnknownFailure(
        'Google Sign-In is not configured. Add GOOGLE_WEB_CLIENT_ID to .env.',
      );
    }
  }

  /// Generates a cryptographically-random raw nonce.
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

  /// Triggers the native account picker and returns the resulting tokens.
  ///
  /// Throws a [Failure] if Google Sign-In is unsupported/unconfigured, and
  /// rethrows the cancellation so callers can distinguish a user-cancel from a
  /// real error.
  Future<GoogleAuthTokens> signIn() async {
    _assertConfigured();

    if (!supportsAuthenticate) {
      throw const UnknownFailure(
        'Google Sign-In is not supported on this platform.',
      );
    }

    final rawNonce = _generateRawNonce();
    final hashedNonce = _sha256Hex(rawNonce);

    // The hashed nonce is embedded in the ID token; Supabase re-hashes the raw
    // nonce to verify it. The nonce is supplied via initialize() in v7, so we
    // (re)initialize per sign-in to bind a fresh nonce.
    await GoogleSignIn.instance.initialize(
      clientId: _clientId,
      serverClientId: _webClientId,
      nonce: hashedNonce,
    );
    _initialized = true;

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const GoogleSignInCancelled();
      }
      throw UnknownFailure(
        e.description?.trim().isNotEmpty == true
            ? e.description!.trim()
            : 'Google Sign-In failed.',
        cause: e,
      );
    }

    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const UnknownFailure('Google Sign-In did not return an ID token.');
    }

    String? accessToken;
    try {
      final authorization = await account.authorizationClient.authorizeScopes(
        const <String>['email', 'profile'],
      );
      accessToken = authorization.accessToken;
    } catch (_) {
      // Authorization is optional for the Supabase ID-token flow; ignore.
      accessToken = null;
    }

    return GoogleAuthTokens(
      idToken: idToken,
      accessToken: accessToken,
      rawNonce: rawNonce,
    );
  }

  /// Signs the user out of the Google session (does not affect Supabase).
  Future<void> signOut() async {
    if (!_initialized) return;
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Best-effort.
    }
  }
}
