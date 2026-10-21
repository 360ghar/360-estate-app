import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Falls back by brightness under a nested `Theme` built without it.
  AppPalette get palette {
    final theme = Theme.of(this);
    return theme.extension<AppPalette>() ??
        (theme.brightness == Brightness.dark
            ? AppPalette.dark
            : AppPalette.light);
  }

  TextTheme get text => Theme.of(this).textTheme;
}
