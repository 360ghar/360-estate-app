import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/auth/user_role.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthStatus {
  checking,
  unauthenticated,
  otpSent,
  authenticated,
  needsRole,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.role,
    this.phone,
    this.errorMessage,
    this.isBusy = false,
  });

  final AuthStatus status;
  final UserProfile? user;
  final UserRole? role;
  final String? phone;
  final String? errorMessage;
  final bool isBusy;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoggedIn =>
      status == AuthStatus.authenticated || status == AuthStatus.needsRole;
  bool get needsRoleSelection => status == AuthStatus.needsRole;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    UserRole? role,
    String? phone,
    String? errorMessage,
    bool? isBusy,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      errorMessage: errorMessage,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  static const AuthState checking = AuthState(status: AuthStatus.checking);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(apiClientProvider),
    ref.read(authTokenStorageProvider),
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.read(authRepositoryProvider),
      ref.read(authTokenStorageProvider),
      ref.read(appPreferencesProvider),
      ref.read(appConfigProvider),
    );
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(
    this._repository,
    this._tokenStorage,
    this._preferences,
    this._config,
  )
      : super(AuthState.checking) {
    _subscription = _tokenStorage.onTokenChanged.listen(_handleTokenChange);
    if (_config.isSupabaseConfigured) {
      _supabaseSubscription = supabase.Supabase.instance.client.auth
          .onAuthStateChange
          .listen((event) async {
        final session = event.session;
        if (session?.accessToken != null && session!.accessToken.isNotEmpty) {
          await _tokenStorage.save(session.accessToken);
        } else {
          await _tokenStorage.clear();
        }
      });
    }
    unawaited(_initialize());
  }

  final AuthRepository _repository;
  final AuthTokenStorage _tokenStorage;
  final AppPreferences _preferences;
  final AppConfig _config;
  late final StreamSubscription<String?> _subscription;
  StreamSubscription<supabase.AuthState>? _supabaseSubscription;

  Future<void> _initialize() async {
    if (_config.isSupabaseConfigured) {
      try {
        final session = supabase.Supabase.instance.client.auth.currentSession;
        if (session != null) {
          await _tokenStorage.save(session.accessToken);
          final user = await _repository.fetchProfileOrFallback(session.user);
          await _setAuthenticated(user, phone: session.user.phone);
          return;
        }
      } catch (_) {
        await _tokenStorage.clear();
      }
    }

    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final user = await _repository.fetchProfile();
      await _setAuthenticated(user);
    } catch (_) {
      await _tokenStorage.clear();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> requestOtp(String phone) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      await _repository.requestOtp(phone);
      state = state.copyWith(status: AuthStatus.otpSent, isBusy: false);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  Future<bool?> checkPhoneRegistered(String phone) async {
    state = state.copyWith(isBusy: true);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final exists = await _repository.isPhoneRegistered(phone);
      state = state.copyWith(isBusy: false);
      return exists;
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: _messageForError(error),
      );
      return null;
    }
  }

  Future<void> signInWithPassword({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final user =
          await _repository.signInWithPassword(phone: phone, password: password);
      await _setAuthenticated(user, phone: phone);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  Future<bool> signUpWithPassword({
    required String phone,
    required String password,
    String? fullName,
    String? email,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      await _repository.signUpWithPassword(
        phone: phone,
        password: password,
        fullName: fullName,
        email: email,
      );
      final session = supabase.Supabase.instance.client.auth.currentSession;
      if (session != null) {
        try {
          await _repository.logout();
        } catch (_) {
          await _tokenStorage.clear();
        }
        await _repository.requestOtp(phone);
      }
      state = state.copyWith(status: AuthStatus.otpSent, isBusy: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      final user = await _repository.verifyOtp(phone: phone, otp: otp);
      await _setAuthenticated(user, phone: phone);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  Future<bool> verifyOtpForSignup({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      await _repository.verifyOtp(phone: phone, otp: otp);
      try {
        await _repository.logout();
      } catch (_) {
        await _tokenStorage.clear();
      }
      state = AuthState(status: AuthStatus.unauthenticated, phone: phone);
      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await _preferences.remove(PrefKeys.userRole);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> updateProfile(UserProfileUpdate update) async {
    state = state.copyWith(isBusy: true);
    try {
      final user = await _repository.updateProfile(update);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        role: state.role,
      );
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  Future<void> setRole(UserRole role) async {
    if (state.user == null) {
      state = state.copyWith(
        errorMessage: 'Unable to set role without a profile.',
      );
      return;
    }
    await _preferences.setString(PrefKeys.userRole, role.name);
    state = AuthState(
      status: AuthStatus.authenticated,
      user: state.user,
      role: role,
    );
  }

  void _handleTokenChange(String? token) {
    if (token == null || token.isEmpty) {
      if (state.status == AuthStatus.authenticated ||
          state.status == AuthStatus.otpSent ||
          state.status == AuthStatus.needsRole) {
        unawaited(_preferences.remove(PrefKeys.userRole));
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
      if (_config.isSupabaseConfigured &&
          supabase.Supabase.instance.client.auth.currentSession != null) {
        unawaited(supabase.Supabase.instance.client.auth.signOut());
      }
    }
  }

  Future<void> _setAuthenticated(UserProfile user, {String? phone}) async {
    final role = await _resolveRole(user) ?? UserRole.owner;
    await _preferences.setString(PrefKeys.userRole, role.name);
    state = AuthState(
      status: AuthStatus.authenticated,
      user: user,
      role: role,
      phone: phone ?? state.phone,
    );
  }

  Future<UserRole?> _resolveRole(UserProfile user) async {
    final roleFromProfile = parseUserRole(user.role);
    if (roleFromProfile != null) {
      return roleFromProfile;
    }

    final stored = _preferences.getString(PrefKeys.userRole);
    return parseStoredRole(stored);
  }

  String _messageForError(Object error) {
    if (error is Failure) return error.message;
    return 'Something went wrong. Please try again.';
  }

  /// Upload profile photo to Supabase Storage
  Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      return await _repository.uploadProfilePhoto(imageFile);
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
      );
      rethrow;
    }
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isBusy: false);
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _supabaseSubscription?.cancel();
    super.dispose();
  }
}
