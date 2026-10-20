import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/cache_control.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';

class DashboardRepository {
  DashboardRepository(this._client, this._cache);

  final ApiClient _client;

  /// Account-scoped by the store itself (see `CacheStore.bindAccount`): sign-out
  /// and an account switch drop every entry, so one account never reads the
  /// figures of another.
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 2);

  /// Public so a write elsewhere (rent payment, charge generation) can drop the
  /// figures it changes.
  static const cachePrefix = 'dashboard:';
  static const _overviewKey = '${cachePrefix}overview';
  static const _activityKey = '${cachePrefix}activity';

  /// Drops the cached figures. Pull to refresh calls it so the next read goes
  /// to the backend.
  void clearCache() => _cache.invalidatePrefix(cachePrefix);

  Future<DashboardOverview> fetchOverview() async {
    final cached = _cache.get<DashboardOverview>(_overviewKey);
    if (cached != null) return cached;
    final response = await _client.get<dynamic>(
      ApiPaths.dashboardOverview,
      ownerScoped: true,
    );
    final overview = DashboardOverview.fromJson(unwrapMap(response.data));
    if (isCacheable(response)) {
      _cache.set(_overviewKey, overview, ttl: _cacheTtl);
    }
    return overview;
  }

  /// The newest activity rows: the first page of the feed.
  Future<List<DashboardActivityItem>> fetchActivity() async {
    final cached = _cache.get<List<DashboardActivityItem>>(_activityKey);
    if (cached != null) return cached;
    final response = await _client.get<dynamic>(
      ApiPaths.dashboardActivity,
      ownerScoped: true,
    );
    final page = unwrapPage(response.data);
    final items = page.items
        .whereType<Map<String, dynamic>>()
        .map(DashboardActivityItem.fromJson)
        .toList();
    if (isCacheable(response)) {
      _cache.set(_activityKey, items, ttl: _cacheTtl);
    }
    return items;
  }
}
