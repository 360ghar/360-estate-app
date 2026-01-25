import 'package:estate_app/core/presentation/design_system/app_borders.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_blur.dart';
import 'package:flutter/material.dart';

/// Professional B2B theme with navy/indigo primary color.
/// Optimized for enterprise property management application.
abstract final class AppTheme {
  static ThemeData _buildTheme(ColorScheme scheme) {
    final textTheme = AppTextStyles.textTheme(scheme);
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        margin: const EdgeInsets.all(0),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: AppBorders.input(scheme.outline),
        enabledBorder: AppBorders.input(scheme.outline),
        focusedBorder: AppBorders.input(scheme.primary),
        errorBorder: AppBorders.input(scheme.error),
        focusedErrorBorder: AppBorders.input(scheme.error),
        filled: true,
        fillColor: scheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withOpacity(0.7),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.pill),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.pill),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withOpacity(0.12),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.all(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.pill),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadii.xlValue),
            topRight: Radius.circular(AppRadii.xlValue),
          ),
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceVariant,
        labelStyle: textTheme.labelMedium,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sm),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get lightTheme => _buildTheme(AppColors.lightScheme());

  static ThemeData get darkTheme => _buildTheme(AppColors.darkScheme());

  // === Glassmorphism Theme Variants ===

  /// Light glassmorphism theme with premium glass effects
  static ThemeData get lightGlassTheme {
    final base = lightTheme;
    final scheme = AppColors.lightScheme();

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(AppGlassColors.opacityMedium),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(AppGlassColors.opacityStrong),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Dark glassmorphism theme with premium glass effects
  static ThemeData get darkGlassTheme {
    final base = darkTheme;

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        color: AppGlassColors.glassSurfaceDark(AppGlassColors.opacityMedium),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppGlassColors.glassSurfaceDark(AppGlassColors.opacityStrong),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Auth theme with dark glassmorphism background
  static ThemeData get authTheme {
    final base = darkTheme;

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: base.colorScheme.copyWith(
        background: Colors.transparent,
        surface: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppGlassColors.glassSurfaceDark(AppGlassColors.opacityMedium),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
        margin: const EdgeInsets.all(0),
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: AppTextStyles.authTitleGlass,
        bodyLarge: AppTextStyles.glassBody,
        bodyMedium: AppTextStyles.glassBody,
        labelLarge: AppTextStyles.glassLabel,
      ),
    );
  }
}

/// Extension for accessing glassmorphism theme data
extension GlassThemeExtension on ThemeData {
  /// Whether this is a glassmorphism theme
  bool get isGlassTheme =>
      brightness == Brightness.dark ||
      scaffoldBackgroundColor == const Color(0xFF0F172A) ||
      scaffoldBackgroundColor == Colors.transparent;
}

/// Glass theme configuration for auth screens
class GlassAuthTheme {
  /// Background gradient for auth screens
  static const LinearGradient authGradient = LinearGradient(
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

  /// Glass container blur for auth cards
  static double get cardBlur => AppGlassBlur.extra;

  /// Glass container opacity for auth cards
  static double get cardOpacity => AppGlassColors.opacityMedium;

  /// Border radius for auth cards
  static double get cardBorderRadius => 20;

  /// Accent color for auth elements
  static const Color accent = Color(0xFF3B82F6);

  /// Primary gradient for auth buttons
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A5F), // Navy
      Color(0xFF2563EB), // Blue
      Color(0xFF3B82F6), // Lighter blue
    ],
  );
}
