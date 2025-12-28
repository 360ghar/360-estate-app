import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

abstract interface class SupabaseAuthDataSource {
  Future<AuthUser?> getCurrentUser();
  Stream<AuthUser?> observeAuthState();

  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<void> signOut();

  Future<bool?> isPhoneRegistered(String phone);

  Future<bool> handleAuthRedirect(Uri uri);
}

final class SupabaseAuthDataSourceImpl implements SupabaseAuthDataSource {
  SupabaseClient? _clientOrNull() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  AuthUser _mapUser(User user) =>
      AuthUser(id: user.id, phone: user.phone, email: user.email);

  Failure _mapAuthException(AuthException exception) {
    final message = exception.message.trim().isEmpty
        ? 'Authentication failed'
        : exception.message.trim();
    return ValidationFailure(message, cause: exception);
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final client = _clientOrNull();
    final user = client?.auth.currentUser;
    return user == null ? null : _mapUser(user);
  }

  @override
  Stream<AuthUser?> observeAuthState() async* {
    final client = _clientOrNull();
    if (client == null) {
      yield null;
      return;
    }

    yield client.auth.currentUser == null
        ? null
        : _mapUser(client.auth.currentUser!);

    await for (final state in client.auth.onAuthStateChange) {
      final user = state.session?.user ?? client.auth.currentUser;
      yield user == null ? null : _mapUser(user);
    }
  }

  @override
  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    final client = _clientOrNull();
    if (client == null) {
      throw const UnknownFailure('Supabase is not initialized');
    }

    try {
      final response = await client.auth.signInWithPassword(
        phone: phone,
        password: password,
      );
      final user =
          response.user ?? response.session?.user ?? client.auth.currentUser;
      if (user == null) {
        throw const UnknownFailure('Login succeeded but user is missing');
      }
      return _mapUser(user);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw UnknownFailure('Authentication failed', cause: e);
    }
  }

  @override
  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    final client = _clientOrNull();
    if (client == null) {
      throw const UnknownFailure('Supabase is not initialized');
    }

    try {
      final response = await client.auth.signUp(
        phone: phone,
        password: password,
      );
      final user =
          response.user ?? response.session?.user ?? client.auth.currentUser;
      if (user == null) {
        throw const UnknownFailure('Sign up succeeded but user is missing');
      }
      return _mapUser(user);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw UnknownFailure('Sign up failed', cause: e);
    }
  }

  @override
  Future<void> signOut() async {
    final client = _clientOrNull();
    if (client == null) return;
    await client.auth.signOut();
  }

  @override
  Future<bool?> isPhoneRegistered(String phone) async {
    final client = _clientOrNull();
    if (client == null) return null;

    try {
      final rows = await client
          .from('profiles')
          .select('id')
          .eq('phone', phone)
          .limit(1);
      return (rows as List).isNotEmpty;
    } on PostgrestException {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> handleAuthRedirect(Uri uri) async {
    final client = _clientOrNull();
    if (client == null) return false;
    try {
      await client.auth.getSessionFromUrl(uri);
      return true;
    } catch (_) {
      return false;
    }
  }
}
