import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A titled group on a card surface: form sections and detail sections.
/// The title is plain type; the icon, when given, stands bare beside it.
class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.trailing,
    this.contentPadding,
    this.children = const [],
    this.child,
  });

  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  /// Null: all sides [AppSpacing.lg] without a title, and a tighter top under
  /// a title.
  final EdgeInsetsGeometry? contentPadding;
  final List<Widget> children;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: context.palette.card,
      borderRadius: AppRadii.lg,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                trailing == null ? AppSpacing.lg : AppSpacing.sm,
                0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 24),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      ExcludeSemantics(
                        child: Icon(
                          icon,
                          size: 20,
                          color: iconColor ?? colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(title!, style: context.text.titleLarge),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
            ),
          Padding(
            padding:
                contentPadding ??
                (title == null
                    ? const EdgeInsets.all(AppSpacing.lg)
                    : const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      )),
            child:
                child ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
          ),
        ],
      ),
    );
  }
}
