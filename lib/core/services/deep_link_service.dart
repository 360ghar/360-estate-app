import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Routes incoming HTTPS and custom-scheme deep links through the GoRouter.
///
/// Supported paths (under `the360ghar.com/estate/...` or the
/// `estate360://...` custom scheme):
///
///   /estate/apply/{slug}      → /public/applications/{slug} (no auth)
///   /estate/property/{id}     → /properties/{id}
///   /estate/task/{id}         → /tasks/{id}
///   /estate/tenant/{id}       → /more/tenants/{id}
///   /estate/lease/{id}        → /more/leases/{id}
///
/// The service captures both the initial link (cold start) and live
/// stream updates (warm/hot). When the user is not yet authenticated the
/// resolved path is stored in [_pendingPath] and replayed by the router
/// redirect once the user lands on the home shell.
class DeepLinkService {
  DeepLinkService({AppLinks? appLinks, GoRouter? router})
      : _appLinks = appLinks ?? AppLinks(),
        _router = router;

  final AppLinks _appLinks;
  GoRouter? _router;
  StreamSubscription<Uri>? _sub;

  static String? _pendingPath;
  static String? consumePendingPath() {
    final path = _pendingPath;
    _pendingPath = null;
    return path;
  }

  /// Bind the router after the GoRouter provider is available.
  void bindRouter(GoRouter router) {
    _router = router;
    if (_pendingPath != null && _pendingPath!.isNotEmpty) {
      final path = _pendingPath!;
      _pendingPath = null;
      _routeToPath(path);
    }
  }

  void init() {
    if (kIsWeb) return;

    unawaited(
      _appLinks
          .getInitialLink()
          .then((uri) {
            if (uri != null) _handle(uri);
          })
          .catchError((Object error, StackTrace stackTrace) {
            AppLogger.w(
              'Initial deep link error',
              error: error,
              stackTrace: stackTrace,
            );
          }),
    );

    _sub = _appLinks.uriLinkStream.listen(
      _handle,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.w(
          'Deep link stream error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }

  void _handle(Uri uri) {
    AppLogger.i('Deep link received: ${uri.scheme}://${uri.host}${uri.path}');
    final path = mapUriToPath(uri);
    if (path == null) {
      AppLogger.w('No deep link mapping for ${uri.scheme}://${uri.host}${uri.path}');
      return;
    }
    _routeToPath(path);
  }

  void _routeToPath(String path) {
    final router = _router;
    if (router == null) {
      _pendingPath = path;
      return;
    }
    _pendingPath = path;
    router.go(path);
  }

  /// Canonical public domain for all 360Ghar deep links. Single source of
  /// truth within this app; keep in sync with the backend `DEEPLINK_DOMAIN`
  /// setting and the hosts declared in AndroidManifest / Runner.entitlements.
  static const String deepLinkDomain = 'the360ghar.com';
  static const String _estateBase = 'https://$deepLinkDomain/estate';

  /// Builds the canonical public share URL for a property.
  static String propertyUrl(String id) => '$_estateBase/property/$id';

  /// Builds the canonical public share URL for a task / maintenance request.
  static String taskUrl(String id) => '$_estateBase/task/$id';

  /// Builds the canonical public share URL for a tenant.
  static String tenantUrl(String id) => '$_estateBase/tenant/$id';

  /// Builds the canonical public share URL for a lease.
  static String leaseUrl(String id) => '$_estateBase/lease/$id';

  /// Builds the canonical public share URL for a rental application.
  static String applicationUrl(String slug) => '$_estateBase/apply/$slug';

  /// Converts an incoming URI to an internal GoRouter path.
  ///
  /// Returns `null` when the URI does not match any known pattern.
  @visibleForTesting
  static String? mapUriToPath(Uri uri) {
    final path = uri.path.isEmpty ? '/${uri.host}' : uri.path;
    final segments = path
        .split('/')
        .where((s) => s.isNotEmpty)
        .toList(growable: false);

    // Custom-scheme fallback: estate360://property/123 -> segments: [property, 123]
    if (uri.scheme == 'estate360') {
      if (segments.isEmpty) return null;
      final head = segments.first;
      if (head == 'apply' && segments.length >= 2) {
        return '/public/applications/${segments[1]}';
      }
      if (segments.length >= 2) {
        return _mapEntity(head, segments[1]);
      }
      return null;
    }

    if (segments.length < 2 || segments[0] != 'estate') return null;
    final entity = segments[1];
    if (segments.length < 3) return null;
    final id = segments[2];
    return _mapEntity(entity, id);
  }

  static String? _mapEntity(String entity, String id) {
    switch (entity) {
      case 'apply':
        return '/public/applications/$id';
      case 'property':
        return '/properties/$id';
      case 'task':
        return '/tasks/$id';
      case 'tenant':
        return '/more/tenants/$id';
      case 'lease':
        return '/more/leases/$id';
    }
    return null;
  }
}
