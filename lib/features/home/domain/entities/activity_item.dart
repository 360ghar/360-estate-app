enum ActivityType {
  paymentReceived,
  maintenanceCreated,
  maintenanceCompleted,
  leaseCreated,
  leaseExpiring,
  tenantMoveIn,
  tenantMoveOut,
  documentUploaded,
  inspectionCompleted,
  unknown;

  static ActivityType fromString(String value) {
    return switch (value) {
      'payment_received' => ActivityType.paymentReceived,
      'maintenance_created' => ActivityType.maintenanceCreated,
      'maintenance_completed' => ActivityType.maintenanceCompleted,
      'lease_created' => ActivityType.leaseCreated,
      'lease_expiring' => ActivityType.leaseExpiring,
      'tenant_move_in' => ActivityType.tenantMoveIn,
      'tenant_move_out' => ActivityType.tenantMoveOut,
      'document_uploaded' => ActivityType.documentUploaded,
      'inspection_completed' => ActivityType.inspectionCompleted,
      _ => ActivityType.unknown,
    };
  }
}

final class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.description,
    this.propertyId,
    this.propertyName,
    this.leaseId,
    this.amount,
    this.status,
  });

  final int id;
  final ActivityType type;
  final DateTime timestamp;
  final String title;
  final String description;
  final int? propertyId;
  final String? propertyName;
  final int? leaseId;
  final double? amount;
  final String? status;
}
