import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';

abstract interface class InspectionsRepository {
  Future<Page<Inspection>> getInspections({
    required int page,
    required int limit,
    int? propertyId,
    InspectionType? inspectionType,
    InspectionStatus? status,
  });

  Future<Inspection> getInspectionById(int id);

  Future<Inspection> createInspection({
    required int propertyId,
    required InspectionType inspectionType,
    required DateTime scheduledDate,
    String? inspectorName,
    String? notes,
  });

  Future<Inspection> updateInspection(int id, Map<String, dynamic> updates);

  Future<Inspection> startInspection(int id);

  Future<Inspection> completeInspection(int id, {String? notes});

  Future<Inspection> signInspection(
    int id, {
    required String signatureType, // 'tenant' or 'landlord'
    required String signature, // base64 signature data
  });

  Future<void> cancelInspection(int id, {String? reason});

  Future<Inspection> addInspectionItem(
    int inspectionId, {
    required String area,
    required String item,
    required String condition,
    String? notes,
  });

  Future<Inspection> updateInspectionItem(
    int inspectionId,
    int itemId, {
    String? condition,
    String? notes,
  });
}
