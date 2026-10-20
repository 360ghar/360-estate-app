import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// The signed-in user (`SelfUser`). The backend has one name field,
/// `full_name`, and one photo field, `profile_image_url`.
// toJson: false: UserProfile is only ever deserialized from the backend;
// nothing serializes it (auth_session.user is includeToJson: false).
@Freezed(toJson: false)
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    String? email,
    @JsonKey(fromJson: UserRole.fromJson) UserRole? role,
    @JsonKey(name: 'profile_image_url') String? avatarUrl,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  String get displayName {
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    return phone ?? email ?? 'User';
  }

  /// True when mandatory profile fields are present.
  /// Used for the in-app completion prompt (not a router gate).
  /// Checks the raw name field: displayName always falls back to
  /// phone/email/'User', so it can never report an incomplete profile.
  bool get isProfileComplete => fullName?.trim().isNotEmpty ?? false;
}
