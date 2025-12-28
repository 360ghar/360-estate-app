import 'package:estate_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<AppLocale?> getLocale() => _local.getLocale();

  @override
  Future<AppThemeMode> getThemeMode() => _local.getThemeMode();

  @override
  Future<void> setLocale(AppLocale? locale) => _local.setLocale(locale);

  @override
  Future<void> setThemeMode(AppThemeMode mode) => _local.setThemeMode(mode);
}
