import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';

final class SetLocaleUseCase {
  const SetLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppLocale? locale) => _repository.setLocale(locale);
}
