import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:flutter/material.dart';

/// Display names, icons and colours for the wire enums of a maintenance
/// request. The enums themselves (`MaintenanceUrgency`,
/// `MaintenanceRequestStatus`, `MaintenanceCategory`) are generated from the
/// backend. A value the backend sends that the app does not know reads as null.
extension MaintenanceUrgencyUi on MaintenanceUrgency {
  String get displayName => switch (this) {
    MaintenanceUrgency.low => 'Low',
    MaintenanceUrgency.medium => 'Medium',
    MaintenanceUrgency.high => 'High',
    MaintenanceUrgency.emergency => 'Emergency',
  };

  IconData get icon => switch (this) {
    MaintenanceUrgency.low => Icons.arrow_downward,
    MaintenanceUrgency.medium => Icons.remove,
    MaintenanceUrgency.high => Icons.arrow_upward,
    MaintenanceUrgency.emergency => Icons.priority_high,
  };
}

extension MaintenanceRequestStatusUi on MaintenanceRequestStatus {
  String get displayName => switch (this) {
    MaintenanceRequestStatus.open => 'Open',
    MaintenanceRequestStatus.inReview => 'In review',
    MaintenanceRequestStatus.workOrderCreated => 'In progress',
    MaintenanceRequestStatus.resolved => 'Resolved',
    MaintenanceRequestStatus.closed => 'Closed',
  };
}

extension MaintenanceCategoryUi on MaintenanceCategory {
  String get displayName => switch (this) {
    MaintenanceCategory.plumbing => 'Plumbing',
    MaintenanceCategory.electrical => 'Electrical',
    MaintenanceCategory.hvac => 'HVAC',
    MaintenanceCategory.appliance => 'Appliance',
    MaintenanceCategory.structural => 'Structural',
    MaintenanceCategory.pestControl => 'Pest control',
    MaintenanceCategory.cleaning => 'Cleaning',
    MaintenanceCategory.other => 'Other',
  };

  IconData get icon => switch (this) {
    MaintenanceCategory.plumbing => Icons.plumbing,
    MaintenanceCategory.electrical => Icons.electrical_services,
    MaintenanceCategory.hvac => Icons.ac_unit,
    MaintenanceCategory.appliance => Icons.kitchen,
    MaintenanceCategory.structural => Icons.foundation,
    MaintenanceCategory.pestControl => Icons.bug_report,
    MaintenanceCategory.cleaning => Icons.cleaning_services,
    MaintenanceCategory.other => Icons.build,
  };
}

/// A maintenance request (`MaintenanceRequest`). `propertyTitle` and
/// `tenantName` are joined by the backend. A request has no photos and no free
/// "assigned to" text: the assignee is an agent id.
final class MaintenanceRequest {
  const MaintenanceRequest({
    required this.id,
    required this.propertyId,
    required this.title,
    this.propertyTitle,
    this.leaseId,
    this.tenantName,
    this.category,
    this.urgency,
    this.status,
    this.description,
    this.availabilityNotes,
    this.assignedAgentId,
    this.workOrderStatus,
    this.estimatedCost,
    this.actualCost,
    this.scheduledFor,
    this.completedAt,
    this.completionNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: parseInt(json['id']) ?? 0,
      propertyId: parseInt(json['property_id']) ?? 0,
      title: parseString(json['title']) ?? '',
      propertyTitle: parseString(json['property_title']),
      leaseId: parseInt(json['lease_id']),
      tenantName: parseString(json['tenant_name']),
      category: MaintenanceCategory.fromJson(json['category']),
      urgency: MaintenanceUrgency.fromJson(json['urgency']),
      status: MaintenanceRequestStatus.fromJson(json['request_status']),
      description: parseString(json['description']),
      availabilityNotes: parseString(json['availability_notes']),
      assignedAgentId: parseInt(json['assigned_agent_id']),
      workOrderStatus: WorkOrderStatus.fromJson(json['work_order_status']),
      estimatedCost: parseDouble(json['estimated_cost']),
      actualCost: parseDouble(json['actual_cost']),
      scheduledFor: parseDateTime(json['scheduled_for']),
      completedAt: parseDateTime(json['completed_at'] ?? json['closed_at']),
      completionNotes: parseString(json['completion_notes']),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  final int id;
  final int propertyId;
  final String title;
  final String? propertyTitle;
  final int? leaseId;
  final String? tenantName;
  final MaintenanceCategory? category;
  final MaintenanceUrgency? urgency;
  final MaintenanceRequestStatus? status;
  final String? description;
  final String? availabilityNotes;
  final int? assignedAgentId;
  final WorkOrderStatus? workOrderStatus;
  final double? estimatedCost;
  final double? actualCost;
  final DateTime? scheduledFor;
  final DateTime? completedAt;
  final String? completionNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// The property name for a card. The backend joins it. Falls back to the id.
  String get propertyLabel {
    final name = propertyTitle?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Property #$propertyId';
  }

  bool get isOpen => status == MaintenanceRequestStatus.open;
  bool get isInProgress =>
      status == MaintenanceRequestStatus.workOrderCreated ||
      status == MaintenanceRequestStatus.inReview;
  bool get isFinished =>
      status == MaintenanceRequestStatus.resolved ||
      status == MaintenanceRequestStatus.closed;
  bool get hasCostEstimate => estimatedCost != null && estimatedCost! > 0;
}

/// The keys a PATCH to a maintenance request may carry. Only a set value is
/// sent. A request has `urgency`, not `priority`.
final class MaintenanceUpdate {
  const MaintenanceUpdate({
    this.status,
    this.urgency,
    this.completionNotes,
    this.assignedAgentId,
    this.estimatedCost,
    this.actualCost,
    this.scheduledFor,
  });

  final MaintenanceRequestStatus? status;
  final MaintenanceUrgency? urgency;
  final String? completionNotes;
  final int? assignedAgentId;
  final double? estimatedCost;
  final double? actualCost;
  final DateTime? scheduledFor;

  Map<String, dynamic> toJson() {
    final note = completionNotes?.trim();
    return {
      if (status != null) 'request_status': status!.wire,
      if (urgency != null) 'urgency': urgency!.wire,
      if (note != null && note.isNotEmpty) 'completion_notes': note,
      if (assignedAgentId != null) 'assigned_agent_id': assignedAgentId,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (actualCost != null) 'actual_cost': actualCost,
      if (scheduledFor != null) 'scheduled_for': toApiUtcInstant(scheduledFor),
    };
  }
}
