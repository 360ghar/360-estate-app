import 'package:estate_app/core/errors/api_error.dart';

sealed class Failure implements Exception {
  const Failure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType(message: $message, cause: $cause)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause, this.isOffline = false});

  final bool isOffline;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.cause});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    super.cause,
    this.fields = const <String, String>{},
  });

  final Map<String, String> fields;
}

final class ApiFailure extends Failure {
  ApiFailure({required this.error, super.cause}) : super(error.message);

  final ApiError error;
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.cause});
}
