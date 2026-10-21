import 'dart:math' as math;

import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Status meaning. Each has its own colour AND its own mark, so the status
/// never depends on colour alone.
enum AppStatusType {
  /// Paid, completed, active, approved: a filled disc.
  success,

  /// Due, pending, expiring: a half-filled disc.
  warning,

  /// Overdue, failed, rejected: a filled diamond.
  danger,

  /// Notes, scheduled: a ring.
  info,

  /// Draft, closed, unknown: a short bar.
  neutral,
}

enum AppStatusVariant {
  /// A tonal block behind the text, for the one status a screen leads with.
  filled,

  /// Mark and text, no fill. The default look in lists.
  subtle,
}

/// A status: a small mark and the word, in the status colour.
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.variant = AppStatusVariant.subtle,
    this.icon,
    this.onTap,
  });

  final String label;
  final AppStatusType type;
  final AppStatusVariant variant;

  /// Replaces the mark when the status is better told by a glyph.
  final IconData? icon;
  final VoidCallback? onTap;

  static String _sentence(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final (Color ink, Color fill) = statusColors(context, type);
    final filled = variant == AppStatusVariant.filled;
    // The mark grows with the text, so it stays legible at large text sizes.
    final mark = MediaQuery.textScalerOf(context).scale(10).clamp(10.0, 16.0);
    final text = _sentence(label.replaceAll('_', ' '));

    Widget badge = Padding(
      padding: filled
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: icon != null
                ? Icon(icon, size: mark + 4, color: ink)
                : CustomPaint(
                    size: Size.square(mark),
                    painter: StatusMarkPainter(type, ink),
                  ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.statusLabel.copyWith(color: ink),
            ),
          ),
        ],
      ),
    );

    if (filled) {
      badge = DecoratedBox(
        decoration: BoxDecoration(color: fill, borderRadius: AppRadii.sm),
        child: badge,
      );
    }
    if (onTap != null) {
      badge = InkWell(
        onTap: onTap,
        borderRadius: AppRadii.sm,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Align(widthFactor: 1, child: badge),
        ),
      );
    }
    return Semantics(
      label: text,
      button: onTap != null,
      onTap: onTap,
      excludeSemantics: true,
      child: badge,
    );
  }
}

/// The (text colour, tonal fill) pair for a status, for both themes.
(Color, Color) statusColors(BuildContext context, AppStatusType type) {
  final colors = context.colors;
  final palette = context.palette;
  return switch (type) {
    // onSuccessContainer, not success: the pair must reach text contrast.
    AppStatusType.success => (
      palette.onSuccessContainer,
      palette.successContainer,
    ),
    AppStatusType.warning => (palette.warning, palette.warningContainer),
    AppStatusType.danger => (colors.error, colors.errorContainer),
    AppStatusType.info => (colors.secondary, colors.secondaryContainer),
    AppStatusType.neutral => (
      colors.onSurfaceVariant,
      colors.surfaceContainerHigh,
    ),
  };
}

/// Draws the status mark centred in its box.
class StatusMarkPainter extends CustomPainter {
  const StatusMarkPainter(this.type, this.color);

  final AppStatusType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    switch (type) {
      case AppStatusType.success:
        canvas.drawCircle(c, r - 1, fill);
      case AppStatusType.warning:
        canvas.drawCircle(c, r - 1.5, stroke);
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: r - 1.5),
          math.pi / 2,
          math.pi,
          true,
          fill,
        );
      case AppStatusType.danger:
        final d = r - 0.5;
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - d)
            ..lineTo(c.dx + d, c.dy)
            ..lineTo(c.dx, c.dy + d)
            ..lineTo(c.dx - d, c.dy)
            ..close(),
          fill,
        );
      case AppStatusType.info:
        canvas.drawCircle(c, r - 1.5, stroke);
      case AppStatusType.neutral:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: c, width: r * 1.8, height: 2.4),
            const Radius.circular(1.2),
          ),
          fill,
        );
    }
  }

  @override
  bool shouldRepaint(StatusMarkPainter old) =>
      old.type != type || old.color != color;
}
