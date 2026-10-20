import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureKvStore {
  SecureKvStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Both values are the defaults; they are stated so a later change
            // cannot weaken them silently. The token is only read by the
            // foreground auth interceptor, so first_unlock is never needed.
            // ignore: avoid_redundant_argument_values
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            // ignore: avoid_redundant_argument_values
            iOptions: IOSOptions(
              // ignore: avoid_redundant_argument_values
              accessibility: KeychainAccessibility.unlocked,
            ),
          );

  final FlutterSecureStorage _storage;

  Future<void> writeString({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> readString(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}
