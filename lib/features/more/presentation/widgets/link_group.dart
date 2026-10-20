import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';

/// A titled card of rows (links, switches, radios) with a quiet divider
/// between them. Used by More, Profile, Settings, Privacy and About.
class LinkGroup extends StatelessWidget {
  const LinkGroup({
    super.key,
    this.title,
    required this.children,
    this.dividerIndent = 56,
  });

  final String? title;
  final List<Widget> children;

  /// Where the divider starts: under the row text. Rows with a leading icon
  /// keep the default; rows without one pass [AppSpacing.lg].
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) Divider(indent: dividerIndent, endIndent: AppSpacing.lg),
          children[i],
        ],
      ],
    );
    return title == null
        ? AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: rows,
          )
        : AppSectionCard(
            title: title,
            contentPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: rows,
          );
  }
}

/// One row that opens something: a bare icon, a title, an optional line
/// under it, and a chevron. A [destructive] row uses the error colour.
class LinkRow extends StatelessWidget {
  const LinkRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? context.colors.error : null;
    return ListTile(
      leading: ExcludeSemantics(child: Icon(icon, color: color)),
      title: Text(title, style: color == null ? null : TextStyle(color: color)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing:
          trailing ??
          ExcludeSemantics(
            child: Icon(
              Icons.chevron_right_rounded,
              color: color ?? context.colors.onSurfaceVariant,
            ),
          ),
      onTap: onTap,
    );
  }
}
