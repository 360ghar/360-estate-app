import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/presentation/tenant_text.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Every tenant of the owner's properties, searchable and filtered by status.
class TenantsPage extends ConsumerStatefulWidget {
  const TenantsPage({super.key});

  @override
  ConsumerState<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends ConsumerState<TenantsPage> {
  String _query = '';
  TenantStatus? _status;

  bool _matches(Tenant tenant) {
    if (_status != null && tenant.status != _status) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return tenant.displayName.toLowerCase().contains(q) ||
        (tenant.phone ?? '').toLowerCase().contains(q) ||
        (tenant.propertyName ?? '').toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(tenantsPagedProvider);
    final controller = ref.read(tenantsPagedProvider.notifier);
    final filtered = state.items.where(_matches).toList();
    final filtering = _query.isNotEmpty || _status != null;

    Widget chip(String label, TenantStatus? status) => FilterChip(
      label: Text(label),
      selected: _status == status,
      onSelected: (_) => setState(() => _status = status),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tenantsTitle)),
      body: Column(
        children: [
          AppSearchBar(
            hintText: l10n.tenantsSearchHint,
            onChanged: (value) => setState(() => _query = value.trim()),
            filterChips: [
              chip(l10n.tenantsFilterAll, null),
              chip(l10n.tenantsStatusActive, TenantStatus.active),
              chip(l10n.tenantsStatusVacated, TenantStatus.vacated),
            ],
          ),
          Expanded(
            child: PagedListView<Tenant>(
              state: state.copyWith(items: filtered),
              emptyTitle: filtering
                  ? l10n.tenantsNoMatchTitle
                  : l10n.tenantsEmptyTitle,
              emptyMessage: !filtering
                  ? l10n.tenantsEmptyBody
                  : state.hasMore
                  ? l10n.tenantsNoMatchLoaded
                  : l10n.tenantsNoMatchBody,
              emptyIcon: filtering
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              emptyAction: filtering
                  ? (state.hasMore
                        ? FilledButton(
                            onPressed: controller.loadMore,
                            child: Text(l10n.tenantsLoadMore),
                          )
                        : null)
                  : FilledButton.icon(
                      onPressed: () => context.go('/more/leases/new'),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.tenantsNewLease),
                    ),
              onLoadMore: controller.loadMore,
              onRefresh: controller.refresh,
              onRetry: controller.loadInitial,
              onLoadMoreRetry: controller.retryLoadMore,
              itemBuilder: (context, tenant) => _TenantRow(tenant: tenant),
            ),
          ),
        ],
      ),
    );
  }
}

class _TenantRow extends StatelessWidget {
  const _TenantRow({required this.tenant});

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = tenant.userId;
    final leases = tenant.activeLeasesCount;
    return AppListCard(
      leading: AppAvatar(name: tenant.fullName),
      title: tenant.displayName,
      subtitle: tenant.propertyName ?? l10n.tenantsNoProperty,
      facts: [
        ?tenant.phone,
        if (leases != null && leases > 0) l10n.tenantsActiveLeases(leases),
      ],
      status: tenantStatusBadge(tenant, l10n),
      onTap: userId == null ? null : () => context.go('/more/tenants/$userId'),
    );
  }
}
