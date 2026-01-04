import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspections_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InspectionsPage extends StatelessWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InspectionsView();
  }
}

class _InspectionsView extends GetView<InspectionsController> {
  const _InspectionsView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Inspections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.failure.value != null && controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.failure.value!.message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadInspections,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.items.isEmpty) {
          return const AppEmptyState(
            icon: Icons.fact_check_outlined,
            title: 'No inspections found',
            message: 'Schedule your first property inspection',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadInspections,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.items.length) {
                unawaited(controller.loadMore());
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final inspection = controller.items[index];
              return _InspectionCard(inspection: inspection);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inspections_fab',
        onPressed: () => Get.toNamed<void>(Routes.inspectionCreate),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Filter by Status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: controller.filterStatus.value == null,
                    onSelected: (_) {
                      controller.setStatusFilter(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...InspectionStatus.values.map((status) {
                    return ChoiceChip(
                      label: Text(status.displayName),
                      selected: controller.filterStatus.value == status,
                      onSelected: (_) {
                        controller.setStatusFilter(status);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),);
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.toNamed<void>(
          Routes.inspectionDetail.replaceFirst(':id', inspection.id.toString()),
          arguments: inspection,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      inspection.propertyTitle ?? 'No Title',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _StatusBadge(status: inspection.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(inspection.scheduledDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.assignment_ind_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    inspection.inspectorName ?? 'Not Assigned',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              if (inspection.notes != null && inspection.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  inspection.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final InspectionStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      InspectionStatus.scheduled => (Colors.blue[700]!, Colors.blue[50]!),
      InspectionStatus.completed => (Colors.green[700]!, Colors.green[50]!),
      InspectionStatus.cancelled => (Colors.red[700]!, Colors.red[50]!),
      InspectionStatus.inProgress => (Colors.orange[700]!, Colors.orange[50]!),
      InspectionStatus.pendingReview => (Colors.purple[700]!, Colors.purple[50]!),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
