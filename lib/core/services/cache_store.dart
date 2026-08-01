class CacheStore {
  CacheStore({this.maxEntries = 200});

  final Map<String, _CacheEntry<Object?>> _entries =
      <String, _CacheEntry<Object?>>{};

  /// Upper bound on cached entries. When exceeded, expired entries are
  /// dropped first, then the oldest remaining entries, so a long browsing
  /// session (many cursor pages / detail ids) cannot grow memory unbounded.
  final int maxEntries;

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
    _evictIfNeeded();
  }

  void invalidate(String key) {
    _entries.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _entries.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() => _entries.clear();

  void _evictIfNeeded() {
    if (_entries.length <= maxEntries) return;
    final now = DateTime.now();
    // 1. Drop everything already past its TTL.
    _entries.removeWhere((_, entry) => now.isAfter(entry.expiresAt));
    if (_entries.length <= maxEntries) return;
    // 2. Drop oldest entries until back under the cap.
    final sorted = _entries.entries.toList()
      ..sort((a, b) => a.value.expiresAt.compareTo(b.value.expiresAt));
    final overflow = sorted.length - maxEntries;
    for (var i = 0; i < overflow; i++) {
      _entries.remove(sorted[i].key);
    }
  }
}

class _CacheEntry<T> {
  _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime expiresAt;
}
