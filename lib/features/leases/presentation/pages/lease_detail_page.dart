import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/presentation/controllers/lease_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaseDetailPage extends StatelessWidget {
  const LeaseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaseDetailController>();

    return Obx(() {
      final state = controller.state.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Lease Details'),
          actions: state.status == ViewStatus.success
              ? [
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(context, value, controller),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'renew',
                        child: Row(
                          children: [
                            Icon(Icons.refresh),
                            SizedBox(width: 8),
                            Text('Renew Lease'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'terminate',
                        child: Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Terminate',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]
              : null,
        ),
        body: switch (state.status) {
          ViewStatus.loading || ViewStatus.idle => const Center(
              child: AppLoader(),
            ),
          ViewStatus.error => Center(
              child: AppErrorView(
                title: 'Unable to load lease',
                message: state.failure!.localizedMessage(context.l10n),
                onRetry: controller.loadLease,
                retryLabel: 'Try Again',
              ),
            ),
          ViewStatus.empty => const Center(
              child: AppEmptyState(
                icon: Icons.description,
                title: 'Lease not found',
                message: 'This lease may have been deleted',
              ),
            ),
          ViewStatus.success => _LeaseDetailContent(
              lease: state.data!,
              controller: controller,
            ),
        },
      );
    });
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    LeaseDetailController controller,
  ) {
    switch (action) {
      case 'renew':
        _showRenewDialog(context, controller);
      case 'terminate':
        _showTerminateDialog(context, controller);
    }
  }

  void _showRenewDialog(
    BuildContext context,
    LeaseDetailController controller,
  ) {
    final lease = controller.state.value.data!;
    DateTime newEndDate = lease.endDate.add(const Duration(days: 365));
    final rentController = TextEditingController(
      text: lease.monthlyRent.toStringAsFixed(0),
    );

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renew Lease'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('New End Date'),
              subtitle: Text(DateFormat('MMM d, yyyy').format(newEndDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: newEndDate,
                    firstDate: lease.endDate,
                    lastDate: lease.endDate.add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    newEndDate = picked;
                  }
                },
              ),
            ),
            TextField(
              controller: rentController,
              decoration: const InputDecoration(
                labelText: 'New Monthly Rent (optional)',
                prefixText: '\u20B9 ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.renewLease(
                newEndDate: newEndDate,
                newMonthlyRent: double.tryParse(rentController.text),
              );
              if (success) {
                Get.snackbar('Success', 'Lease renewed successfully');
              } else {
                Get.snackbar('Error', 'Failed to renew lease');
              }
            },
            child: const Text('Renew'),
          ),
        ],
      ),
    ),);
  }

  void _showTerminateDialog(
    BuildContext context,
    LeaseDetailController controller,
  ) {
    final reasonController = TextEditingController();

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminate Lease'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to terminate this lease? This action cannot be undone.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
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
              final success = await controller.terminateLease(
                reason: reasonController.text.isNotEmpty
                    ? reasonController.text
                    : null,
              );
              if (success) {
                Get.back<void>();
                Get.snackbar('Success', 'Lease terminated');
              } else {
                Get.snackbar('Error', 'Failed to terminate lease');
              }
            },
            child: const Text('Terminate'),
          ),
        ],
      ),
    ),);
  }
}

class _LeaseDetailContent extends StatelessWidget {
  const _LeaseDetailContent({
    required this.lease,
    required this.controller,
  });

  final Lease lease;
  final LeaseDetailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status and timing card
          AppCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusBadge(lease: lease),
                      const Spacer(),
                      if (lease.isExpiringSoon)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lease.daysRemaining} days remaining',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: 'Duration',
                    value:
                        '${dateFormat.format(lease.startDate)} - ${dateFormat.format(lease.endDate)}',
                  ),
                  _InfoRow(
                    label: 'Term',
                    value: '${lease.durationMonths} months',
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Property card
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.apartment, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(
                lease.propertyTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Property'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed<void>(
                Routes.propertyDetail.replaceFirst(
                  ':id',
                  lease.propertyId.toString(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tenant card
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: Text(
                lease.tenantName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Tenant'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed<void>(
                Routes.tenantDetail.replaceFirst(':id', lease.tenantUserId),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Financial details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Monthly Rent',
                    value: currencyFormat.format(lease.monthlyRent),
                  ),
                  if (lease.securityDeposit != null)
                    _InfoRow(
                      label: 'Security Deposit',
                      value: currencyFormat.format(lease.securityDeposit),
                    ),
                  _InfoRow(
                    label: 'Rent Due Day',
                    value: 'Day ${lease.rentDueDay} of each month',
                  ),
                  if (lease.lateFeeAmount != null)
                    _InfoRow(
                      label: 'Late Fee',
                      value:
                          '${currencyFormat.format(lease.lateFeeAmount)} after ${lease.lateFeeGraceDays ?? 5} days',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Document section
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
                          'Signed Document',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (lease.signedDocumentUrl == null)
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Implement file picker
                            Get.snackbar(
                              'Coming Soon',
                              'Document upload will be available soon',
                            );
                          },
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (lease.signedDocumentUrl != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.description, color: Colors.green),
                      title: const Text('Signed lease agreement'),
                      subtitle: const Text('Tap to view'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () {
                        // TODO: Open document viewer
                      },
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Icon(
                                Icons.upload_file,
                                size: 48,
                                color: Theme.of(context).colorScheme.outlineVariant, // Changed color
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'No signed document uploaded',
                              style: TextStyle(color: Theme.of(context).colorScheme.outline),
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

          // Notes
          if (lease.notes != null && lease.notes!.isNotEmpty)
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
                  Text(lease.notes!),
                ],
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (lease.isActive) {
      color = Colors.green;
      label = 'ACTIVE';
    } else if (lease.isExpired) {
      color = Colors.red;
      label = 'EXPIRED';
    } else {
      color = Theme.of(context).colorScheme.outline;
      label = lease.status?.toUpperCase() ?? 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
