import 'package:estate_app/core/presentation/design_system/app_borders.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_blur.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData _buildTheme(ColorScheme scheme) {
    final textTheme = AppTextStyles.textTheme(scheme);
    final isDark = scheme.brightness == Brightness.dark;
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
        scrolledUnderElevation: isDark ? 0.5 : 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lg,
          side: BorderSide(color: scheme.outlineVariant, width: 0.5),
        ),
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
        fillColor: isDark
            ? scheme.surfaceContainerHighest
            : scheme.surfaceContainerHighest,
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
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withOpacity(0.12),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return (textTheme.labelSmall ?? const TextStyle()).copyWith(
            color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 24);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
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
        backgroundColor: isDark
            ? scheme.surfaceContainerHighest
            : scheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? scheme.onSurface : scheme.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: textTheme.labelMedium,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sm),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelLarge,
        indicator: BoxDecoration(
          border: Border(bottom: BorderSide(color: scheme.primary, width: 2.5)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary.withOpacity(0.5);
          }
          return scheme.surfaceContainerHighest;
        }),
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

  static ThemeData get lightGlassTheme {
    final base = lightTheme;
    final scheme = AppColors.lightScheme();
    final textTheme = base.textTheme;

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
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
        backgroundColor: AppGlassColors.glassSurfaceDark(
          AppGlassColors.opacityStrong,
        ),
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

extension GlassThemeExtension on ThemeData {
  bool get isGlassTheme =>
      brightness == Brightness.dark ||
      scaffoldBackgroundColor == const Color(0xFF0F172A) ||
      scaffoldBackgroundColor == Colors.transparent;
}

class GlassAuthTheme {
  static const LinearGradient authGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E1B4B),
      Color(0xFF312E81),
      Color(0xFF1E3A5F),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static double get cardBlur => AppGlassBlur.extra;
  static double get cardOpacity => AppGlassColors.opacityMedium;
  static double get cardBorderRadius => 20;
  static const Color accent = Color(0xFF3B82F6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF2563EB), Color(0xFF3B82F6)],
  );
}
