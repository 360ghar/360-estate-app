import 'package:flutter/animation.dart';

/// Motion tokens. Every animation checks
/// `MediaQuery.disableAnimations` (see `motion.dart`).
abstract final class AppDurations {
  /// Press feedback, toggles.
  static const Duration fast = Duration(milliseconds: 120);

  /// State changes: expand, swap, colour.
  static const Duration medium = Duration(milliseconds: 220);

  /// Page-level moves and counting numbers.
  static const Duration slow = Duration(milliseconds: 360);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entranceCurve = Curves.easeOutCubic;
}
