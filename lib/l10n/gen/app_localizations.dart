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

  /// No description provided for @validationPhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number looks too short'**
  String get validationPhoneTooShort;

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

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

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

  /// No description provided for @deleteAccountConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String deleteAccountConfirmLabel(String word);

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

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully.'**
  String get deleteAccountSuccess;

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

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

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

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

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

  /// No description provided for @rentRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before rent is due'**
  String get rentRemindersDesc;

  /// No description provided for @paymentAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Know when payments are received'**
  String get paymentAlertsDesc;

  /// No description provided for @leaseExpiryAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified before leases expire'**
  String get leaseExpiryAlertsDesc;

  /// No description provided for @maintenanceAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates on maintenance requests'**
  String get maintenanceAlertsDesc;

  /// No description provided for @inspectionRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming inspections'**
  String get inspectionRemindersDesc;

  /// No description provided for @marketingEmailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates and promotional content'**
  String get marketingEmailsDesc;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

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

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

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

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

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

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

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

  /// No description provided for @commonLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this'**
  String get commonLoadFailedTitle;

  /// No description provided for @commonLoadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection, then try again.'**
  String get commonLoadFailedBody;

  /// No description provided for @commonLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more.'**
  String get commonLoadMoreFailed;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get commonClearSearch;

  /// No description provided for @commonFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get commonFilters;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get navProperties;

  /// No description provided for @navCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get navCollections;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navPressBackToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get navPressBackToExit;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeRentCardTitle.
  ///
  /// In en, this message translates to:
  /// **'{month} rent'**
  String homeRentCardTitle(String month);

  /// No description provided for @homeCollectedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Collected this month'**
  String get homeCollectedThisMonth;

  /// No description provided for @homeVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{change} vs last month'**
  String homeVsLastMonth(String change);

  /// No description provided for @homeRentOutstanding.
  ///
  /// In en, this message translates to:
  /// **'{amount} rent outstanding'**
  String homeRentOutstanding(String amount);

  /// No description provided for @homeRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get homeRecordPayment;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeChargesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rent charges for {month} yet.'**
  String homeChargesEmpty(String month);

  /// No description provided for @homeChargesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this month\'s charges.'**
  String get homeChargesFailed;

  /// No description provided for @homeUpcomingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming expenses {amount}'**
  String homeUpcomingExpenses(String amount);

  /// No description provided for @homeStripSemantics.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {total} rent charges paid this month. Opens collections.'**
  String homeStripSemantics(int paid, int total);

  /// No description provided for @homePortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get homePortfolioTitle;

  /// No description provided for @homePropertiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get homePropertiesLabel;

  /// No description provided for @homeOccupancyLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get homeOccupancyLabel;

  /// No description provided for @homeOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get homeOccupied;

  /// No description provided for @homeVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get homeVacant;

  /// No description provided for @homeUnderMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under maintenance'**
  String get homeUnderMaintenance;

  /// No description provided for @homeAddProperty.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get homeAddProperty;

  /// No description provided for @homeActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get homeActivityTitle;

  /// No description provided for @homeActivityEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get homeActivityEmptyTitle;

  /// No description provided for @homeActivityEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Payments, tasks and lease changes show up here.'**
  String get homeActivityEmptyBody;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with your first property'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a property, then record rent as it comes in.'**
  String get homeEmptyBody;

  /// No description provided for @rentStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get rentStatusDue;

  /// No description provided for @rentStatusPartlyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partly paid'**
  String get rentStatusPartlyPaid;

  /// No description provided for @rentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get rentStatusPaid;

  /// No description provided for @rentStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get rentStatusOverdue;

  /// No description provided for @rentStatusWaived.
  ///
  /// In en, this message translates to:
  /// **'Waived'**
  String get rentStatusWaived;

  /// No description provided for @tenantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tenants'**
  String get tenantsTitle;

  /// No description provided for @tenantsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or property'**
  String get tenantsSearchHint;

  /// No description provided for @tenantsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tenantsFilterAll;

  /// No description provided for @tenantsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tenantsStatusActive;

  /// No description provided for @tenantsStatusVacated.
  ///
  /// In en, this message translates to:
  /// **'Vacated'**
  String get tenantsStatusVacated;

  /// No description provided for @tenantsStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get tenantsStatusUnknown;

  /// No description provided for @tenantsNoProperty.
  ///
  /// In en, this message translates to:
  /// **'No property linked'**
  String get tenantsNoProperty;

  /// No description provided for @tenantsActiveLeases.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active lease} other{{count} active leases}}'**
  String tenantsActiveLeases(int count);

  /// No description provided for @tenantsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tenants yet'**
  String get tenantsEmptyTitle;

  /// No description provided for @tenantsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A tenant shows up here once you add them to a lease.'**
  String get tenantsEmptyBody;

  /// No description provided for @tenantsNewLease.
  ///
  /// In en, this message translates to:
  /// **'New lease'**
  String get tenantsNewLease;

  /// No description provided for @tenantsNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No tenants match'**
  String get tenantsNoMatchTitle;

  /// No description provided for @tenantsNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another name or filter.'**
  String get tenantsNoMatchBody;

  /// No description provided for @tenantDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenantDetailTitle;

  /// No description provided for @tenantDetailInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This tenant link is not valid.'**
  String get tenantDetailInvalidLink;

  /// No description provided for @tenantDetailContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get tenantDetailContact;

  /// No description provided for @tenantDetailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get tenantDetailPhone;

  /// No description provided for @tenantDetailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get tenantDetailEmail;

  /// No description provided for @tenantDetailNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get tenantDetailNotAdded;

  /// No description provided for @tenantDetailCall.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String tenantDetailCall(String name);

  /// No description provided for @tenantDetailWrite.
  ///
  /// In en, this message translates to:
  /// **'Email {name}'**
  String tenantDetailWrite(String name);

  /// No description provided for @tenantDetailLeases.
  ///
  /// In en, this message translates to:
  /// **'Leases'**
  String get tenantDetailLeases;

  /// No description provided for @tenantDetailNoLeases.
  ///
  /// In en, this message translates to:
  /// **'No leases yet.'**
  String get tenantDetailNoLeases;

  /// No description provided for @tenantDetailAllLeases.
  ///
  /// In en, this message translates to:
  /// **'All leases of this tenant'**
  String get tenantDetailAllLeases;

  /// No description provided for @tenantDetailInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get tenantDetailInspections;

  /// No description provided for @tenantDetailInspectionsHint.
  ///
  /// In en, this message translates to:
  /// **'Of the current lease'**
  String get tenantDetailInspectionsHint;

  /// No description provided for @tenantDetailInspectionsNone.
  ///
  /// In en, this message translates to:
  /// **'Needs a lease first'**
  String get tenantDetailInspectionsNone;

  /// No description provided for @tenantDetailOpenEnded.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get tenantDetailOpenEnded;

  /// No description provided for @tenantLeaseDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get tenantLeaseDraft;

  /// No description provided for @tenantLeasePendingSignature.
  ///
  /// In en, this message translates to:
  /// **'Pending signature'**
  String get tenantLeasePendingSignature;

  /// No description provided for @tenantLeaseActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tenantLeaseActive;

  /// No description provided for @tenantLeaseExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get tenantLeaseExpiringSoon;

  /// No description provided for @tenantLeaseExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get tenantLeaseExpired;

  /// No description provided for @tenantLeaseTerminated.
  ///
  /// In en, this message translates to:
  /// **'Terminated'**
  String get tenantLeaseTerminated;

  /// No description provided for @tenantLeaseRenewed.
  ///
  /// In en, this message translates to:
  /// **'Renewed'**
  String get tenantLeaseRenewed;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expensesAdd;

  /// No description provided for @expensesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title, category or property'**
  String get expensesSearchHint;

  /// No description provided for @expensesSpentIn.
  ///
  /// In en, this message translates to:
  /// **'Spent in {month}'**
  String expensesSpentIn(String month);

  /// No description provided for @expensesCountThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No expenses this month} =1{1 expense this month} other{{count} expenses this month}}'**
  String expensesCountThisMonth(int count);

  /// No description provided for @expensesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get expensesEmptyTitle;

  /// No description provided for @expensesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record repairs, bills and taxes to see where the money goes.'**
  String get expensesEmptyBody;

  /// No description provided for @expensesNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses match'**
  String get expensesNoMatchTitle;

  /// No description provided for @expensesNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or category.'**
  String get expensesNoMatchBody;

  /// No description provided for @expensesUntitled.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expensesUntitled;

  /// No description provided for @expensesCategoryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get expensesCategoryMaintenance;

  /// No description provided for @expensesCategoryRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get expensesCategoryRepairs;

  /// No description provided for @expensesCategoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get expensesCategoryInsurance;

  /// No description provided for @expensesCategoryPropertyTax.
  ///
  /// In en, this message translates to:
  /// **'Property tax'**
  String get expensesCategoryPropertyTax;

  /// No description provided for @expensesCategoryHoa.
  ///
  /// In en, this message translates to:
  /// **'HOA'**
  String get expensesCategoryHoa;

  /// No description provided for @expensesCategoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get expensesCategoryUtilities;

  /// No description provided for @expensesCategoryMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get expensesCategoryMarketing;

  /// No description provided for @expensesCategoryLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get expensesCategoryLegal;

  /// No description provided for @expensesCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expensesCategoryOther;

  /// No description provided for @expenseFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get expenseFormNewTitle;

  /// No description provided for @expenseFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get expenseFormEditTitle;

  /// No description provided for @expenseFormAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseFormAmount;

  /// No description provided for @expenseFormAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount above zero.'**
  String get expenseFormAmountError;

  /// No description provided for @expenseFormDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseFormDate;

  /// No description provided for @expenseFormProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get expenseFormProperty;

  /// No description provided for @expenseFormPropertyError.
  ///
  /// In en, this message translates to:
  /// **'Choose a property.'**
  String get expenseFormPropertyError;

  /// No description provided for @expenseFormPropertiesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your properties.'**
  String get expenseFormPropertiesFailed;

  /// No description provided for @expenseFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense title'**
  String get expenseFormTitleLabel;

  /// No description provided for @expenseFormTitleHint.
  ///
  /// In en, this message translates to:
  /// **'For example, plumbing repair'**
  String get expenseFormTitleHint;

  /// No description provided for @expenseFormCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseFormCategory;

  /// No description provided for @expenseFormNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get expenseFormNotes;

  /// No description provided for @expenseFormNotesHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get expenseFormNotesHelper;

  /// No description provided for @expenseFormDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get expenseFormDetails;

  /// No description provided for @expenseFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create expense'**
  String get expenseFormCreate;

  /// No description provided for @expenseFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get expenseFormSave;

  /// No description provided for @expenseFormSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved.'**
  String get expenseFormSaved;

  /// No description provided for @expenseFormNotFound.
  ///
  /// In en, this message translates to:
  /// **'This expense was not found.'**
  String get expenseFormNotFound;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get documentsUpload;

  /// No description provided for @documentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title or type'**
  String get documentsSearchHint;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Upload lease agreements, ID proofs and receipts to keep them in one place.'**
  String get documentsEmptyBody;

  /// No description provided for @documentsNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents match'**
  String get documentsNoMatchTitle;

  /// No description provided for @documentsNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or type.'**
  String get documentsNoMatchBody;

  /// No description provided for @documentsUntitled.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get documentsUntitled;

  /// No description provided for @documentsSharedWithTenant.
  ///
  /// In en, this message translates to:
  /// **'Shared with tenant'**
  String get documentsSharedWithTenant;

  /// No description provided for @documentsNoAccess.
  ///
  /// In en, this message translates to:
  /// **'You can\'t open this file.'**
  String get documentsNoAccess;

  /// No description provided for @documentsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file.'**
  String get documentsOpenFailed;

  /// No description provided for @documentsLocked.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get documentsLocked;

  /// No description provided for @documentTypeLeaseAgreement.
  ///
  /// In en, this message translates to:
  /// **'Lease agreement'**
  String get documentTypeLeaseAgreement;

  /// No description provided for @documentTypeIdProof.
  ///
  /// In en, this message translates to:
  /// **'ID proof'**
  String get documentTypeIdProof;

  /// No description provided for @documentTypeAddressProof.
  ///
  /// In en, this message translates to:
  /// **'Address proof'**
  String get documentTypeAddressProof;

  /// No description provided for @documentTypeIncomeProof.
  ///
  /// In en, this message translates to:
  /// **'Income proof'**
  String get documentTypeIncomeProof;

  /// No description provided for @documentTypeInspectionReport.
  ///
  /// In en, this message translates to:
  /// **'Inspection report'**
  String get documentTypeInspectionReport;

  /// No description provided for @documentTypeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get documentTypeReceipt;

  /// No description provided for @documentTypeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get documentTypeInvoice;

  /// No description provided for @documentTypePropertyDeed.
  ///
  /// In en, this message translates to:
  /// **'Property deed'**
  String get documentTypePropertyDeed;

  /// No description provided for @documentTypeInsurancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Insurance policy'**
  String get documentTypeInsurancePolicy;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get documentTypeOther;

  /// No description provided for @documentUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get documentUploadTitle;

  /// No description provided for @documentUploadChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get documentUploadChoose;

  /// No description provided for @documentUploadChange.
  ///
  /// In en, this message translates to:
  /// **'Choose another file'**
  String get documentUploadChange;

  /// No description provided for @documentUploadLimits.
  ///
  /// In en, this message translates to:
  /// **'PDF, image or document, up to 25 MB'**
  String get documentUploadLimits;

  /// No description provided for @documentUploadNoFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file to upload.'**
  String get documentUploadNoFile;

  /// No description provided for @documentUploadTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is over 25 MB. Choose a smaller one.'**
  String get documentUploadTooLarge;

  /// No description provided for @documentUploadPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the file picker. Try again.'**
  String get documentUploadPickFailed;

  /// No description provided for @documentUploadRemoveFile.
  ///
  /// In en, this message translates to:
  /// **'Remove file'**
  String get documentUploadRemoveFile;

  /// No description provided for @documentUploadDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get documentUploadDetails;

  /// No description provided for @documentUploadTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get documentUploadTitleLabel;

  /// No description provided for @documentUploadTitleHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to use the file name.'**
  String get documentUploadTitleHelper;

  /// No description provided for @documentUploadType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get documentUploadType;

  /// No description provided for @documentUploadSubmit.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get documentUploadSubmit;

  /// No description provided for @documentUploadUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get documentUploadUploading;

  /// No description provided for @documentUploadDone.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded.'**
  String get documentUploadDone;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsTypeRentRoll.
  ///
  /// In en, this message translates to:
  /// **'Rent roll'**
  String get reportsTypeRentRoll;

  /// No description provided for @reportsTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportsTypeIncome;

  /// No description provided for @reportsTypeExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsTypeExpenses;

  /// No description provided for @reportsTypePnl.
  ///
  /// In en, this message translates to:
  /// **'Profit and loss'**
  String get reportsTypePnl;

  /// No description provided for @reportsTypeOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get reportsTypeOccupancy;

  /// No description provided for @reportsTypeMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get reportsTypeMaintenance;

  /// No description provided for @reportsAboutRentRoll.
  ///
  /// In en, this message translates to:
  /// **'Rent of every property and whether it is let.'**
  String get reportsAboutRentRoll;

  /// No description provided for @reportsAboutIncome.
  ///
  /// In en, this message translates to:
  /// **'Rent collected in the period.'**
  String get reportsAboutIncome;

  /// No description provided for @reportsAboutExpenses.
  ///
  /// In en, this message translates to:
  /// **'Money spent in the period.'**
  String get reportsAboutExpenses;

  /// No description provided for @reportsAboutPnl.
  ///
  /// In en, this message translates to:
  /// **'Income less expenses in the period.'**
  String get reportsAboutPnl;

  /// No description provided for @reportsAboutOccupancy.
  ///
  /// In en, this message translates to:
  /// **'How many properties are let or vacant.'**
  String get reportsAboutOccupancy;

  /// No description provided for @reportsAboutMaintenance.
  ///
  /// In en, this message translates to:
  /// **'How many maintenance requests came in.'**
  String get reportsAboutMaintenance;

  /// No description provided for @reportsFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get reportsFrom;

  /// No description provided for @reportsTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get reportsTo;

  /// No description provided for @reportsAnyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get reportsAnyDate;

  /// No description provided for @reportsClearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get reportsClearDate;

  /// No description provided for @reportsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to report'**
  String get reportsEmptyTitle;

  /// No description provided for @reportsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'This report has no data for the period you chose.'**
  String get reportsEmptyBody;

  /// No description provided for @reportsBarsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 line} other{{count} lines}}. Highest: {label}, {amount}.'**
  String reportsBarsSummary(int count, String label, String amount);

  /// No description provided for @reportsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Share as CSV'**
  String get reportsExportCsv;

  /// No description provided for @reportDrilldownTitle.
  ///
  /// In en, this message translates to:
  /// **'Report line'**
  String get reportDrilldownTitle;

  /// No description provided for @reportDrilldownShare.
  ///
  /// In en, this message translates to:
  /// **'{percent} of {total}'**
  String reportDrilldownShare(String percent, String total);

  /// No description provided for @reportDrilldownRanking.
  ///
  /// In en, this message translates to:
  /// **'All lines, largest first'**
  String get reportDrilldownRanking;

  /// No description provided for @reportDrilldownNoAmounts.
  ///
  /// In en, this message translates to:
  /// **'This report has no amounts to compare.'**
  String get reportDrilldownNoAmounts;

  /// No description provided for @tenantsNoMatchLoaded.
  ///
  /// In en, this message translates to:
  /// **'None of the tenants loaded so far match.'**
  String get tenantsNoMatchLoaded;

  /// No description provided for @tenantsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more tenants'**
  String get tenantsLoadMore;

  /// No description provided for @propertiesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get propertiesFilterAll;

  /// No description provided for @propertiesFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get propertiesFilterActive;

  /// No description provided for @propertiesFilterOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get propertiesFilterOccupied;

  /// No description provided for @propertiesFilterVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get propertiesFilterVacant;

  /// No description provided for @propertiesFilterPg.
  ///
  /// In en, this message translates to:
  /// **'PG'**
  String get propertiesFilterPg;

  /// No description provided for @propertiesFilterFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get propertiesFilterFlat;

  /// No description provided for @propertiesViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get propertiesViewList;

  /// No description provided for @propertiesViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get propertiesViewGrid;

  /// No description provided for @propertiesSearchByLocation.
  ///
  /// In en, this message translates to:
  /// **'Search by location'**
  String get propertiesSearchByLocation;

  /// No description provided for @propertiesClearLocation.
  ///
  /// In en, this message translates to:
  /// **'Remove location filter'**
  String get propertiesClearLocation;

  /// No description provided for @propertiesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No properties yet'**
  String get propertiesEmptyTitle;

  /// No description provided for @propertiesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first property to start tracking rent.'**
  String get propertiesEmptyBody;

  /// No description provided for @propertiesNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No properties match'**
  String get propertiesNoResultsTitle;

  /// No description provided for @propertiesNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or filter.'**
  String get propertiesNoResultsBody;

  /// No description provided for @propertiesNoMatchYetBody.
  ///
  /// In en, this message translates to:
  /// **'None of the loaded properties match. Load more to keep looking.'**
  String get propertiesNoMatchYetBody;

  /// No description provided for @propertiesLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get propertiesLoadMore;

  /// No description provided for @propertiesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get propertiesPerMonth;

  /// No description provided for @propertyTypeHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get propertyTypeHouse;

  /// No description provided for @propertyTypeApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get propertyTypeApartment;

  /// No description provided for @propertyTypeBuilderFloor.
  ///
  /// In en, this message translates to:
  /// **'Builder floor'**
  String get propertyTypeBuilderFloor;

  /// No description provided for @propertyTypeRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get propertyTypeRoom;

  /// No description provided for @propertyTypeVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get propertyTypeVilla;

  /// No description provided for @propertyTypePlot.
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get propertyTypePlot;

  /// No description provided for @propertyTypeCondo.
  ///
  /// In en, this message translates to:
  /// **'Condo'**
  String get propertyTypeCondo;

  /// No description provided for @propertyTypePenthouse.
  ///
  /// In en, this message translates to:
  /// **'Penthouse'**
  String get propertyTypePenthouse;

  /// No description provided for @propertyTypeStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get propertyTypeStudio;

  /// No description provided for @propertyTypeLoft.
  ///
  /// In en, this message translates to:
  /// **'Loft'**
  String get propertyTypeLoft;

  /// No description provided for @propertyTypePg.
  ///
  /// In en, this message translates to:
  /// **'PG'**
  String get propertyTypePg;

  /// No description provided for @propertyTypeFlatmate.
  ///
  /// In en, this message translates to:
  /// **'Flatmate'**
  String get propertyTypeFlatmate;

  /// No description provided for @propertyTypeOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get propertyTypeOffice;

  /// No description provided for @propertyTypeShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get propertyTypeShop;

  /// No description provided for @propertyTypeWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get propertyTypeWarehouse;

  /// No description provided for @propertyStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get propertyStatusDraft;

  /// No description provided for @propertyStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get propertyStatusActive;

  /// No description provided for @propertyStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get propertyStatusArchived;

  /// No description provided for @propertyFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get propertyFallbackName;

  /// No description provided for @propertyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Property details'**
  String get propertyDetailTitle;

  /// No description provided for @propertyEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit property'**
  String get propertyEdit;

  /// No description provided for @propertyShowOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get propertyShowOnMap;

  /// No description provided for @propertyMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get propertyMoreActions;

  /// No description provided for @propertyArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive property'**
  String get propertyArchive;

  /// No description provided for @propertyArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive this property?'**
  String get propertyArchiveConfirmTitle;

  /// No description provided for @propertyArchiveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It leaves the active list and keeps its history. You can make it active again from Edit.'**
  String get propertyArchiveConfirmBody;

  /// No description provided for @propertyArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get propertyArchiveAction;

  /// No description provided for @propertyArchived.
  ///
  /// In en, this message translates to:
  /// **'Property archived'**
  String get propertyArchived;

  /// No description provided for @propertyArchiveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t archive: {reason}'**
  String propertyArchiveFailed(String reason);

  /// No description provided for @propertyDepositValue.
  ///
  /// In en, this message translates to:
  /// **'Deposit {amount}'**
  String propertyDepositValue(String amount);

  /// No description provided for @propertyCreateLease.
  ///
  /// In en, this message translates to:
  /// **'Create lease'**
  String get propertyCreateLease;

  /// No description provided for @propertyTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get propertyTabOverview;

  /// No description provided for @propertyTabLease.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get propertyTabLease;

  /// No description provided for @propertyTabRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get propertyTabRent;

  /// No description provided for @propertyTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get propertyTabExpenses;

  /// No description provided for @propertyTabMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get propertyTabMaintenance;

  /// No description provided for @propertyTabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get propertyTabDocuments;

  /// No description provided for @propertyTabInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get propertyTabInspections;

  /// No description provided for @propertyPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get propertyPhotos;

  /// No description provided for @propertyFloorPlans.
  ///
  /// In en, this message translates to:
  /// **'Floor plans'**
  String get propertyFloorPlans;

  /// No description provided for @propertyPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo {index} of {total}'**
  String propertyPhotoLabel(int index, int total);

  /// No description provided for @propertySpecs.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get propertySpecs;

  /// No description provided for @propertyTypeField.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get propertyTypeField;

  /// No description provided for @propertyFloorArea.
  ///
  /// In en, this message translates to:
  /// **'Floor area'**
  String get propertyFloorArea;

  /// No description provided for @propertyAreaValue.
  ///
  /// In en, this message translates to:
  /// **'{area} sq ft'**
  String propertyAreaValue(String area);

  /// No description provided for @propertyBedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get propertyBedrooms;

  /// No description provided for @propertyBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get propertyBathrooms;

  /// No description provided for @propertyBalconies.
  ///
  /// In en, this message translates to:
  /// **'Balconies'**
  String get propertyBalconies;

  /// No description provided for @propertyAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get propertyAge;

  /// No description provided for @propertyYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year} other{{count} years}}'**
  String propertyYears(int count);

  /// No description provided for @propertyDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String propertyDays(int count);

  /// No description provided for @propertyAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get propertyAmenities;

  /// No description provided for @propertyRentTerms.
  ///
  /// In en, this message translates to:
  /// **'Rent and collection'**
  String get propertyRentTerms;

  /// No description provided for @propertyMonthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get propertyMonthlyRent;

  /// No description provided for @propertySecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get propertySecurityDeposit;

  /// No description provided for @propertyDueDayNewLeases.
  ///
  /// In en, this message translates to:
  /// **'Due day (new leases)'**
  String get propertyDueDayNewLeases;

  /// No description provided for @propertyDueDayValue.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String propertyDueDayValue(int day);

  /// No description provided for @propertyGraceNewLeases.
  ///
  /// In en, this message translates to:
  /// **'Grace period (new leases)'**
  String get propertyGraceNewLeases;

  /// No description provided for @propertyDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get propertyDescription;

  /// No description provided for @propertyCurrentLease.
  ///
  /// In en, this message translates to:
  /// **'Current lease'**
  String get propertyCurrentLease;

  /// No description provided for @propertyLeaseTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get propertyLeaseTenant;

  /// No description provided for @propertyLeaseStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get propertyLeaseStart;

  /// No description provided for @propertyLeaseEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get propertyLeaseEnd;

  /// No description provided for @propertyLeaseRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get propertyLeaseRent;

  /// No description provided for @propertyLeaseEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get propertyLeaseEndsIn;

  /// No description provided for @propertyLeaseEndsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get propertyLeaseEndsToday;

  /// No description provided for @propertyNoLeaseTitle.
  ///
  /// In en, this message translates to:
  /// **'No lease yet'**
  String get propertyNoLeaseTitle;

  /// No description provided for @propertyNoLeaseBody.
  ///
  /// In en, this message translates to:
  /// **'Create a lease to start collecting rent here.'**
  String get propertyNoLeaseBody;

  /// No description provided for @propertyNoRentTitle.
  ///
  /// In en, this message translates to:
  /// **'No rent charges'**
  String get propertyNoRentTitle;

  /// No description provided for @propertyNoRentBody.
  ///
  /// In en, this message translates to:
  /// **'Charges for this property show up here once a lease is active.'**
  String get propertyNoRentBody;

  /// No description provided for @propertyOpenCollections.
  ///
  /// In en, this message translates to:
  /// **'Open collections'**
  String get propertyOpenCollections;

  /// No description provided for @propertyChargeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String propertyChargeBalance(String amount);

  /// No description provided for @propertyChargeLateFee.
  ///
  /// In en, this message translates to:
  /// **'Late fee {amount}'**
  String propertyChargeLateFee(String amount);

  /// No description provided for @propertyChargeDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String propertyChargeDue(String date);

  /// No description provided for @propertyLeaseNumber.
  ///
  /// In en, this message translates to:
  /// **'Lease #{id}'**
  String propertyLeaseNumber(String id);

  /// No description provided for @propertyNoExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get propertyNoExpensesTitle;

  /// No description provided for @propertyNoExpensesBody.
  ///
  /// In en, this message translates to:
  /// **'Expenses you log for this property show up here.'**
  String get propertyNoExpensesBody;

  /// No description provided for @propertyAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get propertyAddExpense;

  /// No description provided for @propertyNoMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'No maintenance requests'**
  String get propertyNoMaintenanceTitle;

  /// No description provided for @propertyNoMaintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'Requests and repairs for this property show up here.'**
  String get propertyNoMaintenanceBody;

  /// No description provided for @propertyNewTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get propertyNewTask;

  /// No description provided for @propertyNoDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get propertyNoDocumentsTitle;

  /// No description provided for @propertyNoDocumentsBody.
  ///
  /// In en, this message translates to:
  /// **'Agreements, receipts and IDs for this property show up here.'**
  String get propertyNoDocumentsBody;

  /// No description provided for @propertyUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get propertyUploadDocument;

  /// No description provided for @propertyNoInspectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No inspections'**
  String get propertyNoInspectionsTitle;

  /// No description provided for @propertyNoInspectionsBody.
  ///
  /// In en, this message translates to:
  /// **'Move-in and move-out checks for this property show up here.'**
  String get propertyNoInspectionsBody;

  /// No description provided for @propertyNewInspection.
  ///
  /// In en, this message translates to:
  /// **'New inspection'**
  String get propertyNewInspection;

  /// No description provided for @propertyCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String propertyCreatedOn(String date);

  /// No description provided for @propertyUploadedOn.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {date}'**
  String propertyUploadedOn(String date);

  /// No description provided for @propertyConductedOn.
  ///
  /// In en, this message translates to:
  /// **'Conducted {date}'**
  String propertyConductedOn(String date);

  /// No description provided for @propertyNew.
  ///
  /// In en, this message translates to:
  /// **'New property'**
  String get propertyNew;

  /// No description provided for @propertyStepBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get propertyStepBasics;

  /// No description provided for @propertyStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get propertyStepLocation;

  /// No description provided for @propertyStepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String propertyStepCounter(int step, int total);

  /// No description provided for @propertyNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get propertyNext;

  /// No description provided for @propertyCreate.
  ///
  /// In en, this message translates to:
  /// **'Create property'**
  String get propertyCreate;

  /// No description provided for @propertySaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get propertySaveChanges;

  /// No description provided for @propertyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Property name *'**
  String get propertyNameLabel;

  /// No description provided for @propertyNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Green Valley PG'**
  String get propertyNameHint;

  /// No description provided for @propertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Property type *'**
  String get propertyTypeLabel;

  /// No description provided for @propertyStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Management status'**
  String get propertyStatusLabel;

  /// No description provided for @propertyDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Rooms, rules, anything a tenant should know'**
  String get propertyDescriptionHint;

  /// No description provided for @propertySetMapLocation.
  ///
  /// In en, this message translates to:
  /// **'Set map location'**
  String get propertySetMapLocation;

  /// No description provided for @propertyChangeMapLocation.
  ///
  /// In en, this message translates to:
  /// **'Change map location'**
  String get propertyChangeMapLocation;

  /// No description provided for @propertyClearMapLocation.
  ///
  /// In en, this message translates to:
  /// **'Remove map location'**
  String get propertyClearMapLocation;

  /// No description provided for @propertyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address line'**
  String get propertyAddressLabel;

  /// No description provided for @propertyAddressHint.
  ///
  /// In en, this message translates to:
  /// **'House, street, area'**
  String get propertyAddressHint;

  /// No description provided for @propertyCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get propertyCityLabel;

  /// No description provided for @propertyCityHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Pune'**
  String get propertyCityHint;

  /// No description provided for @propertyStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get propertyStateLabel;

  /// No description provided for @propertyPincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get propertyPincodeLabel;

  /// No description provided for @propertyAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor area (sq ft)'**
  String get propertyAreaLabel;

  /// No description provided for @propertyAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get propertyAgeLabel;

  /// No description provided for @propertyAmenitiesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load amenities.'**
  String get propertyAmenitiesFailed;

  /// No description provided for @propertyRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent (₹) *'**
  String get propertyRentLabel;

  /// No description provided for @propertyDepositLabel.
  ///
  /// In en, this message translates to:
  /// **'Security deposit (₹)'**
  String get propertyDepositLabel;

  /// No description provided for @propertyDueDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment due day'**
  String get propertyDueDayLabel;

  /// No description provided for @propertyDueDayHelper.
  ///
  /// In en, this message translates to:
  /// **'1 to 28'**
  String get propertyDueDayHelper;

  /// No description provided for @propertyGraceLabel.
  ///
  /// In en, this message translates to:
  /// **'Grace period (days)'**
  String get propertyGraceLabel;

  /// No description provided for @propertyGraceHelper.
  ///
  /// In en, this message translates to:
  /// **'0 to 365'**
  String get propertyGraceHelper;

  /// No description provided for @propertyRentTermsNote.
  ///
  /// In en, this message translates to:
  /// **'New leases start with these values. A late fee is charged once, after the grace period, when the lease has one.'**
  String get propertyRentTermsNote;

  /// No description provided for @propertyAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get propertyAddPhotos;

  /// No description provided for @propertyAddFloorPlans.
  ///
  /// In en, this message translates to:
  /// **'Add floor plans'**
  String get propertyAddFloorPlans;

  /// No description provided for @propertyMediaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} added'**
  String propertyMediaCount(int count, int max);

  /// No description provided for @propertyRemoveMedia.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get propertyRemoveMedia;

  /// No description provided for @propertyMediaLimit.
  ///
  /// In en, this message translates to:
  /// **'You can add up to {max}.'**
  String propertyMediaLimit(int max);

  /// No description provided for @propertyErrorName.
  ///
  /// In en, this message translates to:
  /// **'Enter a property name'**
  String get propertyErrorName;

  /// No description provided for @propertyErrorType.
  ///
  /// In en, this message translates to:
  /// **'Choose a property type'**
  String get propertyErrorType;

  /// No description provided for @propertyErrorCity.
  ///
  /// In en, this message translates to:
  /// **'Enter a city'**
  String get propertyErrorCity;

  /// No description provided for @propertyErrorRent.
  ///
  /// In en, this message translates to:
  /// **'Enter the monthly rent'**
  String get propertyErrorRent;

  /// No description provided for @propertyErrorDueDay.
  ///
  /// In en, this message translates to:
  /// **'Use a day from 1 to 28'**
  String get propertyErrorDueDay;

  /// No description provided for @propertyErrorGrace.
  ///
  /// In en, this message translates to:
  /// **'Use 0 to 365 days'**
  String get propertyErrorGrace;

  /// No description provided for @propertyCreated.
  ///
  /// In en, this message translates to:
  /// **'Property created'**
  String get propertyCreated;

  /// No description provided for @propertyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Property saved'**
  String get propertyUpdated;

  /// No description provided for @propertySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save: {reason}'**
  String propertySaveFailed(String reason);

  /// No description provided for @propertyUploadsFailed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file did not upload} other{{count} files did not upload}}. Save again to retry.'**
  String propertyUploadsFailed(int count);

  /// No description provided for @propertyDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get propertyDiscardTitle;

  /// No description provided for @propertyDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your changes on this form are not saved yet.'**
  String get propertyDiscardBody;

  /// No description provided for @propertyDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get propertyDiscard;

  /// No description provided for @locationSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get locationSearchTitle;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'City, area or landmark'**
  String get locationSearchHint;

  /// No description provided for @locationUseCurrent.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get locationUseCurrent;

  /// No description provided for @locationDetecting.
  ///
  /// In en, this message translates to:
  /// **'Finding your location'**
  String get locationDetecting;

  /// No description provided for @locationCurrentName.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get locationCurrentName;

  /// No description provided for @locationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn them on to use this.'**
  String get locationServicesOff;

  /// No description provided for @locationSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get locationSettings;

  /// No description provided for @locationPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to use your current location.'**
  String get locationPermissionNeeded;

  /// No description provided for @locationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location access is blocked. Allow it in Settings.'**
  String get locationPermissionBlocked;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find your location.'**
  String get locationFailed;

  /// No description provided for @locationDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that place. Try another one.'**
  String get locationDetailsFailed;

  /// No description provided for @locationIdleTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a place'**
  String get locationIdleTitle;

  /// No description provided for @locationIdleBody.
  ///
  /// In en, this message translates to:
  /// **'Type at least two letters of a city, area or landmark.'**
  String get locationIdleBody;

  /// No description provided for @locationNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get locationNoResultsTitle;

  /// No description provided for @locationNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Check the spelling or try a nearby area.'**
  String get locationNoResultsBody;

  /// No description provided for @locationSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search places.'**
  String get locationSearchFailed;

  /// No description provided for @mapZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mapZoomIn;

  /// No description provided for @mapZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mapZoomOut;

  /// No description provided for @tenantDetailPeriod.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String tenantDetailPeriod(String start, String end);

  /// No description provided for @tenantDetailSince.
  ///
  /// In en, this message translates to:
  /// **'Since {start}'**
  String tenantDetailSince(String start);

  /// No description provided for @commonPropertyNumber.
  ///
  /// In en, this message translates to:
  /// **'Property #{id}'**
  String commonPropertyNumber(String id);

  /// No description provided for @commonLeaseNumber.
  ///
  /// In en, this message translates to:
  /// **'Lease #{id}'**
  String commonLeaseNumber(String id);

  /// No description provided for @commonNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get commonNotSet;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get commonSaving;

  /// No description provided for @commonClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get commonClearFilters;

  /// No description provided for @commonClearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get commonClearDate;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @collectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTitle;

  /// No description provided for @collectionsGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate this month\'s charges'**
  String get collectionsGenerate;

  /// No description provided for @collectionsGenerateShort.
  ///
  /// In en, this message translates to:
  /// **'Generate charges'**
  String get collectionsGenerateShort;

  /// No description provided for @collectionsGenerated.
  ///
  /// In en, this message translates to:
  /// **'{created} charges created, {skipped} skipped.'**
  String collectionsGenerated(int created, int skipped);

  /// No description provided for @collectionsCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collectionsCollected;

  /// No description provided for @collectionsCollectedShare.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of billed rent collected'**
  String collectionsCollectedShare(String percent);

  /// No description provided for @collectionsTotalsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the totals.'**
  String get collectionsTotalsFailed;

  /// No description provided for @collectionsEmptyDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing is due'**
  String get collectionsEmptyDue;

  /// No description provided for @collectionsEmptyDueBody.
  ///
  /// In en, this message translates to:
  /// **'Generate this month\'s charges to start collecting rent.'**
  String get collectionsEmptyDueBody;

  /// No description provided for @collectionsEmptyPartial.
  ///
  /// In en, this message translates to:
  /// **'No partly paid charges'**
  String get collectionsEmptyPartial;

  /// No description provided for @collectionsEmptyOverdue.
  ///
  /// In en, this message translates to:
  /// **'Nothing is overdue'**
  String get collectionsEmptyOverdue;

  /// No description provided for @collectionsEmptyPaid.
  ///
  /// In en, this message translates to:
  /// **'No paid charges yet'**
  String get collectionsEmptyPaid;

  /// No description provided for @collectionsEmptyWaived.
  ///
  /// In en, this message translates to:
  /// **'No waived charges'**
  String get collectionsEmptyWaived;

  /// No description provided for @collectionsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Charges show up here as their status changes.'**
  String get collectionsEmptyBody;

  /// No description provided for @collectionsDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String collectionsDueOn(String date);

  /// No description provided for @collectionsNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get collectionsNoDueDate;

  /// No description provided for @collectionsPaidOf.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {total} paid'**
  String collectionsPaidOf(String paid, String total);

  /// No description provided for @collectionsLateFee.
  ///
  /// In en, this message translates to:
  /// **'Late fee {amount}'**
  String collectionsLateFee(String amount);

  /// No description provided for @collectionsDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day overdue} other{{count} days overdue}}'**
  String collectionsDaysOverdue(int count);

  /// No description provided for @collectionsRemind.
  ///
  /// In en, this message translates to:
  /// **'Send a reminder'**
  String get collectionsRemind;

  /// No description provided for @collectionsReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {tenant}, a reminder that your rent of {amount} for {property} is due on {date}. Thank you.'**
  String collectionsReminderMessage(
    String tenant,
    String amount,
    String property,
    String date,
  );

  /// No description provided for @collectionsSoon.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get collectionsSoon;

  /// No description provided for @collectionsNoMessagingApp.
  ///
  /// In en, this message translates to:
  /// **'No messaging app is available to send the reminder.'**
  String get collectionsNoMessagingApp;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get paymentTitle;

  /// No description provided for @paymentChargeLabel.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get paymentChargeLabel;

  /// No description provided for @paymentChargeRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose the charge this payment is for.'**
  String get paymentChargeRequired;

  /// No description provided for @paymentNoCharges.
  ///
  /// In en, this message translates to:
  /// **'No charge is waiting for a payment.'**
  String get paymentNoCharges;

  /// No description provided for @paymentOwed.
  ///
  /// In en, this message translates to:
  /// **'{amount} owed'**
  String paymentOwed(String amount);

  /// No description provided for @paymentBilled.
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get paymentBilled;

  /// No description provided for @paymentPaidSoFar.
  ///
  /// In en, this message translates to:
  /// **'Paid so far'**
  String get paymentPaidSoFar;

  /// No description provided for @paymentBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get paymentBalance;

  /// No description provided for @paymentDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentDetailsSection;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get paymentAmountLabel;

  /// No description provided for @paymentAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'Starts at what the tenant still owes.'**
  String get paymentAmountHelper;

  /// No description provided for @paymentAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount above zero.'**
  String get paymentAmountInvalid;

  /// No description provided for @paymentAmountTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Enter at most {amount}, the balance of this charge.'**
  String paymentAmountTooHigh(String amount);

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentMethodUpi;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get paymentMethodCheque;

  /// No description provided for @paymentMethodOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get paymentMethodOnline;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date received'**
  String get paymentDateLabel;

  /// No description provided for @paymentNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get paymentNotesLabel;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get paymentRecorded;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksNew.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksNew;

  /// No description provided for @tasksViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tasksViewList;

  /// No description provided for @tasksViewBoard.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get tasksViewBoard;

  /// No description provided for @tasksFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tasksFilterOpen;

  /// No description provided for @tasksFilterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tasksFilterInProgress;

  /// No description provided for @tasksFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksFilterDone;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Report a repair or a chore and track it here.'**
  String get tasksEmptyBody;

  /// No description provided for @tasksEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks here'**
  String get tasksEmptyFilteredTitle;

  /// No description provided for @tasksEmptyFilteredBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this filter.'**
  String get tasksEmptyFilteredBody;

  /// No description provided for @tasksReportedOn.
  ///
  /// In en, this message translates to:
  /// **'Reported {date}'**
  String tasksReportedOn(String date);

  /// No description provided for @tasksVisitOn.
  ///
  /// In en, this message translates to:
  /// **'Visit {date}'**
  String tasksVisitOn(String date);

  /// No description provided for @tasksLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get tasksLoadMore;

  /// No description provided for @taskStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get taskStatusOpen;

  /// No description provided for @taskStatusInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get taskStatusInReview;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get taskStatusResolved;

  /// No description provided for @taskStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get taskStatusClosed;

  /// No description provided for @taskUrgencyLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskUrgencyLow;

  /// No description provided for @taskUrgencyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get taskUrgencyMedium;

  /// No description provided for @taskUrgencyHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskUrgencyHigh;

  /// No description provided for @taskUrgencyEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get taskUrgencyEmergency;

  /// No description provided for @taskCategoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get taskCategoryPlumbing;

  /// No description provided for @taskCategoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get taskCategoryElectrical;

  /// No description provided for @taskCategoryHvac.
  ///
  /// In en, this message translates to:
  /// **'HVAC'**
  String get taskCategoryHvac;

  /// No description provided for @taskCategoryAppliance.
  ///
  /// In en, this message translates to:
  /// **'Appliance'**
  String get taskCategoryAppliance;

  /// No description provided for @taskCategoryStructural.
  ///
  /// In en, this message translates to:
  /// **'Structural'**
  String get taskCategoryStructural;

  /// No description provided for @taskCategoryPestControl.
  ///
  /// In en, this message translates to:
  /// **'Pest control'**
  String get taskCategoryPestControl;

  /// No description provided for @taskCategoryCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get taskCategoryCleaning;

  /// No description provided for @taskCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get taskCategoryOther;

  /// No description provided for @taskCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskCreateTitle;

  /// No description provided for @taskSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'What needs doing'**
  String get taskSectionDetails;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Fix the leaking kitchen tap'**
  String get taskTitleHint;

  /// No description provided for @taskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get taskTitleRequired;

  /// No description provided for @taskTitleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters.'**
  String get taskTitleTooShort;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskDescriptionLabel;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is wrong, and where?'**
  String get taskDescriptionHint;

  /// No description provided for @taskSectionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get taskSectionCategory;

  /// No description provided for @taskPropertyLabel.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get taskPropertyLabel;

  /// No description provided for @taskPropertyRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a property.'**
  String get taskPropertyRequired;

  /// No description provided for @taskNoProperties.
  ///
  /// In en, this message translates to:
  /// **'Add a property before you create tasks.'**
  String get taskNoProperties;

  /// No description provided for @taskAddProperty.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get taskAddProperty;

  /// No description provided for @taskLeaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Lease (optional)'**
  String get taskLeaseLabel;

  /// No description provided for @taskNoLease.
  ///
  /// In en, this message translates to:
  /// **'No lease'**
  String get taskNoLease;

  /// No description provided for @taskSectionUrgency.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get taskSectionUrgency;

  /// No description provided for @taskSectionCost.
  ///
  /// In en, this message translates to:
  /// **'Cost and visit'**
  String get taskSectionCost;

  /// No description provided for @taskCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost (optional)'**
  String get taskCostLabel;

  /// No description provided for @taskCostInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 or more.'**
  String get taskCostInvalid;

  /// No description provided for @taskVisitLabel.
  ///
  /// In en, this message translates to:
  /// **'Visit date (optional)'**
  String get taskVisitLabel;

  /// No description provided for @taskAssignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign to {name}'**
  String taskAssignTo(String name);

  /// No description provided for @taskAssignHelp.
  ///
  /// In en, this message translates to:
  /// **'Your agent handles this request.'**
  String get taskAssignHelp;

  /// No description provided for @taskCreate.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get taskCreate;

  /// No description provided for @taskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created.'**
  String get taskCreated;

  /// No description provided for @taskDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskDetailTitle;

  /// No description provided for @taskNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFoundTitle;

  /// No description provided for @taskNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed. Go back to the list.'**
  String get taskNotFoundBody;

  /// No description provided for @taskInvalidId.
  ///
  /// In en, this message translates to:
  /// **'This link does not point to a task.'**
  String get taskInvalidId;

  /// No description provided for @taskGoBack.
  ///
  /// In en, this message translates to:
  /// **'Back to tasks'**
  String get taskGoBack;

  /// No description provided for @taskSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get taskSectionInfo;

  /// No description provided for @taskCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get taskCategoryLabel;

  /// No description provided for @taskTenantLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get taskTenantLabel;

  /// No description provided for @taskEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost'**
  String get taskEstimatedCost;

  /// No description provided for @taskScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get taskScheduledFor;

  /// No description provided for @taskAssignedAgent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get taskAssignedAgent;

  /// No description provided for @taskAgentNumber.
  ///
  /// In en, this message translates to:
  /// **'Agent #{id}'**
  String taskAgentNumber(String id);

  /// No description provided for @taskReported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get taskReported;

  /// No description provided for @taskSectionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get taskSectionUpdate;

  /// No description provided for @taskStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskStatusLabel;

  /// No description provided for @taskUrgencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get taskUrgencyLabel;

  /// No description provided for @taskNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion notes'**
  String get taskNotesLabel;

  /// No description provided for @taskNotesHint.
  ///
  /// In en, this message translates to:
  /// **'What was done, and by whom'**
  String get taskNotesHint;

  /// No description provided for @taskSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get taskSave;

  /// No description provided for @taskNothingToSave.
  ///
  /// In en, this message translates to:
  /// **'Nothing changed.'**
  String get taskNothingToSave;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated.'**
  String get taskUpdated;

  /// No description provided for @taskProgressSemantics.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4: {label}'**
  String taskProgressSemantics(int step, String label);

  /// No description provided for @leasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Leases'**
  String get leasesTitle;

  /// No description provided for @leasesNew.
  ///
  /// In en, this message translates to:
  /// **'New lease'**
  String get leasesNew;

  /// No description provided for @leasesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tenant or property'**
  String get leasesSearchHint;

  /// No description provided for @leasesFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get leasesFilterActive;

  /// No description provided for @leasesFilterExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get leasesFilterExpiring;

  /// No description provided for @leasesFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get leasesFilterUpcoming;

  /// No description provided for @leasesFilterEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get leasesFilterEnded;

  /// No description provided for @leasesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No leases yet'**
  String get leasesEmptyTitle;

  /// No description provided for @leasesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a lease to start collecting rent.'**
  String get leasesEmptyBody;

  /// No description provided for @leasesNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No leases match'**
  String get leasesNoMatchTitle;

  /// No description provided for @leasesNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another name or filter.'**
  String get leasesNoMatchBody;

  /// No description provided for @leasesTerm.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String leasesTerm(String start, String end);

  /// No description provided for @leasesEndsToday.
  ///
  /// In en, this message translates to:
  /// **'Ends today'**
  String get leasesEndsToday;

  /// No description provided for @leasesEndsIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ends in 1 day} other{Ends in {count} days}}'**
  String leasesEndsIn(int count);

  /// No description provided for @leaseStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get leaseStatusDraft;

  /// No description provided for @leaseStatusPendingSignature.
  ///
  /// In en, this message translates to:
  /// **'Pending signature'**
  String get leaseStatusPendingSignature;

  /// No description provided for @leaseStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get leaseStatusActive;

  /// No description provided for @leaseStatusExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get leaseStatusExpiringSoon;

  /// No description provided for @leaseStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get leaseStatusExpired;

  /// No description provided for @leaseStatusTerminated.
  ///
  /// In en, this message translates to:
  /// **'Terminated'**
  String get leaseStatusTerminated;

  /// No description provided for @leaseStatusRenewed.
  ///
  /// In en, this message translates to:
  /// **'Renewed'**
  String get leaseStatusRenewed;

  /// No description provided for @authEntryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Rent, tenants and repairs in one ledger.'**
  String get authEntryHeadline;

  /// No description provided for @authEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in, or create your account.'**
  String get authEntrySubtitle;

  /// No description provided for @authIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get authIdentifierLabel;

  /// No description provided for @authIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com or 98765 43210'**
  String get authIdentifierHint;

  /// No description provided for @authIdentifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number.'**
  String get authIdentifierRequired;

  /// No description provided for @authIdentifierInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email or phone number.'**
  String get authIdentifierInvalid;

  /// No description provided for @authCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'We send a verification code if you have no password.'**
  String get authCodeHelper;

  /// No description provided for @authUseMyNumber.
  ///
  /// In en, this message translates to:
  /// **'Use my number'**
  String get authUseMyNumber;

  /// No description provided for @authLastUsedGoogle.
  ///
  /// In en, this message translates to:
  /// **'Last time you used Google.'**
  String get authLastUsedGoogle;

  /// No description provided for @authLastUsedApple.
  ///
  /// In en, this message translates to:
  /// **'Last time you used Apple.'**
  String get authLastUsedApple;

  /// No description provided for @authLastUsedEmail.
  ///
  /// In en, this message translates to:
  /// **'Last time you used {masked}.'**
  String authLastUsedEmail(String masked);

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authTermsSentence.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the {terms} and the {privacy}.'**
  String authTermsSentence(String terms, String privacy);

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms} and the {privacy}.'**
  String authAgreeTerms(String terms, String privacy);

  /// No description provided for @authAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Accept the terms to continue.'**
  String get authAcceptTerms;

  /// No description provided for @authUnverifiedNotice.
  ///
  /// In en, this message translates to:
  /// **'Your account is not verified yet. Enter the code we sent, or ask for a new one.'**
  String get authUnverifiedNotice;

  /// No description provided for @authCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t check your account. Try again.'**
  String get authCheckFailed;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account uses this email or phone. Check it, or create an account.'**
  String get authNoAccount;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to sign in.'**
  String get authLoginSubtitle;

  /// No description provided for @authChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get authChange;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get authPhone;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'98765 43210'**
  String get authPhoneHint;

  /// No description provided for @authPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number.'**
  String get authPhoneInvalid;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your password. It has at least 6 characters.'**
  String get authPasswordInvalid;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get authNewHere;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetTitle;

  /// No description provided for @authResetBody.
  ///
  /// In en, this message translates to:
  /// **'We send a code to this number. Then you set a new password.'**
  String get authResetBody;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authSendCode;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few details, then we verify your phone.'**
  String get authSignupSubtitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name.'**
  String get authFullNameRequired;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authEmailInvalid;

  /// No description provided for @authNewPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters.'**
  String get authNewPasswordHelper;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get authPasswordTooShort;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the password again.'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsDiffer.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get authPasswordsDiffer;

  /// No description provided for @authVerifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone'**
  String get authVerifyPhoneTitle;

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get authVerifyEmailTitle;

  /// No description provided for @authCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to {destination}.'**
  String authCodeSentTo(String destination);

  /// No description provided for @authCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get authCodeLabel;

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerify;

  /// No description provided for @authDidNotGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get authDidNotGetCode;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authResendIn(int seconds);

  /// No description provided for @authSetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your password'**
  String get authSetPasswordTitle;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authResetPasswordTitle;

  /// No description provided for @authSetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Create a password so you can sign in faster next time.'**
  String get authSetPasswordBody;

  /// No description provided for @authResetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get authResetPasswordBody;

  /// No description provided for @authPasswordFor.
  ///
  /// In en, this message translates to:
  /// **'For {account}'**
  String authPasswordFor(String account);

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPassword;

  /// No description provided for @authSetPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Set password and continue'**
  String get authSetPasswordAction;

  /// No description provided for @authResetPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Reset password and continue'**
  String get authResetPasswordAction;

  /// No description provided for @authUseDifferentAccount.
  ///
  /// In en, this message translates to:
  /// **'Use a different account'**
  String get authUseDifferentAccount;

  /// No description provided for @authLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password to continue'**
  String get authLeaveTitle;

  /// No description provided for @authLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'A password is needed to finish signing in. Leaving signs you out.'**
  String get authLeaveBody;

  /// No description provided for @authAddPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your phone'**
  String get authAddPhoneTitle;

  /// No description provided for @authAddPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. A verified number helps you recover your account and sign in faster.'**
  String get authAddPhoneBody;

  /// No description provided for @authVerifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get authVerifyAndContinue;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get authSkipForNow;

  /// No description provided for @authProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'A few more details'**
  String get authProfileTitle;

  /// No description provided for @authProfileBody.
  ///
  /// In en, this message translates to:
  /// **'We need your full name and date of birth to continue.'**
  String get authProfileBody;

  /// No description provided for @authDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get authDateOfBirth;

  /// No description provided for @authDateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'Choose your date of birth'**
  String get authDateOfBirthHint;

  /// No description provided for @authDateOfBirthRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose your date of birth.'**
  String get authDateOfBirthRequired;

  /// No description provided for @authProfileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your details. Try again.'**
  String get authProfileSaveFailed;

  /// No description provided for @authSplashTagline.
  ///
  /// In en, this message translates to:
  /// **'Property management, done right.'**
  String get authSplashTagline;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ledger is ready'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Start with one property. Then add tenants, record rent as it comes in, and track repairs, all in one place.'**
  String get onboardingBody;

  /// No description provided for @onboardingStepProperty.
  ///
  /// In en, this message translates to:
  /// **'Add a property'**
  String get onboardingStepProperty;

  /// No description provided for @onboardingStepTenants.
  ///
  /// In en, this message translates to:
  /// **'Add tenants and leases'**
  String get onboardingStepTenants;

  /// No description provided for @onboardingStepRent.
  ///
  /// In en, this message translates to:
  /// **'Record rent every month'**
  String get onboardingStepRent;

  /// No description provided for @onboardingAddProperty.
  ///
  /// In en, this message translates to:
  /// **'Add your first property'**
  String get onboardingAddProperty;

  /// No description provided for @onboardingGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get onboardingGoHome;

  /// No description provided for @configErrorBody.
  ///
  /// In en, this message translates to:
  /// **'The app was built without its settings. Add the missing values to .env, then rebuild and restart the app.'**
  String get configErrorBody;

  /// No description provided for @inspectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get inspectionsTitle;

  /// No description provided for @inspectionsTemplatesAction.
  ///
  /// In en, this message translates to:
  /// **'Checklist templates'**
  String get inspectionsTemplatesAction;

  /// No description provided for @inspectionsNew.
  ///
  /// In en, this message translates to:
  /// **'New inspection'**
  String get inspectionsNew;

  /// No description provided for @inspectionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No inspections yet'**
  String get inspectionsEmptyTitle;

  /// No description provided for @inspectionsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record a move-in, move-out or routine check for a lease.'**
  String get inspectionsEmptyBody;

  /// No description provided for @inspectionsItemTitle.
  ///
  /// In en, this message translates to:
  /// **'{type} inspection'**
  String inspectionsItemTitle(String type);

  /// No description provided for @inspectionsDateNotSet.
  ///
  /// In en, this message translates to:
  /// **'Date not set'**
  String get inspectionsDateNotSet;

  /// No description provided for @inspectionTypeMoveIn.
  ///
  /// In en, this message translates to:
  /// **'Move-in'**
  String get inspectionTypeMoveIn;

  /// No description provided for @inspectionTypeMoveOut.
  ///
  /// In en, this message translates to:
  /// **'Move-out'**
  String get inspectionTypeMoveOut;

  /// No description provided for @inspectionTypeRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get inspectionTypeRoutine;

  /// No description provided for @inspectionStateOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get inspectionStateOpen;

  /// No description provided for @inspectionStateSignedByOwner.
  ///
  /// In en, this message translates to:
  /// **'Signed by owner'**
  String get inspectionStateSignedByOwner;

  /// No description provided for @inspectionStateSignedByTenant.
  ///
  /// In en, this message translates to:
  /// **'Signed by tenant'**
  String get inspectionStateSignedByTenant;

  /// No description provided for @inspectionStateSigned.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get inspectionStateSigned;

  /// No description provided for @inspectionFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New inspection'**
  String get inspectionFormTitle;

  /// No description provided for @inspectionFormLeaseSection.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get inspectionFormLeaseSection;

  /// No description provided for @inspectionFormProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get inspectionFormProperty;

  /// No description provided for @inspectionFormLease.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get inspectionFormLease;

  /// No description provided for @inspectionFormChooseProperty.
  ///
  /// In en, this message translates to:
  /// **'Choose a property.'**
  String get inspectionFormChooseProperty;

  /// No description provided for @inspectionFormChooseLease.
  ///
  /// In en, this message translates to:
  /// **'Choose a lease.'**
  String get inspectionFormChooseLease;

  /// No description provided for @inspectionFormPickPropertyFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a property to see its leases.'**
  String get inspectionFormPickPropertyFirst;

  /// No description provided for @inspectionFormNoLease.
  ///
  /// In en, this message translates to:
  /// **'This property has no lease yet.'**
  String get inspectionFormNoLease;

  /// No description provided for @inspectionFormAddLease.
  ///
  /// In en, this message translates to:
  /// **'Add a lease'**
  String get inspectionFormAddLease;

  /// No description provided for @inspectionFormDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get inspectionFormDetailsSection;

  /// No description provided for @inspectionFormType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get inspectionFormType;

  /// No description provided for @inspectionFormDate.
  ///
  /// In en, this message translates to:
  /// **'Date of inspection'**
  String get inspectionFormDate;

  /// No description provided for @inspectionFormToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get inspectionFormToday;

  /// No description provided for @inspectionFormNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get inspectionFormNotes;

  /// No description provided for @inspectionFormNotesHelp.
  ///
  /// In en, this message translates to:
  /// **'Overall condition, meter readings, keys handed over.'**
  String get inspectionFormNotesHelp;

  /// No description provided for @inspectionFormChecklistSection.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get inspectionFormChecklistSection;

  /// No description provided for @inspectionFormUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use a template'**
  String get inspectionFormUseTemplate;

  /// No description provided for @inspectionFormAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add a checklist item'**
  String get inspectionFormAddItem;

  /// No description provided for @inspectionFormAddItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get inspectionFormAddItemButton;

  /// No description provided for @inspectionFormRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get inspectionFormRemoveItem;

  /// No description provided for @inspectionFormNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add your own, or start from a template.'**
  String get inspectionFormNoItems;

  /// No description provided for @inspectionFormTemplateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get inspectionFormTemplateSheetTitle;

  /// No description provided for @inspectionFormTemplateAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item added} other{{count} items added}}'**
  String inspectionFormTemplateAdded(int count);

  /// No description provided for @inspectionFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create inspection'**
  String get inspectionFormCreate;

  /// No description provided for @inspectionFormCreated.
  ///
  /// In en, this message translates to:
  /// **'Inspection created.'**
  String get inspectionFormCreated;

  /// No description provided for @inspectionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspectionDetailTitle;

  /// No description provided for @inspectionDetailInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This inspection link is not valid.'**
  String get inspectionDetailInvalidLink;

  /// No description provided for @inspectionDetailSignatures.
  ///
  /// In en, this message translates to:
  /// **'Signatures'**
  String get inspectionDetailSignatures;

  /// No description provided for @inspectionDetailOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get inspectionDetailOwner;

  /// No description provided for @inspectionDetailTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get inspectionDetailTenant;

  /// No description provided for @inspectionDetailNotSigned.
  ///
  /// In en, this message translates to:
  /// **'Not signed yet'**
  String get inspectionDetailNotSigned;

  /// No description provided for @inspectionDetailSignedOn.
  ///
  /// In en, this message translates to:
  /// **'Signed {date}'**
  String inspectionDetailSignedOn(String date);

  /// No description provided for @inspectionDetailChecklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checklist items.'**
  String get inspectionDetailChecklistEmpty;

  /// No description provided for @inspectionDetailRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get inspectionDetailRequired;

  /// No description provided for @inspectionDetailSign.
  ///
  /// In en, this message translates to:
  /// **'Sign as owner'**
  String get inspectionDetailSign;

  /// No description provided for @inspectionDetailSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign this inspection?'**
  String get inspectionDetailSignTitle;

  /// No description provided for @inspectionDetailSignBody.
  ///
  /// In en, this message translates to:
  /// **'Your signature records that you agree with this checklist. You cannot undo it.'**
  String get inspectionDetailSignBody;

  /// No description provided for @inspectionDetailSignConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get inspectionDetailSignConfirm;

  /// No description provided for @inspectionDetailSigned.
  ///
  /// In en, this message translates to:
  /// **'Inspection signed.'**
  String get inspectionDetailSigned;

  /// No description provided for @inspectionItemPass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get inspectionItemPass;

  /// No description provided for @inspectionItemFail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get inspectionItemFail;

  /// No description provided for @inspectionItemAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get inspectionItemAttention;

  /// No description provided for @inspectionItemPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get inspectionItemPending;

  /// No description provided for @inspectionTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Checklist templates'**
  String get inspectionTemplatesTitle;

  /// No description provided for @inspectionTemplatesNew.
  ///
  /// In en, this message translates to:
  /// **'New template'**
  String get inspectionTemplatesNew;

  /// No description provided for @inspectionTemplatesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get inspectionTemplatesEmptyTitle;

  /// No description provided for @inspectionTemplatesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save a checklist once and reuse it for every move-in, move-out or yearly check.'**
  String get inspectionTemplatesEmptyBody;

  /// No description provided for @inspectionTemplatesItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String inspectionTemplatesItemCount(int count);

  /// No description provided for @inspectionTemplatesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get inspectionTemplatesDelete;

  /// No description provided for @inspectionTemplatesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this template?'**
  String get inspectionTemplatesDeleteTitle;

  /// No description provided for @inspectionTemplatesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is removed from this device. Inspections already created keep their checklist.'**
  String inspectionTemplatesDeleteBody(String name);

  /// No description provided for @inspectionTemplatesName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get inspectionTemplatesName;

  /// No description provided for @inspectionTemplatesNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Move-in checklist'**
  String get inspectionTemplatesNameHint;

  /// No description provided for @inspectionTemplatesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get inspectionTemplatesNameRequired;

  /// No description provided for @inspectionTemplatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get inspectionTemplatesDescription;

  /// No description provided for @inspectionTemplatesItems.
  ///
  /// In en, this message translates to:
  /// **'Checklist items'**
  String get inspectionTemplatesItems;

  /// No description provided for @inspectionTemplatesItemsHelp.
  ///
  /// In en, this message translates to:
  /// **'One item per line.'**
  String get inspectionTemplatesItemsHelp;

  /// No description provided for @inspectionTemplatesItemsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item.'**
  String get inspectionTemplatesItemsRequired;

  /// No description provided for @inspectionTemplatesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get inspectionTemplatesCreate;

  /// No description provided for @applicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get applicationsTitle;

  /// No description provided for @applicationsTabInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get applicationsTabInbox;

  /// No description provided for @applicationsTabForms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get applicationsTabForms;

  /// No description provided for @applicationsNewForm.
  ///
  /// In en, this message translates to:
  /// **'New form'**
  String get applicationsNewForm;

  /// No description provided for @applicationsInboxEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get applicationsInboxEmptyTitle;

  /// No description provided for @applicationsInboxEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Share a form link. Applications from tenants arrive here.'**
  String get applicationsInboxEmptyBody;

  /// No description provided for @applicationsFormsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No forms yet'**
  String get applicationsFormsEmptyTitle;

  /// No description provided for @applicationsFormsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a form for a property and share its link with people who want to rent.'**
  String get applicationsFormsEmptyBody;

  /// No description provided for @applicationsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get applicationsActive;

  /// No description provided for @applicationsInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get applicationsInactive;

  /// No description provided for @applicationsStatusApplicant.
  ///
  /// In en, this message translates to:
  /// **'Awaiting decision'**
  String get applicationsStatusApplicant;

  /// No description provided for @applicationsStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get applicationsStatusApproved;

  /// No description provided for @applicationsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get applicationsStatusRejected;

  /// No description provided for @applicationsStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get applicationsStatusUnknown;

  /// No description provided for @applicationsQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No questions} =1{1 question} other{{count} questions}}'**
  String applicationsQuestionCount(int count);

  /// No description provided for @applicationsExpires.
  ///
  /// In en, this message translates to:
  /// **'Closes {date}'**
  String applicationsExpires(String date);

  /// No description provided for @applicationsNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No closing date'**
  String get applicationsNoExpiry;

  /// No description provided for @applicationsFee.
  ///
  /// In en, this message translates to:
  /// **'{amount} fee'**
  String applicationsFee(String amount);

  /// No description provided for @applicationsCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get applicationsCopyLink;

  /// No description provided for @applicationsLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get applicationsLinkCopied;

  /// No description provided for @applicationsSubmittedOn.
  ///
  /// In en, this message translates to:
  /// **'Applied {date}'**
  String applicationsSubmittedOn(String date);

  /// No description provided for @applicationsApplicant.
  ///
  /// In en, this message translates to:
  /// **'Applicant'**
  String get applicationsApplicant;

  /// No description provided for @applicationFormDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Application form'**
  String get applicationFormDefaultTitle;

  /// No description provided for @applicationFormDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Application form'**
  String get applicationFormDetailTitle;

  /// No description provided for @applicationFormInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This form link is not valid.'**
  String get applicationFormInvalidLink;

  /// No description provided for @applicationFormShareSection.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get applicationFormShareSection;

  /// No description provided for @applicationFormShareHelp.
  ///
  /// In en, this message translates to:
  /// **'Send this link to people who want to rent. It opens the form on any phone.'**
  String get applicationFormShareHelp;

  /// No description provided for @applicationFormNoLink.
  ///
  /// In en, this message translates to:
  /// **'This form has no public link yet.'**
  String get applicationFormNoLink;

  /// No description provided for @applicationFormShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get applicationFormShare;

  /// No description provided for @applicationFormPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get applicationFormPreview;

  /// No description provided for @applicationFormQuestionsSection.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get applicationFormQuestionsSection;

  /// No description provided for @applicationFormStandardQuestions.
  ///
  /// In en, this message translates to:
  /// **'Every applicant also gives their name, phone and email.'**
  String get applicationFormStandardQuestions;

  /// No description provided for @applicationFormNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No extra questions.'**
  String get applicationFormNoQuestions;

  /// No description provided for @applicationFormRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get applicationFormRequired;

  /// No description provided for @applicationFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New application form'**
  String get applicationFormCreateTitle;

  /// No description provided for @applicationFormDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Form details'**
  String get applicationFormDetailsSection;

  /// No description provided for @applicationFormProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get applicationFormProperty;

  /// No description provided for @applicationFormChooseProperty.
  ///
  /// In en, this message translates to:
  /// **'Choose a property.'**
  String get applicationFormChooseProperty;

  /// No description provided for @applicationFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Form title'**
  String get applicationFormTitleLabel;

  /// No description provided for @applicationFormTitleHint.
  ///
  /// In en, this message translates to:
  /// **'For example, 2 BHK in Sector 51'**
  String get applicationFormTitleHint;

  /// No description provided for @applicationFormTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a form title.'**
  String get applicationFormTitleRequired;

  /// No description provided for @applicationFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get applicationFormDescription;

  /// No description provided for @applicationFormDescriptionHelp.
  ///
  /// In en, this message translates to:
  /// **'Shown at the top of the form.'**
  String get applicationFormDescriptionHelp;

  /// No description provided for @applicationFormCloses.
  ///
  /// In en, this message translates to:
  /// **'Closing date (optional)'**
  String get applicationFormCloses;

  /// No description provided for @applicationFormClearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get applicationFormClearDate;

  /// No description provided for @applicationFormAccepting.
  ///
  /// In en, this message translates to:
  /// **'Accept applications'**
  String get applicationFormAccepting;

  /// No description provided for @applicationFormAcceptingHelp.
  ///
  /// In en, this message translates to:
  /// **'Turn off to stop new applications.'**
  String get applicationFormAcceptingHelp;

  /// No description provided for @applicationFormQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get applicationFormQuestionLabel;

  /// No description provided for @applicationFormQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Do you have pets?'**
  String get applicationFormQuestionHint;

  /// No description provided for @applicationFormQuestionRequired.
  ///
  /// In en, this message translates to:
  /// **'Type the question first.'**
  String get applicationFormQuestionRequired;

  /// No description provided for @applicationFormAnswerType.
  ///
  /// In en, this message translates to:
  /// **'Answer type'**
  String get applicationFormAnswerType;

  /// No description provided for @applicationFormOptions.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get applicationFormOptions;

  /// No description provided for @applicationFormOptionsHelp.
  ///
  /// In en, this message translates to:
  /// **'Separate choices with commas.'**
  String get applicationFormOptionsHelp;

  /// No description provided for @applicationFormOptionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one choice.'**
  String get applicationFormOptionsRequired;

  /// No description provided for @applicationFormRequiredAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer required'**
  String get applicationFormRequiredAnswer;

  /// No description provided for @applicationFormAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get applicationFormAddQuestion;

  /// No description provided for @applicationFormRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get applicationFormRemoveQuestion;

  /// No description provided for @applicationFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create form'**
  String get applicationFormCreate;

  /// No description provided for @applicationFormCreated.
  ///
  /// In en, this message translates to:
  /// **'Form created.'**
  String get applicationFormCreated;

  /// No description provided for @applicationFieldText.
  ///
  /// In en, this message translates to:
  /// **'Short answer'**
  String get applicationFieldText;

  /// No description provided for @applicationFieldTextarea.
  ///
  /// In en, this message translates to:
  /// **'Long answer'**
  String get applicationFieldTextarea;

  /// No description provided for @applicationFieldNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get applicationFieldNumber;

  /// No description provided for @applicationFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get applicationFieldDate;

  /// No description provided for @applicationFieldBoolean.
  ///
  /// In en, this message translates to:
  /// **'Yes or no'**
  String get applicationFieldBoolean;

  /// No description provided for @applicationFieldSelect.
  ///
  /// In en, this message translates to:
  /// **'Choice'**
  String get applicationFieldSelect;

  /// No description provided for @applicationDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get applicationDetailTitle;

  /// No description provided for @applicationDetailInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This application link is not valid.'**
  String get applicationDetailInvalidLink;

  /// No description provided for @applicationDetailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get applicationDetailPhone;

  /// No description provided for @applicationDetailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get applicationDetailEmail;

  /// No description provided for @applicationDetailNotGiven.
  ///
  /// In en, this message translates to:
  /// **'Not given'**
  String get applicationDetailNotGiven;

  /// No description provided for @applicationDetailCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get applicationDetailCall;

  /// No description provided for @applicationDetailWrite.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get applicationDetailWrite;

  /// No description provided for @applicationDetailAnswers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get applicationDetailAnswers;

  /// No description provided for @applicationDetailNoAnswers.
  ///
  /// In en, this message translates to:
  /// **'No extra answers.'**
  String get applicationDetailNoAnswers;

  /// No description provided for @applicationDetailApplicantNote.
  ///
  /// In en, this message translates to:
  /// **'Note from the applicant'**
  String get applicationDetailApplicantNote;

  /// No description provided for @applicationDetailYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get applicationDetailYes;

  /// No description provided for @applicationDetailNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get applicationDetailNo;

  /// No description provided for @applicationDetailDecision.
  ///
  /// In en, this message translates to:
  /// **'Decision'**
  String get applicationDetailDecision;

  /// No description provided for @applicationDetailDecidedOn.
  ///
  /// In en, this message translates to:
  /// **'Decided {date}'**
  String applicationDetailDecidedOn(String date);

  /// No description provided for @applicationDetailYourDecision.
  ///
  /// In en, this message translates to:
  /// **'Your decision'**
  String get applicationDetailYourDecision;

  /// No description provided for @applicationDetailDecisionHelp.
  ///
  /// In en, this message translates to:
  /// **'The applicant is not told automatically. Call them after you decide.'**
  String get applicationDetailDecisionHelp;

  /// No description provided for @applicationDetailApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get applicationDetailApprove;

  /// No description provided for @applicationDetailReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get applicationDetailReject;

  /// No description provided for @applicationDetailApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve this application?'**
  String get applicationDetailApproveTitle;

  /// No description provided for @applicationDetailRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this application?'**
  String get applicationDetailRejectTitle;

  /// No description provided for @applicationDetailDecisionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get applicationDetailDecisionNotes;

  /// No description provided for @applicationDetailDecisionNotesHelp.
  ///
  /// In en, this message translates to:
  /// **'Only you see these notes.'**
  String get applicationDetailDecisionNotesHelp;

  /// No description provided for @applicationDetailApproved.
  ///
  /// In en, this message translates to:
  /// **'Application approved.'**
  String get applicationDetailApproved;

  /// No description provided for @applicationDetailRejected.
  ///
  /// In en, this message translates to:
  /// **'Application rejected.'**
  String get applicationDetailRejected;

  /// No description provided for @publicApplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply to rent'**
  String get publicApplyTitle;

  /// No description provided for @publicApplyIntro.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details. The owner reviews every application and contacts you.'**
  String get publicApplyIntro;

  /// No description provided for @publicApplyFee.
  ///
  /// In en, this message translates to:
  /// **'Application fee {amount}'**
  String publicApplyFee(String amount);

  /// No description provided for @publicApplyAboutYou.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get publicApplyAboutYou;

  /// No description provided for @publicApplyName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get publicApplyName;

  /// No description provided for @publicApplyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get publicApplyNameRequired;

  /// No description provided for @publicApplyPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get publicApplyPhone;

  /// No description provided for @publicApplyPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get publicApplyPhoneRequired;

  /// No description provided for @publicApplyPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit phone number.'**
  String get publicApplyPhoneInvalid;

  /// No description provided for @publicApplyEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get publicApplyEmail;

  /// No description provided for @publicApplyEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get publicApplyEmailRequired;

  /// No description provided for @publicApplyEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an email like name@example.com.'**
  String get publicApplyEmailInvalid;

  /// No description provided for @publicApplyQuestions.
  ///
  /// In en, this message translates to:
  /// **'A few questions'**
  String get publicApplyQuestions;

  /// No description provided for @publicApplyRequiredNote.
  ///
  /// In en, this message translates to:
  /// **'Questions marked * need an answer.'**
  String get publicApplyRequiredNote;

  /// No description provided for @publicApplyAnswerRequired.
  ///
  /// In en, this message translates to:
  /// **'Answer this question.'**
  String get publicApplyAnswerRequired;

  /// No description provided for @publicApplyNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number.'**
  String get publicApplyNumberInvalid;

  /// No description provided for @publicApplyChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose one'**
  String get publicApplyChoose;

  /// No description provided for @publicApplyNotes.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (optional)'**
  String get publicApplyNotes;

  /// No description provided for @publicApplyNotesHelp.
  ///
  /// In en, this message translates to:
  /// **'Move-in date, who will live with you, parking needs.'**
  String get publicApplyNotesHelp;

  /// No description provided for @publicApplySubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get publicApplySubmit;

  /// No description provided for @publicApplyClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Applications are closed'**
  String get publicApplyClosedTitle;

  /// No description provided for @publicApplyClosedBody.
  ///
  /// In en, this message translates to:
  /// **'This form is not taking applications right now.'**
  String get publicApplyClosedBody;

  /// No description provided for @publicApplySentTitle.
  ///
  /// In en, this message translates to:
  /// **'Application sent'**
  String get publicApplySentTitle;

  /// No description provided for @publicApplySentBody.
  ///
  /// In en, this message translates to:
  /// **'The owner now has your details.'**
  String get publicApplySentBody;

  /// No description provided for @publicApplySentNext.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get publicApplySentNext;

  /// No description provided for @publicApplySentStep1.
  ///
  /// In en, this message translates to:
  /// **'The owner reviews your application.'**
  String get publicApplySentStep1;

  /// No description provided for @publicApplySentStep2.
  ///
  /// In en, this message translates to:
  /// **'They contact you on the phone number you gave.'**
  String get publicApplySentStep2;

  /// No description provided for @publicApplySentStep3.
  ///
  /// In en, this message translates to:
  /// **'You can close this page now.'**
  String get publicApplySentStep3;

  /// No description provided for @publicApplySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to 360 Estate'**
  String get publicApplySignIn;

  /// No description provided for @leaseLateFeeFlat.
  ///
  /// In en, this message translates to:
  /// **'{amount} flat'**
  String leaseLateFeeFlat(String amount);

  /// No description provided for @leaseLateFeePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the rent'**
  String leaseLateFeePercent(String percent);

  /// No description provided for @leaseDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get leaseDetailTitle;

  /// No description provided for @leaseMonthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get leaseMonthlyRent;

  /// No description provided for @leaseDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get leaseDeposit;

  /// No description provided for @leaseEndsTodayNotice.
  ///
  /// In en, this message translates to:
  /// **'This lease ends today. Renew it or let it end.'**
  String get leaseEndsTodayNotice;

  /// No description provided for @leaseEndsInNotice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This lease ends tomorrow. Renew it or let it end.} other{This lease ends in {count} days. Renew it or let it end.}}'**
  String leaseEndsInNotice(int count);

  /// No description provided for @leaseExpiredNotice.
  ///
  /// In en, this message translates to:
  /// **'This lease ended on {date}.'**
  String leaseExpiredNotice(String date);

  /// No description provided for @leaseSectionTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get leaseSectionTerm;

  /// No description provided for @leaseStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get leaseStart;

  /// No description provided for @leaseEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get leaseEnd;

  /// No description provided for @leaseTermElapsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the term has passed'**
  String leaseTermElapsed(String percent);

  /// No description provided for @leaseSectionTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get leaseSectionTenant;

  /// No description provided for @leaseName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get leaseName;

  /// No description provided for @leasePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get leasePhone;

  /// No description provided for @leaseEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get leaseEmail;

  /// No description provided for @leaseCallTenant.
  ///
  /// In en, this message translates to:
  /// **'Call the tenant'**
  String get leaseCallTenant;

  /// No description provided for @leaseSectionCollection.
  ///
  /// In en, this message translates to:
  /// **'Rent collection'**
  String get leaseSectionCollection;

  /// No description provided for @leaseDueDay.
  ///
  /// In en, this message translates to:
  /// **'Due day'**
  String get leaseDueDay;

  /// No description provided for @leaseDueDayValue.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of each month'**
  String leaseDueDayValue(int day);

  /// No description provided for @leaseGracePeriod.
  ///
  /// In en, this message translates to:
  /// **'Grace period'**
  String get leaseGracePeriod;

  /// No description provided for @leaseGraceValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String leaseGraceValue(int count);

  /// No description provided for @leaseLateFee.
  ///
  /// In en, this message translates to:
  /// **'Late fee'**
  String get leaseLateFee;

  /// No description provided for @leaseLateFeeRule.
  ///
  /// In en, this message translates to:
  /// **'The late fee is charged once, after the grace period.'**
  String get leaseLateFeeRule;

  /// No description provided for @leaseTerminatedOn.
  ///
  /// In en, this message translates to:
  /// **'Ended on'**
  String get leaseTerminatedOn;

  /// No description provided for @leaseReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get leaseReason;

  /// No description provided for @leaseSectionDocument.
  ///
  /// In en, this message translates to:
  /// **'Signed lease'**
  String get leaseSectionDocument;

  /// No description provided for @leaseDocumentMissing.
  ///
  /// In en, this message translates to:
  /// **'No signed copy yet. Upload the PDF.'**
  String get leaseDocumentMissing;

  /// No description provided for @leaseDocumentPresent.
  ///
  /// In en, this message translates to:
  /// **'The signed PDF is on file.'**
  String get leaseDocumentPresent;

  /// No description provided for @leaseUploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get leaseUploadPdf;

  /// No description provided for @leaseReplacePdf.
  ///
  /// In en, this message translates to:
  /// **'Replace PDF'**
  String get leaseReplacePdf;

  /// No description provided for @leaseViewSigned.
  ///
  /// In en, this message translates to:
  /// **'View signed lease'**
  String get leaseViewSigned;

  /// No description provided for @leaseUploaded.
  ///
  /// In en, this message translates to:
  /// **'Signed lease uploaded.'**
  String get leaseUploaded;

  /// No description provided for @leaseOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the document.'**
  String get leaseOpenFailed;

  /// No description provided for @leaseRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get leaseRenew;

  /// No description provided for @leaseTerminate.
  ///
  /// In en, this message translates to:
  /// **'Terminate'**
  String get leaseTerminate;

  /// No description provided for @leaseRenewTitle.
  ///
  /// In en, this message translates to:
  /// **'Renew lease'**
  String get leaseRenewTitle;

  /// No description provided for @leaseNewStart.
  ///
  /// In en, this message translates to:
  /// **'New start date'**
  String get leaseNewStart;

  /// No description provided for @leaseNewEnd.
  ///
  /// In en, this message translates to:
  /// **'New end date'**
  String get leaseNewEnd;

  /// No description provided for @leaseNewRent.
  ///
  /// In en, this message translates to:
  /// **'New monthly rent'**
  String get leaseNewRent;

  /// No description provided for @leaseNewRentHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep the current rent.'**
  String get leaseNewRentHelper;

  /// No description provided for @leaseStartActive.
  ///
  /// In en, this message translates to:
  /// **'Start as active'**
  String get leaseStartActive;

  /// No description provided for @leaseEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'The end date must be after the start date.'**
  String get leaseEndAfterStart;

  /// No description provided for @leaseRenewed.
  ///
  /// In en, this message translates to:
  /// **'Lease renewed.'**
  String get leaseRenewed;

  /// No description provided for @leaseTerminateTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminate lease'**
  String get leaseTerminateTitle;

  /// No description provided for @leaseTerminateBody.
  ///
  /// In en, this message translates to:
  /// **'The tenant moves out on this date. This cannot be undone.'**
  String get leaseTerminateBody;

  /// No description provided for @leaseTerminationDate.
  ///
  /// In en, this message translates to:
  /// **'Termination date'**
  String get leaseTerminationDate;

  /// No description provided for @leaseTerminated.
  ///
  /// In en, this message translates to:
  /// **'Lease terminated.'**
  String get leaseTerminated;

  /// No description provided for @leaseFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New lease'**
  String get leaseFormTitle;

  /// No description provided for @leaseFormSectionParties.
  ///
  /// In en, this message translates to:
  /// **'Property and tenant'**
  String get leaseFormSectionParties;

  /// No description provided for @leaseFormProperty.
  ///
  /// In en, this message translates to:
  /// **'Property *'**
  String get leaseFormProperty;

  /// No description provided for @leaseFormPropertyRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a property.'**
  String get leaseFormPropertyRequired;

  /// No description provided for @leaseFormPropertiesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your properties.'**
  String get leaseFormPropertiesFailed;

  /// No description provided for @leaseFormTenantName.
  ///
  /// In en, this message translates to:
  /// **'Tenant name'**
  String get leaseFormTenantName;

  /// No description provided for @leaseFormTenantPhone.
  ///
  /// In en, this message translates to:
  /// **'Tenant phone'**
  String get leaseFormTenantPhone;

  /// No description provided for @leaseFormTenantEmail.
  ///
  /// In en, this message translates to:
  /// **'Tenant email'**
  String get leaseFormTenantEmail;

  /// No description provided for @leaseFormTenantUserId.
  ///
  /// In en, this message translates to:
  /// **'Tenant user ID (optional)'**
  String get leaseFormTenantUserId;

  /// No description provided for @leaseFormTenantUserIdHelper.
  ///
  /// In en, this message translates to:
  /// **'The tenant\'s account ID, if the tenant has one.'**
  String get leaseFormTenantUserIdHelper;

  /// No description provided for @leaseFormSectionTerm.
  ///
  /// In en, this message translates to:
  /// **'Term and status'**
  String get leaseFormSectionTerm;

  /// No description provided for @leaseFormStart.
  ///
  /// In en, this message translates to:
  /// **'Start date *'**
  String get leaseFormStart;

  /// No description provided for @leaseFormEnd.
  ///
  /// In en, this message translates to:
  /// **'End date *'**
  String get leaseFormEnd;

  /// No description provided for @leaseFormDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a date.'**
  String get leaseFormDateRequired;

  /// No description provided for @leaseFormStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get leaseFormStatus;

  /// No description provided for @leaseFormSectionRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get leaseFormSectionRent;

  /// No description provided for @leaseFormRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent *'**
  String get leaseFormRent;

  /// No description provided for @leaseFormRentInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a monthly rent above zero.'**
  String get leaseFormRentInvalid;

  /// No description provided for @leaseFormDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get leaseFormDeposit;

  /// No description provided for @leaseFormFromProperty.
  ///
  /// In en, this message translates to:
  /// **'Filled from the property. Change it if this lease differs.'**
  String get leaseFormFromProperty;

  /// No description provided for @leaseFormSectionRules.
  ///
  /// In en, this message translates to:
  /// **'Rent collection rules'**
  String get leaseFormSectionRules;

  /// No description provided for @leaseFormRulesHelp.
  ///
  /// In en, this message translates to:
  /// **'Blank fields take the property\'s values. A flat late fee wins over a percentage.'**
  String get leaseFormRulesHelp;

  /// No description provided for @leaseFormDueDay.
  ///
  /// In en, this message translates to:
  /// **'Due day'**
  String get leaseFormDueDay;

  /// No description provided for @leaseFormGraceDays.
  ///
  /// In en, this message translates to:
  /// **'Grace days'**
  String get leaseFormGraceDays;

  /// No description provided for @leaseFormLateFeeFlat.
  ///
  /// In en, this message translates to:
  /// **'Late fee (flat)'**
  String get leaseFormLateFeeFlat;

  /// No description provided for @leaseFormLateFeePercent.
  ///
  /// In en, this message translates to:
  /// **'Late fee (%)'**
  String get leaseFormLateFeePercent;

  /// No description provided for @leaseFormRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from {min} to {max}.'**
  String leaseFormRange(int min, int max);

  /// No description provided for @leaseFormPercentRange.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 to 100.'**
  String get leaseFormPercentRange;

  /// No description provided for @leaseFormSectionClauses.
  ///
  /// In en, this message translates to:
  /// **'Special clauses'**
  String get leaseFormSectionClauses;

  /// No description provided for @leaseFormClauses.
  ///
  /// In en, this message translates to:
  /// **'Special clauses (optional)'**
  String get leaseFormClauses;

  /// No description provided for @leaseFormClausesHint.
  ///
  /// In en, this message translates to:
  /// **'Any terms beyond rent and dates'**
  String get leaseFormClausesHint;

  /// No description provided for @leaseFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create lease'**
  String get leaseFormCreate;

  /// No description provided for @leaseFormCreated.
  ///
  /// In en, this message translates to:
  /// **'Lease created.'**
  String get leaseFormCreated;

  /// No description provided for @moreSectionManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get moreSectionManage;

  /// No description provided for @moreSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get moreSectionAccount;

  /// No description provided for @moreSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get moreSectionSupport;

  /// No description provided for @moreApplications.
  ///
  /// In en, this message translates to:
  /// **'Rental applications'**
  String get moreApplications;

  /// No description provided for @moreTenants.
  ///
  /// In en, this message translates to:
  /// **'Tenants'**
  String get moreTenants;

  /// No description provided for @moreLeases.
  ///
  /// In en, this message translates to:
  /// **'Leases'**
  String get moreLeases;

  /// No description provided for @moreInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get moreInspections;

  /// No description provided for @moreExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get moreExpenses;

  /// No description provided for @moreDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get moreDocuments;

  /// No description provided for @moreReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get moreReports;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get moreChangePassword;

  /// No description provided for @moreHelp.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get moreHelp;

  /// No description provided for @moreContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get moreContact;

  /// No description provided for @moreSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get moreSignOutTitle;

  /// No description provided for @moreSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to see your properties.'**
  String get moreSignOutBody;

  /// No description provided for @moreVersion.
  ///
  /// In en, this message translates to:
  /// **'360 Estate {version}'**
  String moreVersion(String version);

  /// No description provided for @moreOpenProfile.
  ///
  /// In en, this message translates to:
  /// **'Open your profile'**
  String get moreOpenProfile;

  /// No description provided for @moreGuestName.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get moreGuestName;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// No description provided for @profileEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditAction;

  /// No description provided for @profileDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get profileDetailsTitle;

  /// No description provided for @profileSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurityTitle;

  /// No description provided for @profileNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get profileNotSet;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get profileTakePhoto;

  /// No description provided for @profileChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profileChoosePhoto;

  /// No description provided for @profileRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove new photo'**
  String get profileRemovePhoto;

  /// No description provided for @profileEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Email changes go through your sign-in settings.'**
  String get profileEmailHelper;

  /// No description provided for @profileSavedShort.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSavedShort;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Try again.'**
  String get profileSaveFailed;

  /// No description provided for @passwordPageIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password, then choose a new one.'**
  String get passwordPageIntro;

  /// No description provided for @passwordShow.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get passwordHide;

  /// No description provided for @passwordCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get passwordCurrentLabel;

  /// No description provided for @passwordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get passwordNewLabel;

  /// No description provided for @passwordRules.
  ///
  /// In en, this message translates to:
  /// **'Your new password needs'**
  String get passwordRules;

  /// No description provided for @passwordTooShort8.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get passwordTooShort8;

  /// No description provided for @passwordChangedShort.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChangedShort;

  /// No description provided for @passwordChangeFailedShort.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change your password. Try again.'**
  String get passwordChangeFailedShort;

  /// No description provided for @passwordRuleMet.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get passwordRuleMet;

  /// No description provided for @passwordRuleMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get passwordRuleMissing;

  /// No description provided for @settingsLanguageSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow the phone\'s language'**
  String get settingsLanguageSystemDesc;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get settingsLanguageHindi;

  /// No description provided for @settingsAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications and privacy'**
  String get settingsAlertsTitle;

  /// No description provided for @settingsNotificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get settingsNotificationPrefs;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove your account and its data'**
  String get settingsDeleteAccountDesc;

  /// No description provided for @notifPrefsNote.
  ///
  /// In en, this message translates to:
  /// **'These choices are saved on this phone. Push alerts start once they are switched on for 360 Estate.'**
  String get notifPrefsNote;

  /// No description provided for @notifPrefsAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notifPrefsAllTitle;

  /// No description provided for @notifPrefsAllDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn every alert below on or off'**
  String get notifPrefsAllDesc;

  /// No description provided for @notifPrefsAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get notifPrefsAlertsTitle;

  /// No description provided for @notifPrefsEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notifPrefsEmailTitle;

  /// No description provided for @notifPrefRent.
  ///
  /// In en, this message translates to:
  /// **'Rent due reminders'**
  String get notifPrefRent;

  /// No description provided for @notifPrefPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments received'**
  String get notifPrefPayments;

  /// No description provided for @notifPrefLeases.
  ///
  /// In en, this message translates to:
  /// **'Leases about to end'**
  String get notifPrefLeases;

  /// No description provided for @notifPrefMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Repair updates'**
  String get notifPrefMaintenance;

  /// No description provided for @notifPrefInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspection reminders'**
  String get notifPrefInspections;

  /// No description provided for @notifPrefMarketing.
  ///
  /// In en, this message translates to:
  /// **'News and offers'**
  String get notifPrefMarketing;

  /// No description provided for @privacyDiagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get privacyDiagnosticsTitle;

  /// No description provided for @privacyCrashTitle.
  ///
  /// In en, this message translates to:
  /// **'Send crash reports'**
  String get privacyCrashTitle;

  /// No description provided for @privacyCrashDesc.
  ///
  /// In en, this message translates to:
  /// **'Helps us find and fix bugs. Applies the next time you open the app.'**
  String get privacyCrashDesc;

  /// No description provided for @legalPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalPrivacyPolicy;

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get legalTerms;

  /// No description provided for @legalIntro.
  ///
  /// In en, this message translates to:
  /// **'The full text is on our website. It opens inside the app.'**
  String get legalIntro;

  /// No description provided for @legalOpen.
  ///
  /// In en, this message translates to:
  /// **'Read it now'**
  String get legalOpen;

  /// No description provided for @legalOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the page. Check your connection and try again.'**
  String get legalOpenFailed;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get deleteTitle;

  /// No description provided for @deleteSubmit.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteSubmit;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search questions'**
  String get helpSearchHint;

  /// No description provided for @helpCatAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get helpCatAll;

  /// No description provided for @helpCatProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get helpCatProperties;

  /// No description provided for @helpCatRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get helpCatRent;

  /// No description provided for @helpCatLeases.
  ///
  /// In en, this message translates to:
  /// **'Leases'**
  String get helpCatLeases;

  /// No description provided for @helpCatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get helpCatMaintenance;

  /// No description provided for @helpCatAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get helpCatAccount;

  /// No description provided for @helpQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I add a property?'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In en, this message translates to:
  /// **'Open the Properties tab and tap Add property. Fill in the details, then save.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I record a rent payment?'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In en, this message translates to:
  /// **'Tap Record payment on Home, or open Collections and pick the charge that was paid.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I create a lease?'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In en, this message translates to:
  /// **'Go to More, then Leases, and tap the add button. Pick the property and tenant, then set the rent and dates.'**
  String get helpA3;

  /// No description provided for @helpQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I run an inspection?'**
  String get helpQ4;

  /// No description provided for @helpA4.
  ///
  /// In en, this message translates to:
  /// **'Go to More, then Inspections, and tap the add button. Pick the property and work through the checklist.'**
  String get helpA4;

  /// No description provided for @helpQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I log a repair?'**
  String get helpQ5;

  /// No description provided for @helpA5.
  ///
  /// In en, this message translates to:
  /// **'Open the Tasks tab and tap the add button. Describe the problem and pick the property.'**
  String get helpA5;

  /// No description provided for @helpQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I change my name or photo?'**
  String get helpQ6;

  /// No description provided for @helpA6.
  ///
  /// In en, this message translates to:
  /// **'Go to More, tap your name at the top, then tap Edit profile.'**
  String get helpA6;

  /// No description provided for @helpNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No answers match'**
  String get helpNoResultsTitle;

  /// No description provided for @helpNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another word, or ask us directly.'**
  String get helpNoResultsBody;

  /// No description provided for @helpStillStuckTitle.
  ///
  /// In en, this message translates to:
  /// **'Still stuck?'**
  String get helpStillStuckTitle;

  /// No description provided for @helpStillStuckBody.
  ///
  /// In en, this message translates to:
  /// **'Send us a message. We usually reply within a day.'**
  String get helpStillStuckBody;

  /// No description provided for @contactTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get contactTopic;

  /// No description provided for @contactCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get contactCatGeneral;

  /// No description provided for @contactCatTechnical.
  ///
  /// In en, this message translates to:
  /// **'Something is broken'**
  String get contactCatTechnical;

  /// No description provided for @contactCatBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get contactCatBilling;

  /// No description provided for @contactCatFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature idea'**
  String get contactCatFeature;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get contactName;

  /// No description provided for @contactSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactSubject;

  /// No description provided for @contactMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get contactMessageTitle;

  /// No description provided for @contactMessageHelper.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened and on which screen.'**
  String get contactMessageHelper;

  /// No description provided for @contactSend.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get contactSend;

  /// No description provided for @contactSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent. We will reply by email.'**
  String get contactSent;

  /// No description provided for @contactEmailDirect.
  ///
  /// In en, this message translates to:
  /// **'Or email us at {email}'**
  String contactEmailDirect(String email);

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Rent, tenants and repairs, kept in one ledger.'**
  String get aboutTagline;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String aboutVersion(String version, String build);

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get aboutLicenses;

  /// No description provided for @aboutContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get aboutContactTitle;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} 360Ghar. All rights reserved.'**
  String aboutCopyright(String year);

  /// No description provided for @aboutMadeFor.
  ///
  /// In en, this message translates to:
  /// **'Made for property owners in India.'**
  String get aboutMadeFor;

  /// No description provided for @notifSignedOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see alerts'**
  String get notifSignedOutTitle;

  /// No description provided for @notifSignedOutBody.
  ///
  /// In en, this message translates to:
  /// **'Your notifications appear here after you sign in.'**
  String get notifSignedOutBody;

  /// No description provided for @notifPushNote.
  ///
  /// In en, this message translates to:
  /// **'Push alerts are not switched on for this phone yet. Every alert still lands here.'**
  String get notifPushNote;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Rent reminders, payments and repair updates show up here.'**
  String get notifEmptyBody;

  /// No description provided for @notifUnread.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get notifUnread;

  /// No description provided for @notifDebugTitle.
  ///
  /// In en, this message translates to:
  /// **'Register a device token (debug)'**
  String get notifDebugTitle;

  /// No description provided for @notifDebugToken.
  ///
  /// In en, this message translates to:
  /// **'Device token'**
  String get notifDebugToken;

  /// No description provided for @notifDebugPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get notifDebugPlatform;

  /// No description provided for @notifDebugRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get notifDebugRegister;

  /// No description provided for @notifDebugTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter a device token.'**
  String get notifDebugTokenMissing;

  /// No description provided for @notifDebugPlatformMissing.
  ///
  /// In en, this message translates to:
  /// **'Choose a platform.'**
  String get notifDebugPlatformMissing;

  /// No description provided for @notifDebugRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device registered.'**
  String get notifDebugRegistered;

  /// No description provided for @ownerScopeChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an owner'**
  String get ownerScopeChooseTitle;

  /// No description provided for @ownerScopeAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Showing every owner'**
  String get ownerScopeAllTitle;

  /// No description provided for @ownerScopeManaging.
  ///
  /// In en, this message translates to:
  /// **'Managing owner #{id}'**
  String ownerScopeManaging(int id);

  /// No description provided for @ownerScopeNeedOwnerBody.
  ///
  /// In en, this message translates to:
  /// **'Properties, leases and rent are listed per owner. Enter the owner id to start.'**
  String get ownerScopeNeedOwnerBody;

  /// No description provided for @ownerScopeForOwnerBody.
  ///
  /// In en, this message translates to:
  /// **'Properties, leases, rent and reports are for this owner.'**
  String get ownerScopeForOwnerBody;

  /// No description provided for @ownerScopeChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get ownerScopeChoose;

  /// No description provided for @ownerScopeChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get ownerScopeChange;

  /// No description provided for @ownerScopeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner to manage'**
  String get ownerScopeDialogTitle;

  /// No description provided for @ownerScopeIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner id'**
  String get ownerScopeIdLabel;

  /// No description provided for @ownerScopeIdError.
  ///
  /// In en, this message translates to:
  /// **'Enter the owner id.'**
  String get ownerScopeIdError;

  /// No description provided for @ownerScopeShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get ownerScopeShowAll;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @propertyViewLease.
  ///
  /// In en, this message translates to:
  /// **'View lease'**
  String get propertyViewLease;

  /// No description provided for @taskSectionWhere.
  ///
  /// In en, this message translates to:
  /// **'Property and lease'**
  String get taskSectionWhere;

  /// No description provided for @paymentDueShort.
  ///
  /// In en, this message translates to:
  /// **'due {date}'**
  String paymentDueShort(String date);

  /// No description provided for @propertyStepMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos and floor plans'**
  String get propertyStepMedia;

  /// No description provided for @reportsRowTotalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get reportsRowTotalIncome;

  /// No description provided for @reportsRowTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get reportsRowTotalExpenses;

  /// No description provided for @reportsRowNetIncome.
  ///
  /// In en, this message translates to:
  /// **'Net income'**
  String get reportsRowNetIncome;

  /// No description provided for @reportsRowProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get reportsRowProperties;

  /// No description provided for @reportsRowProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get reportsRowProperty;

  /// No description provided for @reportsRowOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get reportsRowOccupied;

  /// No description provided for @reportsRowVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get reportsRowVacant;

  /// No description provided for @reportsRowOccupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy rate'**
  String get reportsRowOccupancyRate;

  /// No description provided for @reportsRowMaintenanceRequests.
  ///
  /// In en, this message translates to:
  /// **'Maintenance requests'**
  String get reportsRowMaintenanceRequests;

  /// No description provided for @reportsRowPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get reportsRowPeriod;

  /// No description provided for @reportsRowAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get reportsRowAllTime;

  /// No description provided for @reportsRowFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String reportsRowFrom(String date);

  /// No description provided for @reportsRowUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String reportsRowUntil(String date);

  /// No description provided for @reportsRowLeaseEnds.
  ///
  /// In en, this message translates to:
  /// **'Lease ends {date}'**
  String reportsRowLeaseEnds(String date);

  /// No description provided for @mapUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The map is not available on this device.'**
  String get mapUnsupported;

  /// No description provided for @mapOpenInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get mapOpenInBrowser;

  /// No description provided for @leaseFormAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount of zero or more.'**
  String get leaseFormAmountInvalid;

  /// No description provided for @expenseFormPropertyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The properties could not be loaded. Try again.'**
  String get expenseFormPropertyUnavailable;
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
