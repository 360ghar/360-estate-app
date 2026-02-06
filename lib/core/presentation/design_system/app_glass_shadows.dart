import 'package:flutter/material.dart';
import 'app_glass_colors.dart';

/// Glassmorphism shadow system with colored ambient glows.
/// Provides depth through multi-layer colored shadows and glow effects.
abstract final class AppGlassShadows {
  // === Glass Surface Shadows ===

  /// Subtle glass shadow - minimal elevation
  static const List<BoxShadow> glassSm = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  /// Medium glass shadow - standard elevation for cards
  static const List<BoxShadow> glassMd = [
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

  /// Large glass shadow - elevated cards
  static const List<BoxShadow> glassLg = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      offset: Offset(0, 16),
      blurRadius: 32,
      spreadRadius: -8,
    ),
  ];

  /// Extra large glass shadow - modals and dialogs
  static const List<BoxShadow> glassXl = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];

  // === Dark Mode Glass Shadows ===

  /// Dark mode subtle glass shadow
  static const List<BoxShadow> glassSmDark = [
    BoxShadow(
      color: Color(0x08000000), // 3% black
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
    BoxShadow(
      color: Color(0x0AFFFFFF), // 4% white
      offset: Offset(0, -1),
      blurRadius: 2,
    ),
  ];

  /// Dark mode medium glass shadow
  static const List<BoxShadow> glassMdDark = [
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

  /// Dark mode large glass shadow
  static const List<BoxShadow> glassLgDark = [
    BoxShadow(
      color: Color(0x18000000), // 9% black
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
    BoxShadow(
      color: Color(0x10FFFFFF), // 6% white
      offset: Offset(0, -4),
      blurRadius: 8,
    ),
  ];

  /// Dark mode extra large glass shadow
  static const List<BoxShadow> glassXlDark = [
    BoxShadow(
      color: Color(0x20000000), // 12% black
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
    BoxShadow(
      color: Color(0x14FFFFFF), // 8% white
      offset: Offset(0, -6),
      blurRadius: 12,
    ),
  ];

  // === Ambient Glow Shadows ===

  /// Blue ambient glow - for focus states and primary elements
  static const List<BoxShadow> glowBlue = [
    BoxShadow(
      color: AppGlassColors.glowBlue,
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppGlassColors.glowBlue,
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Purple ambient glow - for secondary accents
  static const List<BoxShadow> glowPurple = [
    BoxShadow(
      color: AppGlassColors.glowPurple,
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppGlassColors.glowPurple,
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  /// Teal ambient glow - for success states
  static const List<BoxShadow> glowTeal = [
    BoxShadow(
      color: AppGlassColors.glowTeal,
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppGlassColors.glowTeal,
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

  /// Pink ambient glow - for decorative aurora effects
  static const List<BoxShadow> glowPink = [
    BoxShadow(
      color: AppGlassColors.glowPink,
      offset: Offset(0, 0),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

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

  /// Ghost button - no glow, subtle shadow only
  static const List<BoxShadow> buttonGhost = [
    BoxShadow(
      color: Color(0x05000000), // 2% black
      offset: Offset(0, 1),
      blurRadius: 2,
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

  // === Inner Shadows (inset) ===
  // Note: Flutter's BoxShadow doesn't support inset in recent versions
  // Use Container decoration with gradient or custom painters for inset effects

  /// Inner shadow for pressed states (not directly supported - use alternative)
  static const List<BoxShadow> innerPressed = []; // Empty - use Container styling

  /// Inner shadow for glass containers (not directly supported - use alternative)
  static const List<BoxShadow> innerGlass = []; // Empty - use Container styling

  // === Composite Shadows (for elevated cards) ===

  /// Elevated glass card - combines glass shadow with subtle glow
  static List<BoxShadow> glassCardElevated({bool isDark = false}) {
    return isDark ? glassLgDark : glassLg;
  }

  /// Floating action button glow
  static const List<BoxShadow> fabGlow = [
    BoxShadow(
      color: Color(0x403B82F6), // 25% blue
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x203B82F6), // 12% blue
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];
}
