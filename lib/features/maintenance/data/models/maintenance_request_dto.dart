import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';

final class MaintenanceRequestDto {
  const MaintenanceRequestDto({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    this.leaseId,
    this.tenantName,
    required this.category,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    this.assignedTo,
    this.estimatedCost,
    this.actualCost,
    this.scheduledDate,
    this.completedDate,
    this.notes,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceRequestDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestDto(
      id: json['id'] as int,
      propertyId:
          json['property_id'] as int? ?? json['propertyId'] as int? ?? 0,
      propertyTitle: json['property_title'] as String? ??
          json['propertyTitle'] as String? ??
          '',
      leaseId: json['lease_id'] as int? ?? json['leaseId'] as int?,
      tenantName:
          json['tenant_name'] as String? ?? json['tenantName'] as String?,
      category: json['category'] as String? ?? 'other',
      priority: json['priority'] as String? ?? 'medium',
      status: json['request_status'] as String? ??
          json['status'] as String? ??
          'open',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      assignedTo:
          json['assigned_to'] as String? ?? json['assignedTo'] as String?,
      estimatedCost: _parseDouble(json['estimated_cost'] ?? json['estimatedCost']),
      actualCost: _parseDouble(json['actual_cost'] ?? json['actualCost']),
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : json['scheduledDate'] != null
              ? DateTime.parse(json['scheduledDate'] as String)
              : null,
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'] as String)
          : json['completedDate'] != null
              ? DateTime.parse(json['completedDate'] as String)
              : null,
      notes: json['notes'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>? ??
              json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  final int id;
  final int propertyId;
  final String propertyTitle;
  final int? leaseId;
  final String? tenantName;
  final String category;
  final String priority;
  final String status;
  final String title;
  final String description;
  final String? assignedTo;
  final double? estimatedCost;
  final double? actualCost;
  final DateTime? scheduledDate;
  final DateTime? completedDate;
  final String? notes;
  final List<String>? imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      'category': category,
      'priority': priority,
      'title': title,
      'description': description,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (scheduledDate != null)
        'scheduled_date': scheduledDate!.toIso8601String().split('T')[0],
      if (notes != null) 'notes': notes,
    };
  }

  MaintenanceRequest toEntity() {
    return MaintenanceRequest(
      id: id,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      leaseId: leaseId,
      tenantName: tenantName,
      category: MaintenanceCategory.fromString(category),
      priority: MaintenancePriority.fromString(priority),
      status: MaintenanceStatus.fromString(status),
      title: title,
      description: description,
      assignedTo: assignedTo,
      estimatedCost: estimatedCost,
      actualCost: actualCost,
      scheduledDate: scheduledDate,
      completedDate: completedDate,
      notes: notes,
      imageUrls: imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
