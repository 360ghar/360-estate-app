import 'dart:convert';

import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<void> clearSession();
}

final class RefreshingAuthTokenProvider implements AuthTokenProvider {
  RefreshingAuthTokenProvider(this._storage);

  final AuthTokenStorage _storage;

  @override
  Future<String?> getAccessToken() async {
    supabase.SupabaseClient client;
    try {
      client = supabase.Supabase.instance.client;
    } catch (error, stackTrace) {
      // Supabase is not initialized yet (transient startup race). Do NOT
      // clear the stored session - returning null here without clearing lets
      // the next call succeed once Supabase is ready. Surface the gap so
      // cold-start races are visible in logs (B14).
      AppLogger.w(
        'AuthTokenProvider: Supabase not yet initialized; returning null token',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }

    var session = client.auth.currentSession;
    if (session == null) {
      await _storage.clear();
      return null;
    }

    if (session.isExpired || _isJwtExpired(session.accessToken)) {
      try {
        final refresh = await client.auth.refreshSession();
        session = refresh.session ?? client.auth.currentSession;
      } on supabase.AuthException {
        // Confirmed auth failure (e.g. refresh token expired or revoked).
        // The session is truly invalid; clear storage so the user is logged out.
        await _storage.clear();
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

    final token = session?.accessToken;
    if (token != null && token.isNotEmpty) {
      await _storage.save(token);
      return token;
    }

    await _storage.clear();
    return null;
  }

  @override
  Future<void> clearSession() async {
    await _storage.clear();
    try {
      await supabase.Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Ignore sign-out failures from the auth SDK.
    }
  }
}

bool _isJwtExpired(String token, {Duration skew = const Duration(seconds: 10)}) {
  final payload = _decodeJwtPayload(token);
  if (payload == null) return false;
  final exp = payload['exp'];
  int? expValue;
  if (exp is num) {
    expValue = exp.toInt();
  } else if (exp is String) {
    expValue = int.tryParse(exp);
  }
  if (expValue == null) return false;
  final expiry = DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
  return DateTime.now().add(skew).isAfter(expiry);
}

Map<String, dynamic>? _decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length < 2) return null;
  try {
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    final data = jsonDecode(decoded);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  } catch (_) {
    return null;
  }
}
