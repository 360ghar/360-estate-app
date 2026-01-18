import 'dart:async';

import 'package:estate_app/core/storage/secure_kv_store.dart';

final class AuthTokenStorage {
  AuthTokenStorage(this._store);

  static const _tokenKey = 'auth_token';

  final SecureKvStore _store;
  final StreamController<String?> _controller =
      StreamController<String?>.broadcast();

  Stream<String?> get onTokenChanged => _controller.stream;

  Future<String?> read() => _store.readString(_tokenKey);

  Future<void> save(String token) async {
    await _store.writeString(key: _tokenKey, value: token);
    _controller.add(token);
  }

  Future<void> clear() async {
    await _store.delete(_tokenKey);
    _controller.add(null);
  }
}
