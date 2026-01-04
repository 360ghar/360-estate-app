import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';

/// Mock implementation of SupabaseAuthDataSource for local testing.
/// Simulates authentication without requiring a real Supabase backend.
final class MockAuthDataSource implements SupabaseAuthDataSource {
  // Store a mock user session
  AuthUser? _currentUser;

  // Pre-registered mock phones for testing
  static const List<String> _registeredPhones = [
    '+919876543210',
    '+919876543211',
  ];

  @override
  Future<AuthUser?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Stream<AuthUser?> observeAuthState() async* {
    await Future.delayed(const Duration(milliseconds: 50));
    yield _currentUser;
  }

  @override
  Future<AuthUser> signInWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple validation for mock auth
    if (phone.isEmpty || password.isEmpty) {
      throw const ValidationFailure('Phone and password are required');
    }

    if (password.length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters');
    }

    // Normalize phone number
    final normalizedPhone = _normalizePhone(phone);

    // For mock auth, accept any password for registered phones
    // For unregistered phones, still allow login (simulating sign-up during login)
    _currentUser = AuthUser(
      id: 'mock_user_${normalizedPhone.replaceAll('+', '_')}',
      phone: normalizedPhone,
      email: null,
      role: _registeredPhones.contains(normalizedPhone)
          ? UserRole.admin
          : UserRole.user,
    );

    return _currentUser!;
  }

  @override
  Future<AuthUser> signUpWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (phone.isEmpty || password.isEmpty) {
      throw const ValidationFailure('Phone and password are required');
    }

    if (password.length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters');
    }

    final normalizedPhone = _normalizePhone(phone);

    _currentUser = AuthUser(
      id: 'mock_user_${normalizedPhone.replaceAll('+', '_')}',
      phone: normalizedPhone,
      email: null,
      role: UserRole.user, // Default role for new sign-ups
    );

    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  @override
  Future<bool?> isPhoneRegistered(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedPhone = _normalizePhone(phone);
    return _registeredPhones.contains(normalizedPhone);
  }

  @override
  Future<bool> handleAuthRedirect(Uri uri) async {
    // Mock doesn't support deep link redirects
    await Future.delayed(const Duration(milliseconds: 100));
    return false;
  }

  /// Normalize phone number to E.164 format
  String _normalizePhone(String phone) {
    var normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!normalized.startsWith('+')) {
      // Assume Indian number if no country code
      if (normalized.length == 10) {
        normalized = '+91$normalized';
      } else if (normalized.length == 12 && normalized.startsWith('91')) {
        normalized = '+$normalized';
      } else if (!normalized.startsWith('+') && normalized.length > 10) {
        normalized = '+$normalized';
      }
    }
    return normalized;
  }
}
