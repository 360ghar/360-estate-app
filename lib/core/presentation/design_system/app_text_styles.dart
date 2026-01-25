import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';

/// Professional B2B typography system with Poppins font.
/// Includes financial display styles with tabular figures for data.
abstract final class AppTextStyles {
  static TextTheme textTheme(ColorScheme scheme) {
    final base = GoogleFonts.poppinsTextTheme();
    return base
        .copyWith(
          displayLarge: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            height: 1.08,
          ),
          displayMedium: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.12,
          ),
          displaySmall: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.12,
          ),
          headlineLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          headlineMedium: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          headlineSmall: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          titleSmall: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          labelMedium: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          labelSmall: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  }

  // Financial display styles with tabular figures for aligned numbers
  static const TextStyle currencyLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle currencyMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.15,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle currencySmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle currencyXSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Form field styles
  static const TextStyle formLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle formHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle formError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Status and label styles
  static const TextStyle statusLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.2,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Data display styles
  static const TextStyle dataValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle dataLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  // Convenience getters for commonly used text styles
  static TextStyle? get displayLarge => const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.08,
      );

  static TextStyle? get displayMedium => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.12,
      );

  static TextStyle? get displaySmall => const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.12,
      );

  static TextStyle? get headlineLarge => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle? get headlineMedium => const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle? get headlineSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle? get titleLarge => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle? get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle? get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle? get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle? get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle? get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle? get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle? get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle? get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // === Glassmorphism Premium Text Styles ===

  /// Glass title with shadow for glass surfaces
  static const TextStyle glassTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Color(0xDDF9FAFB), // 87% white
    shadows: [
      Shadow(
        color: Color(0x33000000), // 20% black shadow
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
    ],
  );

  /// Glass subtitle with shadow
  static const TextStyle glassSubtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Color(0x99F9FAFB), // 60% white
    shadows: [
      Shadow(
        color: Color(0x20000000), // 12% black shadow
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// Glass body text for glass surfaces
  static const TextStyle glassBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xDDF9FAFB), // 87% white
  );

  /// Glass caption text
  static const TextStyle glassCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: Color(0x80F9FAFB), // 50% white
  );

  /// Glass label text (uppercase with spacing)
  static const TextStyle glassLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 1.2,
    color: Color(0x99F9FAFB), // 60% white
  );

  /// Auth title style - premium glass effect
  static const TextStyle authTitleGlass = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Color(0x40000000), // 25% black shadow
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
      Shadow(
        color: Color(0x203B82F6), // 12% blue glow
        offset: Offset(0, 0),
        blurRadius: 16,
      ),
    ],
  );

  /// Auth subtitle style
  static const TextStyle authSubtitleGlass = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xB3F9FAFB), // 70% white
    shadows: [
      Shadow(
        color: Color(0x30000000), // 18% black shadow
        offset: Offset(0, 1),
        blurRadius: 4,
      ),
    ],
  );

  /// Button text with glass effect
  static const TextStyle glassButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Color(0x40000000), // 25% black shadow
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
  );

  /// Success text with green glow
  static const TextStyle glassSuccess = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Color(0xFF34D399),
    shadows: [
      Shadow(
        color: Color(0x40059669), // 25% green glow
        offset: Offset(0, 0),
        blurRadius: 4,
      ),
    ],
  );

  /// Error text with red glow
  static const TextStyle glassError = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: Color(0xFFF87171),
    shadows: [
      Shadow(
        color: Color(0x40DC2626), // 25% red glow
        offset: Offset(0, 0),
        blurRadius: 4,
      ),
    ],
  );

  /// OTP digit style - large, bold
  static const TextStyle glassOtpDigit = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: Colors.white,
    letterSpacing: 4,
    shadows: [
      Shadow(
        color: Color(0x40000000), // 25% black
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );
}
