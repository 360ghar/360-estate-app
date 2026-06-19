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
    required String? cursor,
    required int limit,
  }) async {
    final cacheKey = 'maintenance:cursor=${cursor ?? 'first'}:limit=$limit';
    final cached = _cache.get<
        ({List<MaintenanceRequest> items, String? nextCursor, bool hasMore})>(
        cacheKey);
    if (cached != null) {
      return Page(
        items: cached.items,
        limit: limit,
        hasMore: cached.hasMore,
        nextCursor: cached.nextCursor,
      );
    }

    final response = await _client.get<dynamic>(
      '/pm/maintenance/requests',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
    );
    final page = unwrapPage(response.data);
    final data = page.items
        .whereType<Map<String, dynamic>>()
        .map(MaintenanceRequest.fromJson)
        .toList();
    _cache.set(
      cacheKey,
      (items: data, nextCursor: page.nextCursor, hasMore: page.hasMore),
      ttl: _cacheTtl,
    );
    return Page(
      items: data,
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  Future<List<MaintenanceRequest>> list({int limit = 200}) async {
    final page = await listPage(cursor: null, limit: limit);
    return page.items;
  }

  Future<MaintenanceRequest> update(
    String id,
    MaintenanceUpdate update,
  ) async {
    final response = await _client.patch<dynamic>(
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

    final response = await _client.post<dynamic>(
      '/pm/maintenance/requests',
      data: payload,
    );
    final data = unwrapMap(response.data);
    _cache.invalidatePrefix('maintenance:');
    return MaintenanceRequest.fromJson(data);
  }
}
