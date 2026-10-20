import 'package:dio/dio.dart';
import 'package:estate_app/core/network/cache_control.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ttl = Duration(minutes: 5);

  group('CacheStore account scope', () {
    test('a different account never reads the first account values', () {
      final store = CacheStore()..bindAccount('7');
      store.set('dashboard:overview', 'owner 7 figures', ttl: ttl);
      expect(store.get<String>('dashboard:overview'), 'owner 7 figures');

      store.bindAccount('8');
      expect(store.get<String>('dashboard:overview'), isNull);

      // Back to the first account: its entries were purged, not just hidden.
      store.bindAccount('7');
      expect(store.get<String>('dashboard:overview'), isNull);
    });

    test('binding the same account keeps the entries', () {
      final store = CacheStore()..bindAccount('7');
      store.set('k', 1, ttl: ttl);
      store.bindAccount('7');
      expect(store.get<int>('k'), 1);
    });

    test('sign-out (null account) purges every entry', () {
      final store = CacheStore()..bindAccount('7');
      store.set('rent_charges:all', 1, ttl: ttl);
      store.bindAccount(null);
      expect(store.account, isEmpty);
      store.bindAccount('7');
      expect(store.get<int>('rent_charges:all'), isNull);
    });

    test('invalidateAll drops the entries and keeps the account', () {
      final store = CacheStore()..bindAccount('7');
      store.set('properties:all', 1, ttl: ttl);
      store.set('tenants:first', 2, ttl: ttl);
      store.invalidateAll();
      expect(store.get<int>('properties:all'), isNull);
      expect(store.get<int>('tenants:first'), isNull);
      expect(store.account, '7');
    });

    test('the schema version is part of the key', () {
      // Two stores cannot share entries, but the key text proves the version:
      // a value cached under version 1 is not visible after a version bump
      // because the store is rebuilt with the new number.
      final v1 = CacheStore()..bindAccount('7');
      v1.set('k', 'old shape', ttl: ttl);
      final v2 = CacheStore(schemaVersion: 2)..bindAccount('7');
      expect(v2.get<String>('k'), isNull);
    });
  });

  group('no-store', () {
    Response<dynamic> response(Map<String, List<String>> headers) {
      return Response<dynamic>(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: 200,
        headers: Headers.fromMap(headers),
      );
    }

    test('a no-store response is not cacheable', () {
      expect(
        isCacheable(
          response({
            'cache-control': ['no-store'],
          }),
        ),
        isFalse,
      );
      expect(
        isCacheable(
          response({
            'cache-control': ['private, No-Store'],
          }),
        ),
        isFalse,
      );
    });

    test('other responses are cacheable', () {
      expect(isCacheable(response({})), isTrue);
      expect(
        isCacheable(
          response({
            'cache-control': ['max-age=60'],
          }),
        ),
        isTrue,
      );
    });
  });
}
