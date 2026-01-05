import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MaintenanceDetailPage extends StatelessWidget {
  const MaintenanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MaintenanceDetailView();
  }
}

class _MaintenanceDetailView extends StatelessWidget {
  const _MaintenanceDetailView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MaintenanceDetailController>();

    return Obx(() {
      final state = controller.state.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Maintenance Request'),
          actions: [
            if (state.status == ViewStatus.success)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Get.toNamed<MaintenanceRequest>(
                    Routes.maintenanceCreate,
                    arguments: {'request': state.data},
                  );
                  if (result != null) {
                    unawaited(controller.loadRequest());
                  }
                },
              ),
          ],
        ),
        body: Builder(
          builder: (_) {
            switch (state.status) {
              case ViewStatus.idle:
              case ViewStatus.loading:
                return const Center(child: AppLoader());
              case ViewStatus.error:
                return AppErrorView(
                  title: 'Failed to load request',
                  message: state.failure?.message ?? 'Unknown error',
                  retryLabel: 'Retry',
                  onRetry: () => unawaited(controller.loadRequest()),
                );
              case ViewStatus.empty:
                return const Center(child: Text('Request not found'));
              case ViewStatus.success:
                return _DetailContent(request: state.data!);
            }
          },
        ),
      );
    });
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.request});

  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MaintenanceDetailController>();
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: request.category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        request.category.icon,
                        color: request.category.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request.category.displayName,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatusBadge(status: request.status),
                    const SizedBox(width: 8),
                    _PriorityBadge(priority: request.priority),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Property info
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Property',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.apartment,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request.propertyTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                if (request.tenantName != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        request.tenantName!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Details
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                if (request.assignedTo != null)
                  _DetailRow(
                    icon: Icons.person_pin,
                    label: 'Assigned To',
                    value: request.assignedTo!,
                  ),
                if (request.estimatedCost != null)
                  _DetailRow(
                    icon: Icons.attach_money,
                    label: 'Estimated Cost',
                    value: currencyFormat.format(request.estimatedCost),
                  ),
                if (request.actualCost != null)
                  _DetailRow(
                    icon: Icons.receipt,
                    label: 'Actual Cost',
                    value: currencyFormat.format(request.actualCost),
                  ),
                if (request.scheduledDate != null)
                  _DetailRow(
                    icon: Icons.event,
                    label: 'Scheduled',
                    value: dateFormat.format(request.scheduledDate!),
                  ),
                if (request.completedDate != null)
                  _DetailRow(
                    icon: Icons.check_circle_outline,
                    label: 'Completed',
                    value: dateFormat.format(request.completedDate!),
                  ),
                if (request.createdAt != null)
                  _DetailRow(
                    icon: Icons.access_time,
                    label: 'Created',
                    value: dateFormat.format(request.createdAt!),
                  ),
              ],
            ),
          ),

          if (request.notes != null && request.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.notes!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Status actions
          if (!request.isClosed)
            Obx(() {
              final isUpdating = controller.isUpdatingStatus.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Update Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (request.status != MaintenanceStatus.inProgress)
                        _ActionButton(
                          label: 'In Progress',
                          icon: Icons.play_arrow,
                          color: Colors.orange,
                          isLoading: isUpdating,
                          onPressed: () =>
                              unawaited(controller.markInProgress()),
                        ),
                      if (request.status != MaintenanceStatus.onHold)
                        _ActionButton(
                          label: 'On Hold',
                          icon: Icons.pause,
                          color: Colors.grey,
                          isLoading: isUpdating,
                          onPressed: () => unawaited(controller.markOnHold()),
                        ),
                      _ActionButton(
                        label: 'Completed',
                        icon: Icons.check,
                        color: Colors.green,
                        isLoading: isUpdating,
                        onPressed: () => unawaited(controller.markCompleted()),
                      ),
                      _ActionButton(
                        label: 'Cancel',
                        icon: Icons.close,
                        color: Colors.red,
                        isLoading: isUpdating,
                        onPressed: () => _confirmCancel(context, controller),
                      ),
                    ],
                  ),
                ],
              );
            }),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmCancel(
    BuildContext context,
    MaintenanceDetailController controller,
  ) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Request'),
          content: const Text(
            'Are you sure you want to cancel this maintenance request?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                unawaited(controller.markCancelled());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Yes, Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final MaintenanceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: status.color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final MaintenancePriority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: 14, color: priority.color),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              color: priority.color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          : Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
    );
  }
}
