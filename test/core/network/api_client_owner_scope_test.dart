import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{"items": [], "next_cursor": null, "has_more": false, "limit": 20, "total": null}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<bool> get onConnectivityChanged => const Stream.empty();
}

class _NoToken implements AuthTokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<void> clearSession() async {}
}

ApiClient _client(_Recorder recorder, OwnerScope Function() scope) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com/api/v1'));
  dio.httpClientAdapter = recorder;
  return ApiClient(
    baseUrl: 'https://example.com/api/v1',
    networkInfo: _Online(),
    tokenProvider: _NoToken(),
    enableLogging: false,
    ownerScope: scope,
    dio: dio,
  );
}

void main() {
  group('owner scope on PM routes', () {
    test('an agent without an owner is stopped before the request', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.agent, null),
      );
      await expectLater(
        client.get<dynamic>('/pm/properties', ownerScoped: true),
        throwsA(isA<OwnerRequiredFailure>()),
      );
      expect(recorder.requests, isEmpty);
    });

    test('an agent with an owner sends owner_id on a list', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.agent, 7),
      );
      await client.get<dynamic>(
        '/pm/properties',
        ownerScoped: true,
        queryParameters: {'limit': 20},
      );
      expect(recorder.requests.single.queryParameters, {
        'limit': 20,
        'owner_id': 7,
      });
    });

    test('an agent with an owner sends owner_id in a create body', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.agent, 7),
      );
      await client.post<dynamic>(
        '/pm/properties',
        ownerScoped: true,
        data: {'title': 'Flat'},
      );
      expect(recorder.requests.single.data, {'title': 'Flat', 'owner_id': 7});
    });

    test('an owner (role user) never sends owner_id', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.user, 7),
      );
      await client.get<dynamic>('/pm/properties', ownerScoped: true);
      expect(recorder.requests.single.queryParameters, isEmpty);
    });

    test('a route that is not owner scoped is left alone', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.agent, null),
      );
      await client.get<dynamic>('/amenities');
      expect(recorder.requests, hasLength(1));
    });

    test('an admin may omit the owner', () async {
      final recorder = _Recorder();
      final client = _client(
        recorder,
        () => OwnerScope.forRole(UserRole.admin, null),
      );
      await client.get<dynamic>('/pm/leases', ownerScoped: true);
      expect(recorder.requests.single.queryParameters, isEmpty);
    });
  });
}
