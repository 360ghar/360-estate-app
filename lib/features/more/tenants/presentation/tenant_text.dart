import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

/// The tenant's status as a badge: the word and its status type.
AppStatusBadge tenantStatusBadge(Tenant tenant, AppLocalizations l10n) =>
    switch (tenant.effectiveStatus) {
      TenantStatus.active => AppStatusBadge(
        label: l10n.tenantsStatusActive,
        type: AppStatusType.success,
      ),
      TenantStatus.vacated => AppStatusBadge(
        label: l10n.tenantsStatusVacated,
        type: AppStatusType.neutral,
      ),
      null => AppStatusBadge(
        label: l10n.tenantsStatusUnknown,
        type: AppStatusType.info,
      ),
    };

/// A lease of the tenant, as a badge.
AppStatusBadge leaseStatusBadge(LeaseStatus? status, AppLocalizations l10n) {
  final (label, type) = switch (status) {
    LeaseStatus.draft => (l10n.tenantLeaseDraft, AppStatusType.neutral),
    LeaseStatus.pendingSignature => (
      l10n.tenantLeasePendingSignature,
      AppStatusType.warning,
    ),
    LeaseStatus.active => (l10n.tenantLeaseActive, AppStatusType.success),
    LeaseStatus.expiringSoon => (
      l10n.tenantLeaseExpiringSoon,
      AppStatusType.warning,
    ),
    LeaseStatus.expired => (l10n.tenantLeaseExpired, AppStatusType.neutral),
    LeaseStatus.terminated => (
      l10n.tenantLeaseTerminated,
      AppStatusType.danger,
    ),
    LeaseStatus.renewed => (l10n.tenantLeaseRenewed, AppStatusType.info),
    null => (l10n.tenantsStatusUnknown, AppStatusType.neutral),
  };
  return AppStatusBadge(label: label, type: type);
}
