import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'360 Estate'**
  String get appName;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWentWrong;

  /// No description provided for @errorOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get errorOfflineHint;

  /// No description provided for @errorMissingConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'App configuration missing'**
  String get errorMissingConfigTitle;

  /// No description provided for @errorMissingConfigBody.
  ///
  /// In en, this message translates to:
  /// **'Set SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY with --dart-define to enable authentication.'**
  String get errorMissingConfigBody;

  /// No description provided for @enterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneTitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'+91XXXXXXXXXX'**
  String get phoneNumberHint;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInternational.
  ///
  /// In en, this message translates to:
  /// **'Use international format, e.g. +91...'**
  String get validationPhoneInternational;

  /// No description provided for @validationPhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number looks too short'**
  String get validationPhoneTooShort;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupTitle;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @signInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInCta;

  /// No description provided for @createAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountCta;

  /// No description provided for @alreadyHaveAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountCta;

  /// No description provided for @authPhoneSummary.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String authPhoneSummary(String phone);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today is {date}'**
  String homeToday(DateTime date);

  /// No description provided for @homeOutstandingRent.
  ///
  /// In en, this message translates to:
  /// **'Outstanding rent: {amount}'**
  String homeOutstandingRent(String amount);

  /// No description provided for @propertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertiesTitle;

  /// No description provided for @propertiesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search properties'**
  String get propertiesSearchHint;

  /// No description provided for @propertiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No properties} =1{1 property} other{{count} properties}}'**
  String propertiesCount(int count);

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or refresh.'**
  String get emptyBody;

  /// No description provided for @publicApplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get publicApplicationTitle;

  /// No description provided for @publicApplicationSlug.
  ///
  /// In en, this message translates to:
  /// **'Public application: {slug}'**
  String publicApplicationSlug(String slug);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferencesSection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportSection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get dangerZone;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @notEnabled.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get notEnabled;

  /// No description provided for @linkedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get linkedAccounts;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Theme, Language'**
  String get themeLanguage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts'**
  String get manageAlerts;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportBug;

  /// No description provided for @reportBugSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Found an issue? Let us know'**
  String get reportBugSubtitle;

  /// No description provided for @requestFeature.
  ///
  /// In en, this message translates to:
  /// **'Request a Feature'**
  String get requestFeature;

  /// No description provided for @requestFeatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Suggest an improvement'**
  String get requestFeatureSubtitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @deactivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get deactivateAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String deleteAccountConfirmLabel(String word);

  /// No description provided for @deleteAccountConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountConfirmHint;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutTitle;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @deactivateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deactivating your account will temporarily disable it. You can reactivate by signing back in.'**
  String get deactivateConfirm;

  /// No description provided for @deactivateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deactivated'**
  String get deactivateSuccess;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Email app opened. Please send the message to complete your request.'**
  String get deleteAccountEmailSent;

  /// No description provided for @deleteAccountManualFallback.
  ///
  /// In en, this message translates to:
  /// **'Could not open your email app. Please email info@360ghar.com with subject \"Account Deletion Request\".'**
  String get deleteAccountManualFallback;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon'**
  String get featureComingSoon;

  /// No description provided for @enterPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter password to confirm'**
  String get enterPasswordConfirm;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @storageSection.
  ///
  /// In en, this message translates to:
  /// **'Storage & Data'**
  String get storageSection;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the app cache?'**
  String get clearCacheConfirm;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @downloadMyData.
  ///
  /// In en, this message translates to:
  /// **'Download My Data'**
  String get downloadMyData;

  /// No description provided for @downloadDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your data will be prepared and sent to your email. This may take a few minutes.'**
  String get downloadDataConfirm;

  /// No description provided for @dataDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Data export started. Check your email shortly.'**
  String get dataDownloadStarted;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonConfirm;

  /// No description provided for @commonRequest.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get commonRequest;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationEmailInvalid;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get saveFailed;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get passwordChangeFailed;

  /// No description provided for @passwordChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and a new password to update your credentials.'**
  String get passwordChangeInfo;

  /// No description provided for @validationCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get validationCurrentPasswordRequired;

  /// No description provided for @validationNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get validationNewPasswordRequired;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsDoNotMatch;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordRequirements;

  /// No description provided for @requirementMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get requirementMinLength;

  /// No description provided for @requirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get requirementUppercase;

  /// No description provided for @requirementLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter'**
  String get requirementLowercase;

  /// No description provided for @requirementNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get requirementNumber;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @enablePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Push Notifications'**
  String get enablePushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDesc;

  /// No description provided for @alertTypes.
  ///
  /// In en, this message translates to:
  /// **'Alert Types'**
  String get alertTypes;

  /// No description provided for @rentReminders.
  ///
  /// In en, this message translates to:
  /// **'Rent Due Reminders'**
  String get rentReminders;

  /// No description provided for @rentRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before rent is due'**
  String get rentRemindersDesc;

  /// No description provided for @paymentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Payment Received Alerts'**
  String get paymentAlerts;

  /// No description provided for @paymentAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Know when payments are received'**
  String get paymentAlertsDesc;

  /// No description provided for @leaseExpiryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Lease Expiry Alerts'**
  String get leaseExpiryAlerts;

  /// No description provided for @leaseExpiryAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified before leases expire'**
  String get leaseExpiryAlertsDesc;

  /// No description provided for @maintenanceAlerts.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Updates'**
  String get maintenanceAlerts;

  /// No description provided for @maintenanceAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates on maintenance requests'**
  String get maintenanceAlertsDesc;

  /// No description provided for @inspectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Inspection Reminders'**
  String get inspectionReminders;

  /// No description provided for @inspectionRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming inspections'**
  String get inspectionRemindersDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @marketingEmails.
  ///
  /// In en, this message translates to:
  /// **'Marketing Emails'**
  String get marketingEmails;

  /// No description provided for @marketingEmailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates and promotional content'**
  String get marketingEmailsDesc;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @enableQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Enable Quiet Hours'**
  String get enableQuietHours;

  /// No description provided for @quietHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications during specific hours'**
  String get quietHoursDesc;

  /// No description provided for @quietHoursStart.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get quietHoursStart;

  /// No description provided for @quietHoursEnd.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get quietHoursEnd;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @profileVisibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibilitySection;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @visibilityPublicDesc.
  ///
  /// In en, this message translates to:
  /// **'Anyone can see your profile'**
  String get visibilityPublicDesc;

  /// No description provided for @visibilityContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts Only'**
  String get visibilityContacts;

  /// No description provided for @visibilityContactsDesc.
  ///
  /// In en, this message translates to:
  /// **'Only your contacts can see your profile'**
  String get visibilityContactsDesc;

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;

  /// No description provided for @visibilityPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Only you can see your profile'**
  String get visibilityPrivateDesc;

  /// No description provided for @phoneVisibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Phone Number Visibility'**
  String get phoneVisibilitySection;

  /// No description provided for @emailVisibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Email Visibility'**
  String get emailVisibilitySection;

  /// No description provided for @dataAnalyticsSection.
  ///
  /// In en, this message translates to:
  /// **'Data & Analytics'**
  String get dataAnalyticsSection;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app by sharing usage data'**
  String get analyticsDesc;

  /// No description provided for @crashReporting.
  ///
  /// In en, this message translates to:
  /// **'Crash Reporting'**
  String get crashReporting;

  /// No description provided for @crashReportingDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically report crashes to help us fix bugs'**
  String get crashReportingDesc;

  /// No description provided for @dataManagementSection.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagementSection;

  /// No description provided for @downloadDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a copy of all your data'**
  String get downloadDataDesc;

  /// No description provided for @clearActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear your recent activity'**
  String get clearActivityDesc;

  /// No description provided for @searchHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get searchHelp;

  /// No description provided for @quickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get quickLinks;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get gettingStarted;

  /// No description provided for @propertyManagement.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertyManagement;

  /// No description provided for @paymentsCollections.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsCollections;

  /// No description provided for @leases.
  ///
  /// In en, this message translates to:
  /// **'Leases'**
  String get leases;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @stillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get stillNeedHelp;

  /// No description provided for @contactSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to assist you'**
  String get contactSupportDesc;

  /// No description provided for @contactUsBtn.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsBtn;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @validationSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get validationSubjectRequired;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get validationMessageRequired;

  /// No description provided for @validationMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide more details (at least 10 characters)'**
  String get validationMessageTooShort;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @supportRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Support request sent successfully'**
  String get supportRequestSent;

  /// No description provided for @orEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Or email us directly at support@360estate.app'**
  String get orEmailUs;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Complete Property Management Solution'**
  String get tagline;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for property managers'**
  String get madeWithLove;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get couldNotLaunchUrl;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @supportResponseTime.
  ///
  /// In en, this message translates to:
  /// **'We typically respond within 24 hours'**
  String get supportResponseTime;

  /// No description provided for @privacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
