import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';

final class RentChargeDto {
  const RentChargeDto({
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

  factory RentChargeDto.fromJson(Map<String, dynamic> json) {
    return RentChargeDto(
      id: json['id'] as int,
      leaseId: json['lease_id'] as int? ?? json['leaseId'] as int? ?? 0,
      propertyId:
          json['property_id'] as int? ?? json['propertyId'] as int? ?? 0,
      propertyTitle: json['property_title'] as String? ??
          json['propertyTitle'] as String? ??
          '',
      tenantName:
          json['tenant_name'] as String? ?? json['tenantName'] as String? ?? '',
      periodStart: DateTime.parse(
        json['period_start'] as String? ??
            json['periodStart'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      periodEnd: DateTime.parse(
        json['period_end'] as String? ??
            json['periodEnd'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      dueDate: DateTime.parse(
        json['due_date'] as String? ??
            json['dueDate'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      amountDue: _parseDouble(json['amount_due'] ?? json['amountDue']),
      amountPaid: _parseDouble(json['amount_paid'] ?? json['amountPaid']),
      lateFee: _parseDouble(json['late_fee'] ?? json['lateFee']),
      status: json['status'] as String? ?? 'pending',
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
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RentCharge toEntity() {
    return RentCharge(
      id: id,
      leaseId: leaseId,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      tenantName: tenantName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      dueDate: dueDate,
      amountDue: amountDue,
      amountPaid: amountPaid,
      lateFee: lateFee,
      status: RentChargeStatus.fromString(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
