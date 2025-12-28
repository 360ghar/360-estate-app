// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => '360 एस्टेट';

  @override
  String get commonContinue => 'जारी रखें';

  @override
  String get commonBack => 'वापस';

  @override
  String get commonRetry => 'फिर से प्रयास करें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonSearch => 'खोजें';

  @override
  String get commonSignOut => 'साइन आउट';

  @override
  String get errorSomethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get errorOfflineHint =>
      'आप ऑफ़लाइन हैं। कृपया अपना इंटरनेट कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get errorMissingConfigTitle => 'ऐप कॉन्फ़िगरेशन उपलब्ध नहीं है';

  @override
  String get errorMissingConfigBody =>
      'ऑथेंटिकेशन सक्षम करने के लिए --dart-define के साथ SUPABASE_URL और SUPABASE_ANON_KEY सेट करें।';

  @override
  String get enterPhoneTitle => 'फोन नंबर दर्ज करें';

  @override
  String get phoneNumberLabel => 'फोन नंबर';

  @override
  String get phoneNumberHint => '+91XXXXXXXXXX';

  @override
  String get validationPhoneRequired => 'फोन नंबर आवश्यक है';

  @override
  String get validationPhoneInternational =>
      'कृपया इंटरनेशनल फ़ॉर्मेट का उपयोग करें, जैसे +91...';

  @override
  String get validationPhoneTooShort => 'फोन नंबर बहुत छोटा लग रहा है';

  @override
  String get loginTitle => 'लॉगिन';

  @override
  String get signupTitle => 'साइन अप';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get validationPasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get validationPasswordTooShort =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get signInCta => 'साइन इन';

  @override
  String get createAccountCta => 'खाता बनाएँ';

  @override
  String get alreadyHaveAccountCta => 'पहले से खाता है?';

  @override
  String authPhoneSummary(String phone) {
    return 'फोन: $phone';
  }

  @override
  String get homeTitle => 'होम';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String homeToday(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'आज $dateString है';
  }

  @override
  String homeOutstandingRent(String amount) {
    return 'बाकी किराया: $amount';
  }

  @override
  String get propertiesDemoTitle => 'प्रॉपर्टीज़ (पेजिनेशन डेमो)';

  @override
  String get propertiesDemoSubtitle => 'इन्फ़िनिट स्क्रॉल और पुल-टू-रिफ्रेश';

  @override
  String get propertiesTitle => 'प्रॉपर्टीज़';

  @override
  String get propertiesSearchHint => 'प्रॉपर्टीज़ खोजें';

  @override
  String propertiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रॉपर्टीज़',
      one: '1 प्रॉपर्टी',
      zero: 'कोई प्रॉपर्टी नहीं',
    );
    return '$_temp0';
  }

  @override
  String get themeSectionTitle => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get languageSectionTitle => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get emptyTitle => 'अभी यहाँ कुछ नहीं है';

  @override
  String get emptyBody => 'फ़िल्टर बदलें या रिफ्रेश करें।';

  @override
  String get publicApplicationTitle => 'आवेदन';

  @override
  String publicApplicationSlug(String slug) {
    return 'पब्लिक आवेदन: $slug';
  }
}
