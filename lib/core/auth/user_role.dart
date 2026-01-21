enum UserRole { owner }

extension UserRoleX on UserRole {
  bool get isOwner => true;

  String get label {
    return 'Owner';
  }
}

UserRole? parseUserRole(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;
  // Always return owner for any valid input
  if (normalized.contains('owner') ||
      normalized.contains('manager') ||
      normalized.contains('rm') ||
      normalized.contains('relationship') ||
      normalized.contains('tenant')) {
    return UserRole.owner;
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
