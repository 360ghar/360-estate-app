import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';

extension FailureLocalization on Failure {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure(:final isOffline) =>
        isOffline ? l10n.errorOfflineHint : l10n.errorSomethingWentWrong,
      // Field errors first (the actionable part), then the top-level
      // message as fallback. Truncated to 200 chars.
      ValidationFailure(:final message, :final fields) => _validationText(
        message,
        fields,
      ),
      // The server's message is the actionable part for these.
      UnauthorizedFailure(:final message) ||
      NotFoundFailure(:final message) ||
      ApiFailure(
        :final message,
      ) => message.trim().isEmpty ? l10n.errorSomethingWentWrong : message,
      _ => l10n.errorSomethingWentWrong,
    };
  }
}

/// Joins non-empty field errors with the top-level message, capped at 200
/// chars so a field-heavy 422 never floods the snackbar.
String _validationText(String message, Map<String, String> fields) {
  final parts = [
    ...fields.values.where((v) => v.trim().isNotEmpty),
    if (message.trim().isNotEmpty) message,
  ];
  final text = parts.join('\n');
  if (text.length <= 200) return text;
  // Cut by code point so an emoji at the boundary is not split.
  return String.fromCharCodes(text.runes.take(200));
}
