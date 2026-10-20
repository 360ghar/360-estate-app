import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';

/// Body of `POST /pm/inspections` (`InspectionChecklistCreate`). `lease_id` and
/// `inspection_type` are required. The checklist lines go in `rooms_data` as
/// `{"items": [{"title": ...}]}`.
class InspectionCreateRequest {
  const InspectionCreateRequest({
    required this.leaseId,
    required this.inspectionType,
    this.conductedAt,
    this.overallNotes,
    this.items = const [],
  });

  final int leaseId;
  final InspectionType inspectionType;
  final DateTime? conductedAt;
  final String? overallNotes;
  final List<String> items;

  Map<String, dynamic> toJson() {
    final notes = overallNotes?.trim();
    return {
      'lease_id': leaseId,
      'inspection_type': inspectionType.wire,
      if (conductedAt != null) 'conducted_at': toApiUtcInstant(conductedAt),
      if (notes != null && notes.isNotEmpty) 'overall_notes': notes,
      if (items.isNotEmpty)
        'rooms_data': {
          'items': [
            for (final item in items) {'title': item},
          ],
        },
    };
  }
}

class InspectionsRepository {
  InspectionsRepository(this._client);

  final ApiClient _client;

  /// Filters are `property_id` and `lease_id`. The route has no tenant or
  /// status filter.
  Future<Page<Inspection>> listPage({
    required String? cursor,
    required int limit,
    int? propertyId,
    int? leaseId,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.inspections,
      ownerScoped: true,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (leaseId != null) 'lease_id': leaseId,
      },
    );
    final raw = unwrapPage(response.data);
    return Page<Inspection>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Inspection.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
  }

  /// Every inspection that matches (follows `next_cursor`).
  Future<List<Inspection>> listAll({int? propertyId, int? leaseId}) {
    return fetchAllPages<Inspection>(
      ({required cursor, required limit}) => listPage(
        cursor: cursor,
        limit: limit,
        propertyId: propertyId,
        leaseId: leaseId,
      ),
    );
  }

  Future<Inspection> fetch(int inspectionId) async {
    final response = await _client.get<dynamic>(
      ApiPaths.inspection(inspectionId),
    );
    return Inspection.fromJson(unwrapMap(response.data));
  }

  Future<Inspection> create(InspectionCreateRequest request) async {
    final response = await _client.post<dynamic>(
      ApiPaths.inspections,
      data: request.toJson(),
      ownerScoped: true,
    );
    return Inspection.fromJson(unwrapMap(response.data));
  }

  /// Records the signature time of the acting party. The body is an object
  /// (`InspectionSign`). Both signature document ids are optional, so an empty
  /// object is valid.
  Future<Inspection> sign(int inspectionId) async {
    final response = await _client.post<dynamic>(
      ApiPaths.inspectionSign(inspectionId),
      data: <String, dynamic>{},
    );
    return Inspection.fromJson(unwrapMap(response.data));
  }
}
