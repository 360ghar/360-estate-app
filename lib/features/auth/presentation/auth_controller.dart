import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/features/auth/data/apple_sign_in_service.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/data/google_sign_in_service.dart';
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthStatus {
  checking,
  unauthenticated,
  otpSent,
  needsPassword,
  needsPhone,
  needsProfileCompletion,
  needsOnboarding,
  authenticated,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.phone,
    this.errorMessage,
    this.isBusy = false,
  });

  final AuthStatus status;
  final UserProfile? user;
  final String? phone;
  final String? errorMessage;
  final bool isBusy;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoggedIn =>
      status == AuthStatus.authenticated ||
      status == AuthStatus.needsPhone ||
      status == AuthStatus.needsPassword ||
      status == AuthStatus.needsProfileCompletion ||
      status == AuthStatus.needsOnboarding;
  bool get needsPhone => status == AuthStatus.needsPhone;
  bool get needsPassword => status == AuthStatus.needsPassword;
  bool get needsProfileCompletion => status == AuthStatus.needsProfileCompletion;
  bool get needsOnboarding => status == AuthStatus.needsOnboarding;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? phone,
    String? errorMessage,
    bool? isBusy,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      phone: phone ?? this.phone,
      errorMessage: errorMessage,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  static const AuthState checking = AuthState(status: AuthStatus.checking);
}

/// Native Google Sign-In service. Null when Google Sign-In is not configured
/// (no `GOOGLE_WEB_CLIENT_ID`), so the UI can present the button as disabled.
final googleSignInServiceProvider = Provider<GoogleSignInService?>((ref) {
  final config = ref.read(appConfigProvider);
  if (!config.isGoogleSignInConfigured) return null;
  return GoogleSignInService(
    webClientId: config.googleWebClientId,
    iosClientId: config.googleIosClientId.isEmpty
        ? null
        : config.googleIosClientId,
  );
});

/// Native Apple Sign-In service. Only meaningful on iOS/macOS; the UI gates the
/// button by platform + [AppleSignInService.isAvailable].
final appleSignInServiceProvider = Provider<AppleSignInService?>((ref) {
  if (kIsWeb) return null;
  if (!(Platform.isIOS || Platform.isMacOS)) return null;
  return const AppleSignInService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(apiClientProvider),
    ref.read(authTokenStorageProvider),
    googleSignIn: ref.read(googleSignInServiceProvider),
    appleSignIn: ref.read(appleSignInServiceProvider),
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.read(authRepositoryProvider),
      ref.read(authTokenStorageProvider),
      ref.read(appPreferencesProvider),
      ref.read(appConfigProvider),
      ref.read(googleSignInServiceProvider),
    );
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(
    this._repository,
    this._tokenStorage,
    this._preferences,
    this._config,
    this._googleSignIn,
  ) : super(AuthState.checking) {
    _subscription = _tokenStorage.onTokenChanged.listen(_handleTokenChange);
    if (_config.isSupabaseConfigured) {
      _supabaseSubscription = supabase
          .Supabase
          .instance
          .client
          .auth
          .onAuthStateChange
          .listen((event) async {
            final session = event.session;
            if (session?.accessToken != null &&
                session!.accessToken.isNotEmpty) {
              await _tokenStorage.save(session.accessToken);
              // A session arriving while an OAuth redirect is pending is the
              // result of the Google redirect flow (auto-exchanged because
              // detectSessionInUri defaults to true). Drive routing here.
              if (_oauthRedirectPending &&
                  event.event == supabase.AuthChangeEvent.signedIn) {
                _oauthRedirectPending = false;
                await _onOAuthSessionEstablished(session);
              }
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
  final GoogleSignInService? _googleSignIn;
  final AppConfig _config;
  late final StreamSubscription<String?> _subscription;
  StreamSubscription<supabase.AuthState>? _supabaseSubscription;

  /// The password method to record once a mandatory set-password step (req 6)
  /// completes (e.g. `phonePassword` after a phone-OTP login with no password).
  AuthMethod? _pendingPasswordMethod;

  /// The passwordless social method (google/apple) that initiated the current
  /// skippable add-phone step, so completing/skipping records it correctly.
  AuthMethod _pendingSocialMethod = AuthMethod.google;

  /// True while a Google OAuth *redirect* is in flight (external browser open).
  /// The session arrives asynchronously via `onAuthStateChange`; this flag lets
  /// that listener distinguish the redirect result from other session events.
  bool _oauthRedirectPending = false;

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

  /// Sends an SMS OTP. [shouldCreateUser] must be `false` for login/reset and
  /// `true` only for signup (prevents silent account creation for an unknown
  /// number).
  Future<void> requestOtp(String phone, {bool shouldCreateUser = false}) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      await _repository.requestOtp(phone, shouldCreateUser: shouldCreateUser);
      state = state.copyWith(status: AuthStatus.otpSent, isBusy: false);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Resolves an identifier (email or phone) against the backend login state
  /// machine. Returns null when the backend can't be reached; callers should
  /// then fall back to a safe default (treat as a new account -> OTP signup).
  Future<IdentifierStatus?> checkIdentifierStatus(String identifier) async {
    state = state.copyWith(isBusy: true);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final status = await _repository.checkIdentifierStatus(identifier);
      state = state.copyWith(isBusy: false);
      return status;
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: _messageForError(error),
      );
      return null;
    }
  }

  /// Google sign-in. Uses the native ID-token flow when a web client id is
  /// configured; if native fails for a non-cancellation reason it falls back to
  /// the Supabase OAuth redirect flow. With the redirect flow the session
  /// arrives later via `onAuthStateChange` and routing is finished by
  /// [_onOAuthSessionEstablished]; the repository arms the listener (via
  /// [_armOAuthRedirect]) synchronously right before the browser launch.
  ///
  /// On success, routes either straight to authenticated or (when the account
  /// has no phone) into the skippable add-phone step.
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isBusy: true);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final user = await _repository.signInWithGoogle(
        onRedirectLaunched: _armOAuthRedirect,
      );
      if (user == null) {
        // Redirect flow (direct or native-failure fallback): external browser
        // launched. Release the busy state; the deep-link callback completes
        // the sign-in via the onAuthStateChange listener.
        state = state.copyWith(isBusy: false);
        return;
      }
      _oauthRedirectPending = false;
      await _completeSocialSignIn(user, AuthMethod.google);
    } on GoogleSignInCancelled {
      _oauthRedirectPending = false;
      state = state.copyWith(isBusy: false);
    } catch (error) {
      _oauthRedirectPending = false;
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Arms the OAuth deep-link listener. Called synchronously by the repository
  /// immediately before launching the external browser, so a fast callback
  /// can't be missed.
  void _armOAuthRedirect() => _oauthRedirectPending = true;

  /// Completes the Google OAuth *redirect* flow once Supabase has established a
  /// session from the deep-link callback. Fetches the profile and drives the
  /// same routing as the native flow (authenticated or add-phone), recording
  /// `last_auth_method=google`.
  Future<void> _onOAuthSessionEstablished(supabase.Session session) async {
    try {
      final user = await _repository.fetchProfileOrFallback(session.user);
      await _completeSocialSignIn(user, AuthMethod.google);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Native Apple sign-in (iOS). Passwordless, same routing as Google: enters
  /// the app directly, or routes through the skippable add-phone step when the
  /// account has no phone.
  Future<void> signInWithApple() async {
    state = state.copyWith(isBusy: true);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final user = await _repository.signInWithApple();
      await _completeSocialSignIn(user, AuthMethod.apple);
    } on AppleSignInCancelled {
      state = state.copyWith(isBusy: false);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Shared completion for the passwordless social providers (Google/Apple).
  Future<void> _completeSocialSignIn(
    UserProfile user,
    AuthMethod method,
  ) async {
    unawaited(_repository.recordLastMethod(method));
    await _persistLastMethod(method, identifier: user.email);

    final hasPhone = (user.phone ?? '').trim().isNotEmpty;
    if (!hasPhone) {
      // Skippable add-phone interstitial for passwordless social users.
      _pendingSocialMethod = method;
      state = AuthState(status: AuthStatus.needsPhone, user: user);
      return;
    }
    await _setAuthenticated(user, phone: user.phone, method: method);
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
      final user = await _repository.signInWithPassword(
        phone: phone,
        password: password,
      );
      await _setAuthenticated(
        user,
        phone: phone,
        method: AuthMethod.phonePassword,
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Sign in with an email + password (verified-account branch of the state
  /// machine).
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      if (!_config.isSupabaseConfigured) {
        throw const UnknownFailure('Missing Supabase configuration');
      }
      final user = await _repository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      await _setAuthenticated(user, method: AuthMethod.emailPassword);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Sends a 6-digit email OTP. [shouldCreateUser] must be `false` for
  /// login/reset and `true` only for a brand-new email signup.
  Future<void> sendEmailOtp(
    String email, {
    bool shouldCreateUser = false,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      await _repository.sendEmailOtp(email, shouldCreateUser: shouldCreateUser);
      state = state.copyWith(status: AuthStatus.otpSent, isBusy: false);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Verifies an email OTP and signs the user in.
  ///
  /// When [requirePassword] is true (the account has no password — req 6), the
  /// user is routed to the mandatory set-password step instead of straight into
  /// the app.
  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
    bool requirePassword = false,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      final user = await _repository.verifyEmailOtp(email: email, otp: otp);
      if (requirePassword) {
        _enterSetPassword(user, method: AuthMethod.emailPassword);
        return;
      }
      await _setAuthenticated(user, method: AuthMethod.emailOtp);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
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
        // Signup: the account already exists from signUp() above, but this is
        // the signup branch so allow creation.
        await _repository.requestOtp(phone, shouldCreateUser: true);
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

  /// Verifies a phone OTP and signs the user in.
  ///
  /// When [requirePassword] is true (the account has no password — req 6), the
  /// user is routed to the mandatory set-password step instead of straight into
  /// the app.
  Future<void> verifyOtp({
    required String phone,
    required String otp,
    bool requirePassword = false,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      final user = await _repository.verifyOtp(phone: phone, otp: otp);
      if (requirePassword) {
        _enterSetPassword(user, phone: phone, method: AuthMethod.phonePassword);
        return;
      }
      await _setAuthenticated(user, phone: phone, method: AuthMethod.phoneOtp);
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

  /// Sets a password for the just-signed-in account (e.g. after an OTP-only
  /// signup, or for a Google user who opts to add one). Requires an active
  /// session. Returns true on success. Does NOT change the auth status.
  Future<bool> setPasswordAfterSignup(String newPassword) async {
    state = state.copyWith(isBusy: true);
    try {
      await _repository.setPasswordAfterSignup(newPassword);
      state = state.copyWith(isBusy: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  // --- Mandatory set-password after OTP (req 6) ---

  /// Whether the current set-password step is a forgot/reset (vs first-time
  /// set). Drives the screen copy; the underlying call is `updateUser` either
  /// way.
  bool _setPasswordIsReset = false;
  bool get setPasswordIsReset => _setPasswordIsReset;

  /// Transitions into the mandatory (non-skippable) set-password step after an
  /// OTP-verified login for an account that has no password yet, or after a
  /// reset OTP verify.
  void _enterSetPassword(
    UserProfile user, {
    String? phone,
    required AuthMethod method,
    bool isReset = false,
  }) {
    _pendingPasswordMethod = method;
    _setPasswordIsReset = isReset;
    state = AuthState(
      status: AuthStatus.needsPassword,
      user: user,
      phone: phone ?? state.phone,
    );
  }

  /// Verifies a phone reset OTP, then forces the set-new-password step.
  Future<void> verifyOtpForReset({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      final user = await _repository.verifyOtp(phone: phone, otp: otp);
      _enterSetPassword(
        user,
        phone: phone,
        method: AuthMethod.phonePassword,
        isReset: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Verifies an email reset OTP, then forces the set-new-password step.
  Future<void> verifyEmailOtpForReset({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      final user = await _repository.verifyEmailOtp(email: email, otp: otp);
      _enterSetPassword(user, method: AuthMethod.emailPassword, isReset: true);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  /// Completes the mandatory set-password step: sets the password, records the
  /// resulting `*_password` method, then enters the app. Returns false on
  /// failure so the screen can keep the user on the step.
  Future<bool> completeSetPassword(String newPassword) async {
    if (state.status != AuthStatus.needsPassword || state.user == null) {
      return false;
    }
    state = state.copyWith(isBusy: true);
    try {
      await _repository.setPasswordAfterSignup(newPassword);
      final method = _pendingPasswordMethod ?? AuthMethod.phonePassword;
      _pendingPasswordMethod = null;
      _setPasswordIsReset = false;
      unawaited(_repository.recordLastMethod(method));
      await _setAuthenticated(state.user!, phone: state.phone, method: method);
      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.needsPassword,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  /// Abandons the mandatory set-password step. There is no skip, so backing out
  /// signs the user out (the account remains passwordless, OTP-only).
  Future<void> cancelSetPassword() async {
    _pendingPasswordMethod = null;
    _setPasswordIsReset = false;
    await logout();
  }

  // --- Post-Google add-phone (skippable) ---

  /// Requests a phone-change OTP for the currently-signed-in (Google) user.
  Future<bool> requestAddPhoneOtp(String phone) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      await _repository.addPhone(phone);
      state = state.copyWith(isBusy: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  /// Verifies the added phone OTP, then completes authentication.
  Future<bool> verifyAddedPhone({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(isBusy: true, phone: phone);
    try {
      final user = await _repository.verifyAddedPhone(phone: phone, otp: otp);
      // The user signed in with a social provider; adding a phone doesn't
      // change which method they used.
      await _setAuthenticated(user, phone: phone, method: _pendingSocialMethod);
      return true;
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.needsPhone,
        errorMessage: _messageForError(error),
        isBusy: false,
      );
      return false;
    }
  }

  /// Skips the add-phone step and completes authentication as a social user.
  Future<void> skipAddPhone() async {
    final user = state.user;
    if (user == null) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    await _setAuthenticated(
      user,
      phone: user.phone,
      method: _pendingSocialMethod,
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    if (_googleSignIn != null) {
      await _googleSignIn.signOut();
    }
    // Intentionally keep PrefKeys.lastAuthMethod / lastAuthIdentifierMasked so
    // the entry screen can pre-select the user's previous method on next login.
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> updateProfile(UserProfileUpdate update) async {
    state = state.copyWith(isBusy: true);
    try {
      final user = await _repository.updateProfile(update);

      // Re-evaluate the gate after profile update to determine the next stage.
      try {
        final gateState = await _repository.getAuthGateState(app: 'estate');
        final stage = gateState['stage'] as String? ?? 'active';
        // If the backend still returns profile_completion after a successful
        // update, the profile data was not actually saved (backend bug or data
        // not persisted). Keep the user on the profile-completion screen so
        // they can retry instead of masking the problem by forcing
        // authenticated and leaving them in an incomplete state.
        if (stage == 'profile_completion') {
          AppLogger.w(
            'Gate still reports profile_completion after a successful '
            'profile update; staying on needsProfileCompletion so the user '
            'can retry.',
          );
          state = AuthState(
            status: AuthStatus.needsProfileCompletion,
            user: user,
            phone: state.phone,
          );
        } else {
          final gateStatus = _mapGateStageToAuthStatus(stage);
          state = AuthState(status: gateStatus, user: user, phone: state.phone);
        }
      } catch (_) {
        // If gate fails, default to authenticated.
        state = AuthState(status: AuthStatus.authenticated, user: user, phone: state.phone);
      }
    } catch (error) {
      state = state.copyWith(
        errorMessage: _messageForError(error),
        isBusy: false,
      );
    }
  }

  void _handleTokenChange(String? token) {
    if (token == null || token.isEmpty) {
      if (state.status == AuthStatus.authenticated ||
          state.status == AuthStatus.otpSent ||
          state.status == AuthStatus.needsPhone ||
          state.status == AuthStatus.needsPassword) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
      if (_config.isSupabaseConfigured &&
          supabase.Supabase.instance.client.auth.currentSession != null) {
        unawaited(supabase.Supabase.instance.client.auth.signOut());
      }
    }
  }

  Future<void> _setAuthenticated(
    UserProfile user, {
    String? phone,
    AuthMethod? method,
  }) async {
    if (method != null) {
      await _persistLastMethod(
        method,
        identifier:
            method == AuthMethod.emailPassword || method == AuthMethod.emailOtp
            ? user.email
            : (phone ?? user.phone),
      );
      // Mirror the method to the backend (best-effort). Google/Apple/set-
      // password paths already record it explicitly before calling this, so
      // skip those to avoid a duplicate round-trip.
      if (!method.isPasswordless &&
          method != AuthMethod.emailPassword &&
          method != AuthMethod.phonePassword) {
        unawaited(_repository.recordLastMethod(method));
      }
    }

    // ── Gate evaluation: call the backend auth-state endpoint ──────────
    // The backend is the single source of truth for which gate the user is
    // at.  We call GET /users/me/auth-state?app=estate and map the
    // response stage to the AuthStatus enum.
    try {
      final gateState = await _repository.getAuthGateState(app: 'estate');
      final stage = gateState['stage'] as String? ?? 'active';
      final gateStatus = _mapGateStageToAuthStatus(stage);
      state = AuthState(
        status: gateStatus,
        user: user,
        phone: phone ?? state.phone,
      );
    } catch (e) {
      // If the gate endpoint fails, fall back to authenticated so users
      // aren't locked out by a transient backend error.
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        phone: phone ?? state.phone,
      );
    }
  }

  /// Map the backend gate stage string to the local [AuthStatus] enum.
  AuthStatus _mapGateStageToAuthStatus(String stage) {
    switch (stage) {
      case 'identifier_verification':
        return AuthStatus.unauthenticated;
      case 'password_setup':
        return AuthStatus.needsPassword;
      case 'profile_completion':
        return AuthStatus.needsProfileCompletion;
      case 'app_onboarding':
        return AuthStatus.needsOnboarding;
      case 'active':
        return AuthStatus.authenticated;
      default:
        return AuthStatus.authenticated;
    }
  }

  /// Persists the last successful auth method + a masked identifier so the
  /// entry screen can pre-select it on the next visit.
  Future<void> _persistLastMethod(
    AuthMethod method, {
    String? identifier,
  }) async {
    await _preferences.setString(PrefKeys.lastAuthMethod, method.wireName);
    final masked = _maskIdentifier(identifier);
    if (masked != null) {
      await _preferences.setString(PrefKeys.lastAuthIdentifierMasked, masked);
    }
  }

  /// The remembered last auth method, or null if none recorded yet.
  AuthMethod? get lastAuthMethod =>
      AuthMethod.fromWireName(_preferences.getString(PrefKeys.lastAuthMethod));

  /// A masked version of the last identifier used (e.g. `j•••@gmail.com` or
  /// `•••••• 1234`), suitable for display next to the pre-selected method.
  String? get lastAuthIdentifierMasked =>
      _preferences.getString(PrefKeys.lastAuthIdentifierMasked);

  static String? _maskIdentifier(String? identifier) {
    final value = identifier?.trim();
    if (value == null || value.isEmpty) return null;
    if (isEmailIdentifier(value)) {
      final at = value.indexOf('@');
      final local = value.substring(0, at);
      final domain = value.substring(at);
      final head = local.isNotEmpty ? local[0] : '';
      return '$head•••$domain';
    }
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 4) return '••••';
    final last4 = digits.substring(digits.length - 4);
    return '•••••• $last4';
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
      state = state.copyWith(errorMessage: _messageForError(error));
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
