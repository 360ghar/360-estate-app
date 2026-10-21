import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

enum AppAvatarSize { xs, sm, md, lg, xl }

/// A person: their photo, or their initials on one tonal fill.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.initials,
    this.size = AppAvatarSize.md,
    this.backgroundColor,
    this.onTap,
  });

  final String? imageUrl;
  final String? name;
  final String? initials;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  double get _dimension => switch (size) {
    AppAvatarSize.xs => 24,
    AppAvatarSize.sm => 32,
    AppAvatarSize.md => 40,
    AppAvatarSize.lg => 48,
    AppAvatarSize.xl => 72,
  };

  static String _initialsOf(String? name) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'))
      ..removeWhere((p) => p.isEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final d = _dimension;
    final fill = backgroundColor ?? context.colors.primaryContainer;
    final letters = Center(
      child: Text(
        initials ?? _initialsOf(name),
        // The circle does not grow with the text size, so neither do the
        // letters inside it.
        textScaler: TextScaler.noScaling,
        style: TextStyle(
          fontFamily: AppTextStyles.display,
          fontWeight: FontWeight.w700,
          fontSize: d * 0.38,
          height: 1,
          color: backgroundColor == null
              ? context.colors.onPrimaryContainer
              : (fill.computeLuminance() < 0.5 ? Colors.white : Colors.black87),
        ),
      ),
    );
    final url = imageUrl;
    Widget avatar = ClipOval(
      child: SizedBox.square(
        dimension: d,
        child: ColoredBox(
          color: fill,
          child: url == null || url.isEmpty
              ? letters
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  // While the photo loads, and if it never loads, the
                  // initials stand in.
                  frameBuilder: (_, child, frame, _) =>
                      frame == null ? letters : child,
                  errorBuilder: (_, _, _) => letters,
                ),
        ),
      ),
    );
    if (onTap != null) {
      avatar = Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: avatar),
      );
    }
    return Semantics(
      label: name ?? initials,
      image: url != null && url.isNotEmpty,
      button: onTap != null,
      onTap: onTap,
      excludeSemantics: true,
      child: avatar,
    );
  }
}
