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
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MaintenanceView();
  }
}

class _MaintenanceView extends StatefulWidget {
  const _MaintenanceView();

  @override
  State<_MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<_MaintenanceView> {
  late final MaintenanceController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MaintenanceController>();
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
          title: const Text('Maintenance'),
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
                await Get.toNamed<MaintenanceRequest>(Routes.maintenanceCreate);
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
                onRetry: () => unawaited(controller.loadRequests()),
              );
            }

            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.build_outlined,
                title: 'No Maintenance Requests',
                message:
                    'No maintenance requests found. Create a new request to get started.',
                action: AppButton(
                  label: 'Create Request',
                  onPressed: () =>
                      Get.toNamed<void>(Routes.maintenanceCreate),
                ),
              );
            }

            return Column(
              children: [
                _StatsBar(controller: controller),
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

                        final request = items[index];
                        return _MaintenanceCard(
                          request: request,
                          onTap: () async {
                            await Get.toNamed<void>(
                              Routes.maintenanceDetail.replaceFirst(
                                ':id',
                                request.id.toString(),
                              ),
                            );
                            unawaited(controller.refresh());
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
                    'Filter Requests',
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
                'Status',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MaintenanceStatus.values.map((status) {
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
              const SizedBox(height: 16),
              Text(
                'Priority',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MaintenancePriority.values.map((priority) {
                  return _FilterChip(
                    label: priority.displayName,
                    isSelected: controller.filterPriority.value == priority,
                    onTap: () {
                      controller.setPriorityFilter(priority);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MaintenanceCategory.values.map((category) {
                  return _FilterChip(
                    label: category.displayName,
                    isSelected: controller.filterCategory.value == category,
                    onTap: () {
                      controller.setCategoryFilter(category);
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

  final MaintenanceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Open',
            value: controller.openCount.toString(),
            color: Colors.orange,
          ),
          _StatItem(
            label: 'In Progress',
            value: controller.inProgressCount.toString(),
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Urgent',
            value: controller.urgentCount.toString(),
            color: Colors.red,
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
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

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.request,
    required this.onTap,
  });

  final MaintenanceRequest request;
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: request.category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      request.category.icon,
                      color: request.category.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.category.displayName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PriorityBadge(priority: request.priority),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatusBadge(status: request.status),
                  const Spacer(),
                  if (request.createdAt != null) ...[
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(request.createdAt!),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              if (request.scheduledDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 14,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Scheduled: ${dateFormat.format(request.scheduledDate!)}',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 12,
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

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final MaintenancePriority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.displayName.toUpperCase(),
        style: TextStyle(
          color: priority.color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: status.color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
