import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class SignInWithPhonePasswordUseCase {
  const SignInWithPhonePasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({required String phone, required String password}) =>
      _repository.signInWithPhonePassword(phone: phone, password: password);
}
