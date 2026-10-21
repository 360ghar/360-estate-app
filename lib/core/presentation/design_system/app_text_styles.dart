import 'package:flutter/material.dart';

/// Type: Uncut Sans (bundled, SIL OFL) for headings and amounts; the system
/// font (SF Pro / Roboto) for everything else. See MASTER.md for the scale.
abstract final class AppTextStyles {
  static const String display = 'UncutSans';

  /// Single-storey "a" (ss04): the one stylistic choice that gives the
  /// headings their voice.
  static const List<FontFeature> _displayFeatures = [
    FontFeature.enable('ss04'),
  ];

  /// Tabular figures so columns of rupees line up.
  static const List<FontFeature> _amountFeatures = [
    FontFeature.tabularFigures(),
    FontFeature.enable('ss04'),
  ];

  static TextStyle _display(double size, double lineHeight) => TextStyle(
    fontFamily: display,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: FontWeight.w700,
    letterSpacing: size >= 26 ? -0.4 : -0.1,
    fontFeatures: _displayFeatures,
  );

  static TextStyle _system(double size, double lineHeight, FontWeight w) =>
      TextStyle(fontSize: size, height: lineHeight / size, fontWeight: w);

  static TextTheme textTheme(ColorScheme scheme) => TextTheme(
    displayLarge: _display(40, 44),
    displayMedium: _display(32, 38),
    displaySmall: _display(28, 34),
    headlineLarge: _display(26, 32),
    headlineMedium: _display(22, 28),
    headlineSmall: _display(20, 26),
    titleLarge: _display(18, 24),
    titleMedium: _system(16, 22, FontWeight.w600),
    titleSmall: _system(14, 20, FontWeight.w600),
    bodyLarge: _system(16, 24, FontWeight.w400),
    bodyMedium: _system(14, 20, FontWeight.w400),
    bodySmall: _system(12, 16, FontWeight.w400),
    labelLarge: _system(14, 20, FontWeight.w600),
    labelMedium: _system(12, 16, FontWeight.w600),
    labelSmall: _system(11, 16, FontWeight.w500),
  ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

  // Amounts.
  static const TextStyle currencyLarge = TextStyle(
    fontFamily: display,
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    fontFeatures: _amountFeatures,
  );

  static const TextStyle currencyMedium = TextStyle(
    fontFamily: display,
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    fontFeatures: _amountFeatures,
  );

  static const TextStyle currencySmall = TextStyle(
    fontFamily: display,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    fontFeatures: _amountFeatures,
  );

  static const TextStyle currencyXSmall = TextStyle(
    fontFamily: display,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w500,
    fontFeatures: _amountFeatures,
  );

  static const TextStyle statusLabel = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );
}
