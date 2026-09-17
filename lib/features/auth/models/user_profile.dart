import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
// createToJson: false — UserProfile is only ever deserialized from the
// backend; nothing serializes it (auth_session.user is includeToJson: false).
@JsonSerializable(createToJson: false)
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? phone,
    String? email,
    String? role,
    // Client field name is avatarUrl; backend wire name is profile_image_url
    // (avatar_url accepted as legacy alias via fromJson normalization below).
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    // Backend UserSchema uses profile_image_url + full_name only.
    map['avatar_url'] ??= map['profile_image_url'];
    map['full_name'] ??= map['name'];
    // Prefer explicit first/last; otherwise leave null (displayName uses full_name).
    map['first_name'] ??= map['firstName'];
    map['last_name'] ??= map['lastName'];
    return _$UserProfileFromJson(map);
  }
}

extension UserProfileX on UserProfile {
  String get displayName {
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;

    final combined = [firstName, lastName]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .join(' ');
    if (combined.trim().isNotEmpty) return combined;

    return phone ?? email ?? 'User';
  }

  /// True when mandatory profile fields are present.
  /// Used for the in-app completion prompt (not a router gate).
  /// Checks the raw name fields: displayName always falls back to
  /// phone/email/'User', so it can never report an incomplete profile.
  bool get isProfileComplete =>
      (fullName?.trim().isNotEmpty ?? false) ||
      ((firstName?.trim().isNotEmpty ?? false) ||
          (lastName?.trim().isNotEmpty ?? false));
}
