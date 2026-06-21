import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';

class InspectionCreateRequest {
  const InspectionCreateRequest({
    required this.propertyId,
    required this.title,
    this.tenantId,
    this.scheduledAt,
    this.items = const [],
  });

  final String propertyId;
  final String title;
  final String? tenantId;
  final DateTime? scheduledAt;
  final List<String> items;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'property_id': propertyId,
      'title': title,
      if (tenantId != null) 'tenant_id': tenantId,
      if (scheduledAt != null) 'scheduled_at': toApiUtcInstant(scheduledAt),
    };
    if (items.isNotEmpty) {
      payload['items'] = items.map((item) => {'title': item}).toList();
    }
    return payload;
  }
}

class InspectionsRepository {
  InspectionsRepository(this._client);

  final ApiClient _client;

  Future<List<Inspection>> list({
    String? propertyId,
    String? tenantId,
    String? status,
  }) async {
    final response = await _client.get<dynamic>(
      '/pm/inspections/',
      queryParameters: {
        if (propertyId != null) 'property_id': propertyId,
        if (tenantId != null) 'tenant_id': tenantId,
        if (status != null) 'status': status,
      },
    );
    final page = unwrapPage(response.data);
    return page.items
        .whereType<Map<String, dynamic>>()
        .map(Inspection.fromJson)
        .toList();
  }

  Future<Inspection> fetch(String inspectionId) async {
    final response = await _client.get<dynamic>('/pm/inspections/$inspectionId');
    final data = unwrapMap(response.data);
    return Inspection.fromJson(data);
  }

  Future<Inspection> create(InspectionCreateRequest request) async {
    final response = await _client.post<dynamic>(
      '/pm/inspections/',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    return Inspection.fromJson(data);
  }

  Future<Inspection> sign(String inspectionId) async {
    final response = await _client.post<dynamic>('/pm/inspections/$inspectionId/sign');
    final data = unwrapMap(response.data);
    if (data.isNotEmpty) return Inspection.fromJson(data);
    return fetch(inspectionId);
  }
}
