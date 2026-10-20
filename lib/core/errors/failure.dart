import 'package:estate_app/core/errors/api_error.dart';

sealed class Failure implements Exception {
  const Failure(this.message, {this.cause, this.code});

  final String message;
  final Object? cause;

  /// Backend error code (`error.code`) when the failure came from an error
  /// envelope. Null for transport failures and client-side checks.
  final String? code;

  @override
  String toString() => '$runtimeType(message: $message, cause: $cause)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause, this.isOffline = false});

  final bool isOffline;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.cause, super.code});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause, super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    super.cause,
    super.code,
    this.fields = const <String, String>{},
  });

  /// Field errors from `error.details.fields`, keyed by the field name
  /// without its source prefix (`body.`, `query.`, `path.`).
  final Map<String, String> fields;
}

final class ApiFailure extends Failure {
  ApiFailure({required this.error, super.cause})
    : super(error.message, code: error.code);

  final ApiError error;
}

/// An agent has not picked an owner yet. Raised before the request is sent:
/// the backend refuses an agent's PM list or create without `owner_id`.
final class OwnerRequiredFailure extends Failure {
  const OwnerRequiredFailure()
    : super('Choose an owner to manage first.', code: 'OWNER_REQUIRED');
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.cause});
}
