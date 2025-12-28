import 'package:flutter/material.dart';

enum InspectionType {
  moveIn,
  moveOut,
  routine,
  maintenance,
  preRenewal;

  String get apiValue {
    switch (this) {
      case InspectionType.moveIn:
        return 'move_in';
      case InspectionType.moveOut:
        return 'move_out';
      case InspectionType.routine:
        return 'routine';
      case InspectionType.maintenance:
        return 'maintenance';
      case InspectionType.preRenewal:
        return 'pre_renewal';
    }
  }

  String get displayName {
    switch (this) {
      case InspectionType.moveIn:
        return 'Move-In';
      case InspectionType.moveOut:
        return 'Move-Out';
      case InspectionType.routine:
        return 'Routine';
      case InspectionType.maintenance:
        return 'Maintenance';
      case InspectionType.preRenewal:
        return 'Pre-Renewal';
    }
  }

  IconData get icon {
    switch (this) {
      case InspectionType.moveIn:
        return Icons.login;
      case InspectionType.moveOut:
        return Icons.logout;
      case InspectionType.routine:
        return Icons.event_repeat;
      case InspectionType.maintenance:
        return Icons.build;
      case InspectionType.preRenewal:
        return Icons.autorenew;
    }
  }

  Color get color {
    switch (this) {
      case InspectionType.moveIn:
        return Colors.green;
      case InspectionType.moveOut:
        return Colors.orange;
      case InspectionType.routine:
        return Colors.blue;
      case InspectionType.maintenance:
        return Colors.purple;
      case InspectionType.preRenewal:
        return Colors.teal;
    }
  }

  static InspectionType fromApiValue(String value) {
    switch (value) {
      case 'move_in':
        return InspectionType.moveIn;
      case 'move_out':
        return InspectionType.moveOut;
      case 'routine':
        return InspectionType.routine;
      case 'maintenance':
        return InspectionType.maintenance;
      case 'pre_renewal':
        return InspectionType.preRenewal;
      default:
        return InspectionType.routine;
    }
  }
}

enum InspectionStatus {
  scheduled,
  inProgress,
  pendingReview,
  completed,
  cancelled;

  String get apiValue {
    switch (this) {
      case InspectionStatus.scheduled:
        return 'scheduled';
      case InspectionStatus.inProgress:
        return 'in_progress';
      case InspectionStatus.pendingReview:
        return 'pending_review';
      case InspectionStatus.completed:
        return 'completed';
      case InspectionStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case InspectionStatus.scheduled:
        return 'Scheduled';
      case InspectionStatus.inProgress:
        return 'In Progress';
      case InspectionStatus.pendingReview:
        return 'Pending Review';
      case InspectionStatus.completed:
        return 'Completed';
      case InspectionStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case InspectionStatus.scheduled:
        return Icons.schedule;
      case InspectionStatus.inProgress:
        return Icons.play_circle;
      case InspectionStatus.pendingReview:
        return Icons.rate_review;
      case InspectionStatus.completed:
        return Icons.check_circle;
      case InspectionStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case InspectionStatus.scheduled:
        return Colors.blue;
      case InspectionStatus.inProgress:
        return Colors.orange;
      case InspectionStatus.pendingReview:
        return Colors.purple;
      case InspectionStatus.completed:
        return Colors.green;
      case InspectionStatus.cancelled:
        return Colors.grey;
    }
  }

  static InspectionStatus fromApiValue(String value) {
    switch (value) {
      case 'scheduled':
        return InspectionStatus.scheduled;
      case 'in_progress':
        return InspectionStatus.inProgress;
      case 'pending_review':
        return InspectionStatus.pendingReview;
      case 'completed':
        return InspectionStatus.completed;
      case 'cancelled':
        return InspectionStatus.cancelled;
      default:
        return InspectionStatus.scheduled;
    }
  }
}

final class InspectionItem {
  const InspectionItem({
    required this.id,
    required this.area,
    required this.item,
    required this.condition,
    this.notes,
    this.photoUrls = const [],
  });

  final int id;
  final String area;
  final String item;
  final String condition; // good, fair, poor, damaged, n_a
  final String? notes;
  final List<String> photoUrls;

  String get conditionDisplayName {
    switch (condition) {
      case 'good':
        return 'Good';
      case 'fair':
        return 'Fair';
      case 'poor':
        return 'Poor';
      case 'damaged':
        return 'Damaged';
      case 'n_a':
        return 'N/A';
      default:
        return condition;
    }
  }

  Color get conditionColor {
    switch (condition) {
      case 'good':
        return Colors.green;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.deepOrange;
      case 'damaged':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

final class Inspection {
  const Inspection({
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

  final int id;
  final int propertyId;
  final InspectionType inspectionType;
  final InspectionStatus status;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? inspectorName;
  final String? tenantSignature;
  final String? landlordSignature;
  final String? notes;
  final List<InspectionItem> items;
  final String? propertyTitle;
  final String? propertyAddress;
  final String? tenantName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isScheduled => status == InspectionStatus.scheduled;
  bool get isInProgress => status == InspectionStatus.inProgress;
  bool get isPendingReview => status == InspectionStatus.pendingReview;
  bool get isCompleted => status == InspectionStatus.completed;
  bool get isCancelled => status == InspectionStatus.cancelled;

  bool get canStart => isScheduled;
  bool get canComplete => isInProgress;
  bool get canSign => isPendingReview;
  bool get canCancel => !isCompleted && !isCancelled;

  bool get hasTenantSignature => tenantSignature != null;
  bool get hasLandlordSignature => landlordSignature != null;
  bool get isFullySigned => hasTenantSignature && hasLandlordSignature;

  int get itemsCount => items.length;
  int get goodItemsCount =>
      items.where((i) => i.condition == 'good').length;
  int get issueItemsCount =>
      items.where((i) => i.condition == 'poor' || i.condition == 'damaged').length;
}
