/// Standard animation durations for consistent UI motion.
///
/// Using these constants ensures consistent animation timing
/// throughout the application.
abstract final class AppDurations {
  /// Instant transition (no animation)
  static const Duration instant = Duration.zero;

  /// Fast micro-interaction (button press, toggle)
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard short animation (fade in, slide)
  static const Duration short = Duration(milliseconds: 200);

  /// Medium animation (dialog, bottom sheet)
  static const Duration medium = Duration(milliseconds: 300);

  /// Long animation (page transition, complex transforms)
  static const Duration long = Duration(milliseconds: 400);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 250);

  /// Snackbar/toast display duration
  static const Duration snackbar = Duration(seconds: 3);

  /// Long snackbar display duration
  static const Duration snackbarLong = Duration(seconds: 5);
}
