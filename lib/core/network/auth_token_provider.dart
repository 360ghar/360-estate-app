import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/jwt.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<void> clearSession();
}

final class RefreshingAuthTokenProvider implements AuthTokenProvider {
  RefreshingAuthTokenProvider(this._storage);

  final AuthTokenStorage _storage;

  /// In-memory copy of the current access token.
  ///
  /// The secure storage is only written when the token actually changes
  /// (fresh load or refresh) — previously every `getAccessToken()` call wrote
  /// to the Keystore/Keychain, adding tens of ms of platform-channel latency
  /// to every HTTP request.
  String? _cachedToken;

  /// Single in-flight refresh; concurrent callers share the same future so
  /// parallel requests cannot race two `refreshSession()` calls (Supabase
  /// rotates/revokes the refresh token on use, so a double refresh can
  /// invalidate the session).
  Future<String?>? _refreshInFlight;

  @override
  Future<String?> getAccessToken() async {
    final cached = _cachedToken;
    // Fast path: a cached token that is still within its validity window.
    // No Supabase round-trip, no secure-storage write.
    if (cached != null && cached.isNotEmpty && !Jwt.isExpired(cached)) {
      return cached;
    }
    return _loadFreshToken(cached);
  }

  Future<String?> _loadFreshToken(String? cached) async {
    supabase.SupabaseClient client;
    try {
      client = supabase.Supabase.instance.client;
    } catch (error, stackTrace) {
      // Supabase is not initialized yet (transient startup race). Do NOT
      // clear the stored session - returning a cached token (when present)
      // lets the request proceed and the next call succeed once Supabase is
      // ready. Surface the gap so cold-start races are visible in logs (B14).
      AppLogger.w(
        'AuthTokenProvider: Supabase not yet initialized; returning cached token',
        error: error,
        stackTrace: stackTrace,
      );
      return cached;
    }

    final session = client.auth.currentSession;
    if (session == null) {
      await _clearToken();
      return null;
    }

    final token = session.accessToken;
    if (session.isExpired || Jwt.isExpired(token)) {
      return _refreshSession(cached);
    }

    if (token.isNotEmpty) {
      _cachedToken = token;
      await _storage.save(token);
      return token;
    }

    await _clearToken();
    return null;
  }

  Future<String?> _refreshSession(String? cached) {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;
    final future = _doRefresh(cached);
    _refreshInFlight = future;
    return future.whenComplete(() => _refreshInFlight = null);
  }

  Future<String?> _doRefresh(String? cached) async {
    try {
      final refresh = await supabase.Supabase.instance.client.auth
          .refreshSession();
      final session =
          refresh.session ??
          supabase.Supabase.instance.client.auth.currentSession;
      final token = session?.accessToken;
      if (token != null && token.isNotEmpty) {
        _cachedToken = token;
        await _storage.save(token);
        return token;
      }
      await _clearToken();
      return null;
    } on supabase.AuthException {
      // Confirmed auth failure (e.g. refresh token expired or revoked).
      // The session is truly invalid; clear storage so the user is logged out.
      await _clearToken();
      return null;
    } catch (error, stackTrace) {
      // Transient error (network timeout, connectivity, etc.). Do NOT clear
      // the stored session; return null so the caller can retry later
      // without being silently logged out. Log so the failure is visible.
      AppLogger.w(
        'AuthTokenProvider: session refresh failed transiently; returning null token',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _clearToken() async {
    _cachedToken = null;
    await _storage.clear();
  }

  @override
  Future<void> clearSession() async {
    _cachedToken = null;
    await _storage.clear();
    try {
      await supabase.Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Ignore sign-out failures from the auth SDK.
    }
  }
}
