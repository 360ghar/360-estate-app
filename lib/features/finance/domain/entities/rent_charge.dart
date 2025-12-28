enum RentChargeStatus {
  pending,
  paid,
  partiallyPaid,
  overdue,
  waived,
  ;

  static RentChargeStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return RentChargeStatus.pending;
      case 'paid':
        return RentChargeStatus.paid;
      case 'partially_paid':
      case 'partiallypaid':
        return RentChargeStatus.partiallyPaid;
      case 'overdue':
        return RentChargeStatus.overdue;
      case 'waived':
        return RentChargeStatus.waived;
      default:
        return RentChargeStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case RentChargeStatus.pending:
        return 'Pending';
      case RentChargeStatus.paid:
        return 'Paid';
      case RentChargeStatus.partiallyPaid:
        return 'Partial';
      case RentChargeStatus.overdue:
        return 'Overdue';
      case RentChargeStatus.waived:
        return 'Waived';
    }
  }
}

final class RentCharge {
  const RentCharge({
    required this.id,
    required this.leaseId,
    required this.propertyId,
    required this.propertyTitle,
    required this.tenantName,
    required this.periodStart,
    required this.periodEnd,
    required this.dueDate,
    required this.amountDue,
    this.amountPaid = 0,
    this.lateFee = 0,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int leaseId;
  final int propertyId;
  final String propertyTitle;
  final String tenantName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime dueDate;
  final double amountDue;
  final double amountPaid;
  final double lateFee;
  final RentChargeStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get totalDue => amountDue + lateFee;
  double get balance => totalDue - amountPaid;
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != RentChargeStatus.paid;
  bool get isPaid => status == RentChargeStatus.paid;

  String get periodLabel {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[periodStart.month - 1]} ${periodStart.year}';
  }
}
