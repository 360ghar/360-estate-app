import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}
