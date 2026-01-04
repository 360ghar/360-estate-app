/// Feature flags for controlling availability of PM (Property Management) features.
/// 
/// These flags indicate which features are enabled in the app.
/// The app has graceful fallbacks for API endpoints that don't exist yet.
final class FeatureFlags {
  FeatureFlags._();
  
  // ============================================================
  // Property Management Features - ALL ENABLED (UI is implemented)
  // Backend fallbacks handle missing API endpoints gracefully
  // ============================================================
  
  /// Core properties CRUD - Available via /properties endpoint
  static const bool propertiesEnabled = true;
  
  /// Tenant management - UI implemented, backend uses fallback
  static const bool tenantsEnabled = true;
  
  /// Lease management - UI implemented, backend uses fallback
  static const bool leasesEnabled = true;
  
  /// Rent collection & finance - UI implemented, backend uses fallback
  static const bool financeEnabled = true;
  
  /// Maintenance requests - UI implemented, backend uses fallback
  static const bool maintenanceEnabled = true;
  
  /// Document management - UI implemented, backend uses fallback
  static const bool documentsEnabled = true;
  
  /// Application forms - UI implemented, backend uses fallback
  static const bool applicationsEnabled = true;
  
  /// Property inspections - UI implemented, backend uses fallback
  static const bool inspectionsEnabled = true;
  
  /// Reports & analytics - UI implemented, backend uses fallback
  static const bool reportsEnabled = true;
  
  /// Dashboard with PM metrics - UI implemented, backend uses fallback
  static const bool dashboardPmEnabled = true;
  
  // ============================================================
  // Consumer App Features (Already Available)
  // ============================================================
  
  /// Property search and browsing
  static const bool propertySearchEnabled = true;
  
  /// Property bookings/visits
  static const bool bookingsEnabled = true;
  
  /// User notifications
  static const bool notificationsEnabled = true;
  
  /// Blog/content
  static const bool blogEnabled = true;
  
  // ============================================================
  // Helper Methods
  // ============================================================
  
  /// Returns a user-friendly message for disabled features
  static String getDisabledMessage(String featureName) {
    return '$featureName is coming soon! This feature will be available in a future update.';
  }
  
  /// Check if showing PM features in navigation
  static bool get showPmNavigation => 
      tenantsEnabled || 
      leasesEnabled || 
      financeEnabled || 
      maintenanceEnabled;
}
