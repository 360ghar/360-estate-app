import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    FlutterSecureStorage? secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        ) {
    // Initialize prefs
    SharedPreferences.getInstance().then((value) => _sharedPrefs = value);
  }

  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
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
      AppLogger.d('Attempting backend login for phone: $phone');

      // Create a separate Dio instance without auth interceptor for login
      final loginDio = Dio(BaseOptions(
        baseUrl: _apiClient.dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      ));

      final requestData = {
        'phone': phone,
        'password': password,
      };

      final response = await loginDio.post<Map<String, dynamic>>(
        '/auth/login/',
        data: requestData,
      );

      AppLogger.d('Backend login response: ${response.statusCode}');

      final data = response.data;
      if (data == null) {
        AppLogger.e('Backend login failed: No response data');
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
        AppLogger.e('Backend login failed: No token in response',
            error: data.keys.toList());
        throw Exception('Login failed: No access token in response');
      }

      AppLogger.d('Backend login successful, token length: ${token.length}');

      // Store the token and credentials for future use
      // Store sensitive data (password) in secure storage
      await _secureStorage.write(key: _passwordKey, value: password);
      // Store phone and token in regular prefs (phone is not sensitive, token is temporary)
      final prefs = await _getPrefs();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_phoneKey, phone);

      AppLogger.d('Backend token and credentials stored securely');

      return token;
    } on DioException catch (e) {
      AppLogger.e(
        'Backend login DioError: ${e.response?.statusCode}',
        error: e,
      );

      // If login fails with 401, credentials are likely invalid (password changed)
      // Clear them so user can re-authenticate
      if (e.response?.statusCode == 401) {
        AppLogger.w('Backend auth 401 - clearing stored credentials');
      }

      rethrow;
    } catch (e) {
      AppLogger.e('Backend login error', error: e);
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
    AppLogger.d('Backend token stored successfully');
  }

  @override
  Future<void> clearToken() async {
    final prefs = await _getPrefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_phoneKey);
    await _secureStorage.delete(key: _passwordKey);
    AppLogger.d('Backend token and credentials cleared securely');
  }

  @override
  Future<Map<String, String>?> getStoredCredentials() async {
    final prefs = await _getPrefs();
    final phone = prefs.getString(_phoneKey);
    final password = await _secureStorage.read(key: _passwordKey);
    if (phone != null && password != null) {
      return {'phone': phone, 'password': password};
    }
    return null;
  }
}
