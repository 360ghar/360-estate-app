import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';

class DashboardRepository {
  DashboardRepository(this._client, this._cache);

  final ApiClient _client;
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 2);

  Future<DashboardOverview> fetchOverview() async {
    final cached = _cache.get<DashboardOverview>('dashboard:overview');
    if (cached != null) return cached;
    final response = await _client.get('/pm/dashboard/overview');
    final data = unwrapMap(response.data);
    final overview = DashboardOverview.fromJson(data);
    _cache.set('dashboard:overview', overview, ttl: _cacheTtl);
    return overview;
  }

  Future<List<DashboardActivityItem>> fetchActivity() async {
    final cached =
        _cache.get<List<DashboardActivityItem>>('dashboard:activity');
    if (cached != null) return cached;
    final response = await _client.get('/pm/dashboard/activity');
    final data = unwrapList(response.data);
    final items = data
        .whereType<Map<String, dynamic>>()
        .map(DashboardActivityItem.fromJson)
        .toList();
    _cache.set('dashboard:activity', items, ttl: _cacheTtl);
    return items;
  }
}
