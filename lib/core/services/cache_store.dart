class CacheStore {
  final Map<String, _CacheEntry<Object?>> _entries = <String, _CacheEntry<Object?>>{};

  T? get<T>(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _entries.remove(key);
      return null;
    }
    final value = entry.value;
    if (value is T) return value;
    return null;
  }

  void set<T>(String key, T value, {required Duration ttl}) {
    _entries[key] = _CacheEntry<Object?>(
      value: value,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  void invalidate(String key) {
    _entries.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _entries.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() => _entries.clear();
}

class _CacheEntry<T> {
  _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime expiresAt;
}
