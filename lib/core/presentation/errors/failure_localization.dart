import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

extension FailureLocalization on Failure {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure(:final isOffline) =>
        isOffline ? l10n.errorOfflineHint : l10n.errorSomethingWentWrong,
      ValidationFailure() => message,
      UnauthorizedFailure() => message,
      NotFoundFailure() => message,
      ApiFailure() => message,
      UnknownFailure() => l10n.errorSomethingWentWrong,
    };
  }
}
