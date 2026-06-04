import 'package:estate_app/core/presentation/design_system/app_glass_colors.dart';
import 'package:flutter/material.dart';

/// Glassmorphism border utilities.
/// Provides subtle borders with alpha, gradient borders, and focus states.
abstract final class AppGlassBorders {
  // === Basic Border Values ===

  /// Extra thin border - 0.5px (subtle glass effect)
  static const double thicknessXThin = 0.5;

  /// Thin border - 1px (standard glass effect)
  static const double thicknessThin = 1.0;

  /// Medium border - 1.5px (more defined edges)
  static const double thicknessMedium = 1.5;

  /// Thick border - 2px (focus states)
  static const double thicknessThick = 2.0;

  // === Light Mode Borders ===

  /// Subtle glass border for light mode
  static const BorderSide light = BorderSide(
    color: AppGlassColors.borderLight,
  );

  /// Medium glass border for light mode
  static const BorderSide lightMedium = BorderSide(
    color: Color(0x4DFFFFFF), // 30% white
  );

  /// Defined glass border for light mode
  static const BorderSide lightDefined = BorderSide(
    color: Color(0x66FFFFFF), // 40% white
  );

  // === Dark Mode Borders ===

  /// Subtle glass border for dark mode
  static const BorderSide dark = BorderSide(
    color: AppGlassColors.borderDark,
  );

  /// Medium glass border for dark mode
  static const BorderSide darkMedium = BorderSide(
    color: Color(0x33FFFFFF), // 20% white
  );

  /// Defined glass border for dark mode
  static const BorderSide darkDefined = BorderSide(
    color: Color(0x4DFFFFFF), // 30% white
  );

  // === State Borders ===

  /// Focus border - blue glow
  static const BorderSide focus = BorderSide(
    color: AppGlassColors.borderFocus,
    width: thicknessMedium,
  );

  /// Error border - red glow
  static const BorderSide error = BorderSide(
    color: AppGlassColors.borderError,
    width: thicknessMedium,
  );

  /// Success border - green glow
  static const BorderSide success = BorderSide(
    color: AppGlassColors.borderSuccess,
    width: thicknessMedium,
  );

  /// Warning border - orange glow
  static const BorderSide warning = BorderSide(
    color: Color(0x80F59E0B), // 50% orange
    width: thicknessMedium,
  );

  /// Disabled border - subtle gray
  static const BorderSide disabled = BorderSide(
    color: Color(0x1AD1D5DB), // 10% gray
  );

  // === Border Radius for Glass Containers ===

  /// Extra small radius - 4px
  static const Radius radiusXs = Radius.circular(4);

  /// Small radius - 6px
  static const Radius radiusSm = Radius.circular(6);

  /// Medium radius - 8px
  static const Radius radiusMd = Radius.circular(8);

  /// Large radius - 12px
  static const Radius radiusLg = Radius.circular(12);

  /// Extra large radius - 16px
  static const Radius radiusXl = Radius.circular(16);

  /// 2X Large radius - 20px
  static const Radius radius2Xl = Radius.circular(20);

  /// 3X Large radius - 24px
  static const Radius radius3Xl = Radius.circular(24);

  /// Pill radius - varies with container height
  static const Radius radiusPill = Radius.circular(999);

  // === BorderSide Factory Methods ===

  /// Creates a glass border side with custom opacity
  static BorderSide glass({
    double opacity = 0.2,
    double width = thicknessThin,
  }) {
    return BorderSide(
      color: Colors.white.withValues(alpha: opacity),
      width: width,
    );
  }

  /// Creates a colored border side with alpha
  static BorderSide colored(
    Color color, {
    double opacity = 0.5,
    double width = thicknessThin,
  }) {
    return BorderSide(
      color: color.withValues(alpha: opacity),
      width: width,
    );
  }

  /// Creates a focus border with custom color
  static BorderSide focusBorder(Color color) {
    return BorderSide(
      color: color.withValues(alpha: 0.5),
      width: thicknessMedium,
    );
  }

  // === OutlinedBorder Factory Methods ===

  /// Creates a glass rounded rectangle border
  static RoundedRectangleBorder roundedRectBorder({
    double radius = 12,
    BorderSide side = light,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
    );
  }

  /// Creates a glass stadium border (pill shape)
  static StadiumBorder stadiumBorder({
    BorderSide side = light,
  }) {
    return StadiumBorder(side: side);
  }

  /// Creates a glass circle border
  static CircleBorder circleBorder({
    BorderSide side = light,
  }) {
    return CircleBorder(side: side);
  }

  /// Creates a beveled rectangle border for glass cards
  static RoundedRectangleBorder beveledBorder({
    double radius = 12,
    BorderSide side = light,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
    );
  }

  // === Gradient Borders ===

  /// Creates a container with gradient border
  /// Note: Requires using a Container with gradient decoration and padding
  static BoxDecoration gradientBorder({
    required Gradient gradient,
    double radius = 12,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
        ),
      ],
    );
  }

  /// Focus gradient border decoration
  static BoxDecoration focusGradientBorder({
    double radius = 12,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0x993B82F6),
          Color(0x663B82F6),
          Color(0x993B82F6),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Error gradient border decoration
  static BoxDecoration errorGradientBorder({
    double radius = 12,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0x99DC2626),
          Color(0x66DC2626),
          Color(0x99DC2626),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Success gradient border decoration
  static BoxDecoration successGradientBorder({
    double radius = 12,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0x99059669),
          Color(0x66059669),
          Color(0x99059669),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // === InputDecoration Borders ===

  /// Creates an OutlineInputBorder for glass input fields
  static OutlineInputBorder inputOutline({
    double radius = 12,
    BorderSide border = light,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: border,
    );
  }

  /// Focus state input border
  static const OutlineInputBorder inputFocus = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: focus,
  );

  /// Error state input border
  static const OutlineInputBorder inputError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: error,
  );

  /// Default state input border
  static const OutlineInputBorder inputDefault = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: light,
  );

  /// Disabled state input border
  static const OutlineInputBorder inputDisabled = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: disabled,
  );

  // === Border for Different Contexts ===

  /// Border for glass cards
  static RoundedRectangleBorder glassCard({bool isDark = false}) {
    return RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      side: isDark ? dark : light,
    );
  }

  /// Border for glass buttons
  static RoundedRectangleBorder glassButton({bool isDark = false}) {
    return RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      side: isDark ? darkMedium : lightMedium,
    );
  }

  /// Border for glass bottom sheets
  static RoundedRectangleBorder glassBottomSheet({bool isDark = false}) {
    return RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      side: isDark ? dark : light,
    );
  }

  /// Border for glass toasts
  static RoundedRectangleBorder glassToast({bool isDark = false}) {
    return RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      side: isDark ? darkMedium : lightMedium,
    );
  }
}
