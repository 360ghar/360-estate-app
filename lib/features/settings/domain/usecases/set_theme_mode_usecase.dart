import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';

final class SetThemeModeUseCase {
  const SetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppThemeMode mode) => _repository.setThemeMode(mode);
}
