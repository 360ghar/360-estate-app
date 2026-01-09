import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureKvStore {
  SecureKvStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> writeString({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> readString(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  // Aliases for compatibility
  Future<String?> getString(String key) => readString(key);
  Future<void> setString(String key, String value) =>
      writeString(key: key, value: value);

  Future<void> deleteAll() => _storage.deleteAll();
}
