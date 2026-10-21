import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
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
    final l10n = context.l10n;
    // The double-back-to-exit gesture only makes sense on Android, where
    // SystemNavigator.pop() exits the app. On iOS/web/desktop back handling is
    // inconsistent, so we let the platform manage it normally.
    final interceptRootBack =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final index = widget.navigationShell.currentIndex;

    final destinations = [
      (Icons.home_outlined, Icons.home_rounded, l10n.navHome),
      (Icons.apartment_outlined, Icons.apartment_rounded, l10n.navProperties),
      (Icons.payments_outlined, Icons.payments_rounded, l10n.navCollections),
      (Icons.task_alt_outlined, Icons.task_alt_rounded, l10n.navTasks),
      (Icons.grid_view_outlined, Icons.grid_view_rounded, l10n.navMore),
    ];

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
            SnackBar(
              content: Text(l10n.navPressBackToExit),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Stack(
          children: [
            // The system text size is kept. When it is large, only the
            // selected tab shows its label, so five labels never overflow.
            Builder(
              builder: (context) => NavigationBar(
                labelBehavior: MediaQuery.textScalerOf(context).scale(1) > 1.3
                    ? NavigationDestinationLabelBehavior.onlyShowSelected
                    : NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: index,
                onDestinationSelected: _onTap,
                destinations: [
                  for (final (icon, selected, label) in destinations)
                    NavigationDestination(
                      icon: Icon(icon),
                      selectedIcon: Icon(selected),
                      label: label,
                    ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _SlidingIndicator(
                index: index,
                count: destinations.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A short rounded bar on the top edge of the nav, over the active tab. It
/// slides from tab to tab; with reduced motion it jumps.
class _SlidingIndicator extends StatelessWidget {
  const _SlidingIndicator({required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final x = count == 1 ? 0.0 : -1 + 2 * index / (count - 1);
    return IgnorePointer(
      child: SizedBox(
        height: 3,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slot = constraints.maxWidth / count;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: (slot - 32) / 2),
              child: AnimatedAlign(
                alignment: Alignment(x, 0),
                duration: reduceMotion(context)
                    ? Duration.zero
                    : AppDurations.medium,
                curve: AppDurations.defaultCurve,
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
