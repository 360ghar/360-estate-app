import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenant_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TenantDetailPage extends StatelessWidget {
  const TenantDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantDetailController>();

    return Obx(() {
      final state = controller.state.value;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            state.status == ViewStatus.success
                ? state.data!.displayName
                : 'Tenant Details',
          ),
        ),
        body: switch (state.status) {
          ViewStatus.loading || ViewStatus.idle => const Center(
              child: AppLoader(),
            ),
          ViewStatus.error => Center(
              child: AppErrorView(
                title: 'Unable to load tenant',
                message: state.failure!.localizedMessage(context.l10n),
                onRetry: controller.loadTenant,
                retryLabel: 'Try Again',
              ),
            ),
          ViewStatus.empty => const Center(
              child: AppEmptyState(
                icon: Icons.person,
                title: 'Tenant not found',
                message: 'This tenant may have been removed',
              ),
            ),
          ViewStatus.success => _TenantDetailContent(tenant: state.data!),
        },
      );
    });
  }
}

class _TenantDetailContent extends StatelessWidget {
  const _TenantDetailContent({required this.tenant});

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => Get.find<TenantDetailController>().refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar and status
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.brand.withValues(alpha: 0.1),
                  child: Text(
                    tenant.initials,
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.brand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  tenant.displayName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                _StatusBadge(status: tenant.status),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (tenant.phone != null)
                    _InfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: tenant.phone!,
                    ),
                  if (tenant.email != null)
                    _InfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: tenant.email!,
                    ),
                  if (tenant.emergencyContact != null) ...[
                    const Divider(height: 24),
                    Text(
                      'Emergency Contact',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.person,
                      label: 'Name',
                      value: tenant.emergencyContact!,
                    ),
                    if (tenant.emergencyPhone != null)
                      _InfoRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: tenant.emergencyPhone!,
                      ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ID Documents card
          if (tenant.governmentIdType != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Documents',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.badge,
                      label: 'ID Type',
                      value: tenant.governmentIdType!,
                    ),
                    if (tenant.governmentIdNumber != null)
                      _InfoRow(
                        icon: Icons.numbers,
                        label: 'ID Number',
                        value: tenant.governmentIdNumber!,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Current lease card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Current Lease',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (tenant.hasActiveLease)
                        TextButton(
                          onPressed: () => Get.toNamed<void>(
                            Routes.leaseDetail.replaceFirst(
                              ':id',
                              tenant.currentLease!.id.toString(),
                            ),
                          ),
                          child: const Text('View'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (tenant.hasActiveLease)
                    _LeaseCard(lease: tenant.currentLease!)
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No active lease',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lease history
          if (tenant.leaseHistory.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lease History',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tenant.leaseHistory.map(
                      (lease) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LeaseCard(lease: lease, isHistory: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Notes
          if (tenant.notes != null && tenant.notes!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(tenant.notes!),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TenantStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == TenantStatus.active ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaseCard extends StatelessWidget {
  const _LeaseCard({
    required this.lease,
    this.isHistory = false,
  });

  final Lease lease;
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHistory ? Colors.grey[50] : AppColors.brand.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHistory ? Colors.grey[300]! : AppColors.brand.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lease.propertyTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dateFormat.format(lease.startDate)} - ${dateFormat.format(lease.endDate)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currencyFormat.format(lease.monthlyRent)}/month',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isHistory && lease.isExpiringSoon)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${lease.daysRemaining} days left',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
