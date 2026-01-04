import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/inspections/data/models/inspection_dto.dart';

/// Remote data source for property inspections.
/// NOTE: The PM inspections endpoints (/pm/inspections/*) do not yet exist in the backend.
abstract interface class InspectionsRemoteDataSource {
  Future<List<InspectionDto>> getInspections({
    required int limit,
    required int offset,
    int? propertyId,
    int? leaseId,
    String? inspectionType,
    String? status,
  });

  Future<InspectionDto> getInspectionById(int id);

  Future<InspectionDto> createInspection(Map<String, dynamic> data);

  Future<InspectionDto> updateInspection(int id, Map<String, dynamic> updates);

  Future<InspectionDto> startInspection(int id);

  Future<InspectionDto> completeInspection(int id, {String? notes});

  Future<InspectionDto> signInspection(int id, Map<String, dynamic> data);

  Future<void> cancelInspection(int id, {String? reason});

  Future<InspectionDto> addInspectionItem(int inspectionId, Map<String, dynamic> data);

  Future<InspectionDto> updateInspectionItem(int inspectionId, int itemId, Map<String, dynamic> data);
}

/// Stub implementation that returns empty data since PM inspections endpoints
/// are not available in the current backend.
final class ApiInspectionsRemoteDataSource
    implements InspectionsRemoteDataSource {
  ApiInspectionsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<InspectionDto>> getInspections({
    required int limit,
    required int offset,
    int? propertyId,
    int? leaseId,
    String? inspectionType,
    String? status,
  }) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    return [];
  }

  @override
  Future<InspectionDto> getInspectionById(int id) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspections are not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> createInspection(Map<String, dynamic> data) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection creation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> updateInspection(
      int id, Map<String, dynamic> updates) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection update is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> startInspection(int id) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection start is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> completeInspection(int id, {String? notes}) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection completion is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> signInspection(int id, Map<String, dynamic> data) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection signing is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<void> cancelInspection(int id, {String? reason}) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection cancellation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> addInspectionItem(int inspectionId, Map<String, dynamic> data) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection item addition is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<InspectionDto> updateInspectionItem(
    int inspectionId,
    int itemId,
    Map<String, dynamic> data,
  ) async {
    print('[INSPECTIONS] WARNING: PM inspections endpoint not available');
    throw UnsupportedError(
      'Inspection item update is not yet available. PM module pending backend implementation.',
    );
  }
}
