import 'package:flutter/material.dart';

/// Multi-level shadow system for B2B SaaS elevation.
/// Provides clear visual hierarchy through subtle elevation differences.
abstract final class AppShadows {
  // Level 1: Subtle elevation for cards and list items
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  // Level 2: Medium elevation for raised cards
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  // Level 3: High elevation for dialogs and bottom sheets
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 8),
      blurRadius: 12,
    ),
  ];

  // Level 4: Highest elevation for modals and FABs
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
  ];

  // Legacy aliases for gradual migration
  static const List<BoxShadow> card = md;
  static const List<BoxShadow> subtle = sm;
}

/// Dark mode shadows with adjusted opacity for dark backgrounds.
abstract final class AppShadowsDark {
  // Dark mode shadows use lighter colors for visibility on dark backgrounds
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0C000000),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x10000000),
      offset: Offset(0, 8),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
  ];
}
