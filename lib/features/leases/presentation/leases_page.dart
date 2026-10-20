import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeasesPage extends ConsumerStatefulWidget {
  const LeasesPage({super.key, this.propertyId, this.tenantUserId});

  final int? propertyId;

  /// Only the leases of this tenant (`tenant_user_id`).
  final int? tenantUserId;

  @override
  ConsumerState<LeasesPage> createState() => _LeasesPageState();
}

enum _Filter { all, active, expiringSoon, upcoming, ended }

class _LeasesPageState extends ConsumerState<LeasesPage> {
  final _searchController = TextEditingController();
  String _query = '';
  _Filter _filter = _Filter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(Lease lease, Map<int, String> titles) {
    final status = lease.status;
    final byStatus = switch (_filter) {
      _Filter.all => true,
      _Filter.active => status == LeaseStatus.active,
      _Filter.expiringSoon => status == LeaseStatus.expiringSoon,
      _Filter.upcoming =>
        status == LeaseStatus.draft || status == LeaseStatus.pendingSignature,
      _Filter.ended =>
        status == LeaseStatus.expired ||
            status == LeaseStatus.terminated ||
            status == LeaseStatus.renewed,
    };
    if (!byStatus) return false;
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;
    final tenant = lease.tenantName?.toLowerCase() ?? '';
    final property = titles[lease.propertyId]?.toLowerCase() ?? '';
    return tenant.contains(query) || property.contains(query);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _filter = _Filter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filter = LeaseListFilter(
      propertyId: widget.propertyId,
      tenantUserId: widget.tenantUserId,
    );
    final leasesAsync = ref.watch(leasesListProvider(filter));
    final titles =
        ref.watch(propertyTitlesProvider).valueOrNull ?? const <int, String>{};
    final labels = {
      _Filter.all: l10n.commonAll,
      _Filter.active: l10n.leasesFilterActive,
      _Filter.expiringSoon: l10n.leasesFilterExpiring,
      _Filter.upcoming: l10n.leasesFilterUpcoming,
      _Filter.ended: l10n.leasesFilterEnded,
    };
    Future<void> refresh() async {
      ref.invalidate(leasesListProvider(filter));
      await ref
          .read(leasesListProvider(filter).future)
          .catchError((_) => <Lease>[]);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leasesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/leases/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.leasesNew),
      ),
      body: Column(
        children: [
          AppSearchBar(
            hintText: l10n.leasesSearchHint,
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            filterChips: [
              for (final f in _Filter.values)
                FilterChip(
                  label: Text(labels[f]!),
                  selected: _filter == f,
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ],
          ),
          Expanded(
            child: leasesAsync.when(
              loading: () => const AppLoadingShimmer(),
              error: (error, _) => RefreshIndicator(
                onRefresh: refresh,
                child: StateScrollView(
                  child: AppErrorView(
                    title: l10n.commonLoadFailedTitle,
                    message: userFacingMessage(error),
                    onRetry: () => ref.invalidate(leasesListProvider(filter)),
                  ),
                ),
              ),
              data: (leases) {
                final shown = leases.where((l) => _matches(l, titles)).toList();
                return RefreshIndicator(
                  onRefresh: refresh,
                  child: shown.isEmpty
                      ? StateScrollView(
                          child: leases.isEmpty
                              ? AppEmptyView(
                                  title: l10n.leasesEmptyTitle,
                                  message: l10n.leasesEmptyBody,
                                  icon: Icons.description_outlined,
                                  action: FilledButton.icon(
                                    onPressed: () =>
                                        context.go('/more/leases/new'),
                                    icon: const Icon(Icons.add_rounded),
                                    label: Text(l10n.leasesNew),
                                  ),
                                )
                              : AppEmptyView(
                                  title: l10n.leasesNoMatchTitle,
                                  message: l10n.leasesNoMatchBody,
                                  icon: Icons.search_off_rounded,
                                  action: TextButton(
                                    onPressed: _clearFilters,
                                    child: Text(l10n.commonClearFilters),
                                  ),
                                ),
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            96,
                          ),
                          itemCount: shown.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, i) => RiseIn(
                            index: i,
                            child: LeaseRow(
                              lease: shown[i],
                              propertyTitle: titles[shown[i].propertyId],
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// One lease: tenant, property, rent, term and status.
class LeaseRow extends StatelessWidget {
  const LeaseRow({super.key, required this.lease, this.propertyTitle});

  final Lease lease;
  final String? propertyTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = lease.status;
    final start = lease.startDate;
    final end = lease.endDate;
    final daysLeft = lease.daysUntilEnd(DateTime.now());
    final rent = lease.monthlyRent;
    String date(DateTime? d) =>
        d == null ? l10n.commonNotSet : shortDate(context, d);
    return AppListCard(
      title: lease.title(l10n),
      subtitle: propertyTitle,
      trailing: rent == null
          ? null
          : Text(
              rupees(rent),
              style: AppTextStyles.currencySmall.copyWith(
                color: context.colors.onSurface,
              ),
            ),
      facts: [
        if (start != null || end != null)
          l10n.leasesTerm(date(start), date(end)),
        if (lease.isExpiringSoon && daysLeft != null && daysLeft >= 0)
          daysLeft == 0 ? l10n.leasesEndsToday : l10n.leasesEndsIn(daysLeft),
      ],
      status: status == null
          ? null
          : AppStatusBadge(label: status.text(l10n), type: status.statusType),
      onTap: () => context.go('/more/leases/${lease.id}'),
    );
  }
}
