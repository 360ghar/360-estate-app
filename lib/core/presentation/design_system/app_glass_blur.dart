import 'dart:ui';

/// Glassmorphism blur value constants.
/// Provides consistent blur levels for glass effects across the app.
abstract final class AppGlassBlur {
  // === Blur Sigma Values ===

  /// Light blur - 4 sigma
  /// Use for: Subtle glass overlays, minimal frosted effect
  static const double light = 4.0;

  /// Medium blur - 8 sigma
  /// Use for: Standard glass containers, cards
  static const double medium = 8.0;

  /// Heavy blur - 16 sigma
  /// Use for: Elevated glass, modal overlays
  static const double heavy = 16.0;

  /// Extra blur - 24 sigma
  /// Use for: Bottom sheets, prominent glass surfaces
  static const double extra = 24.0;

  /// Ultra blur - 32 sigma
  /// Use for: Maximum frosted effect, dramatic glass
  static const double ultra = 32.0;

  // === ImageFilter Factory Methods ===

  /// Creates an ImageFilter with light blur (4 sigma)
  static ImageFilter lightFilter() => ImageFilter.blur(sigmaX: light, sigmaY: light);

  /// Creates an ImageFilter with medium blur (8 sigma)
  static ImageFilter mediumFilter() => ImageFilter.blur(sigmaX: medium, sigmaY: medium);

  /// Creates an ImageFilter with heavy blur (16 sigma)
  static ImageFilter heavyFilter() => ImageFilter.blur(sigmaX: heavy, sigmaY: heavy);

  /// Creates an ImageFilter with extra blur (24 sigma)
  static ImageFilter extraFilter() => ImageFilter.blur(sigmaX: extra, sigmaY: extra);

  /// Creates an ImageFilter with ultra blur (32 sigma)
  static ImageFilter ultraFilter() => ImageFilter.blur(sigmaX: ultra, sigmaY: ultra);

  /// Creates an ImageFilter with custom blur sigma
  static ImageFilter customFilter(double sigma) =>
      ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

  // === Context-Specific Blur Recommendations ===

  /// Recommended blur for glass cards
  static const double card = medium;

  /// Recommended blur for modal backdrops
  static const double modalBackdrop = heavy;

  /// Recommended blur for bottom sheets
  static const double bottomSheet = extra;

  /// Recommended blur for toast notifications
  static const double toast = medium;

  /// Recommended blur for navigation bars
  static const double navigationBar = heavy;

  /// Recommended blur for app bars
  static const double appBar = heavy;

  /// Recommended blur for glass buttons (subtle)
  static const double button = light;

  /// Recommended blur for glass text fields
  static const double textField = medium;

  /// Recommended blur for glass containers
  static const double container = medium;

  /// Recommended blur for glass dialogs
  static const double dialog = heavy;

  // === Blur ImageFilter for Contexts ===

  /// ImageFilter for glass cards
  static ImageFilter cardFilter() => mediumFilter();

  /// ImageFilter for modal backdrops
  static ImageFilter modalBackdropFilter() => heavyFilter();

  /// ImageFilter for bottom sheets
  static ImageFilter bottomSheetFilter() => extraFilter();

  /// ImageFilter for toast notifications
  static ImageFilter toastFilter() => mediumFilter();

  /// ImageFilter for navigation bars
  static ImageFilter navigationBarFilter() => heavyFilter();

  /// ImageFilter for app bars
  static ImageFilter appBarFilter() => heavyFilter();

  /// ImageFilter for glass buttons
  static ImageFilter buttonFilter() => lightFilter();

  /// ImageFilter for glass text fields
  static ImageFilter textFieldFilter() => mediumFilter();

  /// ImageFilter for glass containers
  static ImageFilter containerFilter() => mediumFilter();

  /// ImageFilter for glass dialogs
  static ImageFilter dialogFilter() => heavyFilter();

  // === Blur Level Enum ===

  /// Enumeration of blur levels for type-safe blur selection
  static ImageFilter filterForLevel(BlurLevel level) {
    switch (level) {
      case BlurLevel.light:
        return lightFilter();
      case BlurLevel.medium:
        return mediumFilter();
      case BlurLevel.heavy:
        return heavyFilter();
      case BlurLevel.extra:
        return extraFilter();
      case BlurLevel.ultra:
        return ultraFilter();
    }
  }

  /// Gets the sigma value for a given blur level
  static double sigmaForLevel(BlurLevel level) {
    switch (level) {
      case BlurLevel.light:
        return light;
      case BlurLevel.medium:
        return medium;
      case BlurLevel.heavy:
        return heavy;
      case BlurLevel.extra:
        return extra;
      case BlurLevel.ultra:
        return ultra;
    }
  }
}

/// Blur levels for glassmorphism effects
enum BlurLevel {
  /// Light blur (4 sigma) - subtle frosted effect
  light,

  /// Medium blur (8 sigma) - standard glass effect
  medium,

  /// Heavy blur (16 sigma) - strong frosted effect
  heavy,

  /// Extra blur (24 sigma) - very strong frosted effect
  extra,

  /// Ultra blur (32 sigma) - maximum frosted effect
  ultra,
}
