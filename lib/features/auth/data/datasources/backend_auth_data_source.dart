import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Backend API authentication data source.
/// The backend API has its own auth system separate from Supabase.
abstract interface class BackendAuthDataSource {
  /// Log in to the backend API and get an access token
  Future<String> login({
    required String phone,
    required String password,
  });

  /// Get the current backend access token from storage
  String? getStoredToken();

  /// Store the backend access token
  Future<void> storeToken(String token);

  /// Clear the stored token (on logout)
  Future<void> clearToken();

  /// Get stored credentials for re-login
  Future<Map<String, String>?> getStoredCredentials();
}

final class BackendAuthDataSourceImpl implements BackendAuthDataSource {
  BackendAuthDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient {
    // Initialize prefs
    SharedPreferences.getInstance().then((value) => _sharedPrefs = value);
  }

  final ApiClient _apiClient;
  static const String _tokenKey = 'backend_access_token';
  static const String _phoneKey = 'backend_phone';
  static const String _passwordKey = 'backend_password';

  SharedPreferences? _sharedPrefs;

  @override
  Future<String> login({
    required String phone,
    required String password,
  }) async {
    try {
      print('[BACKEND_AUTH] ========================================');
      print('[BACKEND_AUTH] Attempting login to /auth/login/');
      print('[BACKEND_AUTH] Phone: $phone');
      print('[BACKEND_AUTH] Base URL: ${_apiClient.dio.options.baseUrl}');
      print('[BACKEND_AUTH] Full URL will be: ${_apiClient.dio.options.baseUrl}/auth/login/');

      // Create a separate Dio instance without auth interceptor for login
      final loginDio = Dio(BaseOptions(
        baseUrl: _apiClient.dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      ));

      final requestData = {
        'phone': phone,
        'password': password,
      };
      print('[BACKEND_AUTH] Request data: $requestData');

      final response = await loginDio.post<Map<String, dynamic>>(
        '/auth/login/',
        data: requestData,
      );

      print('[BACKEND_AUTH] Response status: ${response.statusCode}');
      print('[BACKEND_AUTH] Response data: ${response.data}');

      final data = response.data;
      if (data == null) {
        print('[BACKEND_AUTH] ERROR: No response data');
        throw Exception('Login failed: No response data');
      }

      // Try different possible token key names
      final token = (data['access_token'] as String?) ??
          (data['accessToken'] as String?) ??
          (data['token'] as String?) ??
          (data['data']?['access_token'] as String?) ??
          (data['data']?['token'] as String?) ??
          (data['results']?['access_token'] as String?) ??
          (data['results']?['token'] as String?) ??
          (data['user']?['access_token'] as String?) ??
          (data['user']?['token'] as String?);

      if (token == null || token.isEmpty) {
        print('[BACKEND_AUTH] ERROR: No token found');
        print('[BACKEND_AUTH] Available keys: ${data.keys.toList()}');
        print('[BACKEND_AUTH] Full response: $data');
        throw Exception('Login failed: No access token in response');
      }

      print('[BACKEND_AUTH] SUCCESS! Got token (${token.length} chars)');

      // Store the token and credentials for future use
      final prefs = await _getPrefs();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_phoneKey, phone);
      await prefs.setString(_passwordKey, password);

      print('[BACKEND_AUTH] Token and credentials stored');
      print('[BACKEND_AUTH] ========================================');

      return token;
    } on DioException catch (e) {
      print('[BACKEND_AUTH] Dio error: ${e.message}');
      print('[BACKEND_AUTH] Status code: ${e.response?.statusCode}');
      print('[BACKEND_AUTH] Response: ${e.response?.data}');
      print('[BACKEND_AUTH] Request URL: ${e.requestOptions.uri}');

      // If login fails with 401, credentials are likely invalid (password changed)
      // Clear them so user can re-authenticate
      if (e.response?.statusCode == 401) {
        print('[BACKEND_AUTH] 401 error - clearing stored credentials');
        await clearToken();
      }

      print('[BACKEND_AUTH] ========================================');
      rethrow;
    } catch (e) {
      print('[BACKEND_AUTH] Error: $e');
      print('[BACKEND_AUTH] ========================================');
      rethrow;
    }
  }

  Future<SharedPreferences> _getPrefs() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    return _sharedPrefs!;
  }

  @override
  String? getStoredToken() {
    return _sharedPrefs?.getString(_tokenKey);
  }

  @override
  Future<void> storeToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_tokenKey, token);
    print('[BACKEND_AUTH] Token stored successfully');
  }

  @override
  Future<void> clearToken() async {
    final prefs = await _getPrefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_passwordKey);
    print('[BACKEND_AUTH] Token and credentials cleared');
  }

  @override
  Future<Map<String, String>?> getStoredCredentials() async {
    final prefs = await _getPrefs();
    final phone = prefs.getString(_phoneKey);
    final password = prefs.getString(_passwordKey);
    if (phone != null && password != null) {
      return {'phone': phone, 'password': password};
    }
    return null;
  }
}
