import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    UserProfile? user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
