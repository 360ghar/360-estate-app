import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color brand = Color(0xFF1D4ED8);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  static ColorScheme lightScheme() {
    final scheme = ColorScheme.fromSeed(seedColor: brand);
    return scheme.copyWith(primary: brand, secondary: info, error: danger);
  }

  static ColorScheme darkScheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.dark,
    );
    return scheme.copyWith(primary: brand, secondary: info, error: danger);
  }
}
