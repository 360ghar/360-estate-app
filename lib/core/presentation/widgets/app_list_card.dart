import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// The row every list uses: what it is, where or who, a few facts, and its
/// status. One look across properties, tenants, leases, tasks and the rest.
///
///   [leading]  title ................ [trailing]
///              subtitle
///              fact   fact   fact          [status]
class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.facts = const [],
    this.trailing,
    this.status,
    this.onTap,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;

  /// A bare icon, an avatar or a thumbnail. Never an icon in a tinted tile.
  final Widget? leading;

  /// Short facts (type, rent, date), set apart by space.
  final List<String> facts;

  /// Top-right: usually an amount or a date.
  final Widget? trailing;

  /// Bottom-right: usually an [AppStatusBadge].
  final Widget? status;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final visibleFacts = facts.where((f) => f.trim().isNotEmpty).toList();
    return AppCard(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleMedium,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      trailing!,
                    ],
                  ],
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
                if (visibleFacts.isNotEmpty || status != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Facts wrap as whole words with a gap between them,
                      // so no separator is ever left at a line end.
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.xxs,
                          children: [
                            for (final fact in visibleFacts)
                              Text(fact, style: muted),
                          ],
                        ),
                      ),
                      if (status != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        status!,
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
