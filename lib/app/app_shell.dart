import 'package:estate_app/core/presentation/design_system/app_colors.dart';
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
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              ...AppShadows.lg,
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                offset: const Offset(0, 2),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ColorFilter.mode(
                scheme.surface.withOpacity(0.95),
                BlendMode.srcOver,
              ),
              child: Container(
                height: 68,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: navigationShell.currentIndex == 0,
                      onTap: () => _onTap(0),
                      color: scheme.primary,
                    ),
                    _NavItem(
                      icon: Icons.apartment_outlined,
                      activeIcon: Icons.apartment_rounded,
                      label: 'Properties',
                      isSelected: navigationShell.currentIndex == 1,
                      onTap: () => _onTap(1),
                      color: scheme.primary,
                    ),
                    _NavItem(
                      icon: Icons.payments_outlined,
                      activeIcon: Icons.payments_rounded,
                      label: 'Collections',
                      isSelected: navigationShell.currentIndex == 2,
                      onTap: () => _onTap(2),
                      color: scheme.primary,
                    ),
                    _NavItem(
                      icon: Icons.task_outlined,
                      activeIcon: Icons.task_rounded,
                      label: 'Tasks',
                      isSelected: navigationShell.currentIndex == 3,
                      onTap: () => _onTap(3),
                      color: scheme.primary,
                    ),
                    _NavItem(
                      icon: Icons.menu_outlined,
                      activeIcon: Icons.menu_rounded,
                      label: 'More',
                      isSelected: navigationShell.currentIndex == 4,
                      onTap: () => _onTap(4),
                      color: scheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 4 : 0,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? color : scheme.onSurfaceVariant,
                    size: isSelected ? 24 : 22,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : scheme.onSurfaceVariant,
                  height: 1.2,
                ),
                child: Text(label, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
