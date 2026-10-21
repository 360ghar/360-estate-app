import 'dart:math' as math;

import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:flutter/material.dart';

/// A card shape with rounded top corners and a perforated bottom edge, like a
/// rent receipt torn from its book. The bites are [notch] deep and spread
/// evenly about every [pitch] pixels. Content needs more than [notch] of
/// bottom padding to clear the cut.
class ReceiptEdgeBorder extends ShapeBorder {
  const ReceiptEdgeBorder({
    this.radius = AppRadii.lgValue,
    this.notch = 4,
    this.pitch = 14,
  });

  final double radius;
  final double notch;
  final double pitch;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: notch);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = math.min(radius, rect.shortestSide / 2);
    final path = Path()
      ..moveTo(rect.left, rect.top + r)
      ..arcToPoint(Offset(rect.left + r, rect.top), radius: Radius.circular(r))
      ..lineTo(rect.right - r, rect.top)
      ..arcToPoint(Offset(rect.right, rect.top + r), radius: Radius.circular(r))
      ..lineTo(rect.right, rect.bottom);
    final count = pitch > 0 ? (rect.width / pitch).floor() : 0;
    if (count > 0) {
      final step = rect.width / count;
      for (var i = 0; i < count; i++) {
        final cx = rect.right - step * (i + 0.5);
        path
          ..lineTo(cx + notch, rect.bottom)
          ..arcToPoint(
            Offset(cx - notch, rect.bottom),
            radius: Radius.circular(notch),
            clockwise: false,
          );
      }
    }
    return path
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) =>
      ReceiptEdgeBorder(radius: radius * t, notch: notch * t, pitch: pitch * t);
}
