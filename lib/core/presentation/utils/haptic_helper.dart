import 'package:flutter/services.dart';

/// Helper class for consistent haptic feedback throughout the app.
///
/// Uses Flutter's built-in HapticFeedback for cross-platform support.
abstract final class HapticHelper {
  /// Light haptic feedback for subtle interactions.
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Medium haptic feedback for standard interactions.
  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Heavy haptic feedback for important actions.
  static Future<void> heavy() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Selection feedback for pickers and toggles.
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Success notification feedback.
  static Future<void> success() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Warning notification feedback.
  static Future<void> warning() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }

  /// Error notification feedback.
  static Future<void> error() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // Haptics not supported on this device
    }
  }
}

