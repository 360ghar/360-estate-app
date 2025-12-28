import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}
