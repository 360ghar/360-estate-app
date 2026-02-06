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

  // === Colored Glow Shadows ===

  /// Blue ambient glow - for focus states and primary elements
  static const List<BoxShadow> glowBlue = [
    BoxShadow(
      color: Color(0x1A3B82F6), // 10% blue
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A3B82F6),
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Purple ambient glow - for secondary accents
  static const List<BoxShadow> glowPurple = [
    BoxShadow(
      color: Color(0x1A8B5CF6), // 10% purple
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A8B5CF6),
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Teal ambient glow - for success states
  static const List<BoxShadow> glowTeal = [
    BoxShadow(
      color: Color(0x1A14B8A6), // 10% teal
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A14B8A6),
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Red ambient glow - for error states
  static const List<BoxShadow> glowRed = [
    BoxShadow(
      color: Color(0x1ADC2626), // 10% red
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1ADC2626),
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  // === Glassmorphism Shadows ===

  /// Glass surface shadow for elevated cards
  static const List<BoxShadow> glass = [
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x08000000), // 3% black
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Dark mode glass shadow
  static const List<BoxShadow> glassDark = [
    BoxShadow(
      color: Color(0x10000000), // 6% black
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x0CFFFFFF), // 5% white
      offset: Offset(0, -2),
      blurRadius: 4,
    ),
  ];

  // Glass shadows by size (for convenience)
  static const List<BoxShadow> glassSm = sm;
  static const List<BoxShadow> glassMd = md;
  static const List<BoxShadow> glassLg = lg;
  static const List<BoxShadow> glassXl = xl;

  // Dark mode glass shadows by size
  static const List<BoxShadow> glassSmDark = AppShadowsDark.sm;
  static const List<BoxShadow> glassMdDark = AppShadowsDark.md;
  static const List<BoxShadow> glassLgDark = AppShadowsDark.lg;
  static const List<BoxShadow> glassXlDark = AppShadowsDark.xl;

  // === Button Glow Effects ===

  /// Primary button glow - blue glow for pressed/hover states
  static const List<BoxShadow> buttonGlowPrimary = [
    BoxShadow(
      color: Color(0x403B82F6), // 25% blue
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x203B82F6), // 12% blue
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  /// Secondary button glow - purple glow
  static const List<BoxShadow> buttonGlowSecondary = [
    BoxShadow(
      color: Color(0x408B5CF6), // 25% purple
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x208B5CF6), // 12% purple
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  // === Input Field Glows ===

  /// Input focus glow - blue glow when focused
  static const List<BoxShadow> inputFocus = [
    BoxShadow(
      color: Color(0x303B82F6), // 19% blue
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A3B82F6), // 10% blue
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Input error glow - red glow for invalid states
  static const List<BoxShadow> inputError = [
    BoxShadow(
      color: Color(0x30DC2626), // 19% red
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1ADC2626), // 10% red
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Input success glow - green glow for valid states
  static const List<BoxShadow> inputSuccess = [
    BoxShadow(
      color: Color(0x30059669), // 19% green
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A059669), // 10% green
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];
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
