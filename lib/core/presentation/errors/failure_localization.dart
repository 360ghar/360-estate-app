import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

extension FailureLocalization on Failure {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure(:final isOffline) =>
        isOffline ? l10n.errorOfflineHint : l10n.errorSomethingWentWrong,
      // Backend strings never reach the UI untranslated: only the
      // field-level validation message is shown, truncated to 200 chars.
      ValidationFailure(:final message) =>
        message.length > 200 ? message.substring(0, 200) : message,
      _ => l10n.errorSomethingWentWrong,
    };
  }
}
