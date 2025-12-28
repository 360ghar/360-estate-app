import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<bool> refreshSession();
}

final class SupabaseAuthTokenProvider implements AuthTokenProvider {
  const SupabaseAuthTokenProvider();

  SupabaseClient? _clientOrNull() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    final client = _clientOrNull();
    return client?.auth.currentSession?.accessToken;
  }

  @override
  Future<bool> refreshSession() async {
    final client = _clientOrNull();
    if (client == null) return false;
    final session = client.auth.currentSession;
    if (session == null) return false;

    try {
      await client.auth.refreshSession();
      return client.auth.currentSession != null;
    } catch (_) {
      return false;
    }
  }
}
