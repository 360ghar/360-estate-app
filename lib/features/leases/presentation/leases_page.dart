import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeasesPage extends ConsumerStatefulWidget {
  const LeasesPage({super.key, this.propertyId, this.tenantId});

  final String? propertyId;
  final String? tenantId;

  @override
  ConsumerState<LeasesPage> createState() => _LeasesPageState();
}

enum _LeaseStatusFilter { all, active, expired, upcoming }

class _LeasesPageState extends ConsumerState<LeasesPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  _LeaseStatusFilter _statusFilter = _LeaseStatusFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Lease> _applyFilters(List<Lease> leases) {
    var filtered = leases;

    // Status filter
    if (_statusFilter != _LeaseStatusFilter.all) {
      filtered = filtered.where((lease) {
        final status = lease.status?.toLowerCase() ?? '';
        switch (_statusFilter) {
          case _LeaseStatusFilter.active:
            return status == 'active';
          case _LeaseStatusFilter.expired:
            return status == 'expired' || status == 'terminated';
          case _LeaseStatusFilter.upcoming:
            return status == 'pending' || status == 'draft';
          case _LeaseStatusFilter.all:
            return true;
        }
      }).toList();
    }

    // Search filter (by tenant name or property name)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((lease) {
        final tenantName = lease.tenantName?.toLowerCase() ?? '';
        final propertyName = lease.propertyName?.toLowerCase() ?? '';
        return tenantName.contains(query) ||
            propertyName.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final leasesAsync = ref.watch(
      leasesListProvider(
        LeaseListFilter(propertyId: widget.propertyId, tenantId: widget.tenantId),
      ),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Leases')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/leases/new'),
        icon: const Icon(Icons.post_add_outlined),
        label: const Text('New lease'),
      ),
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
                hintText: 'Search by tenant or property...',
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
              children: _LeaseStatusFilter.values.map((filter) {
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
                    labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? scheme.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
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
          // Lease list
          Expanded(
            child: leasesAsync.when(
              data: (leases) {
                final filtered = _applyFilters(leases);
                if (filtered.isEmpty) {
                  return AppEmptyView(
                    title: 'No leases found',
                    message: leases.isEmpty
                        ? 'Create your first lease to begin tracking.'
                        : 'No leases match your search or filter.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return _LeaseTile(lease: filtered[index]);
                  },
                );
              },
              loading: () => const AppLoadingShimmer(),
              error: (error, _) => AppErrorView(
                title: 'Unable to load leases',
                message: error.toString(),
                onRetry: () => ref.invalidate(leasesListProvider),
                retryLabel: 'Try again',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(_LeaseStatusFilter filter) {
    switch (filter) {
      case _LeaseStatusFilter.all:
        return 'All';
      case _LeaseStatusFilter.active:
        return 'Active';
      case _LeaseStatusFilter.expired:
        return 'Expired';
      case _LeaseStatusFilter.upcoming:
        return 'Upcoming';
    }
  }
}

class _LeaseTile extends StatelessWidget {
  const _LeaseTile({required this.lease});

  final Lease lease;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppStatusType.success;
      case 'expired':
      case 'terminated':
        return AppStatusType.neutral;
      case 'expiring':
      case 'pending':
        return AppStatusType.warning;
      case 'draft':
        return AppStatusType.info;
      default:
        return AppStatusType.info;
    }
  }

  Color _borderColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'expired':
      case 'terminated':
        return AppColors.textTertiary;
      case 'expiring':
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final start = _formatDate(lease.startDate);
    final end = _formatDate(lease.endDate);
    final status = lease.status ?? 'Active';

    return GestureDetector(
      onTap: () => context.go('/more/leases/${lease.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Colored left border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _borderColor(status),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lease.displayName,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          AppStatusBadge(
                            label: status,
                            type: _statusType(status),
                            variant: AppStatusVariant.subtle,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Date range
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '$start  -  $end',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (lease.rentAmount != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Text(
                              '\u20B9${lease.rentAmount!.toStringAsFixed(0)}',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                            ),
                            Text(
                              '/month',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Chevron
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
