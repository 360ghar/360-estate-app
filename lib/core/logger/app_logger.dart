import 'dart:developer' as developer;

import 'package:estate_app/core/config/app_config.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { trace, debug, info, warn, error }

final class AppLogger {
  AppLogger._(this._minLevel);

  static AppLogger? _instance;
  
  /// Returns the singleton instance, creating a default one if not yet initialized.
  /// This prevents LateInitializationError when logging is attempted before init().
  static AppLogger get instance {
    _instance ??= AppLogger._(kReleaseMode ? LogLevel.info : LogLevel.trace);
    return _instance!;
  }

  final LogLevel _minLevel;

  static void init(AppConfig config) {
    final minLevel = (kReleaseMode || !config.enableDebugLogs)
        ? LogLevel.info
        : LogLevel.trace;
    _instance = AppLogger._(minLevel);
  }

  static void t(String message, {Object? error, StackTrace? stackTrace}) =>
      instance._log(LogLevel.trace, message, error, stackTrace);
  static void d(String message, {Object? error, StackTrace? stackTrace}) =>
      instance._log(LogLevel.debug, message, error, stackTrace);
  static void i(String message, {Object? error, StackTrace? stackTrace}) =>
      instance._log(LogLevel.info, message, error, stackTrace);
  static void w(String message, {Object? error, StackTrace? stackTrace}) =>
      instance._log(LogLevel.warn, message, error, stackTrace);
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      instance._log(LogLevel.error, message, error, stackTrace);

  void _log(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (level.index < _minLevel.index) return;

    developer.log(
      message,
      name: '360Estate',
      level: _toDeveloperLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _toDeveloperLevel(LogLevel level) {
    return switch (level) {
      LogLevel.trace => 300,
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warn => 900,
      LogLevel.error => 1000,
    };
  }
}
