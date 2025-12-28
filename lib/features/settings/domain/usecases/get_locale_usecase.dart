import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/repositories/settings_repository.dart';

final class GetLocaleUseCase {
  const GetLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AppLocale?> call() => _repository.getLocale();
}
