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
          heroTag: 'shell_fab',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _QuickActionItem(
                      icon: Icons.apartment,
                      label: 'Add Property',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.propertyCreate));
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.description,
                      label: 'Create Lease',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.leaseCreate));
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.receipt_long,
                      label: 'Generate Rent',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.finance));
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.payments,
                      label: 'Record Pay',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.recordPayment));
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.money_off,
                      label: 'Add Expense',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.expenseCreate));
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.build,
                      label: 'Maintenance',
                      color: Colors.amber,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(Get.toNamed<void>(Routes.maintenanceCreate));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
