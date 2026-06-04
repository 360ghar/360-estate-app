import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';

final class LeaseDto {
  const LeaseDto({
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

  factory LeaseDto.fromJson(Map<String, dynamic> json) {
    return LeaseDto(
      id: parseInt(json['id']) ?? 0,
      propertyId:
          json['property_id'] as int? ?? json['propertyId'] as int? ?? 0,
      propertyTitle:
          json['property_title'] as String? ??
          json['propertyTitle'] as String? ??
          '',
      tenantUserId:
          json['tenant_user_id'] as String? ??
          json['tenantUserId'] as String? ??
          '',
      tenantName:
          json['tenant_name'] as String? ?? json['tenantName'] as String? ?? '',
      startDate:
          parseDateTime(
            json['start_date'] as String? ??
                json['startDate'] as String? ??
                DateTime.now().toIso8601String(),
          ) ??
          DateTime.now(),
      endDate:
          parseDateTime(
            json['end_date'] as String? ??
                json['endDate'] as String? ??
                DateTime.now().add(const Duration(days: 365)).toIso8601String(),
          ) ??
          DateTime.now().add(const Duration(days: 365)),
      monthlyRent: _parseDouble(json['monthly_rent'] ?? json['monthlyRent']),
      securityDeposit: _parseDoubleNullable(
        json['security_deposit'] ?? json['securityDeposit'],
      ),
      rentDueDay:
          json['rent_due_day'] as int? ?? json['rentDueDay'] as int? ?? 1,
      lateFeeAmount: _parseDoubleNullable(
        json['late_fee_amount'] ?? json['lateFeeAmount'],
      ),
      lateFeeGraceDays:
          json['late_fee_grace_days'] as int? ??
          json['lateFeeGraceDays'] as int?,
      renewalNotifyDays:
          json['renewal_notify_days'] as int? ??
          json['renewalNotifyDays'] as int? ??
          30,
      signedDocumentUrl:
          json['signed_document_url'] as String? ??
          json['signedDocumentUrl'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'tenant_user_id': tenantUserId,
      'start_date': toApiDateOnly(startDate),
      'end_date': toApiDateOnly(endDate),
      'monthly_rent': monthlyRent,
      if (securityDeposit != null) 'security_deposit': securityDeposit,
      'rent_due_day': rentDueDay,
      if (lateFeeAmount != null) 'late_fee_amount': lateFeeAmount,
      if (lateFeeGraceDays != null) 'late_fee_grace_days': lateFeeGraceDays,
      'renewal_notify_days': renewalNotifyDays,
      if (notes != null) 'notes': notes,
    };
  }

  Lease toEntity() {
    return Lease(
      id: id,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      tenantUserId: tenantUserId,
      tenantName: tenantName,
      startDate: startDate,
      endDate: endDate,
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      rentDueDay: rentDueDay,
      lateFeeAmount: lateFeeAmount,
      lateFeeGraceDays: lateFeeGraceDays,
      renewalNotifyDays: renewalNotifyDays,
      signedDocumentUrl: signedDocumentUrl,
      status: status,
      notes: notes,
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

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
