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
  String get phoneNumberLabel => 'Phone number';

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
  String get propertiesDemoTitle => 'Properties (pagination demo)';

  @override
  String get propertiesDemoSubtitle => 'Infinite scroll with pull-to-refresh';

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
}
