import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: AppRadii.xl,
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: AppShadows.card,
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.apartment_outlined),
                label: 'Properties',
              ),
              NavigationDestination(
                icon: Icon(Icons.payments_outlined),
                label: 'Collections',
              ),
              NavigationDestination(
                icon: Icon(Icons.task_outlined),
                label: 'Tasks',
              ),
              NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
            ],
          ),
        ),
      ),
    );
  }
}
