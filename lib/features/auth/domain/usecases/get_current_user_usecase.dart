import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser?> call() => _repository.getCurrentUser();
}
