import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);

  Future<AppLocale?> getLocale();
  Future<void> setLocale(AppLocale? locale);
}
