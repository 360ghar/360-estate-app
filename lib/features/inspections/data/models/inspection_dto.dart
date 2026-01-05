import 'package:estate_app/features/inspections/domain/entities/inspection.dart';

final class InspectionItemDto {
  const InspectionItemDto({
    required this.id,
    required this.area,
    required this.item,
    required this.condition,
    this.notes,
    this.photoUrls = const [],
  });

  factory InspectionItemDto.fromJson(Map<String, dynamic> json) {
    return InspectionItemDto(
      id: json['id'] as int,
      area: json['area'] as String? ?? '',
      item: json['item'] as String? ?? '',
      condition: json['condition'] as String? ?? 'good',
      notes: json['notes'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  final int id;
  final String area;
  final String item;
  final String condition;
  final String? notes;
  final List<String> photoUrls;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area': area,
      'item': item,
      'condition': condition,
      if (notes != null) 'notes': notes,
      'photo_urls': photoUrls,
    };
  }

  InspectionItem toEntity() {
    return InspectionItem(
      id: id,
      area: area,
      item: item,
      condition: condition,
      notes: notes,
      photoUrls: photoUrls,
    );
  }
}

final class InspectionDto {
  const InspectionDto({
    required this.id,
    required this.propertyId,
    required this.inspectionType,
    required this.status,
    required this.scheduledDate,
    this.completedDate,
    this.inspectorName,
    this.tenantSignature,
    this.landlordSignature,
    this.notes,
    this.items = const [],
    this.propertyTitle,
    this.propertyAddress,
    this.tenantName,
    this.createdAt,
    this.updatedAt,
  });

  factory InspectionDto.fromJson(Map<String, dynamic> json) {
    return InspectionDto(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      inspectionType: json['inspection_type'] as String? ?? 'routine',
      status: json['status'] as String? ?? 'scheduled',
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'] as String)
          : null,
      inspectorName: json['inspector_name'] as String?,
      tenantSignature: json['tenant_signature'] as String?,
      landlordSignature: json['landlord_signature'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => InspectionItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      propertyTitle: json['property_title'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['title'] as String?,
      propertyAddress: json['property_address'] as String? ??
          (json['property'] as Map<String, dynamic>?)?['address'] as String?,
      tenantName: json['tenant_name'] as String? ??
          (json['tenant'] as Map<String, dynamic>?)?['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  final int id;
  final int propertyId;
  final String inspectionType;
  final String status;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? inspectorName;
  final String? tenantSignature;
  final String? landlordSignature;
  final String? notes;
  final List<InspectionItemDto> items;
  final String? propertyTitle;
  final String? propertyAddress;
  final String? tenantName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'inspection_type': inspectionType,
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      if (inspectorName != null) 'inspector_name': inspectorName,
      if (notes != null) 'notes': notes,
    };
  }

  Inspection toEntity() {
    return Inspection(
      id: id,
      propertyId: propertyId,
      inspectionType: InspectionType.fromApiValue(inspectionType),
      status: InspectionStatus.fromApiValue(status),
      scheduledDate: scheduledDate,
      completedDate: completedDate,
      inspectorName: inspectorName,
      tenantSignature: tenantSignature,
      landlordSignature: landlordSignature,
      notes: notes,
      items: items.map((i) => i.toEntity()).toList(),
      propertyTitle: propertyTitle,
      propertyAddress: propertyAddress,
      tenantName: tenantName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
