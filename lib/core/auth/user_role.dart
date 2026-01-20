enum UserRole { owner, manager }

extension UserRoleX on UserRole {
  bool get isOwner => this == UserRole.owner;
  bool get isManager => this == UserRole.manager;

  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Owner';
      case UserRole.manager:
        return 'Relationship Manager';
    }
  }
}

UserRole? parseUserRole(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;
  if (normalized.contains('owner')) return UserRole.owner;
  if (normalized.contains('rm') ||
      normalized.contains('relationship') ||
      normalized.contains('manager')) {
    return UserRole.manager;
  }
  return null;
}

UserRole? parseStoredRole(String? value) {
  if (value == null || value.isEmpty) return null;
  for (final role in UserRole.values) {
    if (role.name == value) return role;
  }
  return parseUserRole(value);
}
