import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class ObserveAuthStateUseCase {
  const ObserveAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthUser?> call() => _repository.observeAuthState();
}
