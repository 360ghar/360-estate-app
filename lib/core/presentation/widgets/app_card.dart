import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppInsets.card,
    this.onTap,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveBorderRadius = borderRadius ?? AppRadii.lg;
    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? scheme.surface,
        borderRadius: effectiveBorderRadius,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: AppShadows.md,
      ),
      child: child,
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      borderRadius: effectiveBorderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: container,
      ),
    );
  }
}
