import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/models/rent_payment.dart';
import 'package:estate_app/features/collections/models/tenant_payment_intent.dart';

class RentPaymentRequest {
  const RentPaymentRequest({
    required this.tenantId,
    required this.amount,
    required this.paidAt,
    required this.method,
    this.notes,
  });

  final String tenantId;
  final double amount;
  final DateTime paidAt;
  final String method;
  final String? notes;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'tenant_id': tenantId,
      'amount': amount,
      'paid_at': toApiUtcInstant(paidAt),
      'method': method,
    };
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    return payload;
  }
}

class RentRepository {
  RentRepository(this._client, this._cache);

  final ApiClient _client;
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 3);

  Future<Page<RentCharge>> listChargesPage({
    required String? cursor,
    required int limit,
    String? status,
    int? propertyId,
  }) async {
    final cacheKey =
        'rent_charges:status=$status:property=$propertyId:cursor=${cursor ?? 'first'}:limit=$limit';
    final cached = _cache
        .get<({List<RentCharge> items, String? nextCursor, bool hasMore})>(
            cacheKey);
    if (cached != null) {
      return Page(
        items: cached.items,
        limit: limit,
        hasMore: cached.hasMore,
        nextCursor: cached.nextCursor,
      );
    }

    try {
      final response = await _client.get<dynamic>(
        '/pm/rent/charges',
        queryParameters: {
          if (status != null) 'status': status,
          if (propertyId != null) 'property_id': propertyId,
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
      );
      final page = unwrapPage(response.data);
      final rawItems = page.items
          .whereType<Map<String, dynamic>>()
          .toList();

      final seenIds = <int?>{};
      final charges = rawItems
          .map(RentCharge.fromJson)
          .where((charge) => charge.amount != null || charge.dueDate != null)
          .where((charge) => seenIds.add(charge.id))
          .toList();

      _cache.set(
        cacheKey,
        (items: charges, nextCursor: page.nextCursor, hasMore: page.hasMore),
        ttl: _cacheTtl,
      );
      return Page(
        items: charges,
        limit: limit,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
      );
    } on NotFoundFailure {
      // No charges exist yet - return empty page instead of error
      return Page(
        items: const <RentCharge>[],
        limit: limit,
        hasMore: false,
      );
    }
  }

  Future<List<RentCharge>> listCharges({
    String? status,
    int? propertyId,
    int limit = 200,
  }) async {
    final all = <RentCharge>[];
    String? cursor;

    while (true) {
      final page = await listChargesPage(
        cursor: cursor,
        limit: limit,
        status: status,
        propertyId: propertyId,
      );
      all.addAll(page.items);

      if (!page.hasMore || page.nextCursor == null || page.nextCursor == cursor) {
        break;
      }
      cursor = page.nextCursor;
    }

    return all;
  }

  Future<void> generateCharges() async {
    await _client.post<dynamic>('/pm/rent/charges/generate');
    _cache.invalidatePrefix('rent_charges:');
  }

  Future<void> recordPayment(RentPaymentRequest request) async {
    await _client.post<dynamic>('/pm/rent/payments', data: request.toJson());
    _cache.invalidatePrefix('rent_charges:');
  }

  Future<List<RentPayment>> listPayments() async {
    final response = await _client.get<dynamic>('/pm/rent/payments');
    final data = unwrapList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(RentPayment.fromJson)
        .toList();
  }

  Future<TenantPaymentIntent> createTenantPaymentIntent(String chargeId) async {
    final response = await _client.post<dynamic>(
      '/pm/rent/charges/$chargeId/tenant-payment-intent',
    );
    final data = unwrapData(response.data);
    if (data is Map<String, dynamic>) {
      return TenantPaymentIntent.fromJson(data);
    }
    return TenantPaymentIntent.fromJson(const <String, dynamic>{});
  }
}
