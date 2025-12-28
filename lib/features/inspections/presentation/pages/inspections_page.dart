import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
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

class _InspectionsView extends StatefulWidget {
  const _InspectionsView();

  @override
  State<_InspectionsView> createState() => _InspectionsViewState();
}

class _InspectionsViewState extends State<_InspectionsView> {
  late final InspectionsController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<InspectionsController>();
    scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 250) {
      unawaited(controller.loadMore());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      final isLoading = controller.isLoading.value && items.isEmpty;
      final failure = controller.failure.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Inspections'),
          actions: [
            if (controller.hasActiveFilters)
              IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: controller.clearFilters,
              ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result =
                await Get.toNamed<Inspection>(Routes.inspectionCreate);
            if (result != null) {
              unawaited(controller.refresh());
            }
          },
          backgroundColor: AppColors.brand,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Builder(
          builder: (_) {
            if (isLoading) {
              return const Center(child: AppLoader());
            }

            if (failure != null && items.isEmpty) {
              return AppErrorView(
                title: context.l10n.errorSomethingWentWrong,
                message: failure.localizedMessage(context.l10n),
                retryLabel: context.l10n.commonRetry,
                onRetry: () => unawaited(controller.loadInspections()),
              );
            }

            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.checklist_outlined,
                title: 'No Inspections',
                message:
                    'No inspections found. Schedule an inspection to get started.',
                action: AppButton(
                  label: 'Schedule Inspection',
                  onPressed: () =>
                      Get.toNamed<void>(Routes.inspectionCreate),
                ),
              );
            }

            return Column(
              children: [
                // Stats bar
                _StatsBar(controller: controller),
                // List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          if (controller.isLoadingMore.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: AppLoader()),
                            );
                          }
                          return const SizedBox(height: 16);
                        }

                        final inspection = items[index];
                        return _InspectionCard(
                          inspection: inspection,
                          onTap: () async {
                            final result = await Get.toNamed<Inspection>(
                              Routes.inspectionDetail
                                  .replaceFirst(':id', '${inspection.id}'),
                            );
                            if (result != null) {
                              unawaited(controller.refresh());
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Filter Inspections',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Type',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: InspectionType.values.map((type) {
                  return _FilterChip(
                    label: type.displayName,
                    isSelected: controller.filterType.value == type,
                    onTap: () {
                      controller.setTypeFilter(type);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Status',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: InspectionStatus.values.map((status) {
                  return _FilterChip(
                    label: status.displayName,
                    isSelected: controller.filterStatus.value == status,
                    onTap: () {
                      controller.setStatusFilter(status);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ));
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.controller});

  final InspectionsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Scheduled',
            value: controller.scheduledCount.toString(),
            color: InspectionStatus.scheduled.color,
          ),
          _StatItem(
            label: 'In Progress',
            value: controller.inProgressCount.toString(),
            color: InspectionStatus.inProgress.color,
          ),
          _StatItem(
            label: 'Review',
            value: controller.pendingReviewCount.toString(),
            color: InspectionStatus.pendingReview.color,
          ),
          _StatItem(
            label: 'Completed',
            value: controller.completedCount.toString(),
            color: InspectionStatus.completed.color,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.brand.withValues(alpha: 0.2),
      checkmarkColor: AppColors.brand,
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({
    required this.inspection,
    required this.onTap,
  });

  final Inspection inspection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: inspection.inspectionType.color
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      inspection.inspectionType.icon,
                      color: inspection.inspectionType.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inspection.inspectionType.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (inspection.propertyTitle != null)
                          Text(
                            inspection.propertyTitle!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: inspection.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(inspection.scheduledDate),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (inspection.inspectorName != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        inspection.inspectorName!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (inspection.itemsCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.checklist,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${inspection.itemsCount} items',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (inspection.issueItemsCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${inspection.issueItemsCount} issues',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (!inspection.isFullySigned && inspection.isPendingReview) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Awaiting signatures',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 12,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
