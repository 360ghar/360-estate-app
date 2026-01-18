// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => '360 Estate';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get errorSomethingWentWrong => 'Something went wrong';

  @override
  String get errorOfflineHint =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get errorMissingConfigTitle => 'App configuration missing';

  @override
  String get errorMissingConfigBody =>
      'Set SUPABASE_URL and SUPABASE_ANON_KEY with --dart-define to enable authentication.';

  @override
  String get enterPhoneTitle => 'Enter phone number';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => '+91XXXXXXXXXX';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationPhoneInternational =>
      'Use international format, e.g. +91...';

  @override
  String get validationPhoneTooShort => 'Phone number looks too short';

  @override
  String get loginTitle => 'Login';

  @override
  String get signupTitle => 'Sign up';

  @override
  String get passwordLabel => 'Password';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get signInCta => 'Sign in';

  @override
  String get createAccountCta => 'Create account';

  @override
  String get alreadyHaveAccountCta => 'Already have an account?';

  @override
  String authPhoneSummary(String phone) {
    return 'Phone: $phone';
  }

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String homeToday(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Today is $dateString';
  }

  @override
  String homeOutstandingRent(String amount) {
    return 'Outstanding rent: $amount';
  }

  @override
  String get propertiesTitle => 'Properties';

  @override
  String get propertiesSearchHint => 'Search properties';

  @override
  String propertiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count properties',
      one: '1 property',
      zero: 'No properties',
    );
    return '$_temp0';
  }

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody => 'Try adjusting your filters or refresh.';

  @override
  String get publicApplicationTitle => 'Application';

  @override
  String publicApplicationSlug(String slug) {
    return 'Public application: $slug';
  }

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get accountSection => 'ACCOUNT';

  @override
  String get preferencesSection => 'PREFERENCES';

  @override
  String get supportSection => 'SUPPORT';

  @override
  String get aboutSection => 'ABOUT';

  @override
  String get dangerZone => 'DANGER ZONE';

  @override
  String get changePassword => 'Change Password';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get notEnabled => 'Not enabled';

  @override
  String get linkedAccounts => 'Linked Accounts';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLanguage => 'Theme, Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageAlerts => 'Manage alerts';

  @override
  String get privacy => 'Privacy';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get reportProblem => 'Report a Problem';

  @override
  String get appVersion => 'App Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get deactivateAccount => 'Deactivate Account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get deactivateConfirm =>
      'Deactivating your account will temporarily disable it. You can reactivate by signing back in.';

  @override
  String get deactivateSuccess => 'Account deactivated';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deleteAccountWarning =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get deleteSuccess => 'Account deletion requested';

  @override
  String get delete => 'Delete';

  @override
  String get featureComingSoon => 'This feature is coming soon';

  @override
  String get enterPasswordConfirm => 'Enter password to confirm';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get storageSection => 'Storage & Data';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheConfirm =>
      'Are you sure you want to clear the app cache?';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get downloadMyData => 'Download My Data';

  @override
  String get downloadDataConfirm =>
      'Your data will be prepared and sent to your email. This may take a few minutes.';

  @override
  String get dataDownloadStarted =>
      'Data export started. Check your email shortly.';

  @override
  String get commonConfirm => 'Clear';

  @override
  String get commonRequest => 'Request';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get language => 'Language';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String get saveFailed => 'Failed to save profile';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get passwordChangeFailed => 'Failed to change password';

  @override
  String get passwordChangeInfo =>
      'Enter your current password and a new password to update your credentials.';

  @override
  String get validationCurrentPasswordRequired =>
      'Current password is required';

  @override
  String get validationNewPasswordRequired => 'New password is required';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your new password';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get requirementMinLength => 'At least 8 characters';

  @override
  String get requirementUppercase => 'At least one uppercase letter';

  @override
  String get requirementLowercase => 'At least one lowercase letter';

  @override
  String get requirementNumber => 'At least one number';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get enablePushNotifications => 'Enable Push Notifications';

  @override
  String get pushNotificationsDesc => 'Receive notifications on your device';

  @override
  String get alertTypes => 'Alert Types';

  @override
  String get rentReminders => 'Rent Due Reminders';

  @override
  String get rentRemindersDesc => 'Get reminded before rent is due';

  @override
  String get paymentAlerts => 'Payment Received Alerts';

  @override
  String get paymentAlertsDesc => 'Know when payments are received';

  @override
  String get leaseExpiryAlerts => 'Lease Expiry Alerts';

  @override
  String get leaseExpiryAlertsDesc => 'Get notified before leases expire';

  @override
  String get maintenanceAlerts => 'Maintenance Updates';

  @override
  String get maintenanceAlertsDesc => 'Updates on maintenance requests';

  @override
  String get inspectionReminders => 'Inspection Reminders';

  @override
  String get inspectionRemindersDesc => 'Reminders for upcoming inspections';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get marketingEmails => 'Marketing Emails';

  @override
  String get marketingEmailsDesc => 'Receive updates and promotional content';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get enableQuietHours => 'Enable Quiet Hours';

  @override
  String get quietHoursDesc => 'Mute notifications during specific hours';

  @override
  String get quietHoursStart => 'Start Time';

  @override
  String get quietHoursEnd => 'End Time';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get profileVisibilitySection => 'Profile Visibility';

  @override
  String get visibilityPublic => 'Public';

  @override
  String get visibilityPublicDesc => 'Anyone can see your profile';

  @override
  String get visibilityContacts => 'Contacts Only';

  @override
  String get visibilityContactsDesc =>
      'Only your contacts can see your profile';

  @override
  String get visibilityPrivate => 'Private';

  @override
  String get visibilityPrivateDesc => 'Only you can see your profile';

  @override
  String get phoneVisibilitySection => 'Phone Number Visibility';

  @override
  String get emailVisibilitySection => 'Email Visibility';

  @override
  String get dataAnalyticsSection => 'Data & Analytics';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsDesc => 'Help improve the app by sharing usage data';

  @override
  String get crashReporting => 'Crash Reporting';

  @override
  String get crashReportingDesc =>
      'Automatically report crashes to help us fix bugs';

  @override
  String get dataManagementSection => 'Data Management';

  @override
  String get downloadDataDesc => 'Get a copy of all your data';

  @override
  String get clearActivityDesc => 'Clear your recent activity';

  @override
  String get searchHelp => 'Search for help...';

  @override
  String get quickLinks => 'Quick Links';

  @override
  String get gettingStarted => 'Getting Started';

  @override
  String get propertyManagement => 'Properties';

  @override
  String get paymentsCollections => 'Payments';

  @override
  String get leases => 'Leases';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get stillNeedHelp => 'Still need help?';

  @override
  String get contactSupportDesc => 'Our support team is here to assist you';

  @override
  String get contactUsBtn => 'Contact Us';

  @override
  String get yourName => 'Your Name';

  @override
  String get category => 'Category';

  @override
  String get subject => 'Subject';

  @override
  String get message => 'Message';

  @override
  String get validationSubjectRequired => 'Subject is required';

  @override
  String get validationMessageRequired => 'Message is required';

  @override
  String get validationMessageTooShort =>
      'Please provide more details (at least 10 characters)';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get supportRequestSent => 'Support request sent successfully';

  @override
  String get orEmailUs => 'Or email us directly at support@360estate.app';

  @override
  String get about => 'About';

  @override
  String get tagline => 'Complete Property Management Solution';

  @override
  String get version => 'Version';

  @override
  String get legal => 'Legal';

  @override
  String get licenses => 'Licenses';

  @override
  String get website => 'Website';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get followUs => 'Follow Us';

  @override
  String get madeWithLove => 'Made with ❤️ for property managers';

  @override
  String get allRightsReserved => 'All rights reserved.';

  @override
  String get couldNotLaunchUrl => 'Could not launch URL';

  @override
  String get support => 'Support';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get supportResponseTime => 'We typically respond within 24 hours';

  @override
  String get privacySection => 'Privacy';
}
