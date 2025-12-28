import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class CheckPhoneRegisteredUseCase {
  const CheckPhoneRegisteredUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool?> call(String phone) => _repository.isPhoneRegistered(phone);
}
