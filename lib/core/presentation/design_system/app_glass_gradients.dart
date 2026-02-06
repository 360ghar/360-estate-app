import 'package:flutter/material.dart';
import 'app_glass_colors.dart';

/// Premium gradient definitions for glassmorphism UI.
/// Includes aurora mesh gradients, surface gradients, and shimmer effects.
abstract final class AppGlassGradients {
  // Primary Gradients
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

  /// Accent gradient for secondary actions
  /// Purple to pink gradient
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFF8B5CF6), // Purple
      Color(0xFFA855F7), // Light purple
    ],
  );

  /// Success gradient for positive actions
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF059669), // Emerald
      Color(0xFF10B981), // Light emerald
    ],
  );

  /// Error gradient for destructive actions
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDC2626), // Red
      Color(0xFFEF4444), // Light red
    ],
  );

  // Aurora Mesh Gradients (for animated backgrounds)
  /// Aurora gradient - animated northern lights effect
  /// Deep navy base with purple, blue, and teal highlights
  static const LinearGradient aurora = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppGlassColors.auroraNavy,
      AppGlassColors.auroraPurple,
      AppGlassColors.auroraIndigo,
      AppGlassColors.auroraBlue,
      AppGlassColors.auroraCyan,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  /// Light mode aurora - softer pastel version
  static const LinearGradient auroraLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEEF2FF), // Very light indigo
      Color(0xFFE0E7FF), // Light indigo
      Color(0xFFC7D2FE), // Soft indigo
      Color(0xFFA5B4FC), // Medium indigo
    ],
  );

  /// Dark mode aurora - vibrant deep colors
  static const LinearGradient auroraDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A), // Slate 900
      Color(0xFF1E1B4B), // Indigo 950
      Color(0xFF312E81), // Indigo 900
      Color(0xFF3730A3), // Indigo 800
      Color(0xFF4338CA), // Indigo 700
    ],
  );

  // Surface Gradients
  /// Glass surface gradient - subtle white/gray shimmer
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
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
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

  // Shimmer Gradients
  /// Shimmer gradient for loading states
  static LinearGradient shimmer({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment(-1, -0.5),
      end: Alignment(1, 0.5),
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

  /// Animated shimmer gradient with multiple stops
  static LinearGradient shimmerAnimated({bool isDark = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              const Color(0x1A1E293B),
              const Color(0x331E293B),
              const Color(0x4C1E293B),
              const Color(0x331E293B),
              const Color(0x1A1E293B),
            ]
          : [
              const Color(0x1AFFFFFF),
              const Color(0x33FFFFFF),
              const Color(0x4CFFFFFF),
              const Color(0x33FFFFFF),
              const Color(0x1AFFFFFF),
            ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );
  }

  // Border Gradients
  /// Gradient border for glass containers
  static const LinearGradient border = LinearGradient(
    colors: [
      Color(0x33FFFFFF), // 20% white
      Color(0x1AFFFFFF), // 10% white
      Color(0x33FFFFFF), // 20% white
    ],
  );

  /// Focus border gradient - blue glow
  static const LinearGradient borderFocus = LinearGradient(
    colors: [
      Color(0x993B82F6), // 60% blue
      Color(0x663B82F6), // 40% blue
      Color(0x993B82F6), // 60% blue
    ],
  );

  /// Success border gradient
  static const LinearGradient borderSuccess = LinearGradient(
    colors: [
      Color(0x99059669), // 60% green
      Color(0x66059669), // 40% green
      Color(0x99059669), // 60% green
    ],
  );

  /// Error border gradient
  static const LinearGradient borderError = LinearGradient(
    colors: [
      Color(0x99DC2626), // 60% red
      Color(0x66DC2626), // 40% red
      Color(0x99DC2626), // 60% red
    ],
  );

  // Auth Background Gradients
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
}
