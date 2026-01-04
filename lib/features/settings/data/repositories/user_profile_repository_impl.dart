import 'package:estate_app/features/settings/data/datasources/user_profile_data_source.dart';
import 'package:estate_app/features/settings/domain/entities/user_profile.dart';
import 'package:estate_app/features/settings/domain/repositories/user_profile_repository.dart';

final class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this._dataSource);

  final UserProfileDataSource _dataSource;

  @override
  Future<UserProfile> getProfile() => _dataSource.getProfile();

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  }) => _dataSource.updateProfile(
    fullName: fullName,
    email: email,
    avatarUrl: avatarUrl,
  );

  @override
  Future<void> updatePreferences(UserPreferences preferences) =>
      _dataSource.updatePreferences(preferences);

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) =>
      _dataSource.updateNotificationSettings(settings);
}
