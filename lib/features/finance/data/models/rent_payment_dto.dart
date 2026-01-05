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
      id: json['id'] as int,
      rentChargeId:
          json['rent_charge_id'] as int? ?? json['rentChargeId'] as int? ?? 0,
      leaseId: json['lease_id'] as int? ?? json['leaseId'] as int? ?? 0,
      amount: _parseDouble(json['amount']),
      paymentDate: DateTime.parse(
        json['payment_date'] as String? ??
            json['paymentDate'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      paymentMethod: json['payment_method'] as String? ??
          json['paymentMethod'] as String? ??
          'other',
      referenceNumber: json['reference_number'] as String? ??
          json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
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
      'payment_date': paymentDate.toIso8601String().split('T')[0],
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
