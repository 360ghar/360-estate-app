import 'package:estate_app/core/errors/failure.dart';

/// Maps an arbitrary error to a user-safe message for snackbars/error views.
///
/// Raw `error.toString()` output (DioException internals, stack traces, URLs)
/// must never be rendered to users — the failure hierarchy already carries
/// product copy, and anything else is a bug we should not expose.
String userFacingMessage(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is Failure) return error.message;
  return fallback;
}
