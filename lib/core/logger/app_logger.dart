import 'dart:developer' as developer;

import 'package:estate_app/core/config/app_config.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { trace, debug, info, warn, error }

final class AppLogger {
  AppLogger._(this._minLevel);

  static AppLogger? _instance;

  /// Lazily-created default so log calls before [init] (e.g. in widget tests)
  /// never throw a LateInitializationError.
  static AppLogger get instance => _instance ??= AppLogger._(LogLevel.info);

  final LogLevel _minLevel;

  static void init(AppConfig config) {
    final minLevel = (kReleaseMode || !config.enableDebugLogs)
        ? LogLevel.info
        : LogLevel.trace;
    _instance = AppLogger._(minLevel);
  }

  static void t(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => _logAt(LogLevel.trace, message, error: error, stackTrace: stackTrace, requestId: requestId);
  static void d(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => _logAt(LogLevel.debug, message, error: error, stackTrace: stackTrace, requestId: requestId);
  static void i(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => _logAt(LogLevel.info, message, error: error, stackTrace: stackTrace, requestId: requestId);
  static void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => _logAt(LogLevel.warn, message, error: error, stackTrace: stackTrace, requestId: requestId);
  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => _logAt(LogLevel.error, message, error: error, stackTrace: stackTrace, requestId: requestId);

  static void _logAt(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? requestId,
  }) => instance._log(
    level,
    _withRequestId(message, requestId),
    error,
    stackTrace,
  );

  static String _withRequestId(String message, String? requestId) {
    if (requestId == null || requestId.isEmpty) return message;
    return 'rid=$requestId $message';
  }

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
