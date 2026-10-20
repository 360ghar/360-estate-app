import 'package:estate_app/core/errors/failure.dart';

/// Maps an arbitrary error to a user-safe message for snackbars/error views.
///
/// Raw `error.toString()` output (DioException internals, stack traces, URLs)
/// must never be rendered to users: the failure hierarchy already carries
/// product copy, and anything else is a bug we should not expose.
///
/// A validation failure also lists the fields the backend refused
/// (`error.details.fields`), one per line, so the user sees what to fix.
String userFacingMessage(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is ValidationFailure && error.fields.isNotEmpty) {
    final lines = [
      for (final entry in error.fields.entries)
        '${entry.key.replaceAll('_', ' ')}: ${entry.value}',
    ];
    return '${error.message}\n${lines.join('\n')}';
  }
  // A 429 or 503 may say when to try again (`Retry-After`).
  if (error is ApiFailure && error.error.retryAfterSeconds != null) {
    final seconds = error.error.retryAfterSeconds!;
    return '${error.message}\nTry again in $seconds ${seconds == 1 ? 'second' : 'seconds'}.';
  }
  if (error is Failure) return error.message;
  return fallback;
}
