/// In-memory response cache for the signed-in account.
///
/// - Schema version: every key carries [schemaVersion]. Raise it when a cached
///   value changes shape, so an old value can never be read as the new type.
/// - Account scope: every key carries the account bound with [bindAccount]. A
///   different account, or [bindAccount] with null (sign-out), purges every
///   entry first, so one account never reads another account's values.
/// - `Cache-Control: no-store` is honoured by the callers: do not [set] a
///   response that carries it (see `isCacheable` in `cache_control.dart`).
class CacheStore {
  CacheStore({this.maxEntries = 200, this.schemaVersion = 1});

  final Map<String, _CacheEntry<Object?>> _entries =
      <String, _CacheEntry<Object?>>{};

  /// Upper bound on cached entries. When exceeded, expired entries are
  /// dropped first, then the oldest remaining entries, so a long browsing
  /// session (many cursor pages / detail ids) cannot grow memory unbounded.
  final int maxEntries;

  /// Shape version of the cached values. Part of every key.
  final int schemaVersion;

  String _account = '';

  /// The bound account id, or an empty string when nobody is signed in.
  String get account => _account;

  /// Binds the store to [accountId]. Purges all entries when the account
  /// changes, and on sign-out (null).
  void bindAccount(String? accountId) {
    final next = accountId ?? '';
    if (next == _account) return;
    _entries.clear();
    _account = next;
  }

  String _scoped(String key) => 'v$schemaVersion|$_account|$key';

  T? get<T>(String key) {
    final scoped = _scoped(key);
    final entry = _entries[scoped];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _entries.remove(scoped);
      return null;
    }
    final value = entry.value;
    if (value is T) return value;
    return null;
  }

  void set<T>(String key, T value, {required Duration ttl}) {
    _entries[_scoped(key)] = _CacheEntry<Object?>(
      value: value,
      expiresAt: DateTime.now().add(ttl),
    );
    _evictIfNeeded();
  }

  void invalidate(String key) {
    _entries.remove(_scoped(key));
  }

  void invalidatePrefix(String prefix) {
    final scopedPrefix = _scoped(prefix);
    _entries.removeWhere((key, _) => key.startsWith(scopedPrefix));
  }

  /// Drops every entry of the bound account and keeps the binding. Used when
  /// the data the account sees changes without a sign-in change, for example
  /// an agent who picks another owner.
  void invalidateAll() => invalidatePrefix('');

  /// Drops every entry of every account and unbinds the account.
  void clear() {
    _entries.clear();
    _account = '';
  }

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
