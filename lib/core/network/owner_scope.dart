import 'package:estate_app/core/api/wire_enums.dart';

/// Which owner's data the signed-in user acts on.
///
/// An owner (role `user`) needs none: the backend scopes every PM route to the
/// caller, and a role `user` that sends `owner_id` on a create gets 403. An
/// agent must name the owner on every PM list and create (`owner_id`): the
/// backend refuses an agent request without it. An admin may name an owner or
/// omit it.
final class OwnerScope {
  const OwnerScope({this.ownerId, this.requiresOwner = false});

  /// No owner to name. For the role `user` and for a signed-out app.
  static const OwnerScope none = OwnerScope();

  /// The scope for a signed-in [role] with the owner the user picked.
  factory OwnerScope.forRole(UserRole? role, int? pickedOwnerId) {
    return switch (role) {
      UserRole.agent => OwnerScope(ownerId: pickedOwnerId, requiresOwner: true),
      UserRole.admin => OwnerScope(ownerId: pickedOwnerId),
      _ => none,
    };
  }

  /// The owner to send as `owner_id`, or null.
  final int? ownerId;

  /// True when a request without [ownerId] must not be sent (agent).
  final bool requiresOwner;

  /// The user can pick an owner (agent or admin).
  bool get canPickOwner => requiresOwner || ownerId != null;

  @override
  bool operator ==(Object other) =>
      other is OwnerScope &&
      other.ownerId == ownerId &&
      other.requiresOwner == requiresOwner;

  @override
  int get hashCode => Object.hash(ownerId, requiresOwner);
}

/// Preference key of the owner an agent or admin picked, per account.
String ownerPrefKey(int userId) => 'pm_owner_id_$userId';
