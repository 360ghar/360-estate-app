import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/presentation/rent_status_text.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/presentation/inspection_text.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/more/documents/presentation/document_text.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_category_visual.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_overview_tab.dart';
import 'package:estate_app/features/tasks/presentation/task_text.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Reloads [provider] and waits for it, for pull to refresh. A failure shows
/// in the list itself, so it is not rethrown here.
Future<void> _reload(WidgetRef ref, FutureProvider<Object?> provider) async {
  ref.invalidate(provider);
  try {
    await ref.read(provider.future);
  } catch (_) {}
}

/// One related list: skeleton, error with retry, empty with an action, rows.
/// Every state can be pulled to refresh.
class _RecordsList<T> extends StatelessWidget {
  const _RecordsList({
    required this.value,
    required this.onRefresh,
    required this.empty,
    required this.row,
    this.lead = const [],
  });

  final AsyncValue<List<T>> value;
  final Future<void> Function() onRefresh;
  final AppEmptyView empty;
  final Widget Function(T item) row;

  /// Shown above the rows (the current lease).
  final List<Widget> lead;

  @override
  Widget build(BuildContext context) {
    final body = value.when(
      loading: () => null,
      error: (error, _) => StateScrollView(
        child: AppErrorView(
          title: context.l10n.commonLoadFailedTitle,
          message: userFacingMessage(error),
          onRetry: onRefresh,
        ),
      ),
      data: (items) {
        if (items.isEmpty && lead.isEmpty) return StateScrollView(child: empty);
        final children = [...lead, for (final item in items) row(item)];
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          itemCount: children.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, i) => RiseIn(index: i, child: children[i]),
        );
      },
    );
    if (body == null) return const AppLoadingShimmer();
    return RefreshIndicator(onRefresh: onRefresh, child: body);
  }
}

AppEmptyView _empty(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String action,
  required String route,
}) => AppEmptyView(
  icon: icon,
  title: title,
  message: message,
  action: FilledButton.tonal(
    onPressed: () => context.go(route),
    child: Text(action),
  ),
);

AppStatusType _leaseStatusType(LeaseStatus? status) => switch (status) {
  LeaseStatus.active || LeaseStatus.renewed => AppStatusType.success,
  LeaseStatus.expiringSoon ||
  LeaseStatus.pendingSignature => AppStatusType.warning,
  _ => AppStatusType.neutral,
};

/// The lease that occupies the property, then its other leases.
class PropertyLeaseTab extends ConsumerWidget {
  const PropertyLeaseTab({
    super.key,
    required this.propertyId,
    required this.activeLease,
  });

  final int propertyId;
  final Lease? activeLease;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = leasesListProvider(
      LeaseListFilter(propertyId: propertyId),
    );
    final current = activeLease;
    return _RecordsList<Lease>(
      value: ref
          .watch(provider)
          .whenData(
            (all) => [
              for (final l in all)
                if (l.id != current?.id) l,
            ],
          ),
      onRefresh: () => _reload(ref, provider),
      lead: [if (current != null) _CurrentLease(lease: current)],
      empty: _empty(
        context,
        icon: Icons.description_outlined,
        title: l10n.propertyNoLeaseTitle,
        message: l10n.propertyNoLeaseBody,
        action: l10n.propertyCreateLease,
        route: '/more/leases/new',
      ),
      row: (lease) => AppListCard(
        onTap: () => context.go('/more/leases/${lease.id}'),
        title: lease.displayName,
        subtitle: _dateRange(context, lease),
        trailing: lease.monthlyRent == null
            ? null
            : _Amount(lease.monthlyRent!),
        status: lease.status == null
            ? null
            : AppStatusBadge(
                label: lease.status!.text(l10n),
                type: _leaseStatusType(lease.status),
              ),
      ),
    );
  }
}

String? _dateRange(BuildContext context, Lease lease) {
  final start = lease.startDate;
  final end = lease.endDate;
  if (start == null && end == null) return null;
  return [
    if (start != null) shortDate(context, start),
    if (end != null) shortDate(context, end),
  ].join(' – ');
}

class _CurrentLease extends StatelessWidget {
  const _CurrentLease({required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final daysLeft = lease.daysUntilEnd(DateTime.now());
    final summary = lease.enforcementSummary;
    return AppSectionCard(
      title: l10n.propertyCurrentLease,
      trailing: lease.status == null
          ? null
          : AppStatusBadge(
              label: lease.status!.text(l10n),
              type: _leaseStatusType(lease.status),
            ),
      children: [
        FactRow(l10n.propertyLeaseTenant, lease.displayName),
        if (lease.startDate != null)
          FactRow(
            l10n.propertyLeaseStart,
            shortDate(context, lease.startDate!),
          ),
        if (lease.endDate != null)
          FactRow(l10n.propertyLeaseEnd, shortDate(context, lease.endDate!)),
        if (lease.monthlyRent != null)
          FactRow(l10n.propertyLeaseRent, rupees(lease.monthlyRent!)),
        if (lease.isExpiringSoon && daysLeft != null && daysLeft >= 0)
          FactRow(
            l10n.propertyLeaseEndsIn,
            daysLeft == 0
                ? l10n.propertyLeaseEndsToday
                : l10n.propertyDays(daysLeft),
          ),
        if (summary != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            summary,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => context.go('/more/leases/${lease.id}'),
            child: Text(l10n.propertyViewLease),
          ),
        ),
      ],
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount(this.value);

  final double value;

  @override
  Widget build(BuildContext context) => Text(
    rupees(value),
    style: AppTextStyles.currencyXSmall.copyWith(
      fontWeight: FontWeight.w700,
      color: context.colors.onSurface,
    ),
  );
}

/// The rent charges of the property. A charge with a balance opens the
/// payment form for it.
class PropertyRentTab extends ConsumerWidget {
  const PropertyRentTab({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // The backend filters by property_id, so no charge is lost past page one.
    final provider = rentChargesForPropertyProvider(propertyId);
    final tenants = ref.watch(leaseTenantNamesProvider).valueOrNull;
    return _RecordsList<RentChargeWithTotals>(
      value: ref.watch(provider),
      onRefresh: () => _reload(ref, provider),
      empty: _empty(
        context,
        icon: Icons.payments_outlined,
        title: l10n.propertyNoRentTitle,
        message: l10n.propertyNoRentBody,
        action: l10n.propertyOpenCollections,
        route: '/collections',
      ),
      row: (row) {
        final charge = row.charge;
        final status = row.status;
        return AppListCard(
          onTap: row.balance > 0 && row.id != null
              ? () => context.go('/collections/payments/new?chargeId=${row.id}')
              : null,
          title:
              tenants?[charge.leaseId] ??
              l10n.propertyLeaseNumber('${charge.leaseId ?? '-'}'),
          subtitle: charge.dueDate == null
              ? null
              : l10n.propertyChargeDue(shortDate(context, charge.dueDate!)),
          facts: [
            if (row.balance > 0)
              l10n.propertyChargeBalance(rupees(row.balance)),
            if (row.lateFee > 0)
              l10n.propertyChargeLateFee(rupees(row.lateFee)),
          ],
          trailing: _Amount(row.totalDue),
          status: status == null
              ? null
              : AppStatusBadge(
                  label: status.text(l10n),
                  type: status.statusType,
                ),
        );
      },
    );
  }
}

class PropertyExpensesTab extends ConsumerWidget {
  const PropertyExpensesTab({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = expensesForPropertyProvider(propertyId);
    return _RecordsList<Expense>(
      value: ref.watch(provider),
      onRefresh: () => _reload(ref, provider),
      empty: _empty(
        context,
        icon: Icons.receipt_long_outlined,
        title: l10n.propertyNoExpensesTitle,
        message: l10n.propertyNoExpensesBody,
        action: l10n.propertyAddExpense,
        route: '/more/expenses/new',
      ),
      row: (expense) => AppListCard(
        onTap: expense.id == null
            ? null
            : () => context.go('/more/expenses/${expense.id}/edit'),
        title: expense.title ?? l10n.propertyTabExpenses,
        subtitle: expense.category?.text(l10n),
        facts: [if (expense.date != null) shortDate(context, expense.date!)],
        trailing: expense.amount == null ? null : _Amount(expense.amount!),
      ),
    );
  }
}

AppStatusType _maintenanceType(MaintenanceRequestStatus? status) =>
    switch (status) {
      MaintenanceRequestStatus.open => AppStatusType.info,
      MaintenanceRequestStatus.inReview ||
      MaintenanceRequestStatus.workOrderCreated => AppStatusType.warning,
      MaintenanceRequestStatus.resolved => AppStatusType.success,
      _ => AppStatusType.neutral,
    };

class PropertyMaintenanceTab extends ConsumerWidget {
  const PropertyMaintenanceTab({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = maintenanceListForPropertyProvider(propertyId);
    return _RecordsList<MaintenanceRequest>(
      value: ref.watch(provider),
      onRefresh: () => _reload(ref, provider),
      empty: _empty(
        context,
        icon: Icons.handyman_outlined,
        title: l10n.propertyNoMaintenanceTitle,
        message: l10n.propertyNoMaintenanceBody,
        action: l10n.propertyNewTask,
        route: '/tasks/create',
      ),
      row: (request) => AppListCard(
        onTap: () => context.go('/tasks/${request.id}'),
        title: request.title,
        facts: [
          if (request.createdAt != null)
            l10n.propertyCreatedOn(shortDate(context, request.createdAt!)),
        ],
        status: request.status == null
            ? null
            : AppStatusBadge(
                label: request.status!.text(l10n),
                type: _maintenanceType(request.status),
              ),
      ),
    );
  }
}

Future<void> _openDocument(BuildContext context, String? url) async {
  final l10n = context.l10n;
  final uri = Uri.tryParse(url ?? '');
  if (uri == null || !uri.hasScheme) {
    context.showSnack(l10n.documentsNoAccess);
    return;
  }
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    context.showSnack(l10n.documentsOpenFailed);
  }
}

class PropertyDocumentsTab extends ConsumerWidget {
  const PropertyDocumentsTab({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = documentsForPropertyProvider(propertyId);
    return _RecordsList(
      value: ref.watch(provider),
      onRefresh: () => _reload(ref, provider),
      empty: _empty(
        context,
        icon: Icons.folder_open_outlined,
        title: l10n.propertyNoDocumentsTitle,
        message: l10n.propertyNoDocumentsBody,
        action: l10n.propertyUploadDocument,
        route: '${Routes.documentsUpload}?propertyId=$propertyId',
      ),
      row: (doc) => AppListCard(
        title: doc.title ?? l10n.propertyTabDocuments,
        subtitle: doc.documentType?.text(l10n),
        facts: [
          if (doc.createdAt != null)
            l10n.propertyUploadedOn(shortDate(context, doc.createdAt!)),
        ],
        // `file_url` is the signed link, null for a viewer who may not open it.
        onTap: () => _openDocument(context, doc.fileUrl),
      ),
    );
  }
}

AppStatusType _signType(InspectionSignState state) => switch (state) {
  InspectionSignState.signed => AppStatusType.success,
  InspectionSignState.open => AppStatusType.warning,
  _ => AppStatusType.info,
};

class PropertyInspectionsTab extends ConsumerWidget {
  const PropertyInspectionsTab({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = inspectionsListProvider(
      InspectionListFilter(propertyId: propertyId),
    );
    return _RecordsList<Inspection>(
      value: ref.watch(provider),
      onRefresh: () => _reload(ref, provider),
      empty: _empty(
        context,
        icon: Icons.fact_check_outlined,
        title: l10n.propertyNoInspectionsTitle,
        message: l10n.propertyNoInspectionsBody,
        action: l10n.propertyNewInspection,
        route: '/more/inspections/new',
      ),
      row: (inspection) => AppListCard(
        onTap: inspection.id == null
            ? null
            : () => context.go('/more/inspections/${inspection.id}'),
        title: inspection.typeLabel,
        facts: [
          if (inspection.conductedAt != null)
            l10n.propertyConductedOn(
              shortDate(context, inspection.conductedAt!),
            ),
        ],
        status: AppStatusBadge(
          label: inspection.signState.text(l10n),
          type: _signType(inspection.signState),
        ),
      ),
    );
  }
}
