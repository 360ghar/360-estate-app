import 'package:estate_app/core/services/cache_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheStore', () {
    test('set then get returns the value within TTL', () {
      final store = CacheStore();
      store.set('a', 1, ttl: const Duration(minutes: 5));
      expect(store.get<int>('a'), 1);
    });

    test('expired entries are dropped', () async {
      final store = CacheStore();
      store.set('a', 1, ttl: const Duration(milliseconds: 1));
      expect(store.get<int>('a'), 1);
      // Let the TTL elapse.
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(store.get<int>('a'), isNull);
    });

    test('type-mismatched get returns null', () {
      final store = CacheStore();
      store.set('a', 'text', ttl: const Duration(minutes: 5));
      expect(store.get<int>('a'), isNull);
    });

    test('invalidate removes a single key', () {
      final store = CacheStore();
      store.set('a', 1, ttl: const Duration(minutes: 5));
      store.set('b', 2, ttl: const Duration(minutes: 5));
      store.invalidate('a');
      expect(store.get<int>('a'), isNull);
      expect(store.get<int>('b'), 2);
    });

    test('invalidatePrefix removes matching keys', () {
      final store = CacheStore();
      store.set('properties:x:1', 1, ttl: const Duration(minutes: 5));
      store.set('properties:x:2', 2, ttl: const Duration(minutes: 5));
      store.set('tenants:1', 3, ttl: const Duration(minutes: 5));
      store.invalidatePrefix('properties:');
      expect(store.get<int>('properties:x:1'), isNull);
      expect(store.get<int>('properties:x:2'), isNull);
      expect(store.get<int>('tenants:1'), 3);
    });

    test('evicts oldest entries when exceeding maxEntries', () {
      final store = CacheStore(maxEntries: 3);
      store.set('a', 1, ttl: const Duration(minutes: 5));
      store.set('b', 2, ttl: const Duration(minutes: 5));
      store.set('c', 3, ttl: const Duration(minutes: 5));
      store.set('d', 4, ttl: const Duration(minutes: 5));
      expect(store.get<int>('a'), isNull); // oldest evicted
      expect(store.get<int>('b'), 2);
      expect(store.get<int>('c'), 3);
      expect(store.get<int>('d'), 4);
    });

    test('clear removes everything', () {
      final store = CacheStore();
      store.set('a', 1, ttl: const Duration(minutes: 5));
      store.clear();
      expect(store.get<int>('a'), isNull);
    });
  });
}
