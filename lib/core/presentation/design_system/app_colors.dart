import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF152E4D);
  static const Color primaryLight = Color(0xFF2A4A73);
  static const Color primarySoft = Color(0xFFE8EDF4);

  static const Color accent = Color(0xFF3B82F6);

  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFF87171);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFF38BDF8);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF9FAFB);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F6FA);
  static const Color backgroundDark = Color(0xFF0F172A);

  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkBorder = Color(0xFF334155);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

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
      primaryContainer: const Color(0xFFDCE8F5),
      onPrimaryContainer: primaryDark,
      secondary: accent,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDBEAFE),
      onSecondaryContainer: primaryDark,
      tertiary: info,
      onTertiary: Colors.white,
      error: danger,
      onError: Colors.white,
      surface: const Color(0xFFFEFEFE),
      onSurface: textPrimary,
      surfaceContainerHighest: const Color(0xFFF1F3F8),
      surfaceContainerHigh: const Color(0xFFF5F6FA),
      surfaceContainer: const Color(0xFFF8F9FC),
      surfaceVariant: const Color(0xFFF1F3F8),
      onSurfaceVariant: textSecondary,
      outline: const Color(0xFFD1D5DB),
      outlineVariant: const Color(0xFFE8EAEF),
      background: background,
      onBackground: textPrimary,
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.dark,
      primary: const Color(0xFF5B8EC9),
      onPrimary: const Color(0xFF0F172A),
      primaryContainer: const Color(0xFF1E3A5F),
      onPrimaryContainer: const Color(0xFFDCE8F5),
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
      surfaceContainerHigh: const Color(0xFF283548),
      surfaceContainer: const Color(0xFF1E293B),
      surfaceVariant: darkSurfaceVariant,
      onSurfaceVariant: darkTextSecondary,
      outline: const Color(0xFF475569),
      outlineVariant: const Color(0xFF334155),
      background: darkBackground,
      onBackground: darkTextPrimary,
    );
  }
}
