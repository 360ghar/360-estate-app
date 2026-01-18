import 'package:flutter/material.dart';

/// Professional B2B SaaS color palette with navy/indigo primary.
/// Optimized for enterprise property management with clear semantic usage.
abstract final class AppColors {
  // Primary - Navy/Indigo for enterprise trust
  static const Color primary = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF152E4D);
  static const Color primaryLight = Color(0xFF2A4A73);
  static const Color primarySoft = Color(0xFFE8EDF4);

  // Accent
  static const Color accent = Color(0xFF3B82F6);

  // Semantic colors - used for status only, not decoration
  static const Color success = Color(0xFF059669);      // Emerald - Paid, Completed
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);      // Amber - Due, Expiring
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFDC2626);       // Red - Overdue, Critical
  static const Color dangerLight = Color(0xFFF87171);
  static const Color info = Color(0xFF0284C7);         // Sky - Information
  static const Color infoLight = Color(0xFF38BDF8);

  // Gray scale for hierarchy
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF9FAFB);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF111827);

  // Dark mode colors
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkBorder = Color(0xFF374151);

  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);

  // Legacy aliases for gradual migration
  static const Color brand = primary;
  static const Color brandDark = Color(0xFF152E4D);
  static const Color brandSoft = primarySoft;
  static const Color ink = textPrimary;
  static const Color muted = textSecondary;
  static const Color outline = border;
  static const Color outlineVariant = borderLight;

  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primarySoft,
      onPrimaryContainer: primaryDark,
      secondary: accent,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDBEAFE),
      onSecondaryContainer: primaryDark,
      tertiary: info,
      onTertiary: Colors.white,
      error: danger,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceVariant,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: borderLight,
      background: background,
      onBackground: textPrimary,
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF2A3B52),
      onPrimaryContainer: primarySoft,
      secondary: infoLight,
      onSecondary: darkBackground,
      secondaryContainer: darkSurfaceVariant,
      onSecondaryContainer: primarySoft,
      tertiary: infoLight,
      onTertiary: darkBackground,
      error: dangerLight,
      onError: darkBackground,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkSurfaceVariant,
      surfaceVariant: darkSurfaceVariant,
      onSurfaceVariant: darkTextSecondary,
      outline: darkBorder,
      outlineVariant: darkSurfaceVariant,
      background: darkBackground,
      onBackground: darkTextPrimary,
    );
  }
}
