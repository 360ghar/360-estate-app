enum UserRole { owner, manager, tenant }

extension UserRoleX on UserRole {
  bool get isTenant => this == UserRole.tenant;

  String get label {
    switch (this) {
      case UserRole.owner:
      case UserRole.manager:
        return 'Owner / Relationship manager';
      case UserRole.tenant:
        return 'Tenant';
    }
  }
}

UserRole? parseUserRole(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;
  if (normalized.contains('tenant')) return UserRole.tenant;
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
