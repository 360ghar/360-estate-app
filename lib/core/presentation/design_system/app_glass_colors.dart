import 'package:flutter/material.dart';

/// Glassmorphism color tokens for premium UI.
/// Provides surface opacities, ambient glow colors, and aurora gradients.
abstract final class AppGlassColors {
  // Glass Surface Opacities
  /// 87% opacity - Strong glass for primary surfaces
  static const double opacityStrong = 0.87;

  /// 80% opacity - Medium glass for cards and containers
  static const double opacityMedium = 0.80;

  /// 70% opacity - Light glass for subtle overlays
  static const double opacityLight = 0.70;

  /// 50% opacity - Very light glass for decorative elements
  static const double opacitySubtle = 0.50;

  // Ambient Glow Colors (hex with alpha for soft glow effects)
  /// Soft blue glow for primary focus states
  static const Color glowBlue = Color(0x1A3B82F6);

  /// Soft purple glow for secondary accents
  static const Color glowPurple = Color(0x1A8B5CF6);

  /// Soft teal glow for success states
  static const Color glowTeal = Color(0x1A14B8A6);

  /// Soft pink glow for decorative aurora effects
  static const Color glowPink = Color(0x1AEC4899);

  /// Soft orange glow for warm accents
  static const Color glowOrange = Color(0x1AF97316);

  // Aurora Gradient Colors (for animated backgrounds)
  /// Deep navy base for dark mode aurora
  static const Color auroraNavy = Color(0xFF0F172A);

  /// Rich purple for aurora gradients
  static const Color auroraPurple = Color(0xFF6366F1);

  /// Vibrant indigo for aurora gradients
  static const Color auroraIndigo = Color(0xFF4F46E5);

  /// Soft blue for aurora gradients
  static const Color auroraBlue = Color(0xFF3B82F6);

  /// Cyan accent for aurora gradients
  static const Color auroraCyan = Color(0xFF06B6D4);

  /// Teal accent for aurora gradients
  static const Color auroraTeal = Color(0xFF14B8A6);

  // Glass Surface Colors (with alpha applied)
  /// Light mode glass surface (white with alpha)
  static Color glassSurfaceLight(double opacity) =>
      Colors.white.withOpacity(opacity);

  /// Dark mode glass surface (dark with alpha)
  static Color glassSurfaceDark(double opacity) =>
      const Color(0xFF1E293B).withOpacity(opacity);

  // Border Colors
  /// Subtle light mode border
  static const Color borderLight = Color(0x33FFFFFF); // 20% white

  /// Subtle dark mode border
  static const Color borderDark = Color(0x1AFFFFFF); // 10% white

  /// Active focus border (blue glow)
  static const Color borderFocus = Color(0x803B82F6); // 50% blue

  /// Error border (red glow)
  static const Color borderError = Color(0x80DC2626); // 50% red

  /// Success border (green glow)
  static const Color borderSuccess = Color(0x80059669); // 50% green

  // Text Colors (optimized for glass surfaces)
  /// Primary text on light glass
  static const Color textOnLight = Color(0xDD111827); // 87% black

  /// Secondary text on light glass
  static const Color textSecondaryOnLight = Color(0x996B7280); // 60% gray

  /// Primary text on dark glass
  static const Color textOnDark = Color(0xDDF9FAFB); // 87% white

  /// Secondary text on dark glass
  static const Color textSecondaryOnDark = Color(0x999CA3AF); // 60% gray

  // Overlay Colors
  /// Scrim overlay for modal backgrounds
  static const Color scrim = Color(0x66000000); // 40% black

  /// Light toast overlay
  static const Color toastLight = Color(0xF2FFFFFF); // 95% white

  /// Dark toast overlay
  static const Color toastDark = Color(0xF21E293B); // 95% dark slate
}
