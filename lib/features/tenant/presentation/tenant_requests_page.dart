import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TenantRequestsPage extends ConsumerWidget {
  const TenantRequestsPage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  String _formatStatus(MaintenanceStatus status) {
    return status.displayName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(maintenancePagedProvider);
    final controller = ref.read(maintenancePagedProvider.notifier);

    return AppScaffold(
      appBar: AppBar(title: const Text('Requests')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tenant/requests/new'),
        icon: const Icon(Icons.add),
        label: const Text('New request'),
      ),
      body: PagedListView<MaintenanceRequest>(
        state: state,
        emptyTitle: 'No requests yet',
        emptyMessage: 'Submit a maintenance request when needed.',
        onLoadMore: controller.loadMore,
        onRefresh: controller.refresh,
        onRetry: controller.loadInitial,
        itemBuilder: (context, request) => _RequestTile(
          request: request,
          formattedDate: _formatDate(request.createdAt),
          formattedStatus: _formatStatus(request.status),
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.request,
    required this.formattedDate,
    required this.formattedStatus,
  });

  final MaintenanceRequest request;
  final String formattedDate;
  final String formattedStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(request.title),
        subtitle: Text('$formattedStatus | $formattedDate'),
        leading: Icon(
          _iconForCategory(request.category),
          color: request.category.color,
        ),
        trailing: Icon(
          _iconForStatus(request.status),
          color: request.status.color,
          size: 20,
        ),
      ),
    );
  }

  IconData _iconForCategory(MaintenanceCategory category) {
    return category.icon;
  }

  IconData _iconForStatus(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.open:
        return Icons.circle_outlined;
      case MaintenanceStatus.inProgress:
        return Icons.sync;
      case MaintenanceStatus.onHold:
        return Icons.pause;
      case MaintenanceStatus.completed:
        return Icons.check_circle;
      case MaintenanceStatus.cancelled:
        return Icons.cancel;
    }
  }
}
