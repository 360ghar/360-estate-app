import 'package:flutter/material.dart';

/// The 360 Estate palette: one teal family, ink, amber for "due" and red for
/// "overdue". Values and contrast checks live in
/// `design-system/360-estate/MASTER.md`.
///
/// Widgets read colours from the theme (`context.colors`, `context.palette`),
/// so light and dark both work. The raw constants below feed the schemes.
abstract final class AppColors {
  // Light.
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryContainer = Color(0xFFCDE8E2);
  static const Color onPrimaryContainer = Color(0xFF073B37);
  static const Color secondary = Color(0xFF3D5A56);
  static const Color secondaryContainer = Color(0xFFD9E6E3);
  static const Color onSecondaryContainer = Color(0xFF16302C);
  static const Color pageLight = Color(0xFFF4F8F7);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF10201E);
  static const Color inkVariant = Color(0xFF45524F);
  static const Color outlineLight = Color(0xFF6F7E7B);
  static const Color outlineVariantLight = Color(0xFFC6D2CF);
  static const Color error = Color(0xFFB3261E);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF5C0F0B);
  static const Color warning = Color(0xFF8A5700);
  static const Color warningContainer = Color(0xFFFBE7C2);
  static const Color onWarningContainer = Color(0xFF3D2700);

  // Dark: a green-black, never a blue one.
  static const Color primaryDarkMode = Color(0xFF79D0C3);
  static const Color onPrimaryDarkMode = Color(0xFF00382F);
  static const Color primaryContainerDark = Color(0xFF0C4E48);
  static const Color onPrimaryContainerDark = Color(0xFFC2EDE6);
  static const Color secondaryDarkMode = Color(0xFFAFCAC5);
  static const Color secondaryContainerDark = Color(0xFF304C48);
  static const Color onSecondaryContainerDark = Color(0xFFCDE7E2);
  static const Color pageDark = Color(0xFF0E1413);
  static const Color cardDark = Color(0xFF151D1C);
  static const Color inkDark = Color(0xFFE2EBE9);
  static const Color inkVariantDark = Color(0xFFA8B7B4);
  static const Color outlineDark = Color(0xFF869491);
  static const Color outlineVariantDark = Color(0xFF3A4745);
  static const Color errorDarkMode = Color(0xFFF2B8B5);
  static const Color errorContainerDark = Color(0xFF7A1A15);
  static const Color warningDarkMode = Color(0xFFEFC27A);
  static const Color warningContainerDark = Color(0xFF4F3600);

  static ColorScheme lightScheme() => const ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: warning,
    onTertiary: Colors.white,
    tertiaryContainer: warningContainer,
    onTertiaryContainer: onWarningContainer,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: pageLight,
    onSurface: ink,
    onSurfaceVariant: inkVariant,
    surfaceDim: Color(0xFFD4DEDB),
    surfaceBright: pageLight,
    surfaceContainerLowest: cardLight,
    surfaceContainerLow: Color(0xFFEDF3F1),
    surfaceContainer: Color(0xFFE7EEEC),
    surfaceContainerHigh: Color(0xFFE1E9E7),
    surfaceContainerHighest: Color(0xFFDAE3E1),
    outline: outlineLight,
    outlineVariant: outlineVariantLight,
    inverseSurface: Color(0xFF253331),
    onInverseSurface: Color(0xFFE9F1EF),
    inversePrimary: primaryDarkMode,
    shadow: Color(0xFF0B1A18),
    scrim: Color(0xFF0B1A18),
    surfaceTint: Colors.transparent,
  );

  static ColorScheme darkScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDarkMode,
    onPrimary: onPrimaryDarkMode,
    primaryContainer: primaryContainerDark,
    onPrimaryContainer: onPrimaryContainerDark,
    secondary: secondaryDarkMode,
    onSecondary: Color(0xFF1C3532),
    secondaryContainer: secondaryContainerDark,
    onSecondaryContainer: onSecondaryContainerDark,
    tertiary: warningDarkMode,
    onTertiary: Color(0xFF3D2700),
    tertiaryContainer: warningContainerDark,
    onTertiaryContainer: warningContainer,
    error: errorDarkMode,
    onError: Color(0xFF601410),
    errorContainer: errorContainerDark,
    onErrorContainer: errorContainer,
    surface: pageDark,
    onSurface: inkDark,
    onSurfaceVariant: inkVariantDark,
    surfaceDim: pageDark,
    surfaceBright: Color(0xFF2C3836),
    surfaceContainerLowest: Color(0xFF0A0F0E),
    surfaceContainerLow: Color(0xFF121A19),
    surfaceContainer: Color(0xFF172120),
    surfaceContainerHigh: Color(0xFF1F2A28),
    surfaceContainerHighest: Color(0xFF263230),
    outline: outlineDark,
    outlineVariant: outlineVariantDark,
    inverseSurface: inkDark,
    onInverseSurface: Color(0xFF1B2624),
    inversePrimary: primary,
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: Colors.transparent,
  );
}

/// The colours Material 3 has no role for: the card surface (white on the
/// tinted page in light, lifted off the green-black page in dark) and the
/// success and warning states. Danger uses `colorScheme.error`; info uses
/// `colorScheme.secondary`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.card,
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  static const light = AppPalette(
    card: AppColors.cardLight,
    success: AppColors.primary,
    successContainer: AppColors.primaryContainer,
    onSuccessContainer: AppColors.onPrimaryContainer,
    warning: AppColors.warning,
    warningContainer: AppColors.warningContainer,
    onWarningContainer: AppColors.onWarningContainer,
  );

  static const dark = AppPalette(
    card: AppColors.cardDark,
    success: AppColors.primaryDarkMode,
    successContainer: AppColors.primaryContainerDark,
    onSuccessContainer: AppColors.onPrimaryContainerDark,
    warning: AppColors.warningDarkMode,
    warningContainer: AppColors.warningContainerDark,
    onWarningContainer: AppColors.warningContainer,
  );

  final Color card;
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;

  @override
  AppPalette copyWith({Color? card}) => AppPalette(
    card: card ?? this.card,
    success: success,
    successContainer: successContainer,
    onSuccessContainer: onSuccessContainer,
    warning: warning,
    warningContainer: warningContainer,
    onWarningContainer: onWarningContainer,
  );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      card: mix(card, other.card),
      success: mix(success, other.success),
      successContainer: mix(successContainer, other.successContainer),
      onSuccessContainer: mix(onSuccessContainer, other.onSuccessContainer),
      warning: mix(warning, other.warning),
      warningContainer: mix(warningContainer, other.warningContainer),
      onWarningContainer: mix(onWarningContainer, other.onWarningContainer),
    );
  }
}
