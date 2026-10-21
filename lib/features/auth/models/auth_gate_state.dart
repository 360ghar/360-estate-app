import 'package:estate_app/core/api/wire_enums.dart';

/// `GET /users/me/auth-state` (`AuthGateState`). An unknown `stage` or
/// `next_action` reads as null.
final class AuthGateState {
  const AuthGateState({
    this.stage,
    this.nextAction,
    this.missingFields = const <String>[],
  });

  factory AuthGateState.fromJson(Map<String, dynamic> json) {
    final missing = json['missing_fields'];
    return AuthGateState(
      stage: AuthGateStage.fromJson(json['stage']),
      nextAction: AuthGateNextAction.fromJson(json['next_action']),
      missingFields: missing is List
          ? [for (final item in missing) item.toString()]
          : const <String>[],
    );
  }

  final AuthGateStage? stage;
  final AuthGateNextAction? nextAction;
  final List<String> missingFields;
}
