enum LeaseStatus {
  draft,
  pending,
  active,
  expired,
  terminated,
  renewed,
  ;

  static LeaseStatus fromString(String value) {
    return LeaseStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => LeaseStatus.draft,
    );
  }
}

final class Lease {
  const Lease({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.tenantUserId,
    required this.tenantName,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    this.securityDeposit,
    this.rentDueDay = 1,
    this.lateFeeAmount,
    this.lateFeeGraceDays,
    this.renewalNotifyDays = 30,
    this.signedDocumentUrl,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int propertyId;
  final String propertyTitle;
  final String tenantUserId;
  final String tenantName;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double? securityDeposit;
  final int rentDueDay;
  final double? lateFeeAmount;
  final int? lateFeeGraceDays;
  final int renewalNotifyDays;
  final String? signedDocumentUrl;
  final String? status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isExpired => DateTime.now().isAfter(endDate);

  bool get isExpiringSoon {
    final daysUntilExpiry = endDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= renewalNotifyDays && daysUntilExpiry > 0;
  }

  int get daysRemaining {
    final days = endDate.difference(DateTime.now()).inDays;
    return days > 0 ? days : 0;
  }

  int get durationMonths {
    return (endDate.difference(startDate).inDays / 30).round();
  }
}
