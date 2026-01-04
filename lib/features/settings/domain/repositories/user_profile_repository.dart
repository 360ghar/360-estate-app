import 'package:estate_app/features/settings/domain/entities/user_profile.dart';

/// Repository for user profile operations
abstract interface class UserProfileRepository {
  /// Get current user's full profile from backend
  Future<UserProfile> getProfile();

  /// Update user's profile
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  });

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences);

  /// Update notification settings
  Future<void> updateNotificationSettings(NotificationSettings settings);
}
