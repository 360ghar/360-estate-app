import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';

final class GetThemeModeUseCase {
  const GetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AppThemeMode> call() => _repository.getThemeMode();
}
