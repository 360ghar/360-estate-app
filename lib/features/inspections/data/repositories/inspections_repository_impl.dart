import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/inspections/data/datasources/inspections_remote_data_source.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/domain/repositories/inspections_repository.dart';

final class InspectionsRepositoryImpl implements InspectionsRepository {
  InspectionsRepositoryImpl({required InspectionsRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final InspectionsRemoteDataSource _dataSource;

  @override
  Future<Page<Inspection>> getInspections({
    required int page,
    required int limit,
    int? propertyId,
    InspectionType? inspectionType,
    InspectionStatus? status,
  }) async {
    final offset = (page - 1) * limit;
    final dtos = await _dataSource.getInspections(
      limit: limit,
      offset: offset,
      propertyId: propertyId,
      inspectionType: inspectionType?.apiValue,
      status: status?.apiValue,
    );

    final inspections = dtos.map((dto) => dto.toEntity()).toList();

    return Page(
      items: inspections,
      page: page,
      limit: limit,
      hasMore: inspections.length >= limit,
    );
  }

  @override
  Future<Inspection> getInspectionById(int id) async {
    final dto = await _dataSource.getInspectionById(id);
    return dto.toEntity();
  }

  @override
  Future<Inspection> createInspection({
    required int propertyId,
    required InspectionType inspectionType,
    required DateTime scheduledDate,
    String? inspectorName,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      'property_id': propertyId,
      'inspection_type': inspectionType.apiValue,
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      if (inspectorName != null) 'inspector_name': inspectorName,
      if (notes != null) 'notes': notes,
    };

    final dto = await _dataSource.createInspection(data);
    return dto.toEntity();
  }

  @override
  Future<Inspection> updateInspection(
      int id, Map<String, dynamic> updates) async {
    final dto = await _dataSource.updateInspection(id, updates);
    return dto.toEntity();
  }

  @override
  Future<Inspection> startInspection(int id) async {
    final dto = await _dataSource.startInspection(id);
    return dto.toEntity();
  }

  @override
  Future<Inspection> completeInspection(int id, {String? notes}) async {
    final dto = await _dataSource.completeInspection(id, notes: notes);
    return dto.toEntity();
  }

  @override
  Future<Inspection> signInspection(
    int id, {
    required String signatureType,
    required String signature,
  }) async {
    final data = {
      'signature_type': signatureType,
      'signature': signature,
    };
    final dto = await _dataSource.signInspection(id, data);
    return dto.toEntity();
  }

  @override
  Future<void> cancelInspection(int id, {String? reason}) async {
    await _dataSource.cancelInspection(id, reason: reason);
  }

  @override
  Future<Inspection> addInspectionItem(
    int inspectionId, {
    required String area,
    required String item,
    required String condition,
    String? notes,
  }) async {
    final data = {
      'area': area,
      'item': item,
      'condition': condition,
      if (notes != null) 'notes': notes,
    };
    final dto = await _dataSource.addInspectionItem(inspectionId, data);
    return dto.toEntity();
  }

  @override
  Future<Inspection> updateInspectionItem(
    int inspectionId,
    int itemId, {
    String? condition,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      if (condition != null) 'condition': condition,
      if (notes != null) 'notes': notes,
    };
    final dto = await _dataSource.updateInspectionItem(
      inspectionId,
      itemId,
      data,
    );
    return dto.toEntity();
  }
}
