import 'package:flutter/animation.dart';

/// Centralized animation timing constants.
/// Ensures consistent motion across the entire app.
abstract final class AppDurations {
  /// Micro-interactions: press feedback, toggles, icon changes
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard transitions: expand, slide, color change
  static const Duration medium = Duration(milliseconds: 250);

  /// Page transitions, staggered list entrances
  static const Duration slow = Duration(milliseconds: 400);

  /// Delay between staggered list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Default easing curve for most animations
  static const Curve defaultCurve = Curves.easeOutCubic;

  /// Curve for entrance animations (slide in, fade in)
  static const Curve entranceCurve = Curves.easeOut;

  /// Curve for exit animations (slide out, fade out)
  static const Curve exitCurve = Curves.easeIn;

  /// Curve for spring-like press feedback
  static const Curve pressCurve = Curves.easeInOut;
}
