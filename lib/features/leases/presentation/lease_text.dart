import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

extension LeaseStatusText on LeaseStatus {
  String text(AppLocalizations l10n) => switch (this) {
    LeaseStatus.draft => l10n.leaseStatusDraft,
    LeaseStatus.pendingSignature => l10n.leaseStatusPendingSignature,
    LeaseStatus.active => l10n.leaseStatusActive,
    LeaseStatus.expiringSoon => l10n.leaseStatusExpiringSoon,
    LeaseStatus.expired => l10n.leaseStatusExpired,
    LeaseStatus.terminated => l10n.leaseStatusTerminated,
    LeaseStatus.renewed => l10n.leaseStatusRenewed,
  };

  AppStatusType get statusType => switch (this) {
    LeaseStatus.active => AppStatusType.success,
    LeaseStatus.expiringSoon ||
    LeaseStatus.pendingSignature => AppStatusType.warning,
    LeaseStatus.draft => AppStatusType.info,
    LeaseStatus.expired ||
    LeaseStatus.terminated ||
    LeaseStatus.renewed => AppStatusType.neutral,
  };
}

extension LeaseText on Lease {
  /// The tenant, or the lease number when the lease names no tenant.
  String title(AppLocalizations l10n) {
    final tenant = tenantName?.trim();
    if (tenant != null && tenant.isNotEmpty) return tenant;
    return id == null ? l10n.leasesTitle : l10n.commonLeaseNumber('$id');
  }

  /// How the late fee is charged, or null when the lease has none. A fixed
  /// amount wins over a percentage of the rent.
  String? lateFeeText(AppLocalizations l10n) {
    final amount = lateFeeAmount;
    if (amount != null && amount > 0) {
      return l10n.leaseLateFeeFlat(rupees(amount));
    }
    final percent = lateFeePercentage;
    if (percent != null && percent > 0) {
      final value = percent == percent.roundToDouble()
          ? percent.toStringAsFixed(0)
          : percent.toStringAsFixed(2);
      return l10n.leaseLateFeePercent(value);
    }
    return null;
  }
}
