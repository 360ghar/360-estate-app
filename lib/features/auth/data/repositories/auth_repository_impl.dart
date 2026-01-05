import 'package:estate_app/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final SupabaseAuthDataSource _remote;

  @override
  Future<AuthUser?> getCurrentUser() => _remote.getCurrentUser();

  @override
  Stream<AuthUser?> observeAuthState() => _remote.observeAuthState();

  @override
  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  }) =>
      _remote.signInWithPhonePassword(phone: phone, password: password);

  @override
  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  }) =>
      _remote.signUpWithPhonePassword(phone: phone, password: password);

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<bool?> isPhoneRegistered(String phone) =>
      _remote.isPhoneRegistered(phone);

  @override
  Future<bool> handleAuthRedirect(Uri uri) => _remote.handleAuthRedirect(uri);
}
