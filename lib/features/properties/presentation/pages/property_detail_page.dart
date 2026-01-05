import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/presentation/controllers/property_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PropertyDetailPage extends StatelessWidget {
  const PropertyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailController>();

    return Obx(() {
      final state = controller.state.value;

      return Scaffold(
        body: switch (state.status) {
          ViewStatus.loading || ViewStatus.idle => const Center(
              child: AppLoader(),
            ),
          ViewStatus.error => Center(
              child: AppErrorView(
                title: 'Unable to load property',
                message: state.failure!.localizedMessage(context.l10n),
                onRetry: controller.loadProperty,
                retryLabel: 'Try Again',
              ),
            ),
          ViewStatus.empty => const Center(
              child: AppEmptyState(
                icon: Icons.apartment,
                title: 'Property not found',
                message: 'This property may have been deleted',
              ),
            ),
          ViewStatus.success => _PropertyDetailContent(
              property: state.data!,
              controller: controller,
            ),
        },
      );
    });
  }
}

class _PropertyDetailContent extends StatelessWidget {
  const _PropertyDetailContent({
    required this.property,
    required this.controller,
  });

  final Property property;
  final PropertyDetailController controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text(property.displayName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _editProperty(context),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Lease'),
              Tab(text: 'Rent'),
              Tab(text: 'Expenses'),
              Tab(text: 'Maintenance'),
              Tab(text: 'Documents'),
              Tab(text: 'Inspections'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(property: property),
            _LeaseTab(property: property),
            _PlaceholderTab(title: 'Rent', icon: Icons.payments),
            _PlaceholderTab(title: 'Expenses', icon: Icons.money_off),
            _PlaceholderTab(title: 'Maintenance', icon: Icons.build),
            _PlaceholderTab(title: 'Documents', icon: Icons.folder),
            _PlaceholderTab(title: 'Inspections', icon: Icons.checklist),
          ],
        ),
      ),
    );
  }

  void _editProperty(BuildContext context) {
    unawaited(
      Get.toNamed<void>(
        Routes.propertyEdit.replaceFirst(':id', property.id.toString()),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    if (action == 'delete') {
      _confirmDelete(context);
    }
  }

  void _confirmDelete(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Property'),
          content: Text(
            'Are you sure you want to delete "${property.displayName}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                final success = await controller.deleteProperty();
                if (success) {
                  Get.back<void>();
                  Get.snackbar('Success', 'Property deleted');
                } else {
                  Get.snackbar('Error', 'Failed to delete property');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return RefreshIndicator(
      onRefresh: () => Get.find<PropertyDetailController>().refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Images section
          if (property.images.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: property.images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      property.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image,
                            size: 64, color: theme.colorScheme.outlineVariant),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Status badge
          Row(
            children: [
              _StatusBadge(status: property.managementStatus),
              const SizedBox(width: 8),
              if (property.isOccupied)
                const _StatusBadge(
                  label: 'Occupied',
                  color: Colors.green,
                )
              else
                const _StatusBadge(
                  label: 'Vacant',
                  color: Colors.orange,
                ),
            ],
          ),
          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _InfoRow(label: 'Type', value: property.propertyType.name),
                _InfoRow(
                    label: 'Category', value: property.propertyCategory.name),
                _InfoRow(label: 'Address', value: property.fullAddress),
                if (property.bedroomCount != null)
                  _InfoRow(
                      label: 'Bedrooms', value: '${property.bedroomCount}'),
                if (property.bathroomCount != null)
                  _InfoRow(
                      label: 'Bathrooms', value: '${property.bathroomCount}'),
                if (property.balconyCount != null)
                  _InfoRow(
                      label: 'Balconies', value: '${property.balconyCount}'),
                if (property.floorAreaSqft != null)
                  _InfoRow(
                    label: 'Area',
                    value:
                        '${property.floorAreaSqft!.toStringAsFixed(0)} sq.ft',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Info',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Monthly Rent',
                  value: currencyFormat.format(property.monthlyRentInr),
                ),
                _InfoRow(
                  label: 'Payment Due Day',
                  value: 'Day ${property.paymentDueDay} of each month',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          if (property.notes != null && property.notes!.isNotEmpty)
            AppCard(
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
                  Text(property.notes!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LeaseTab extends StatelessWidget {
  const _LeaseTab({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('MMM d, yyyy');

    if (property.activeLease == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined,
                size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'No Active Lease',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This property is currently vacant',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Get.toNamed<void>(Routes.leaseCreate),
              icon: const Icon(Icons.add),
              label: const Text('Create Lease'),
            ),
          ],
        ),
      );
    }

    final lease = property.activeLease!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Active Lease',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (lease.isExpiringSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 16, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            'Expiring Soon',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Divider(height: 24),
              _InfoRow(label: 'Tenant', value: lease.tenantName),
              _InfoRow(
                  label: 'Start Date',
                  value: dateFormat.format(lease.startDate)),
              _InfoRow(
                  label: 'End Date', value: dateFormat.format(lease.endDate)),
              _InfoRow(
                label: 'Monthly Rent',
                value: currencyFormat.format(lease.monthlyRent),
              ),
              if (lease.securityDeposit != null)
                _InfoRow(
                  label: 'Security Deposit',
                  value: currencyFormat.format(lease.securityDeposit),
                ),
              if (lease.status != null)
                _InfoRow(label: 'Status', value: lease.status!),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed<void>(
                  Routes.leaseDetail.replaceFirst(':id', lease.id.toString()),
                ),
                icon: const Icon(Icons.visibility),
                label: const Text('View Details'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  // TODO: Implement renew lease
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Renew'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    this.status,
    this.label,
    this.color,
  });

  final ManagementStatus? status;
  final String? label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? status?.name ?? '';
    final displayColor = color ?? _getStatusColor(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: displayColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayLabel.toUpperCase(),
        style: TextStyle(
          color: displayColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, ManagementStatus? status) {
    return switch (status) {
      ManagementStatus.active => Theme.of(context).colorScheme.primary,
      ManagementStatus.inactive => Theme.of(context).colorScheme.outline,
      ManagementStatus.sold => Colors.purple,
      null => Theme.of(context).colorScheme.outline,
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
