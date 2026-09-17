import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureKvStore {
  SecureKvStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              // Token is only read by the foreground auth interceptor; no
              // background access needs the weaker first_unlock level.
              // ignore: avoid_redundant_argument_values -- `unlocked` is the
              // default; stated explicitly so first_unlock is not reintroduced.
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
