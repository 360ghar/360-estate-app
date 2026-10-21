import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/detail_line.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Who, where, the status, the two figures that matter and any end notice.
class LeaseHeader extends StatelessWidget {
  const LeaseHeader({super.key, required this.lease, this.propertyTitle});

  final Lease lease;
  final String? propertyTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = lease.status;
    final daysLeft = lease.daysUntilEnd(DateTime.now());
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    String? notice;
    if (lease.isExpiringSoon && daysLeft != null && daysLeft >= 0) {
      notice = daysLeft == 0
          ? l10n.leaseEndsTodayNotice
          : l10n.leaseEndsInNotice(daysLeft);
    } else if (lease.isExpired && lease.endDate != null) {
      notice = l10n.leaseExpiredNotice(shortDate(context, lease.endDate!));
    }
    Widget figure(String label, double? value, TextStyle style) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: muted),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value == null ? l10n.commonNotSet : rupees(value),
          style: style.copyWith(color: context.colors.onSurface),
        ),
      ],
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lease.title(l10n), style: context.text.headlineSmall),
          if (propertyTitle != null)
            Text(
              propertyTitle!,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          if (status != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppStatusBadge(label: status.text(l10n), type: status.statusType),
          ],
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.md,
            children: [
              figure(
                l10n.leaseMonthlyRent,
                lease.monthlyRent,
                AppTextStyles.currencyMedium,
              ),
              figure(
                l10n.leaseDeposit,
                lease.securityDeposit,
                AppTextStyles.currencySmall,
              ),
            ],
          ),
          if (notice != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: lease.isExpired
                        ? context.colors.onSurfaceVariant
                        : context.palette.warning,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(notice, style: context.text.bodyMedium)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Start and end, and how much of the term has passed.
class LeaseTermSection extends StatelessWidget {
  const LeaseTermSection({super.key, required this.lease});

  final Lease lease;

  double get _elapsed {
    final start = lease.startDate;
    final end = lease.endDate;
    if (start == null || end == null) return 0;
    final total = end.difference(start).inDays;
    if (total <= 0) return 1;
    return (DateTime.now().difference(start).inDays / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    String date(DateTime? d) =>
        d == null ? l10n.commonNotSet : shortDate(context, d);
    final elapsed = _elapsed;
    return AppSectionCard(
      title: l10n.leaseSectionTerm,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.leaseStart, style: muted),
                  Text(date(lease.startDate), style: context.text.titleSmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.leaseEnd, style: muted),
                Text(date(lease.endDate), style: context.text.titleSmall),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ExcludeSemantics(
          child: LinearProgressIndicator(
            value: elapsed,
            minHeight: 6,
            borderRadius: AppRadii.xs,
            color: elapsed >= 0.9
                ? context.palette.warning
                : context.colors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.leaseTermElapsed((elapsed * 100).toStringAsFixed(0)),
          style: muted,
        ),
      ],
    );
  }
}

/// The tenant's name and how to reach them.
class LeaseTenantSection extends StatelessWidget {
  const LeaseTenantSection({super.key, required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phone = lease.tenantPhone?.trim();
    final email = lease.tenantEmail?.trim();
    return AppSectionCard(
      title: l10n.leaseSectionTenant,
      children: [
        DetailLine(
          label: l10n.leaseName,
          value: lease.tenantName ?? l10n.commonNotSet,
        ),
        if (phone != null && phone.isNotEmpty)
          DetailLine(
            label: l10n.leasePhone,
            value: phone,
            trailing: IconButton(
              tooltip: l10n.leaseCallTenant,
              icon: const Icon(Icons.call_outlined),
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: phone)),
            ),
          ),
        if (email != null && email.isNotEmpty)
          DetailLine(label: l10n.leaseEmail, value: email),
      ],
    );
  }
}

/// The rent rules the backend enforces, and how the lease ended.
class LeaseCollectionSection extends StatelessWidget {
  const LeaseCollectionSection({super.key, required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dueDay = lease.paymentDueDay;
    final grace = lease.gracePeriodDays;
    final fee = lease.lateFeeText(l10n);
    final ended = lease.terminationDate;
    return AppSectionCard(
      title: l10n.leaseSectionCollection,
      children: [
        DetailLine(
          label: l10n.leaseDueDay,
          value: dueDay == null
              ? l10n.commonNotSet
              : l10n.leaseDueDayValue(dueDay),
        ),
        DetailLine(
          label: l10n.leaseGracePeriod,
          value: grace == null
              ? l10n.commonNotSet
              : l10n.leaseGraceValue(grace),
        ),
        DetailLine(label: l10n.leaseLateFee, value: fee ?? l10n.commonNone),
        if (fee != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.leaseLateFeeRule,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        if (ended != null) ...[
          const SizedBox(height: AppSpacing.sm),
          DetailLine(
            label: l10n.leaseTerminatedOn,
            value: shortDate(context, ended),
          ),
          if (lease.terminationReason != null)
            DetailLine(
              label: l10n.leaseReason,
              value: lease.terminationReason!,
            ),
        ],
      ],
    );
  }
}

/// The signed copy: upload or replace it, and open it.
class LeaseDocumentSection extends StatelessWidget {
  const LeaseDocumentSection({
    super.key,
    required this.documentId,
    required this.busy,
    required this.onUpload,
    required this.onView,
  });

  final int? documentId;
  final bool busy;
  final VoidCallback onUpload;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final has = documentId != null;
    return AppSectionCard(
      title: l10n.leaseSectionDocument,
      children: [
        Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                has
                    ? Icons.picture_as_pdf_outlined
                    : Icons.upload_file_outlined,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                has ? l10n.leaseDocumentPresent : l10n.leaseDocumentMissing,
                style: context.text.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            if (has)
              TextButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(l10n.leaseViewSigned),
              ),
            TextButton.icon(
              onPressed: busy ? null : onUpload,
              icon: const Icon(Icons.upload_rounded, size: 18),
              label: Text(has ? l10n.leaseReplacePdf : l10n.leaseUploadPdf),
            ),
          ],
        ),
      ],
    );
  }
}
