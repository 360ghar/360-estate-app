import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);

  Future<AppLocale?> getLocale();
  Future<void> setLocale(AppLocale? locale);
}

final class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._prefs);

  final AppPreferences _prefs;

  static AppThemeMode _parseThemeMode(String raw) {
    return switch (raw) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  static String _encodeThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => 'system',
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
    };
  }

  @override
  Future<AppThemeMode> getThemeMode() async {
    final raw = _prefs.getString(PrefKeys.themeMode);
    if (raw == null) return AppThemeMode.system;
    return _parseThemeMode(raw);
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(PrefKeys.themeMode, _encodeThemeMode(mode));
  }

  @override
  Future<AppLocale?> getLocale() async {
    final languageCode = _prefs.getString(PrefKeys.localeLanguageCode);
    if (languageCode == null || languageCode.isEmpty) return null;
    final countryCode = _prefs.getString(PrefKeys.localeCountryCode);
    return AppLocale(languageCode: languageCode, countryCode: countryCode);
  }

  @override
  Future<void> setLocale(AppLocale? locale) async {
    if (locale == null) {
      await _prefs.remove(PrefKeys.localeLanguageCode);
      await _prefs.remove(PrefKeys.localeCountryCode);
      return;
    }
    await _prefs.setString(PrefKeys.localeLanguageCode, locale.languageCode);
    final countryCode = locale.countryCode;
    if (countryCode == null || countryCode.isEmpty) {
      await _prefs.remove(PrefKeys.localeCountryCode);
    } else {
      await _prefs.setString(PrefKeys.localeCountryCode, countryCode);
    }
  }
}
