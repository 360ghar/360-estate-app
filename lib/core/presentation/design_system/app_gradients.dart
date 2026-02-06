import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium gradient definitions for glassmorphism UI.
/// Includes auth backgrounds, surface gradients, and accent gradients.
abstract final class AppGradients {
  // === Primary Gradients ===

  /// Premium primary gradient for buttons and highlights
  /// Deep navy to vibrant blue - professional yet modern
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A5F), // Navy
      Color(0xFF2563EB), // Blue
      Color(0xFF3B82F6), // Lighter blue
    ],
  );

  /// Hero gradient - purple to lavender (legacy, kept for compatibility)
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6E5AE8),
      Color(0xFF8F7BFF),
      Color(0xFFC5A3FF),
    ],
  );

  /// Accent gradient - purple to pink
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFF8B5CF6), // Purple
      Color(0xFFA855F7), // Light purple
    ],
  );

  /// Success gradient - green tones
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF059669), // Emerald
      Color(0xFF10B981), // Light emerald
    ],
  );

  /// Error gradient - red tones
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDC2626), // Red
      Color(0xFFEF4444), // Light red
    ],
  );

  // === Auth Background Gradients ===

  /// Deep gradient for authentication screens
  static const LinearGradient authBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A), // Slate 900
      Color(0xFF1E1B4B), // Indigo 950
      Color(0xFF312E81), // Indigo 900
      Color(0xFF1E3A5F), // Navy
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  /// Light mode auth background gradient
  static const LinearGradient authBackgroundLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEEF2FF), // Very light indigo
      Color(0xFFE0E7FF), // Light indigo
      Color(0xFFC7D2FE), // Soft indigo
    ],
  );

  // === Surface Gradients ===

  /// Soft surface gradient (legacy, kept for compatibility)
  static const LinearGradient softSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.surface,
      Color(0xFFF0ECFF),
    ],
  );

  /// Glass surface gradient - subtle white shimmer
  static LinearGradient glassSurface({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              const Color(0xCC1E293B), // Dark slate with alpha
              const Color(0xB31E293B), // Dark slate with less alpha
            ]
          : [
              const Color(0xCCFFFFFF), // White with alpha
              const Color(0xB3FFFFFF), // White with less alpha
            ],
    );
  }

  /// Card surface gradient - directional glass effect
  static LinearGradient glassCard({bool isDark = false}) {
    return LinearGradient(
      begin: const Alignment(-1, -1),
      end: const Alignment(1, 1),
      colors: isDark
          ? [
              const Color(0xD91E293B), // 85% dark slate
              const Color(0x991E293B), // 60% dark slate
            ]
          : [
              const Color(0xD9FFFFFF), // 85% white
              const Color(0x99FFFFFF), // 60% white
            ],
      stops: const [0.0, 1.0],
    );
  }

  // === Shimmer Gradients ===

  /// Shimmer gradient for loading states
  static LinearGradient shimmer({bool isDark = false}) {
    return LinearGradient(
      begin: const Alignment(-1, -0.5),
      end: const Alignment(1, 0.5),
      colors: isDark
          ? [
              const Color(0x331E293B), // 20% dark slate
              const Color(0x66FFFFFF), // 40% white highlight
              const Color(0x331E293B), // 20% dark slate
            ]
          : [
              const Color(0x33FFFFFF), // 20% white
              const Color(0x66FFFFFF), // 40% white highlight
              const Color(0x33FFFFFF), // 20% white
            ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // === Orb Gradients ===

  /// Orb gradient for floating decorative elements
  static RadialGradient orbGradient(Color color) {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        color.withOpacity(0.4),
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Aurora orb gradient - animated northern lights effect
  static RadialGradient auroraOrb1() {
    return orbGradient(const Color(0xFF6366F1)); // Indigo orb
  }

  /// Second aurora orb with different color
  static RadialGradient auroraOrb2() {
    return orbGradient(const Color(0xFF06B6D4)); // Cyan orb
  }

  /// Third aurora orb for variety
  static RadialGradient auroraOrb3() {
    return orbGradient(const Color(0xFF8B5CF6)); // Purple orb
  }
}
