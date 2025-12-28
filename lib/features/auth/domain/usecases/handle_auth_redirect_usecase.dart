import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class HandleAuthRedirectUseCase {
  const HandleAuthRedirectUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call(Uri uri) => _repository.handleAuthRedirect(uri);
}
