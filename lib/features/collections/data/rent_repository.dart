import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
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
      'paid_at': paidAt.toIso8601String(),
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
    required int page,
    required int limit,
    String? status,
  }) async {
    final cacheKey = 'rent_charges:status=$status:page=$page:limit=$limit';
    final cached = _cache.get<List<RentCharge>>(cacheKey);
    if (cached != null) {
      return Page(
        items: cached,
        page: page,
        limit: limit,
        hasMore: cached.length >= limit,
      );
    }

    try {
      final offset = (page - 1) * limit;
      final response = await _client.get(
        '/pm/rent/charges',
        queryParameters: {
          if (status != null) 'status': status,
          'limit': limit,
          'offset': offset,
        },
      );
      final payload = response.data;
      List<Map<String, dynamic>> rawItems = [];
      int? total;
      if (payload is Map<String, dynamic>) {
        final itemsPayload =
            payload['items'] ?? payload['data'] ?? payload['results'];
        if (itemsPayload is List) {
          rawItems = itemsPayload.whereType<Map<String, dynamic>>().toList();
        }
        total = payload['total'] as int?;
      }
      if (rawItems.isEmpty) {
        rawItems = unwrapList(payload).whereType<Map<String, dynamic>>().toList();
      }

      final seenIds = <int?>{};
      final charges = rawItems
          .map(RentCharge.fromJson)
          .where((charge) => charge.amount != null || charge.dueDate != null)
          .where((charge) => seenIds.add(charge.id))
          .toList();

      _cache.set(cacheKey, charges, ttl: _cacheTtl);
      return Page(
        items: charges,
        page: page,
        limit: limit,
        hasMore: total != null
            ? offset + rawItems.length < total
            : rawItems.length >= limit,
      );
    } on NotFoundFailure {
      // No charges exist yet - return empty page instead of error
      return Page(
        items: const <RentCharge>[],
        page: page,
        limit: limit,
        hasMore: false,
      );
    }
  }

  Future<List<RentCharge>> listCharges({
    String? status,
    int limit = 200,
  }) async {
    final page = await listChargesPage(
      page: 1,
      limit: limit,
      status: status,
    );
    return page.items;
  }

  Future<void> generateCharges() async {
    await _client.post('/pm/rent/charges/generate');
    _cache.invalidatePrefix('rent_charges:');
  }

  Future<void> recordPayment(RentPaymentRequest request) async {
    await _client.post('/pm/rent/payments', data: request.toJson());
    _cache.invalidatePrefix('rent_charges:');
  }

  Future<List<RentPayment>> listPayments() async {
    final response = await _client.get('/pm/rent/payments');
    final data = unwrapList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(RentPayment.fromJson)
        .toList();
  }

  Future<TenantPaymentIntent> createTenantPaymentIntent(
    String chargeId,
  ) async {
    final response = await _client.post(
      '/pm/rent/charges/$chargeId/tenant-payment-intent',
    );
    final data = unwrapData(response.data);
    if (data is Map<String, dynamic>) {
      return TenantPaymentIntent.fromJson(data);
    }
    return TenantPaymentIntent.fromJson(const <String, dynamic>{});
  }
}
