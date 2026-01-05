import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'MANAGEMENT', [
            _MoreMenuItem(
              icon: Icons.build_outlined,
              label: 'Maintenance',
              subtitle: 'Manage maintenance requests',
              onTap: () => Get.toNamed<void>(Routes.maintenance),
            ),
            _MoreMenuItem(
              icon: Icons.assignment_outlined,
              label: 'Applications',
              subtitle: 'Tenant applications & forms',
              onTap: () => Get.toNamed<void>(Routes.applications),
            ),
            _MoreMenuItem(
              icon: Icons.description_outlined,
              label: 'Leases',
              subtitle: 'Manage lease agreements',
              onTap: () => Get.toNamed<void>(Routes.leases),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'RESOURCES', [
            _MoreMenuItem(
              icon: Icons.folder_outlined,
              label: 'Documents',
              subtitle: 'Document vault',
              onTap: () => Get.toNamed<void>(Routes.documents),
            ),
            _MoreMenuItem(
              icon: Icons.checklist_outlined,
              label: 'Inspections',
              subtitle: 'Property inspections',
              onTap: () => Get.toNamed<void>(Routes.inspections),
            ),
            _MoreMenuItem(
              icon: Icons.bar_chart_outlined,
              label: 'Reports',
              subtitle: 'Analytics & reports',
              onTap: () => Get.toNamed<void>(Routes.reports),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'PREFERENCES', [
            _MoreMenuItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              subtitle: 'App preferences',
              onTap: () => Get.toNamed<void>(Routes.settings),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ),
        AppCard(
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  const _MoreMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
