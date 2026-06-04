import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';

final class RentPaymentDto {
  const RentPaymentDto({
    required this.id,
    required this.rentChargeId,
    required this.leaseId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory RentPaymentDto.fromJson(Map<String, dynamic> json) {
    return RentPaymentDto(
      id: parseInt(json['id']) ?? 0,
      rentChargeId:
          json['rent_charge_id'] as int? ?? json['rentChargeId'] as int? ?? 0,
      leaseId: json['lease_id'] as int? ?? json['leaseId'] as int? ?? 0,
      amount: _parseDouble(json['amount']),
      paymentDate:
          parseDateTime(
            json['payment_date'] as String? ??
                json['paymentDate'] as String? ??
                DateTime.now().toIso8601String(),
          ) ??
          DateTime.now(),
      paymentMethod:
          json['payment_method'] as String? ??
          json['paymentMethod'] as String? ??
          'other',
      referenceNumber:
          json['reference_number'] as String? ??
          json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  final int id;
  final int rentChargeId;
  final int leaseId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'rent_charge_id': rentChargeId,
      'lease_id': leaseId,
      'amount': amount,
      'payment_date': toApiDateOnly(paymentDate),
      'payment_method': paymentMethod,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (notes != null) 'notes': notes,
    };
  }

  RentPayment toEntity() {
    return RentPayment(
      id: id,
      rentChargeId: rentChargeId,
      leaseId: leaseId,
      amount: amount,
      paymentDate: paymentDate,
      paymentMethod: PaymentMethod.fromString(paymentMethod),
      referenceNumber: referenceNumber,
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
}
