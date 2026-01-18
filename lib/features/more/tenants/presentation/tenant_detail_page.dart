import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TenantDetailPage extends ConsumerWidget {
  const TenantDetailPage({super.key, required this.tenantId});

  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantDetailProvider(tenantId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Tenant details')),
      body: tenantAsync.when(
        data: (tenant) => _TenantDetail(tenant: tenant),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load tenant',
          message: error.toString(),
          onRetry: () => ref.invalidate(tenantDetailProvider(tenantId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _TenantDetail extends StatelessWidget {
  const _TenantDetail({required this.tenant});

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    final tenantId = tenant.id?.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tenant.displayName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(tenant.propertyName ?? 'Property not set'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Contact'),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(label: 'Phone', value: tenant.phone ?? 'Not set'),
        _InfoRow(label: 'Email', value: tenant.email ?? 'Not set'),
        _InfoRow(label: 'Room', value: tenant.roomNumber ?? 'Not set'),
        _InfoRow(label: 'Status', value: tenant.status ?? 'Active'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Leases & inspections'),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: tenantId == null
                  ? null
                  : () => context.go('/more/leases?tenantId=$tenantId'),
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('View leases'),
            ),
            OutlinedButton.icon(
              onPressed: tenantId == null
                  ? null
                  : () =>
                      context.go('/more/inspections?tenantId=$tenantId'),
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('View inspections'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
