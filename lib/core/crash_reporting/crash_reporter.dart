import 'dart:async';

import 'package:estate_app/core/logger/app_logger.dart';
import 'package:flutter/foundation.dart';

abstract interface class CrashReporter {
  Future<void> init();

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  });

  Future<void> recordFlutterError(FlutterErrorDetails details);
}

final class NoopCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {}

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {}
}

/// Stub implementation intended to be swapped with Sentry/Crashlytics.
final class ConsoleCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {
    AppLogger.i('Crash reporting enabled (console stub)');
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    AppLogger.e(
      'CrashReporter captured error (fatal=$fatal, reason=${reason ?? '-'})',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    final exception = details.exception;
    final stackTrace = details.stack ?? StackTrace.current;
    await recordError(
      exception,
      stackTrace,
      reason: details.context?.toDescription(),
    );
  }
}

final class CrashReporterGuard {
  CrashReporterGuard(this._reporter);

  final CrashReporter _reporter;

  void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(_reporter.recordFlutterError(details));
    };
  }
}
