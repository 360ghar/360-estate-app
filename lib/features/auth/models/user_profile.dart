import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? phone,
    String? email,
    String? role,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  String get displayName {
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;

    final combined = [firstName, lastName]
        .where((value) => value != null && value!.trim().isNotEmpty)
        .map((value) => value!.trim())
        .join(' ');
    if (combined.trim().isNotEmpty) return combined;

    return phone ?? email ?? 'User';
  }
}
