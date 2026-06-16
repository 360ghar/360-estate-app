import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  DateTime? _lastBackPress;

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // The double-back-to-exit gesture only makes sense on Android, where
    // SystemNavigator.pop() exits the app. On iOS/web/desktop back handling is
    // inconsistent, so we let the platform manage it normally.
    final interceptRootBack =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return PopScope(
      canPop: !interceptRootBack,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !interceptRootBack) return;
        final now = DateTime.now();
        if (_lastBackPress != null &&
            now.difference(_lastBackPress!) < const Duration(seconds: 3)) {
          SystemNavigator.pop();
        } else {
          _lastBackPress = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
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
              selectedIndex: widget.navigationShell.currentIndex,
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
    final isSelected = widget.navigationShell.currentIndex == index;
    return NavigationDestination(
      icon: Icon(isSelected ? selectedIcon : icon),
      label: label,
    );
  }
}
