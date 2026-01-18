import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/tasks/models/maintenance_request.dart';

class MaintenanceUpdate {
  const MaintenanceUpdate({this.status, this.priority, this.notes});

  final String? status;
  final String? priority;
  final String? notes;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (status != null && status!.trim().isNotEmpty) {
      payload['status'] = status!.trim();
    }
    if (priority != null && priority!.trim().isNotEmpty) {
      payload['priority'] = priority!.trim();
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    return payload;
  }
}

class MaintenanceRepository {
  MaintenanceRepository(this._client, this._cache);

  final ApiClient _client;
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 3);

  Future<Page<MaintenanceRequest>> listPage({
    required int page,
    required int limit,
  }) async {
    final cacheKey = 'maintenance:page=$page:limit=$limit';
    final cached = _cache.get<List<MaintenanceRequest>>(cacheKey);
    if (cached != null) {
      return Page(
        items: cached,
        page: page,
        limit: limit,
        hasMore: cached.length >= limit,
      );
    }

    final response = await _client.get(
      '/pm/maintenance/requests',
      queryParameters: {
        'page': page,
        'limit': limit,
        'offset': (page - 1) * limit,
      },
    );
    final data = unwrapList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(MaintenanceRequest.fromJson)
        .toList();
    _cache.set(cacheKey, data, ttl: _cacheTtl);
    return Page(
      items: data,
      page: page,
      limit: limit,
      hasMore: data.length >= limit,
    );
  }

  Future<List<MaintenanceRequest>> list({int limit = 200}) async {
    final page = await listPage(page: 1, limit: limit);
    return page.items;
  }

  Future<MaintenanceRequest> update(
    String id,
    MaintenanceUpdate update,
  ) async {
    final response = await _client.patch(
      '/pm/maintenance/requests/$id',
      data: update.toJson(),
    );
    final data = unwrapMap(response.data);
    _cache.invalidatePrefix('maintenance:');
    return MaintenanceRequest.fromJson(data);
  }

  Future<MaintenanceRequest> create({
    required String title,
    required String description,
    String? propertyId,
    String? tenantId,
    List<String>? attachments,
    String? category,
    String? priority,
  }) async {
    final payload = <String, dynamic>{
      'title': title,
      'description': description,
      if (propertyId != null) 'property_id': propertyId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (attachments != null && attachments.isNotEmpty)
        'attachments': attachments,
      if (category != null) 'category': category,
      if (priority != null) 'urgency': priority,
    };

    final response = await _client.post(
      '/pm/maintenance/requests',
      data: payload,
    );
    final data = unwrapMap(response.data);
    _cache.invalidatePrefix('maintenance:');
    return MaintenanceRequest.fromJson(data);
  }
}
