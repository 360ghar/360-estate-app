enum UserRole {
  admin, // Property Owner
  agent, // Relationship Manager
  user, // Tenant
  unknown;

  static UserRole parse(String? value) {
    if (value == null) return UserRole.unknown;

    final normalized = value.toLowerCase().trim();

    // Map backend role values to app roles
    switch (normalized) {
      case 'admin':
      case 'administrator':
      case 'owner':
      case 'property_owner':
        return UserRole.admin;
      case 'agent':
      case 'rm':
      case 'relationship_manager':
        return UserRole.agent;
      case 'user':
      case 'tenant':
        return UserRole.user;
      default:
        // Try exact enum match as fallback
        try {
          return UserRole.values.firstWhere(
            (e) => e.name.toLowerCase() == normalized,
            orElse: () => UserRole.unknown,
          );
        } catch (_) {
          return UserRole.unknown;
        }
    }
  }

  bool get isOwner => this == admin;
  bool get isAgent => this == agent;
  bool get isTenant => this == user;
}

final class AuthUser {
  const AuthUser({
    required this.id,
    this.phone,
    this.email,
    this.role = UserRole.unknown,
  });

  final String id;
  final String? phone;
  final String? email;
  final UserRole role;
}
