import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/features/finance/presentation/pages/finance_page.dart';
import 'package:estate_app/features/home/presentation/pages/home_page.dart';
import 'package:estate_app/features/properties/presentation/pages/properties_page.dart';
import 'package:estate_app/features/shell/presentation/controllers/shell_controller.dart';
import 'package:estate_app/features/shell/presentation/pages/more_page.dart';
import 'package:estate_app/features/tenants/presentation/pages/tenants_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShellController>();

    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomePage(),
            PropertiesPage(),
            TenantsPage(),
            FinancePage(),
            MorePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.apartment_outlined),
              selectedIcon: Icon(Icons.apartment),
              label: 'Properties',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Tenants',
            ),
            NavigationDestination(
              icon: Icon(Icons.payments_outlined),
              selectedIcon: Icon(Icons.payments),
              label: 'Finance',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu),
              selectedIcon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showQuickActions(context),
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void _showQuickActions(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _QuickActionTile(
                icon: Icons.apartment,
                label: 'Add Property',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.propertyCreate));
                },
              ),
              _QuickActionTile(
                icon: Icons.description,
                label: 'Create Lease',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.leaseCreate));
                },
              ),
              _QuickActionTile(
                icon: Icons.receipt_long,
                label: 'Generate Rent Charges',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.rentChargeGenerate));
                },
              ),
              _QuickActionTile(
                icon: Icons.payments,
                label: 'Record Payment',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.recordPayment));
                },
              ),
              _QuickActionTile(
                icon: Icons.money_off,
                label: 'Add Expense',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.expenseCreate));
                },
              ),
              _QuickActionTile(
                icon: Icons.build,
                label: 'Create Maintenance Request',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.maintenanceCreate));
                },
              ),
              _QuickActionTile(
                icon: Icons.upload_file,
                label: 'Upload Document',
                onTap: () {
                  Navigator.pop(context);
                  unawaited(Get.toNamed<void>(Routes.documentUpload));
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brand),
      title: Text(label),
      onTap: onTap,
    );
  }
}
