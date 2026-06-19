import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _TenantStatusFilter { all, active, inactive, pending }

class TenantsPage extends ConsumerStatefulWidget {
  const TenantsPage({super.key});

  @override
  ConsumerState<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends ConsumerState<TenantsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  _TenantStatusFilter _statusFilter = _TenantStatusFilter.all;

  // Bulk selection state
  final Set<int> _selectedIds = {};
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(int? id) {
    if (id == null) return;
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _enterSelectionMode(int? id) {
    if (id == null) return;
    setState(() {
      _isSelectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  List<Tenant> _applyFilters(List<Tenant> tenants) {
    var filtered = tenants;

    // Status filter
    if (_statusFilter != _TenantStatusFilter.all) {
      filtered = filtered.where((tenant) {
        final status = tenant.status?.toLowerCase() ?? '';
        switch (_statusFilter) {
          case _TenantStatusFilter.active:
            return status == 'active';
          case _TenantStatusFilter.inactive:
            return status == 'inactive' ||
                status == 'moved_out' ||
                status == 'moved out';
          case _TenantStatusFilter.pending:
            return status == 'pending';
          case _TenantStatusFilter.all:
            return true;
        }
      }).toList();
    }

    // Search filter (by name, phone, or property name)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((tenant) {
        final name = tenant.displayName.toLowerCase();
        final phone = tenant.phone?.toLowerCase() ?? '';
        final property = tenant.propertyName?.toLowerCase() ?? '';
        return name.contains(query) ||
            phone.contains(query) ||
            property.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tenantsPagedProvider);
    final controller = ref.read(tenantsPagedProvider.notifier);

    // Apply client-side filters to the loaded items.
    final filteredItems = _applyFilters(state.items);
    final filteredState = state.copyWith(items: filteredItems);
    // When filtered results are empty but more pages exist, show a message
    // that encourages loading more instead of a terminal empty state.
    final showLoadMoreHint =
        filteredItems.isEmpty && state.hasMore && state.items.isNotEmpty;

    return AppScaffold(
      appBar: AppBar(title: const Text('Tenants')),
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, phone, or property...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.md,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: _TenantStatusFilter.values.map((filter) {
                final isSelected = filter == _statusFilter;
                final scheme = Theme.of(context).colorScheme;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(_filterLabel(filter)),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _statusFilter = filter);
                    },
                    selectedColor: scheme.primary.withValues(alpha: 0.12),
                    checkmarkColor: scheme.primary,
                    labelStyle:
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? scheme.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.md,
                      side: BorderSide(
                        color: isSelected
                            ? scheme.primary
                            : scheme.outlineVariant,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -2),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Tenant list
          Expanded(
            child: PagedListView<Tenant>(
              state: filteredState,
              emptyTitle: showLoadMoreHint
                  ? 'No matches yet'
                  : 'No tenants found',
              emptyMessage: showLoadMoreHint
                  ? 'No tenants match your search or filter. '
                      'Load more to find matches.'
                  : state.items.isEmpty
                      ? 'Tenant directory will show up here.'
                      : 'No tenants match your search or filter.',
              onLoadMore: controller.loadMore,
              onRefresh: controller.refresh,
              onRetry: controller.loadInitial,
              onLoadMoreRetry: controller.retryLoadMore,
              itemBuilder: (context, tenant) => _TenantTile(
                tenant: tenant,
                isSelectionMode: _isSelectionMode,
                isSelected: _selectedIds.contains(tenant.id),
                onTap: _isSelectionMode
                    ? () => _toggleSelection(tenant.id)
                    : null,
                onLongPress: () => _enterSelectionMode(tenant.id),
              ),
            ),
          ),
          // Bulk action bar
          if (_isSelectionMode)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${_selectedIds.length} selected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () => _bulkSendReminders(context),
                    icon: const Icon(Icons.sms_outlined, size: 20),
                    label: const Text('Remind'),
                  ),
                  TextButton.icon(
                    onPressed: _exitSelectionMode,
                    icon: const Icon(Icons.close, size: 20),
                    label: const Text('Cancel'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _bulkSendReminders(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment reminders queued for ${_selectedIds.length} tenant(s).',
        ),
      ),
    );
    _exitSelectionMode();
  }

  String _filterLabel(_TenantStatusFilter filter) {
    switch (filter) {
      case _TenantStatusFilter.all:
        return 'All';
      case _TenantStatusFilter.active:
        return 'Active';
      case _TenantStatusFilter.inactive:
        return 'Inactive';
      case _TenantStatusFilter.pending:
        return 'Pending';
    }
  }
}

class _TenantTile extends StatelessWidget {
  const _TenantTile({
    required this.tenant,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  final Tenant tenant;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppStatusType.success;
      case 'inactive':
      case 'moved_out':
      case 'moved out':
        return AppStatusType.neutral;
      case 'pending':
        return AppStatusType.warning;
      default:
        return AppStatusType.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final status = tenant.status ?? 'Active';
    final initials = _getInitials(tenant.displayName);

    return GestureDetector(
      onLongPress: onLongPress,
      child: AppCard(
        onTap: isSelectionMode
            ? onTap
            : () => context.go('/more/tenants/${tenant.id}'),
        child: Row(
          children: [
            // Selection checkbox or avatar
            if (isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textTertiary,
                  size: 24,
                ),
              )
            else
              // Avatar
              Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                initials,
                style: textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name & property
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenant.displayName,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  tenant.propertyName ?? 'Property not set',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Status badge
          AppStatusBadge(
            label: status,
            type: _statusType(status),
            variant: AppStatusVariant.subtle,
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: AppColors.textTertiary,
          ),
        ],
      ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
