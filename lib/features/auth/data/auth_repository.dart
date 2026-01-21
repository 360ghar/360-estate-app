import 'dart:io';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:gotrue/gotrue.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserProfileUpdate {
  const UserProfileUpdate({
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;

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
    return payload;
  }
}

class AuthRepository {
  AuthRepository(this._client, this._tokenStorage);

  final ApiClient _client;
  final AuthTokenStorage _tokenStorage;

  SupabaseClient get _supabase => Supabase.instance.client;

  bool get _isSupabaseReady {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool?> isPhoneRegistered(String phone) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) return null;
    try {
      final rows = await _supabase
          .from('profiles')
          .select('id')
          .eq('phone', normalizedPhone)
          .limit(1);
      return (rows as List).isNotEmpty;
    } on PostgrestException {
      return null;
    } catch (_) {
      return null;
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

  Future<void> requestOtp(String phone) async {
    final normalizedPhone = normalizePhone(phone);
    if (normalizedPhone.isEmpty) {
      throw const ValidationFailure('Enter a valid phone number.');
    }
    if (!_isSupabaseReady) {
      throw const UnknownFailure('Supabase is not configured for OTP login.');
    }
    await _supabase.auth.signInWithOtp(phone: normalizedPhone);
  }

  Future<UserProfile> verifyOtp({required String phone, required String otp}) async {
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

  Future<UserProfile> fetchProfile() async {
    final response = await _client.get('/users/profile/');
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
    final response = await _client.put(
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

  /// Upload profile photo to Supabase Storage
  /// Returns the public URL of the uploaded image
  Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      // Get the current user
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const UnauthorizedFailure('User not authenticated');
      }

      // Validate file type
      final mimeType = lookupMimeType(imageFile.path);
      if (mimeType == null || (!mimeType.startsWith('image/') && mimeType != 'application/octet-stream')) {
        throw const ValidationFailure('Invalid file type. Please select an image.');
      }

      // Validate file size (max 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw const ValidationFailure('Image size must be less than 5MB');
      }

      // Generate unique filename
      final fileExt = mimeType.split('/').last;
      final fileName = '${const Uuid().v4()}.$fileExt';
      final filePath = 'avatars/${user.id}/$fileName';

      // Upload to Supabase Storage
      final storageResponse = await _supabase.storage
          .from('profiles')
          .upload(filePath, imageFile);

      // Get public URL
      final imageUrl = _supabase.storage
          .from('profiles')
          .getPublicUrl(filePath);

      return imageUrl;
    } on StorageException catch (e) {
      throw UnknownFailure('Failed to upload photo: ${e.message}', cause: e);
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
        if (e.message.contains('Invalid') || e.message.contains('credentials')) {
          throw const ValidationFailure('Current password is incorrect');
        }
        rethrow;
      }

      // Update password
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw ValidationFailure(e.message.trim(), cause: e);
    } catch (e) {
      throw UnknownFailure('Failed to change password', cause: e);
    }
  }

  /// Update only the profile photo URL (after upload)
  Future<UserProfile> updateProfilePhoto(String photoUrl) async {
    try {
      final response = await _client.put(
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

String? _extractToken(Object? payload) {
  if (payload is Map<String, dynamic>) {
    final direct = payload['token'] ??
        payload['access_token'] ??
        payload['access'] ??
        payload['auth_token'];
    if (direct is String && direct.isNotEmpty) return direct;

    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['token'] ?? data['access_token'] ?? data['access'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
  }
  return null;
}

Map<String, dynamic>? _extractUser(Object? payload) {
  if (payload is Map<String, dynamic>) {
    final direct = payload['user'];
    if (direct is Map<String, dynamic>) return direct;

    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['user'] ?? data['profile'];
      if (nested is Map<String, dynamic>) return nested;
    }
  }
  return null;
}
