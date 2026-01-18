import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6E5AE8),
      Color(0xFF8F7BFF),
      Color(0xFFC5A3FF),
    ],
  );

  static const LinearGradient softSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.surface,
      Color(0xFFF0ECFF),
    ],
  );
}
