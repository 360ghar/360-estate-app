import 'package:estate_app/core/utils/parse.dart';
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
    final propertyTitle = _extractPropertyTitle(json);
    return MaintenanceRequestDto(
      id: parseInt(json['id']) ?? 0,
      propertyId: parseInt(json['property_id'] ?? json['propertyId']) ?? 0,
      propertyTitle: propertyTitle,
      leaseId: parseInt(json['lease_id'] ?? json['leaseId']),
      tenantName: parseString(json['tenant_name'] ?? json['tenantName']),
      category: parseString(json['category']) ?? 'other',
      priority:
          parseString(json['urgency'] ?? json['priority']) ?? 'medium',
      status: parseString(json['request_status'] ?? json['status']) ?? 'open',
      title: parseString(json['title']) ?? '',
      description: parseString(json['description']) ?? '',
      assignedTo: parseString(
        json['assigned_to'] ??
            json['assignedTo'] ??
            json['assigned_agent_id'],
      ),
      estimatedCost: parseDouble(json['estimated_cost'] ?? json['estimatedCost']),
      actualCost: parseDouble(json['actual_cost'] ?? json['actualCost']),
      scheduledDate: parseDateTime(
        json['scheduled_for'] ??
            json['scheduled_date'] ??
            json['scheduledDate'],
      ),
      completedDate: parseDateTime(
        json['completed_at'] ??
            json['completed_date'] ??
            json['completedDate'] ??
            json['closed_at'],
      ),
      notes: parseString(
        json['notes'] ??
            json['completion_notes'] ??
            json['availability_notes'],
      ),
      imageUrls: parseStringList(
        json['image_urls'] ?? json['imageUrls'] ?? json['attachments'],
      ),
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDateTime(json['updated_at'] ?? json['updatedAt']),
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
      'urgency': _mapUrgency(priority),
      'title': title,
      'description': description,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (scheduledDate != null)
        'scheduled_for': scheduledDate!.toIso8601String(),
      if (notes != null) 'availability_notes': notes,
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

  static String _extractPropertyTitle(Map<String, dynamic> json) {
    final direct = parseString(
      json['property_title'] ??
          json['propertyTitle'] ??
          json['property_name'] ??
          json['propertyName'],
    );
    if (direct != null && direct.trim().isNotEmpty) return direct;

    final property = json['property'];
    if (property is Map) {
      final nested = parseString(
        property['name'] ??
            property['title'] ??
            property['property_name'] ??
            property['propertyTitle'] ??
            property['property_title'],
      );
      if (nested != null && nested.trim().isNotEmpty) return nested;
    }

    return '';
  }

  static String _mapUrgency(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'urgent') return 'emergency';
    return normalized.isEmpty ? 'medium' : normalized;
  }
}
