import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/features/auth/data/datasources/backend_auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
  Future<bool> refreshSession();

  /// Called after successful login to store the backend token
  Future<void> onLoginSuccess(
      {required String phone, required String password});
}

final class CompositeAuthTokenProvider implements AuthTokenProvider {
  CompositeAuthTokenProvider({
    required BackendAuthDataSource backendAuth,
  }) : _backendAuth = backendAuth {
    // Initialize prefs asynchronously
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  final BackendAuthDataSource _backendAuth;
  static const String _tokenKey = 'backend_access_token';
  SharedPreferences? _prefs;

  // Track if re-login has been attempted for this request cycle
  // This is reset after each successful refresh or when a new token is obtained
  bool _reloginAttempted = false;

  // Reset the re-login flag (call when starting a new refresh cycle)
  void _resetReloginFlag() {
    _reloginAttempted = false;
  }

  // Synchronous read for immediate use
  String? _getStoredTokenSync() {
    return _prefs?.getString(_tokenKey);
  }

  /// Attempt to re-login to backend using stored credentials
  Future<bool> _attemptRelogin() async {
    if (_reloginAttempted) {
      AppLogger.d('Re-login already attempted for this cycle, skipping');
      return false;
    }
    _reloginAttempted = true;

    try {
      final creds = await _backendAuth.getStoredCredentials();
      if (creds == null) {
        AppLogger.d('No stored credentials for re-login');
        // Clear the invalid/stored token so we don't keep using it
        await _clearStoredToken();
        return false;
      }

      AppLogger.d('Attempting re-login to backend with stored credentials');
      AppLogger.d('Phone: ${creds['phone']}');
      // Clear old token before re-login
      await _clearStoredToken();
      await _backendAuth.login(
          phone: creds['phone']!, password: creds['password']!);
      AppLogger.d('Re-login successful');
      // Reset flag on success so future refreshes can attempt again
      _reloginAttempted = false;
      return true;
    } catch (e) {
      AppLogger.w('Re-login failed', error: e);
      // Clear any invalid token
      await _clearStoredToken();
      return false;
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      await _prefs!.remove(_tokenKey);
      AppLogger.d('Cleared stored backend token');
    } catch (_) {
      // Ignore errors when clearing
    }
  }

  @override
  Future<String?> getAccessToken() async {
    // First try synchronous read
    final storedToken = _getStoredTokenSync();
    if (storedToken != null && storedToken.isNotEmpty) {
      return storedToken;
    }

    // Wait for prefs to be initialized
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    // Check for backend token
    final backendToken = _prefs!.getString(_tokenKey);
    if (backendToken != null && backendToken.isNotEmpty) {
      AppLogger.d('Using backend token, length: ${backendToken.length}');
      return backendToken;
    }

    // No backend token - try to re-login with stored credentials
    AppLogger.d('No backend token found, attempting re-login...');
    final reloginSuccess = await _attemptRelogin();
    if (reloginSuccess) {
      // Re-login successful, get the new token
      final newToken = _prefs!.getString(_tokenKey);
      if (newToken != null && newToken.isNotEmpty) {
        AppLogger.d(
            'Using re-acquired backend token, length: ${newToken.length}');
        return newToken;
      }
    }

    // Fall back to Supabase token (for Supabase client calls)
    try {
      final client = Supabase.instance.client;
      final supabaseToken = client.auth.currentSession?.accessToken;
      if (supabaseToken != null) {
        AppLogger.w('Using Supabase token (backend may reject it)');
      }
      return supabaseToken;
    } catch (_) {
      AppLogger.d('No token available');
      return null;
    }
  }

  @override
  Future<bool> refreshSession() async {
    // Reset the re-login flag to allow a new attempt
    _resetReloginFlag();

    // Try to refresh backend session via re-login
    AppLogger.d('refreshSession called, attempting backend re-login');
    final success = await _attemptRelogin();
    if (success) {
      AppLogger.d('Backend re-login successful during refresh');
      return true;
    }

    AppLogger.d('Backend re-login failed, falling back to Supabase refresh');
    // Fall back to Supabase refresh
    try {
      final client = Supabase.instance.client;
      final session = client.auth.currentSession;
      if (session == null) return false;

      await client.auth.refreshSession();
      return client.auth.currentSession != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> onLoginSuccess({
    required String phone,
    required String password,
  }) async {
    try {
      // Log in to the backend API after Supabase login
      AppLogger.d('Logging into backend API...');
      await _backendAuth.login(phone: phone, password: password);
    } catch (e) {
      // Log but don't fail - the UI should still work even if backend login fails
      AppLogger.w('Backend login failed', error: e);
    }
  }
}

/// Legacy Supabase-only token provider (kept for compatibility)
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

  @override
  Future<void> onLoginSuccess({
    required String phone,
    required String password,
  }) async {
    // No-op for Supabase-only provider
  }
}
