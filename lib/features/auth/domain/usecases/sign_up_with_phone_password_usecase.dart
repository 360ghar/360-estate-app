import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class SignUpWithPhonePasswordUseCase {
  const SignUpWithPhonePasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({required String phone, required String password}) =>
      _repository.signUpWithPhonePassword(phone: phone, password: password);
}
