import 'package:shared_preferences/shared_preferences.dart';

abstract final class PrefKeys {
  // Theme & Language
  static const themeMode = 'theme_mode';
  static const localeLanguageCode = 'locale_language_code';
  static const localeCountryCode = 'locale_country_code';

  // User & Mode
  static const lastSelectedMode = 'last_selected_mode';
  static const userRole = 'user_role';

  // Profile
  static const profilePhotoUrl = 'profile_photo_url';

  // Notifications
  static const notificationsEnabled = 'notifications_enabled';
  static const quietHoursStart = 'quiet_hours_start';
  static const quietHoursEnd = 'quiet_hours_end';
  static const rentRemindersEnabled = 'rent_reminders_enabled';
  static const paymentAlertsEnabled = 'payment_alerts_enabled';
  static const leaseExpiryAlertsEnabled = 'lease_expiry_alerts_enabled';
  static const maintenanceAlertsEnabled = 'maintenance_alerts_enabled';
  static const inspectionRemindersEnabled = 'inspection_reminders_enabled';
  static const marketingEmailsEnabled = 'marketing_emails_enabled';

  // Privacy
  static const analyticsEnabled = 'analytics_enabled';
  static const profileVisibility = 'profile_visibility';
  static const phoneVisibility = 'phone_visibility';
  static const emailVisibility = 'email_visibility';
}

final class AppPreferences {
  AppPreferences._(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences._(prefs);
  }

  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);
}
