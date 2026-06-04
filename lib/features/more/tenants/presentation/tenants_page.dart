import 'package:estate_app/core/presentation/design_system/app_colors.dart';
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

class TenantsPage extends ConsumerWidget {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tenantsPagedProvider);
    final controller = ref.read(tenantsPagedProvider.notifier);

    return AppScaffold(
      appBar: AppBar(title: const Text('Tenants')),
      padding: EdgeInsets.zero,
      body: PagedListView<Tenant>(
        state: state,
        emptyTitle: 'No tenants',
        emptyMessage: 'Tenant directory will show up here.',
        onLoadMore: controller.loadMore,
        onRefresh: controller.refresh,
        onRetry: controller.loadInitial,
        itemBuilder: (context, tenant) => _TenantTile(tenant: tenant),
      ),
    );
  }
}

class _TenantTile extends StatelessWidget {
  const _TenantTile({required this.tenant});

  final Tenant tenant;

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

    return AppCard(
      onTap: () => context.go('/more/tenants/${tenant.id}'),
      child: Row(
        children: [
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
