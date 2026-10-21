import 'package:dio/dio.dart' show Response;
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/cache_control.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/models/rent_payment.dart';
import 'package:estate_app/features/home/data/dashboard_repository.dart';

/// Body of `POST /pm/rent/payments` (`RentPaymentCreate`). The payment is
/// recorded against a charge: `charge_id` and `amount_paid` are required.
/// `payment_method` is one of the `PaymentMethod` wire values.
class RentPaymentRequest {
  const RentPaymentRequest({
    required this.chargeId,
    required this.amountPaid,
    this.paidAt,
    this.paymentMethod,
    this.reference,
    this.notes,
  });

  final int chargeId;
  final double amountPaid;
  final DateTime? paidAt;
  final PaymentMethod? paymentMethod;
  final String? reference;
  final String? notes;

  Map<String, dynamic> toJson() {
    String? text(String? value) {
      final trimmed = value?.trim();
      return trimmed == null || trimmed.isEmpty ? null : trimmed;
    }

    return {
      'charge_id': chargeId,
      'amount_paid': amountPaid,
      if (paidAt != null) 'paid_at': toApiUtcInstant(paidAt),
      if (paymentMethod != null) 'payment_method': paymentMethod!.wire,
      if (text(reference) != null) 'reference': text(reference),
      if (text(notes) != null) 'notes': text(notes),
    };
  }
}

class RentRepository {
  RentRepository(this._client, this._cache);

  final ApiClient _client;

  /// Account-scoped by the store itself (see `CacheStore.bindAccount`).
  final CacheStore _cache;
  static const _cacheTtl = Duration(minutes: 3);
  static const _cachePrefix = 'rent_charges:';

  /// One page of charges, each with its totals. The amounts count settled
  /// payments only. `status` is the read-time status (a charge past its grace
  /// period with a balance is `overdue`).
  Future<Page<RentChargeWithTotals>> listChargesPage({
    required String? cursor,
    required int limit,
    RentChargeStatus? status,
    int? propertyId,
    int? leaseId,
  }) async {
    final cacheKey =
        '$_cachePrefix${status?.wire ?? 'all'}:property=$propertyId:'
        'lease=$leaseId:${cursor ?? Page.nullCursorCacheKey}:limit=$limit';
    final cached = _cache.get<Page<RentChargeWithTotals>>(cacheKey);
    if (cached != null) return cached;
    final generation = _cache.generation;

    final Response<dynamic> response;
    try {
      response = await _client.get<dynamic>(
        ApiPaths.rentCharges,
        ownerScoped: true,
        queryParameters: {
          if (status != null) 'status': status.wire,
          if (propertyId != null) 'property_id': propertyId,
          if (leaseId != null) 'lease_id': leaseId,
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
      );
    } on NotFoundFailure {
      // No charges exist yet: an empty page, not an error.
      return Page<RentChargeWithTotals>(
        items: const <RentChargeWithTotals>[],
        limit: limit,
        hasMore: false,
      );
    }
    final raw = unwrapPage(response.data);
    final result = Page<RentChargeWithTotals>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(RentChargeWithTotals.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
      total: raw.total,
    );
    if (isCacheable(response)) {
      _cache.set(cacheKey, result, ttl: _cacheTtl, generation: generation);
    }
    return result;
  }

  /// Every charge that matches (follows `next_cursor`).
  Future<List<RentChargeWithTotals>> listAllCharges({
    RentChargeStatus? status,
    int? propertyId,
    int? leaseId,
  }) {
    return fetchAllPages<RentChargeWithTotals>(
      ({required cursor, required limit}) => listChargesPage(
        cursor: cursor,
        limit: limit,
        status: status,
        propertyId: propertyId,
        leaseId: leaseId,
      ),
    );
  }

  /// `POST /pm/rent/charges/generate`. The body is optional: without
  /// `start_month` it generates the current month for the owner's leases.
  Future<RentChargeGenerateResult> generateCharges() async {
    final response = await _client.post<dynamic>(
      ApiPaths.rentChargesGenerate,
      data: <String, dynamic>{},
      ownerScoped: true,
    );
    _invalidateAfterWrite();
    return RentChargeGenerateResult.fromJson(unwrapMap(response.data));
  }

  /// Drops the cached charge pages so the next read goes to the backend.
  void clearCache() => _cache.invalidatePrefix(_cachePrefix);

  /// Charges and payments feed the Home KPIs (for example
  /// `outstanding_rent_total`) and the activity feed, so both caches go.
  void _invalidateAfterWrite() {
    _cache
      ..invalidatePrefix(_cachePrefix)
      ..invalidatePrefix(DashboardRepository.cachePrefix);
  }

  Future<RentPayment> recordPayment(RentPaymentRequest request) async {
    final response = await _client.post<dynamic>(
      ApiPaths.rentPayments,
      data: request.toJson(),
    );
    _invalidateAfterWrite();
    return RentPayment.fromJson(unwrapMap(response.data));
  }
}
