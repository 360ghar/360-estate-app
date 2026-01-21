import 'dart:convert';

import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<void> clearSession();
}

final class SecureAuthTokenProvider implements AuthTokenProvider {
  SecureAuthTokenProvider(this._storage);

  final AuthTokenStorage _storage;

  @override
  Future<String?> getAccessToken() => _storage.read();

  @override
  Future<void> clearSession() => _storage.clear();
}

final class RefreshingAuthTokenProvider implements AuthTokenProvider {
  RefreshingAuthTokenProvider(this._storage, {required AppConfig config})
      : _config = config;

  final AuthTokenStorage _storage;
  final AppConfig _config;

  @override
  Future<String?> getAccessToken() async {
    if (!_config.isSupabaseConfigured) {
      return _readStoredToken();
    }

    final client = supabase.Supabase.instance.client;
    var session = client.auth.currentSession;
    if (session == null) {
      final stored = await _readStoredToken();
      if (stored == null) return null;
      if (!_isSupabaseToken(stored, _config)) {
        await _storage.clear();
        return null;
      }
      return stored;
    }

    if (session.isExpired || _isJwtExpired(session.accessToken)) {
      try {
        final refresh = await client.auth.refreshSession();
        session = refresh.session ?? client.auth.currentSession;
      } catch (_) {
        await _storage.clear();
        return null;
      }
    }

    final token = session?.accessToken;
    if (token != null && token.isNotEmpty) {
      await _storage.save(token);
      return token;
    }

    return _readStoredToken();
  }

  @override
  Future<void> clearSession() async {
    await _storage.clear();
    if (_config.isSupabaseConfigured) {
      try {
        await supabase.Supabase.instance.client.auth.signOut();
      } catch (_) {
        // Ignore sign-out failures from the auth SDK.
      }
    }
  }

  Future<String?> _readStoredToken() async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) return null;
    if (_isJwtExpired(token)) {
      await _storage.clear();
      return null;
    }
    return token;
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

bool _isSupabaseToken(String token, AppConfig config) {
  final payload = _decodeJwtPayload(token);
  if (payload == null) return false;
  final issuer = payload['iss']?.toString();
  final ref = payload['ref']?.toString();
  final supabaseUrl = config.supabaseUrl.trim();
  if (issuer != null && supabaseUrl.isNotEmpty) {
    if (issuer.contains(supabaseUrl)) return true;
  }
  if (ref != null) {
    final projectRef = _extractProjectRef(supabaseUrl);
    if (projectRef != null && ref == projectRef) return true;
  }
  return false;
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

String? _extractProjectRef(String supabaseUrl) {
  if (supabaseUrl.isEmpty) return null;
  final uri = Uri.tryParse(supabaseUrl);
  final host = uri?.host ?? supabaseUrl;
  if (host.isEmpty) return null;
  final parts = host.split('.');
  if (parts.isEmpty) return null;
  return parts.first.trim().isEmpty ? null : parts.first.trim();
}
