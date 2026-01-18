import 'package:flutter/material.dart';

enum MaintenancePriority {
  low,
  medium,
  high,
  urgent,
  ;

  static MaintenancePriority fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'emergency':
      case 'urgent':
        return MaintenancePriority.urgent;
      case 'high':
        return MaintenancePriority.high;
      case 'low':
        return MaintenancePriority.low;
      case 'medium':
      default:
        return MaintenancePriority.medium;
    }
  }

  String get displayName {
    switch (this) {
      case MaintenancePriority.low:
        return 'Low';
      case MaintenancePriority.medium:
        return 'Medium';
      case MaintenancePriority.high:
        return 'High';
      case MaintenancePriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case MaintenancePriority.low:
        return Colors.green;
      case MaintenancePriority.medium:
        return Colors.orange;
      case MaintenancePriority.high:
        return Colors.deepOrange;
      case MaintenancePriority.urgent:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenancePriority.low:
        return Icons.arrow_downward;
      case MaintenancePriority.medium:
        return Icons.remove;
      case MaintenancePriority.high:
        return Icons.arrow_upward;
      case MaintenancePriority.urgent:
        return Icons.priority_high;
    }
  }
}

enum MaintenanceStatus {
  open,
  inProgress,
  onHold,
  completed,
  cancelled,
  ;

  static MaintenanceStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'open':
        return MaintenanceStatus.open;
      case 'in_review':
      case 'inreview':
        return MaintenanceStatus.onHold;
      case 'work_order_created':
      case 'workordercreated':
        return MaintenanceStatus.inProgress;
      case 'in_progress':
      case 'inprogress':
        return MaintenanceStatus.inProgress;
      case 'on_hold':
      case 'onhold':
        return MaintenanceStatus.onHold;
      case 'resolved':
        return MaintenanceStatus.completed;
      case 'completed':
        return MaintenanceStatus.completed;
      case 'closed':
        return MaintenanceStatus.completed;
      case 'cancelled':
      case 'canceled':
        return MaintenanceStatus.cancelled;
      default:
        return MaintenanceStatus.open;
    }
  }

  String get displayName {
    switch (this) {
      case MaintenanceStatus.open:
        return 'Open';
      case MaintenanceStatus.inProgress:
        return 'In Progress';
      case MaintenanceStatus.onHold:
        return 'On Hold';
      case MaintenanceStatus.completed:
        return 'Completed';
      case MaintenanceStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get apiValue {
    switch (this) {
      case MaintenanceStatus.open:
        return 'open';
      case MaintenanceStatus.inProgress:
        return 'work_order_created';
      case MaintenanceStatus.onHold:
        return 'in_review';
      case MaintenanceStatus.completed:
        return 'resolved';
      case MaintenanceStatus.cancelled:
        return 'closed';
    }
  }

  Color get color {
    switch (this) {
      case MaintenanceStatus.open:
        return Colors.blue;
      case MaintenanceStatus.inProgress:
        return Colors.orange;
      case MaintenanceStatus.onHold:
        return Colors.grey;
      case MaintenanceStatus.completed:
        return Colors.green;
      case MaintenanceStatus.cancelled:
        return Colors.red;
    }
  }
}

enum MaintenanceCategory {
  plumbing,
  electrical,
  hvac,
  appliance,
  structural,
  painting,
  flooring,
  roofing,
  landscaping,
  pest,
  cleaning,
  security,
  other,
  ;

  static MaintenanceCategory fromString(String value) {
    final normalized = value.toLowerCase();
    if (normalized == 'pest_control' || normalized == 'pestcontrol') {
      return MaintenanceCategory.pest;
    }
    return MaintenanceCategory.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => MaintenanceCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case MaintenanceCategory.plumbing:
        return 'Plumbing';
      case MaintenanceCategory.electrical:
        return 'Electrical';
      case MaintenanceCategory.hvac:
        return 'HVAC';
      case MaintenanceCategory.appliance:
        return 'Appliance';
      case MaintenanceCategory.structural:
        return 'Structural';
      case MaintenanceCategory.painting:
        return 'Painting';
      case MaintenanceCategory.flooring:
        return 'Flooring';
      case MaintenanceCategory.roofing:
        return 'Roofing';
      case MaintenanceCategory.landscaping:
        return 'Landscaping';
      case MaintenanceCategory.pest:
        return 'Pest Control';
      case MaintenanceCategory.cleaning:
        return 'Cleaning';
      case MaintenanceCategory.security:
        return 'Security';
      case MaintenanceCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceCategory.plumbing:
        return Icons.plumbing;
      case MaintenanceCategory.electrical:
        return Icons.electrical_services;
      case MaintenanceCategory.hvac:
        return Icons.ac_unit;
      case MaintenanceCategory.appliance:
        return Icons.kitchen;
      case MaintenanceCategory.structural:
        return Icons.foundation;
      case MaintenanceCategory.painting:
        return Icons.format_paint;
      case MaintenanceCategory.flooring:
        return Icons.view_module;
      case MaintenanceCategory.roofing:
        return Icons.roofing;
      case MaintenanceCategory.landscaping:
        return Icons.grass;
      case MaintenanceCategory.pest:
        return Icons.bug_report;
      case MaintenanceCategory.cleaning:
        return Icons.cleaning_services;
      case MaintenanceCategory.security:
        return Icons.security;
      case MaintenanceCategory.other:
        return Icons.build;
    }
  }

  Color get color {
    switch (this) {
      case MaintenanceCategory.plumbing:
        return Colors.blue;
      case MaintenanceCategory.electrical:
        return Colors.amber;
      case MaintenanceCategory.hvac:
        return Colors.cyan;
      case MaintenanceCategory.appliance:
        return Colors.teal;
      case MaintenanceCategory.structural:
        return Colors.brown;
      case MaintenanceCategory.painting:
        return Colors.purple;
      case MaintenanceCategory.flooring:
        return Colors.indigo;
      case MaintenanceCategory.roofing:
        return Colors.deepOrange;
      case MaintenanceCategory.landscaping:
        return Colors.green;
      case MaintenanceCategory.pest:
        return Colors.red;
      case MaintenanceCategory.cleaning:
        return Colors.lightBlue;
      case MaintenanceCategory.security:
        return Colors.blueGrey;
      case MaintenanceCategory.other:
        return Colors.grey;
    }
  }
}

final class MaintenanceRequest {
  const MaintenanceRequest({
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

  final int id;
  final int propertyId;
  final String propertyTitle;
  final int? leaseId;
  final String? tenantName;
  final MaintenanceCategory category;
  final MaintenancePriority priority;
  final MaintenanceStatus status;
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

  bool get isOpen => status == MaintenanceStatus.open;
  bool get isInProgress => status == MaintenanceStatus.inProgress;
  bool get isCompleted => status == MaintenanceStatus.completed;
  bool get isClosed =>
      status == MaintenanceStatus.completed ||
      status == MaintenanceStatus.cancelled;

  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;
  bool get hasCostEstimate => estimatedCost != null && estimatedCost! > 0;
}
