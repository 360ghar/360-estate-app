import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/auth_token_provider.dart';
import 'package:estate_app/core/network/network_info.dart';
import 'package:estate_app/core/network/owner_scope.dart';

import 'contract_helpers.dart';

/// A fake backend for tests. [FixtureAdapter] answers every route with the
/// fixture that `tool/api_fixtures.py` built from the backend response models,
/// and records each request. [fixtureApiClient] gives an [ApiClient] that talks
/// to it. The route contract (`routes.json`) comes from the backend OpenAPI.

class ApiRoute {
  ApiRoute(this.key, this.method, this.template, Map<String, dynamic> spec)
    : query = (spec['query'] as Map<String, dynamic>).cast<String, dynamic>(),
      body = spec['body'] as Map<String, dynamic>?,
      pattern = RegExp(
        '^${template.replaceAllMapped(RegExp(r'\{[^}]+\}'), (_) => '[^/]+')}\$',
      ),
      paramCount = RegExp(r'\{[^}]+\}').allMatches(template).length;

  final String key;
  final String method;
  final String template;
  final Map<String, dynamic> query;
  final Map<String, dynamic>? body;
  final RegExp pattern;
  final int paramCount;
}

List<ApiRoute> loadRoutes() {
  final routes = loadFixture('routes');
  return [
    for (final entry in routes.entries)
      ApiRoute(
        entry.key,
        entry.key.split(' ').first,
        entry.key.split(' ').last,
        entry.value as Map<String, dynamic>,
      ),
  ];
}

ApiRoute? matchRoute(List<ApiRoute> routes, String method, String path) {
  final candidates =
      routes
          .where((r) => r.method == method && r.pattern.hasMatch(path))
          .toList()
        ..sort((a, b) => a.paramCount.compareTo(b.paramCount));
  return candidates.isEmpty ? null : candidates.first;
}

class FixtureAdapter implements HttpClientAdapter {
  FixtureAdapter(this.routes, {Map<String, Object>? overrides, this.mutate})
    : overrides = overrides ?? const {};

  /// Changes every JSON reply (a test of unknown values or sparse payloads).
  final Object? Function(Object? json)? mutate;

  final List<ApiRoute> routes;
  final requests = <RequestOptions>[];

  /// Replies that replace a fixture, by route key (`GET /pm/leases`).
  final Map<String, Object> overrides;

  /// Replies by route key. A route without a reply gets `{}` (204 for a delete).
  late final Map<String, Object> replies = _replies();

  Map<String, Object> _replies() {
    Object fx(String group, String name) => loadFixture(group)[name]! as Object;
    return {
      'GET /pm/properties': fx('properties', 'list_page'),
      'GET /pm/properties/{property_id}': fx('properties', 'detail'),
      'POST /pm/properties': fx('properties', 'created'),
      'PATCH /pm/properties/{property_id}': fx('properties', 'created'),
      'GET /pm/leases': fx('leases', 'list_page'),
      'GET /pm/leases/{lease_id}': fx('leases', 'detail'),
      'POST /pm/leases': fx('leases', 'detail'),
      'POST /pm/leases/{lease_id}/renew': fx('leases', 'detail'),
      'POST /pm/leases/{lease_id}/terminate': fx('leases', 'terminated'),
      'POST /pm/leases/{lease_id}/upload-signed': fx('leases', 'upload_signed'),
      'GET /pm/rent/charges': fx('rent', 'charges_page'),
      'POST /pm/rent/charges/generate': fx('rent', 'generate_result'),
      'POST /pm/rent/payments': fx('rent', 'payment'),
      'GET /pm/maintenance/requests': fx('maintenance', 'list_page'),
      'GET /pm/inspections': fx('inspections', 'list_page'),
      'GET /pm/inspections/{inspection_id}': fx('inspections', 'detail'),
      'POST /pm/inspections': fx('inspections', 'detail'),
      'POST /pm/inspections/{inspection_id}/sign': fx('inspections', 'detail'),
      'GET /pm/expenses': fx('expenses', 'list_page'),
      'GET /pm/documents': fx('documents', 'list_page'),
      'GET /pm/documents/{document_id}/download': fx('documents', 'download'),
      'GET /pm/tenants': fx('tenants', 'list_page'),
      'GET /pm/tenants/{tenant_user_id}': fx('tenants', 'detail'),
      'GET /pm/applications/forms': fx('applications', 'forms_page'),
      'GET /pm/applications/forms/{form_id}': fx('applications', 'form'),
      'POST /pm/applications/forms': fx('applications', 'form'),
      'GET /pm/applications': fx('applications', 'inbox_page'),
      'GET /pm/applications/{application_id}': fx('applications', 'detail'),
      'POST /pm/applications/{application_id}/decision': fx(
        'applications',
        'detail',
      ),
      'GET /pm/public/applications/{slug}': fx('applications', 'public_form'),
      'POST /pm/public/applications/{slug}/submit': fx(
        'applications',
        'submitted',
      ),
      'GET /notifications/me': fx('notifications', 'inbox_page'),
      'POST /notifications/deliveries/{delivery_id}/opened': fx(
        'notifications',
        'opened',
      ),
      'GET /pm/dashboard/overview': fx('dashboard', 'overview'),
      'GET /pm/dashboard/activity': fx('dashboard', 'activity_page'),
      'GET /pm/reports/rent-roll': fx('reports', 'rent_roll_page'),
      'GET /pm/reports/income': fx('reports', 'income'),
      'GET /pm/reports/expenses': fx('reports', 'expenses'),
      'GET /pm/reports/pnl': fx('reports', 'pnl'),
      'GET /pm/reports/occupancy': fx('reports', 'occupancy'),
      'GET /pm/reports/maintenance': fx('reports', 'maintenance'),
      'GET /amenities': fx('amenities', 'page'),
      'GET /agents/assigned': fx('agents', 'assigned'),
      'POST /upload': fx('uploads', 'upload_result'),
      'POST /auth/identifier-status': fx('users', 'identifier_status'),
      'GET /users/me/auth-state': fx('users', 'auth_gate'),
      'GET /users/profile': fx('users', 'profile'),
      'PUT /users/profile': fx('users', 'profile'),
    };
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final route = matchRoute(routes, options.method, options.path);
    var reply = route == null
        ? null
        : (overrides[route.key] ?? replies[route.key]);
    // Documents and expenses answer the list fixture with the items of its
    // own kind; a create or an update returns the first item.
    if (route != null && reply == null) {
      if (route.key == 'POST /pm/documents/upload' ||
          route.key == 'PATCH /pm/maintenance/requests/{request_id}' ||
          route.key == 'POST /pm/maintenance/requests' ||
          route.key == 'POST /pm/expenses' ||
          route.key == 'PATCH /pm/expenses/{expense_id}') {
        final group = route.key.contains('documents')
            ? 'documents'
            : route.key.contains('maintenance')
            ? 'maintenance'
            : 'expenses';
        final page = loadFixture(group)['list_page'] as Map<String, dynamic>;
        reply = (page['items'] as List<dynamic>).first;
      }
    }
    // A list answers its fixture for the first page and an empty last page for
    // a request that carries the cursor, so a read that follows `next_cursor`
    // ends and does not see the rows twice.
    if (reply is Map &&
        reply['next_cursor'] != null &&
        options.queryParameters['cursor'] != null) {
      reply = {
        ...reply,
        'items': <Object?>[],
        'has_more': false,
        'next_cursor': null,
      };
    }
    if (reply == null && options.method == 'DELETE') {
      return ResponseBody.fromString('', 204);
    }
    final body = mutate == null ? reply : mutate!(reply);
    return ResponseBody.fromString(
      jsonEncode(body ?? <String, dynamic>{}),
      options.method == 'POST' ? 201 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class AlwaysOnline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<bool> get onConnectivityChanged => const Stream.empty();
}

class NoToken implements AuthTokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<void> clearSession() async {}
}

/// An [ApiClient] that talks to [adapter].
ApiClient fixtureApiClient(
  FixtureAdapter adapter, {
  OwnerScope Function()? ownerScope,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com/api/v1'))
    ..httpClientAdapter = adapter;
  return ApiClient(
    baseUrl: 'https://example.com/api/v1',
    networkInfo: AlwaysOnline(),
    tokenProvider: NoToken(),
    enableLogging: false,
    ownerScope: ownerScope,
    dio: dio,
  );
}
