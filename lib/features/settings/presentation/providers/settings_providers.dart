import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(appPreferencesProvider);
  return SettingsRepositoryImpl(prefs);
});

/// Theme mode provider
final appThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Locale provider
final appLocaleProvider = StateProvider<Locale?>((ref) => null);

/// Settings repository implementation (moved from data layer for simplicity)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this.prefs);

  final AppPreferences prefs;

  @override
  Future<AppThemeMode> getThemeMode() async {
    final modeStr = prefs.getString(PrefKeys.themeMode);
    return switch (modeStr) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    final modeStr = switch (mode) {
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
      AppThemeMode.system => 'system',
    };
    await prefs.setString(PrefKeys.themeMode, modeStr);
  }

  @override
  Future<AppLocale?> getLocale() async {
    final languageCode = prefs.getString(PrefKeys.localeLanguageCode);
    if (languageCode == null) return null;
    final countryCode = prefs.getString(PrefKeys.localeCountryCode);
    return AppLocale(languageCode: languageCode, countryCode: countryCode);
  }

  @override
  Future<void> setLocale(AppLocale? locale) async {
    if (locale == null) {
      await prefs.remove(PrefKeys.localeLanguageCode);
      await prefs.remove(PrefKeys.localeCountryCode);
    } else {
      await prefs.setString(PrefKeys.localeLanguageCode, locale.languageCode);
      if (locale.countryCode != null) {
        await prefs.setString(PrefKeys.localeCountryCode, locale.countryCode!);
      }
    }
  }
}
