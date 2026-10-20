import 'dart:async';

import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The theme the user picked, kept across restarts. Set it with
/// `ref.read(appThemeProvider.notifier).state = mode`.
final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);

class AppThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      switch (ref.watch(appPreferencesProvider).getString(PrefKeys.themeMode)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  @override
  set state(ThemeMode mode) {
    super.state = mode;
    unawaited(
      ref.read(appPreferencesProvider).setString(PrefKeys.themeMode, mode.name),
    );
  }
}

/// The app language the user picked (null follows the phone), kept across
/// restarts.
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale?>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref
        .watch(appPreferencesProvider)
        .getString(PrefKeys.localeLanguageCode);
    return code == null ? null : Locale(code);
  }

  @override
  set state(Locale? locale) {
    super.state = locale;
    final prefs = ref.read(appPreferencesProvider);
    unawaited(
      locale == null
          ? prefs.remove(PrefKeys.localeLanguageCode)
          : prefs.setString(PrefKeys.localeLanguageCode, locale.languageCode),
    );
  }
}
