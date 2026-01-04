/// Full user profile from backend API (/api/v1/users/profile/)
/// Contains complete user information including name, avatar, preferences, etc.
final class UserProfile {
  const UserProfile({
    required this.id,
    this.supabaseUserId,
    this.phone,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.role,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.preferences,
    this.notificationSettings,
  });

  final int id;
  final String? supabaseUserId;
  final String? phone;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? role;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserPreferences? preferences;
  final NotificationSettings? notificationSettings;

  /// Get display name (full_name or phone or email)
  String get displayName => fullName ?? phone ?? email ?? 'User';

  /// Get role display label
  String get roleLabel {
    final normalized = role?.toLowerCase().trim();
    switch (normalized) {
      case 'admin':
      case 'administrator':
      case 'owner':
      case 'property_owner':
        return 'Property Owner';
      case 'agent':
      case 'rm':
      case 'relationship_manager':
        return 'Relationship Manager';
      case 'user':
      case 'tenant':
        return 'Tenant';
      default:
        return 'User';
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int? ?? 0,
      supabaseUserId: json['supabase_user_id'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String? ?? json['fullName'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      role: json['role'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'] as String) 
          : null,
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : null,
      notificationSettings: json['notification_settings'] != null
          ? NotificationSettings.fromJson(json['notification_settings'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'supabase_user_id': supabaseUserId,
    'phone': phone,
    'email': email,
    'full_name': fullName,
    'avatar_url': avatarUrl,
    'role': role,
    'is_active': isActive,
    'is_verified': isVerified,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

/// User search/property preferences
final class UserPreferences {
  const UserPreferences({
    this.preferredLocations,
    this.budgetMin,
    this.budgetMax,
    this.preferredPropertyTypes,
  });

  final List<String>? preferredLocations;
  final double? budgetMin;
  final double? budgetMax;
  final List<String>? preferredPropertyTypes;

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      preferredLocations: (json['preferred_locations'] as List<dynamic>?)
          ?.cast<String>(),
      budgetMin: (json['budget_min'] as num?)?.toDouble(),
      budgetMax: (json['budget_max'] as num?)?.toDouble(),
      preferredPropertyTypes: (json['preferred_property_types'] as List<dynamic>?)
          ?.cast<String>(),
    );
  }
}

/// Notification preferences
final class NotificationSettings {
  const NotificationSettings({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.marketingEnabled = false,
  });

  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool marketingEnabled;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['push_enabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? true,
      smsEnabled: json['sms_enabled'] as bool? ?? false,
      marketingEnabled: json['marketing_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'push_enabled': pushEnabled,
    'email_enabled': emailEnabled,
    'sms_enabled': smsEnabled,
    'marketing_enabled': marketingEnabled,
  };
}
