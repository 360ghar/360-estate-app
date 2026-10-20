import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/presentation/rent_status_text.dart';
import 'package:estate_app/features/collections/presentation/widgets/charge_row.dart';
import 'package:estate_app/features/collections/presentation/widgets/collections_summary.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Rent charges: the ledger summary on top, then one tab per backend status.
class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key, this.initialStatus});

  final String? initialStatus;

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
  // One tab per backend status. The backend computes `overdue` when it reads:
  // an open charge past its grace period.
  static const _tabs = [
    RentChargeStatus.pending,
    RentChargeStatus.partial,
    RentChargeStatus.overdue,
    RentChargeStatus.paid,
    RentChargeStatus.waived,
  ];

  bool _generating = false;

  Future<void> _generateCharges() async {
    if (_generating) return;
    setState(() => _generating = true);
    try {
      final result = await ref.read(rentRepositoryProvider).generateCharges();
      if (mounted) {
        context.showSnack(
          context.l10n.collectionsGenerated(
            result.created ?? 0,
            result.skipped ?? 0,
          ),
        );
      }
      ref
        ..invalidate(allRentChargesProvider)
        ..invalidate(unpaidRentChargesProvider)
        ..invalidate(rentChargesPagedProvider)
        ..invalidate(dashboardOverviewProvider)
        ..invalidate(dashboardActivityProvider);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // A bad or missing `status` opens the first tab. `due` is the old name of
    // `pending`.
    final initial = widget.initialStatus == 'due'
        ? RentChargeStatus.pending
        : RentChargeStatus.fromJson(widget.initialStatus);
    final initialIndex = initial == null ? 0 : _tabs.indexOf(initial);

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.collectionsTitle),
          actions: [
            IconButton(
              tooltip: l10n.collectionsGenerate,
              icon: const Icon(Icons.post_add_rounded),
              onPressed: _generating ? null : _generateCharges,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/collections/payments/new'),
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.homeRecordPayment),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: CollectionsSummary(),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              tabs: [for (final status in _tabs) _StatusTab(status: status)],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (final status in _tabs)
                    _ChargesList(
                      status: status,
                      onGenerate: _generating ? null : _generateCharges,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({required this.status});

  final RentChargeStatus status;

  @override
  Widget build(BuildContext context) {
    final type = status.statusType;
    final (ink, _) = statusColors(context, type);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: CustomPaint(
              size: const Size.square(10),
              painter: StatusMarkPainter(type, ink),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(status.text(context.l10n)),
        ],
      ),
    );
  }
}

/// The charges of one status, paged.
class _ChargesList extends ConsumerWidget {
  const _ChargesList({required this.status, required this.onGenerate});

  final RentChargeStatus status;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch<PagedListState<RentChargeWithTotals>>(
      rentChargesPagedProvider(status),
    );
    final controller = ref.read(rentChargesPagedProvider(status).notifier);
    final tenants = ref.watch(leaseTenantNamesProvider).valueOrNull;
    final properties = ref.watch(propertyTitlesProvider).valueOrNull;

    final emptyTitle = switch (status) {
      RentChargeStatus.pending => l10n.collectionsEmptyDue,
      RentChargeStatus.partial => l10n.collectionsEmptyPartial,
      RentChargeStatus.overdue => l10n.collectionsEmptyOverdue,
      RentChargeStatus.paid => l10n.collectionsEmptyPaid,
      RentChargeStatus.waived => l10n.collectionsEmptyWaived,
    };

    return PagedListView<RentChargeWithTotals>(
      state: state,
      // Room under the last row for the floating button.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        96,
      ),
      emptyTitle: emptyTitle,
      emptyMessage: status == RentChargeStatus.pending
          ? l10n.collectionsEmptyDueBody
          : l10n.collectionsEmptyBody,
      emptyIcon: Icons.receipt_long_outlined,
      emptyAction: status == RentChargeStatus.pending
          ? FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.post_add_rounded),
              label: Text(l10n.collectionsGenerateShort),
            )
          : null,
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      onLoadMoreRetry: controller.retryLoadMore,
      itemBuilder: (context, row) => ChargeRow(
        row: row,
        tenantName: tenants?[row.charge.leaseId],
        propertyTitle: properties?[row.charge.propertyId],
      ),
    );
  }
}
