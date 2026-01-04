import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';
import 'package:estate_app/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/presentation/controllers/maintenance_controller.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/presentation/controllers/properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RMDashboardPage extends StatelessWidget {
  const RMDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final propertiesController = Get.find<PropertiesController>();
    final maintenanceController = Get.find<MaintenanceController>();

    return AppScaffold(
      appBar: AppBar(
        title: const Text('RM Dashboard'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed<void>(Routes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          unawaited(dashboardController.refresh());
          unawaited(propertiesController.refreshList());
          unawaited(maintenanceController.refresh());
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 24),
            _buildOverviewSection(context, dashboardController),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildPendingTasksSection(context, maintenanceController),
            const SizedBox(height: 24),
            _buildAssignedPropertiesSection(context, propertiesController),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Obx(() {
      final user = authController.state.value.data;
      final displayName = user?.phone ?? 'Agent';

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.support_agent,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $displayName!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage properties and assist owners',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOverviewSection(
    BuildContext context,
    DashboardController controller,
  ) {
    final state = controller.overviewState.value;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        switch (state.status) {
          ViewStatus.loading || ViewStatus.idle => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: AppLoader(),
              ),
            ),
          ViewStatus.error => AppErrorView(
              title: 'Unable to load dashboard',
              message: state.failure!.localizedMessage(context.l10n),
              onRetry: controller.loadDashboard,
              retryLabel: 'Try Again',
            ),
          ViewStatus.empty => const AppEmptyState(
              icon: Icons.dashboard,
              title: 'No data yet',
              message: 'Data will appear once properties are assigned to you',
            ),
          ViewStatus.success => _buildKpiGrid(context, state.data!),
        },
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context, DashboardOverview overview) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.apartment,
                label: 'Assigned Properties',
                value: overview.totalProperties.toString(),
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.people,
                label: 'Active Tenants',
                value: overview.occupiedProperties.toString(),
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.build,
                label: 'Vacant Units',
                value: overview.vacantProperties.toString(),
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.event,
                label: 'Maintenance',
                value: overview.underMaintenanceProperties.toString(),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionChip(
              icon: Icons.person_add,
              label: 'Add Tenant',
              onTap: () => Get.toNamed<void>(Routes.tenantCreate),
            ),
            _ActionChip(
              icon: Icons.description,
              label: 'Create Lease',
              onTap: () => Get.toNamed<void>(Routes.leaseCreate),
            ),
            _ActionChip(
              icon: Icons.build,
              label: 'Maintenance',
              onTap: () => Get.toNamed<void>(Routes.maintenance),
            ),
            _ActionChip(
              icon: Icons.attach_money,
              label: 'Record Payment',
              onTap: () => Get.toNamed<void>(Routes.recordPayment),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPendingTasksSection(
    BuildContext context,
    MaintenanceController controller,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Tasks',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed<void>(Routes.maintenance),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final items = controller.items
              .where((r) =>
                  r.status == MaintenanceStatus.open ||
                  r.status == MaintenanceStatus.inProgress)
              .take(3)
              .toList();

          if (items.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No pending maintenance requests',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return Card(
            child: Column(
              children: List.generate(
                items.length,
                (index) => Column(
                  children: [
                    if (index > 0) const Divider(height: 1),
                    _TaskTile(
                      icon: items[index].category.icon,
                      title: items[index].title,
                      subtitle: _getRelativeTime(items[index].createdAt),
                      priority: items[index].priority.displayName,
                      priorityColor: items[index].priority.color,
                      onTap: () => Get.toNamed<void>(
                        Routes.maintenanceDetail.replaceFirst(
                          ':id',
                          items[index].id.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  String _getRelativeTime(DateTime? time) {
    if (time == null) return 'Unknown time';
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return 'Reported ${diff.inDays} days ago';
    if (diff.inHours > 0) return 'Reported ${diff.inHours} hours ago';
    return 'Reported recently';
  }

  Widget _buildAssignedPropertiesSection(
    BuildContext context,
    PropertiesController controller,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Assigned Properties',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed<void>(Routes.properties),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoadingFirstPage.value) {
            return const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final items = controller.items.take(5).toList();
          if (items.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No properties assigned yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final property = items[index];
                return _PropertyMiniCard(
                  name: property.displayName,
                  units: '${property.bedroomCount ?? 0} BHK',
                  occupancy: property.managementStatus == ManagementStatus.active
                      ? 'Occupied'
                      : property.managementStatus.name,
                  onTap: () => Get.toNamed<void>(
                    Routes.propertyDetail.replaceFirst(
                      ':id',
                      property.id.toString(),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.priority,
    required this.priorityColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String priority;
  final Color priorityColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(icon, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: priorityColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          priority,
          style: TextStyle(
            color: priorityColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PropertyMiniCard extends StatelessWidget {
  const _PropertyMiniCard({
    required this.name,
    required this.units,
    required this.occupancy,
    this.onTap,
  });

  final String name;
  final String units;
  final String occupancy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.apartment,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const Spacer(),
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$units • $occupancy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
