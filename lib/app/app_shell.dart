import 'package:estate_app/core/presentation/design_system/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : scheme.surface,
            borderRadius: AppRadii.xl,
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              width: 0.5,
            ),
            boxShadow: AppShadows.cardElevated,
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            destinations: [
              _buildDestination(
                context,
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildDestination(
                context,
                index: 1,
                icon: Icons.apartment_outlined,
                selectedIcon: Icons.apartment_rounded,
                label: 'Properties',
              ),
              _buildDestination(
                context,
                index: 2,
                icon: Icons.payments_outlined,
                selectedIcon: Icons.payments_rounded,
                label: 'Collections',
              ),
              _buildDestination(
                context,
                index: 3,
                icon: Icons.task_outlined,
                selectedIcon: Icons.task_alt_rounded,
                label: 'Tasks',
              ),
              _buildDestination(
                context,
                index: 4,
                icon: Icons.grid_view_outlined,
                selectedIcon: Icons.grid_view_rounded,
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    return NavigationDestination(
      icon: Icon(isSelected ? selectedIcon : icon),
      label: label,
    );
  }
}
