enum PaymentMethod {
  cash,
  cheque,
  bankTransfer,
  upi,
  creditCard,
  other,
  ;

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'cheque':
      case 'check':
        return PaymentMethod.cheque;
      case 'bank_transfer':
      case 'banktransfer':
        return PaymentMethod.bankTransfer;
      case 'upi':
        return PaymentMethod.upi;
      case 'credit_card':
      case 'creditcard':
        return PaymentMethod.creditCard;
      default:
        return PaymentMethod.other;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

final class RentPayment {
  const RentPayment({
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

  final int id;
  final int rentChargeId;
  final int leaseId;
  final double amount;
  final DateTime paymentDate;
  final PaymentMethod paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
