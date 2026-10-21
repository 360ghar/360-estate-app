import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

extension RentChargeStatusText on RentChargeStatus {
  String text(AppLocalizations l10n) => switch (this) {
    RentChargeStatus.pending => l10n.rentStatusDue,
    RentChargeStatus.partial => l10n.rentStatusPartlyPaid,
    RentChargeStatus.paid => l10n.rentStatusPaid,
    RentChargeStatus.overdue => l10n.rentStatusOverdue,
    RentChargeStatus.waived => l10n.rentStatusWaived,
  };

  AppStatusType get statusType => switch (this) {
    RentChargeStatus.paid => AppStatusType.success,
    RentChargeStatus.partial ||
    RentChargeStatus.pending => AppStatusType.warning,
    RentChargeStatus.overdue => AppStatusType.danger,
    RentChargeStatus.waived => AppStatusType.neutral,
  };

  /// A charge that still owes money and can take a payment.
  bool get isOpen =>
      this == RentChargeStatus.pending ||
      this == RentChargeStatus.partial ||
      this == RentChargeStatus.overdue;
}

extension PaymentMethodText on PaymentMethod {
  String text(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cash => l10n.paymentMethodCash,
    PaymentMethod.upi => l10n.paymentMethodUpi,
    PaymentMethod.bankTransfer => l10n.paymentMethodBankTransfer,
    PaymentMethod.cheque => l10n.paymentMethodCheque,
    PaymentMethod.online => l10n.paymentMethodOnline,
    PaymentMethod.other => l10n.paymentMethodOther,
  };
}
