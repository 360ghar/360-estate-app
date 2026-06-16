import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/data/apple_sign_in_service.dart';
import 'package:estate_app/features/auth/data/google_sign_in_service.dart';
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:mime/mime.dart';
// Hide http's MultipartFile (re-exported by supabase_flutter) so the dio
// MultipartFile used by uploadProfilePhoto resolves unambiguously.
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

class UserProfileUpdate {
  const UserProfileUpdate({
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.dateOfBirth,
  });

  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final DateTime? dateOfBirth;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (fullName != null && fullName!.trim().isNotEmpty) {
      payload['full_name'] = fullName!.trim();
    }
    if (firstName != null && firstName!.trim().isNotEmpty) {
      payload['first_name'] = firstName!.trim();
    }
    if (lastName != null && lastName!.trim().isNotEmpty) {
      payload['last_name'] = lastName!.trim();
    }
    if (email != null && email!.trim().isNotEmpty) {
      payload['email'] = email!.trim();
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      payload['phone'] = phone!.trim();
    }
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      payload['avatar_url'] = avatarUrl!.trim();
    }
    if (dateOfBirth != null) {
      payload['date_of_birth'] = dateOfBirth!.toIso8601String();
    }
    return payload;
  }
}

/// Detects whether an identifier looks like an email address (otherwise it is
/// treated as a phone number).
bool isEmailIdentifier(String identifier) {
  final trimmed = identifier.trim();
  if (trimmed.isEmpty) return false;
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
}

class AuthRepository {
  AuthRepository(
    this._client,
    this._tokenStorage, {
    this.googleSignIn,
    this.appleSignIn,
  });

  final ApiClient _client;
  final AuthTokenStorage _tokenStorage;

  /// Optional native Google Sign-In service. Null when Google Sign-In is not
  /// configured (no `GOOGLE_WEB_CLIENT_ID`).
  final GoogleSignInService? googleSignIn;

  /// Native Apple Sign-In service. Only used on iOS (gated by the UI).
  final AppleSignInService? appleSignIn;

  SupabaseClient get _supabase => Supabase.instance.client;

  bool get _isSupabaseReady {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Resolves an identifier (email or phone) against the backend login state
  /// machine: `POST /api/v1/auth/identifier-status`.
  ///
  /// Returns null when the backend can't be reached so callers can fall back
  /// to a safe default (treat as new account -> OTP-first signup).
  Future<IdentifierStatus?> checkIdentifierStatus(String identifier) async {
    final isEmail = isEmailIdentifier(identifier);
    final normalized = isEmail
        ? identifier.trim().toLowerCase()
        : normalizePhone(identifier);
    if (normalized.isEmpty) return null;
    try {
      final response = await _client.post<dynamic>(
        '/api/v1/auth/identifier-status',
        data: {'identifier': normalized},
      );
      final data = unwrapMap(response.data);
      final channelRaw = (data['channel'] as String?)?.toLowerCase();
      final nextStepRaw = (data['next_step'] as String?)?.toLowerCase();
      return IdentifierStatus(
        exists: data['exists'] == true,
        verified: data['verified'] == true,
        hasPassword: data['has_password'] == true,
        channel: channelRaw == 'email'
            ? IdentifierChannel.email
            : channelRaw == 'phone'
            ? IdentifierChannel.phone
            : (isEmail ? IdentifierChannel.email : IdentifierChannel.phone),
        nextStep: nextStepRaw == 'password'
            ? IdentifierNextStep.password
            : IdentifierNextStep.otp,
      );
    } on Failure {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Records the last successful auth method via `POST /api/v1/auth/last-method`.
  /// Best-effort: failures are swallowed so they never block a sign-in.
  Future<void> recordLastMethod(AuthMethod method) async {
    try {
      await _client.post<dynamic>(
        '/api/v1/auth/last-method',
        data: {'method': method.wireName},
      );
    } catch (_) {
      // Non-critical; ignore.
    }
  }

  /// Fetches the auth gate state from the backend.
  /// Returns a map with `stage`, `next_action`, and `missing_fields`.
  Future<Map<String, dynamic>> getAuthGateState({String app = 'estate'}) async {
    final response = await _client.get<dynamic>(
      '/api/v1/users/me/auth-state',
      queryParameters: {'app': app},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  /// Marks the given app's onboarding as complete (sets
  /// `<app>_onboarding_completed = true` on the user). Best-effort: failures
  /// are swallowed so they never block entry to the app.
  Future<void> completeOnboarding({String app = 'estate'}) async {
    try {
      await _client.post<dynamic>(
        '/api/v1/users/me/onboarding',
        queryParameters: {'app': app},
      );
    } catch (_) {
      // Non-critical; ignore.
    }
  }

  /// The deep-link callback Supabase redirects to after the Google OAuth flow.
  /// Matches the custom scheme registered in `AndroidManifest.xml`
  /// (scheme `com.the360ghar.estateapp`, host `login-callback`) and the
  /// iOS `CFBundleURLSchemes` entry. Add this exact value to the Supabase
  /// dashboard's redirect URL allowlist.
  static const String googleOAuthRedirectUrl =
      'com.the360ghar.estateapp://login-callback';

  /// Google Sign-In.
  ///
  /// Prefers the native ID-token flow when a web client id is configured. If
  /// the native attempt fails for any reason OTHER than user cancellation
  /// (e.g. missing google-services.json / unprovisioned Android OAuth client +
  /// SHA), it automatically FALLS BACK to the Supabase OAuth redirect flow. A
  /// user cancellation is propagated and never falls back.
  ///
  /// Returns the [UserProfile] when the native ID-token flow runs synchronously.
  /// Returns `null` when the OAuth redirect flow is used (directly or via
  /// fallback): the external browser is launched and the session arrives
  /// asynchronously via `onAuthStateChange`. [onRedirectLaunched] is invoked
  /// synchronously immediately before the browser launch so the controller can
  /// arm its deep-link listener without racing the callback.
  Future<UserProfile?> signInWithGoogle({
    void Function()? onRedirectLaunched,
  }) async {
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured.');
    }
    final service = googleSignIn;

    // No native client id -> OAuth redirect flow (no google-services.json or
    // client id required). Google must be enabled in the Supabase dashboard.
    if (service == null) {
      return _signInWithGoogleRedirect(onRedirectLaunched);
    }

    // Native ID-token flow, with redirect fallback on non-cancellation errors.
    try {
      final tokens = await service.signIn();
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: tokens.idToken,
        accessToken: tokens.accessToken,
        nonce: tokens.rawNonce,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session == null) {
        throw const UnknownFailure(
          'Google sign-in succeeded but session is missing',
        );
      }
      await _tokenStorage.save(session.accessToken);
      final user = response.user ?? session.user;
      return _fetchProfileWithFallback(user);
    } on GoogleSignInCancelled {
      // User dismissed the native picker — do NOT fall back.
      rethrow;
    } catch (_) {
      // Any non-cancellation native failure (e.g. unprovisioned OAuth client /
      // wrong SHA / missing google-services.json) -> redirect fallback.
      return _signInWithGoogleRedirect(onRedirectLaunched);
    }
  }

  /// Launches the Supabase OAuth redirect flow for Google. Returns `null`
  /// because the session arrives later via the deep-link callback.
  Future<UserProfile?> _signInWithGoogleRedirect(
    void Function()? onRedirectLaunched,
  ) async {
    try {
      onRedirectLaunched?.call();
      final launched = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: googleOAuthRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const UnknownFailure('Could not open Google sign-in.');
      }
      // Session arrives via the deep-link callback; nothing to return yet.
      return null;
    } on Failure {
      rethrow;
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Google sign-in failed', cause: e);
    }
  }

  /// Native Apple Sign-In -> Supabase `signInWithIdToken` -> profile.
  ///
  /// On the first authorization Apple may return the user's name; we forward it
  /// into Supabase user metadata since Apple never returns it again.
  Future<UserProfile> signInWithApple() async {
    final service = appleSignIn;
    if (service == null) {
      throw const UnknownFailure('Apple Sign-In is not available.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured.');
    }
    try {
      final tokens = await service.signIn();
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: tokens.idToken,
        nonce: tokens.rawNonce,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session == null) {
        throw const UnknownFailure(
          'Apple sign-in succeeded but session is missing',
        );
      }
      await _tokenStorage.save(session.accessToken);

      // Apple only returns the name on the very first sign-in. Persist it to
      // user metadata if present and not already set.
      final user = response.user ?? session.user;
      final hasName =
          ((user.userMetadata?['full_name'] as String?)?.trim().isNotEmpty ??
          false);
      if (tokens.fullName != null && !hasName) {
        try {
          await _supabase.auth.updateUser(
            UserAttributes(data: {'full_name': tokens.fullName}),
          );
        } catch (_) {
          // Non-critical; ignore.
        }
      }
      return _fetchProfileWithFallback(user);
    } on AppleSignInCancelled {
      rethrow;
    } on Failure {
      rethrow;
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Apple sign-in failed', cause: e);
    }
  }

  Future<UserProfile> signInWithPassword({
    required String phone,
    required String password,
  }) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    try {
      final response = await _supabase.auth.signInWithPassword(
        phone: normalizedPhone,
        password: password,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session == null) {
        throw const UnknownFailure('Login succeeded but session is missing');
      }
      await _tokenStorage.save(session.accessToken);
      final user = response.user ?? session.user;
      return _fetchProfileWithFallback(user);
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Authentication failed', cause: e);
    }
  }

  Future<UserProfile> signUpWithPassword({
    required String phone,
    required String password,
    String? fullName,
    String? email,
  }) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    try {
      final metadata = <String, dynamic>{};
      if (fullName != null && fullName.trim().isNotEmpty) {
        metadata['full_name'] = fullName.trim();
      }
      if (email != null && email.trim().isNotEmpty) {
        metadata['email'] = email.trim();
      }

      final response = await _supabase.auth.signUp(
        phone: normalizedPhone,
        password: password,
        data: metadata.isEmpty ? null : metadata,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      final user = response.user ?? session?.user;
      if (session != null) {
        await _tokenStorage.save(session.accessToken);
      }
      if (user == null) {
        throw const UnknownFailure('Sign up succeeded but user is missing');
      }
      return _fetchProfileWithFallback(user);
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Sign up failed', cause: e);
    }
  }

  /// Sends a 6-digit SMS OTP.
  ///
  /// [shouldCreateUser] MUST be `false` for login (OTP-first) and password
  /// reset, so an unknown/mistyped number never silently creates an account.
  /// Pass `true` only for signup.
  Future<void> requestOtp(String phone, {bool shouldCreateUser = false}) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured for OTP login.');
    }
    await _supabase.auth.signInWithOtp(
      phone: normalizedPhone,
      shouldCreateUser: shouldCreateUser,
    );
  }

  Future<UserProfile> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured for OTP login.');
    }
    final response = await _supabase.auth.verifyOTP(
      phone: normalizedPhone,
      token: otp,
      type: OtpType.sms,
    );
    final session = response.session ?? _supabase.auth.currentSession;
    if (session == null) {
      throw const UnknownFailure('Login succeeded but session is missing');
    }
    await _tokenStorage.save(session.accessToken);
    final user = response.user ?? session.user;
    return _fetchProfileWithFallback(user);
  }

  /// Sends a 6-digit email OTP (Supabase `OtpType.email`).
  ///
  /// [shouldCreateUser] MUST be `false` for login (OTP-first) and password
  /// reset, so an unknown/mistyped email never silently creates an account.
  /// Pass `true` only for a brand-new email signup.
  Future<void> sendEmailOtp(
    String email, {
    bool shouldCreateUser = false,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!isEmailIdentifier(normalized)) {
      throw const ValidationFailure('Enter a valid email address.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured for OTP login.');
    }
    try {
      await _supabase.auth.signInWithOtp(
        email: normalized,
        shouldCreateUser: shouldCreateUser,
        emailRedirectTo: googleOAuthRedirectUrl,
      );
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    }
  }

  /// Verifies a 6-digit email OTP and establishes a session.
  Future<UserProfile> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!isEmailIdentifier(normalized)) {
      throw const ValidationFailure('Enter a valid email address.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured for OTP login.');
    }
    try {
      final response = await _supabase.auth.verifyOTP(
        email: normalized,
        token: otp,
        type: OtpType.email,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session == null) {
        throw const UnknownFailure('Login succeeded but session is missing');
      }
      await _tokenStorage.save(session.accessToken);
      final user = response.user ?? session.user;
      return _fetchProfileWithFallback(user);
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    }
  }

  /// Signs in with an email + password.
  Future<UserProfile> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!isEmailIdentifier(normalized)) {
      throw const ValidationFailure('Enter a valid email address.');
    }
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: normalized,
        password: password,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session == null) {
        throw const UnknownFailure('Login succeeded but session is missing');
      }
      await _tokenStorage.save(session.accessToken);
      final user = response.user ?? session.user;
      return _fetchProfileWithFallback(user);
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Authentication failed', cause: e);
    }
  }

  /// Sets the account password after an OTP-verified signup (and for the
  /// passwordless-Google flow when a user opts to add a password). Requires an
  /// active Supabase session.
  Future<void> setPasswordAfterSignup(String newPassword) async {
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured.');
    }
    if (_supabase.auth.currentSession == null) {
      throw const UnauthorizedFailure(
        'You must be signed in to set a password.',
      );
    }
    if (newPassword.trim().length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters.');
    }
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to set password', cause: e);
    }
  }

  /// Requests a phone-change OTP for the currently signed-in user (used by the
  /// post-Google add-phone flow). Requires an active Supabase session.
  Future<void> addPhone(String phone) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured.');
    }
    if (_supabase.auth.currentSession == null) {
      throw const UnauthorizedFailure('You must be signed in to add a phone.');
    }
    try {
      await _supabase.auth.updateUser(UserAttributes(phone: normalizedPhone));
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to start phone verification', cause: e);
    }
  }

  /// Verifies the phone-change OTP and returns the refreshed profile. Used by
  /// the post-Google add-phone flow.
  Future<UserProfile> verifyAddedPhone({
    required String phone,
    required String otp,
  }) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured.');
    }
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: normalizedPhone,
        token: otp,
        type: OtpType.phoneChange,
      );
      final session = response.session ?? _supabase.auth.currentSession;
      if (session != null) {
        await _tokenStorage.save(session.accessToken);
      }
      final user = response.user ?? session?.user;
      return _fetchProfileWithFallback(user);
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to verify phone', cause: e);
    }
  }

  Future<UserProfile> fetchProfile() async {
    final response = await _client.get<dynamic>('/users/profile/');
    final data = unwrapMap(response.data);
    return UserProfile.fromJson(data);
  }

  Future<UserProfile> fetchProfileOrFallback(User? user) async {
    return _fetchProfileWithFallback(user);
  }

  Future<UserProfile> _fetchProfileWithFallback(User? user) async {
    try {
      return await fetchProfile();
    } catch (_) {
      if (user == null) rethrow;
      return _profileFromSupabase(user);
    }
  }

  Future<UserProfile> updateProfile(UserProfileUpdate update) async {
    final response = await _client.put<dynamic>(
      '/users/profile/',
      data: update.toJson(),
    );
    final data = unwrapMap(response.data);
    return UserProfile.fromJson(data);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _tokenStorage.clear();
  }

  /// Upload profile photo via backend API (Cloudinary).
  /// Returns the public URL of the uploaded image.
  Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const UnauthorizedFailure('User not authenticated');
      }

      final mimeType = lookupMimeType(imageFile.path);
      if (mimeType == null ||
          (!mimeType.startsWith('image/') &&
              mimeType != 'application/octet-stream')) {
        throw const ValidationFailure(
          'Invalid file type. Please select an image.',
        );
      }

      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw const ValidationFailure('Image size must be less than 5MB');
      }

      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'folder': 'avatars',
        'visibility': 'public',
      });

      final response = await _client.upload<dynamic>(
        '/api/v1/upload',
        data: formData,
      );

      final data = response.data;
      final imageUrl = data['public_url'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) {
        throw const UnknownFailure('Upload succeeded but no URL returned.');
      }
      return imageUrl;
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? e.message;
      throw UnknownFailure('Failed to upload photo: $detail', cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to upload photo', cause: e);
    }
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const UnauthorizedFailure('User not authenticated');
      }

      if (user.email == null) {
        throw const UnknownFailure('No email associated with this account');
      }

      // Verify current password by attempting to sign in
      try {
        await _supabase.auth.signInWithPassword(
          email: user.email!,
          password: currentPassword,
        );
      } on AuthException catch (e) {
        if (e.message.contains('Invalid') ||
            e.message.contains('credentials')) {
          throw const ValidationFailure('Current password is incorrect');
        }
        rethrow;
      }

      // Update password
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to change password', cause: e);
    }
  }

  /// Update only the profile photo URL (after upload)
  Future<UserProfile> updateProfilePhoto(String photoUrl) async {
    try {
      final response = await _client.put<dynamic>(
        '/users/profile/',
        data: {'avatar_url': photoUrl},
      );
      final data = unwrapMap(response.data);
      return UserProfile.fromJson(data);
    } catch (e) {
      throw UnknownFailure('Failed to update profile photo', cause: e);
    }
  }
}

UserProfile _profileFromSupabase(User user) {
  final metadata = user.userMetadata ?? const <String, dynamic>{};
  return UserProfile(
    fullName: metadata['full_name'] as String?,
    firstName: metadata['first_name'] as String?,
    lastName: metadata['last_name'] as String?,
    phone: user.phone,
    email: user.email,
    role: metadata['role'] as String?,
  );
}
