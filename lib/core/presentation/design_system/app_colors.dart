import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary brand colors
  static const Color brand = Color(0xFF1D4ED8);
  static const Color brandLight = Color(0xFF3B82F6);
  static const Color brandDark = Color(0xFF1E40AF);

  // Semantic colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // Premium gradient colors
  static const Color gradientStart = Color(0xFF667EEA);
  static const Color gradientEnd = Color(0xFF764BA2);
  static const Color gradientTeal = Color(0xFF06B6D4);
  static const Color gradientCyan = Color(0xFF22D3EE);

  // Dark theme gradients - Aesthetic Dark Blue
  static const Color darkGradientStart = Color(0xFF0D1B2A);
  static const Color darkGradientMiddle = Color(0xFF1B263B);
  static const Color darkGradientEnd = Color(0xFF1B3A5F);

  // Light theme gradients
  static const Color lightGradientStart = Color(0xFFE0E7FF);
  static const Color lightGradientEnd = Color(0xFFF0F9FF);

  // Glassmorphism colors
  static const Color glassWhite = Color(0x40FFFFFF);
  static const Color glassDark = Color(0x30000000);

  // ===== NEW AUTH THEME COLORS =====
  // Pure black background for modern auth UI
  static const Color authBackground = Color(0xFF000000);

  // Amber/Gold accent color (primary action color)
  static const Color authAccent = Color(0xFFFFC107);
  static const Color authAccentDark = Color(0xFFE5AC00);
  static const Color authAccentLight = Color(0xFFFFD54F);

  // Dark cards and inputs
  static const Color authCardBackground = Color(0xFF1A1A1A);
  static const Color authInputBackground = Color(0xFF2A2A2A);
  static const Color authInputBorder = Color(0xFFFFC107);

  // Text colors for auth
  static const Color authTextPrimary = Color(0xFFFFFFFF);
  static const Color authTextSecondary = Color(0xFFB0B0B0);
  static const Color authTextHint = Color(0xFF808080);

  /// Primary gradient for auth pages and premium UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  /// Teal accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientTeal, gradientCyan],
  );

  /// Dark auth background gradient
  static const LinearGradient darkAuthGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkGradientStart, darkGradientMiddle, darkGradientEnd],
  );

  /// Light auth background gradient
  static const LinearGradient lightAuthGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGradientStart, lightGradientEnd],
  );

  /// Button gradient for primary CTAs
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [brand, brandLight],
  );

  /// Amber button gradient for auth pages
  static const LinearGradient authButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [authAccent, authAccentLight],
  );

  static ColorScheme lightScheme() {
    final scheme = ColorScheme.fromSeed(seedColor: brand);
    return scheme.copyWith(
      primary: brand,
      secondary: info,
      error: danger,
      surfaceContainerHighest: const Color(0xFFF8FAFC),
    );
  }

  static ColorScheme darkScheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.dark,
    );
    return scheme.copyWith(
      primary: brandLight,
      secondary: info,
      error: danger,
      surface: const Color(0xFF121827),
      surfaceContainerHighest: const Color(0xFF1F2937),
    );
  }
}
