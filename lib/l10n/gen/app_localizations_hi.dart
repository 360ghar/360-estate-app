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
      'ऑथेंटिकेशन सक्षम करने के लिए --dart-define के साथ SUPABASE_URL और SUPABASE_PUBLISHABLE_KEY सेट करें।';

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

  @override
  String get profileTitle => 'प्रोफ़ाइल और सेटिंग्स';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get accountSection => 'खाता';

  @override
  String get preferencesSection => 'प्राथमिकताएं';

  @override
  String get supportSection => 'सहायता';

  @override
  String get aboutSection => 'के बारे में';

  @override
  String get dangerZone => 'खतरा क्षेत्र';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get twoFactorAuth => 'दो-कारक प्रमाणीकरण';

  @override
  String get notEnabled => 'सक्षम नहीं';

  @override
  String get linkedAccounts => 'लिंक किए गए खाते';

  @override
  String get appearance => 'उपस्थिति';

  @override
  String get themeLanguage => 'थीम, भाषा';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get manageAlerts => 'अलर्ट प्रबंधित करें';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get helpCenter => 'सहायता केंद्र';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get reportProblem => 'समस्या की रिपोर्ट करें';

  @override
  String get reportBug => 'बग की रिपोर्ट करें';

  @override
  String get reportBugSubtitle => 'कोई समस्या मिली? हमें बताएं';

  @override
  String get requestFeature => 'सुविधा का अनुरोध करें';

  @override
  String get requestFeatureSubtitle => 'सुधार का सुझाव दें';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get deactivateAccount => 'खाता निष्क्रिय करें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get signOutTitle => 'साइन आउट';

  @override
  String get signOutConfirm => 'क्या आप वाकई साइन आउट करना चाहते हैं?';

  @override
  String get deactivateConfirm =>
      'अपना खाता निष्क्रिय करने से यह अस्थायी रूप से अक्षम हो जाएगा। आप वापस साइन इन करके इसे पुनः सक्षम कर सकते हैं।';

  @override
  String get deactivateSuccess => 'खाता निष्क्रिय कर दिया गया';

  @override
  String get deactivate => 'निष्क्रिय करें';

  @override
  String get deleteAccountWarning =>
      'इस कार्य को पूर्ववत नहीं किया जा सकता। आपका सभी डेटा स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get deleteSuccess => 'खाता हटाने का अनुरोध प्राप्त हुआ';

  @override
  String get delete => 'हटाएं';

  @override
  String get featureComingSoon => 'यह सुविधा जल्द आ रही है';

  @override
  String get enterPasswordConfirm => 'पुष्टि के लिए पासवर्ड दर्ज करें';

  @override
  String get notificationsSection => 'सूचनाएं';

  @override
  String get notificationPreferences => 'सूचना प्राथमिकताएं';

  @override
  String get storageSection => 'स्टोरेज और डेटा';

  @override
  String get clearCache => 'कैश साफ़ करें';

  @override
  String get clearCacheConfirm => 'क्या आप वाकई ऐप कैश साफ़ करना चाहते हैं?';

  @override
  String get cacheCleared => 'कैश सफलतापूर्वक साफ़ हो गया';

  @override
  String get downloadMyData => 'मेरा डेटा डाउनलोड करें';

  @override
  String get downloadDataConfirm =>
      'आपका डेटा तैयार किया जाएगा और आपके ईमेल पर भेजा जाएगा। इसमें कुछ मिनट लग सकते हैं।';

  @override
  String get dataDownloadStarted =>
      'डेटा निर्यात शुरू हो गया है। जल्द ही अपना ईमेल जांचें।';

  @override
  String get commonConfirm => 'साफ़ करें';

  @override
  String get commonRequest => 'अनुरोध';

  @override
  String get themeMode => 'थीम मोड';

  @override
  String get language => 'भाषा';

  @override
  String get tapToChangePhoto => 'फोटो बदलने के लिए टैप करें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get removePhoto => 'फोटो हटाएं';

  @override
  String get fullNameLabel => 'पूरा नाम';

  @override
  String get emailLabel => 'ईमेल पता';

  @override
  String get validationNameRequired => 'नाम आवश्यक है';

  @override
  String get validationEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get validationEmailInvalid => 'अमान्य ईमेल';

  @override
  String get profileSaved => 'प्रोफ़ाइल सफलतापूर्वक सहेजा गया';

  @override
  String get saveFailed => 'प्रोफ़ाइल सहेजने में विफल';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get passwordChanged => 'पासवर्ड सफलतापूर्वक बदल दिया गया';

  @override
  String get passwordChangeFailed => 'पासवर्ड बदलने में विफल';

  @override
  String get passwordChangeInfo =>
      'अपना वर्तमान पासवर्ड और एक नया पासवर्ड दर्ज करके अपने क्रेडेंशियल अपडेट करें।';

  @override
  String get validationCurrentPasswordRequired => 'वर्तमान पासवर्ड आवश्यक है';

  @override
  String get validationNewPasswordRequired => 'नया पासवर्ड आवश्यक है';

  @override
  String get validationConfirmPasswordRequired =>
      'कृपया अपने नए पासवर्ड की पुष्टि करें';

  @override
  String get validationPasswordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get passwordRequirements => 'पासवर्ड आवश्यकताएं:';

  @override
  String get requirementMinLength => 'कम से कम 8 अक्षर';

  @override
  String get requirementUppercase => 'कम से कम एक बड़ा अक्षर';

  @override
  String get requirementLowercase => 'कम से कम एक छोटा अक्षर';

  @override
  String get requirementNumber => 'कम से कम एक अंक';

  @override
  String get pushNotifications => 'पुश नोटिफिकेशन';

  @override
  String get enablePushNotifications => 'पुश नोटिफिकेशन सक्षम करें';

  @override
  String get pushNotificationsDesc => 'अपने डिवाइस पर सूचनाएं प्राप्त करें';

  @override
  String get alertTypes => 'अलर्ट प्रकार';

  @override
  String get rentReminders => 'किराया देने की याद दिलाएं';

  @override
  String get rentRemindersDesc => 'किराया देने से पहले याद दिलाई जाए';

  @override
  String get paymentAlerts => 'भुगतान प्राप्त अलर्ट';

  @override
  String get paymentAlertsDesc => 'जब भुगतान प्राप्त हो तो पता चले';

  @override
  String get leaseExpiryAlerts => 'लीज अवधि समाप्ति अलर्ट';

  @override
  String get leaseExpiryAlertsDesc => 'लीज समाप्त होने से पहले सूचित किया जाए';

  @override
  String get maintenanceAlerts => 'रखरखाव अपडेट';

  @override
  String get maintenanceAlertsDesc => 'रखरखाव अनुरोधों पर अपडेट';

  @override
  String get inspectionReminders => 'निरीक्षण अनुस्मारक';

  @override
  String get inspectionRemindersDesc => 'आगामी निरीक्षणों के लिए अनुस्मारक';

  @override
  String get emailNotifications => 'ईमेल सूचनाएं';

  @override
  String get marketingEmails => 'मार्केटिंग ईमेल';

  @override
  String get marketingEmailsDesc => 'अपडेट और प्रचार सामग्री प्राप्त करें';

  @override
  String get quietHours => 'शांत घंटे';

  @override
  String get enableQuietHours => 'शांत घंटे सक्षम करें';

  @override
  String get quietHoursDesc => 'निर्धारित घंटों के दौरान सूचनाएं म्यूट करें';

  @override
  String get quietHoursStart => 'प्रारंभ समय';

  @override
  String get quietHoursEnd => 'समाप्ति समय';

  @override
  String get errorLoadingSettings => 'सेटिंग लोड करने में त्रुटि';

  @override
  String get privacySettings => 'गोपनीयता सेटिंग्स';

  @override
  String get profileVisibilitySection => 'प्रोफ़ाइल दृश्यता';

  @override
  String get visibilityPublic => 'सार्वजनिक';

  @override
  String get visibilityPublicDesc => 'कोई भी आपकी प्रोफ़ाइल देख सकता है';

  @override
  String get visibilityContacts => 'केवल संपर्क';

  @override
  String get visibilityContactsDesc =>
      'केवल आपके संपर्क आपकी प्रोफ़ाइल देख सकते हैं';

  @override
  String get visibilityPrivate => 'निजी';

  @override
  String get visibilityPrivateDesc => 'केवल आप अपनी प्रोफ़ाइल देख सकते हैं';

  @override
  String get phoneVisibilitySection => 'फोन नंबर दृश्यता';

  @override
  String get emailVisibilitySection => 'ईमेल दृश्यता';

  @override
  String get dataAnalyticsSection => 'डेटा और विश्लेषिकी';

  @override
  String get analyticsTitle => 'विश्लेषिकी';

  @override
  String get analyticsDesc => 'उपयोग डेटा साझा करके ऐप में सुधार में मदद करें';

  @override
  String get crashReporting => 'क्रैश रिपोर्टिंग';

  @override
  String get crashReportingDesc =>
      'बग को ठीक करने में मदद के लिए स्वचालित रूप से क्रैश की रिपोर्ट करें';

  @override
  String get dataManagementSection => 'डेटा प्रबंधन';

  @override
  String get downloadDataDesc => 'अपने सभी डेटा की एक प्रति प्राप्त करें';

  @override
  String get clearActivityDesc => 'अपनी हाल की गतिविधि साफ़ करें';

  @override
  String get searchHelp => 'सहायता खोजें...';

  @override
  String get quickLinks => 'त्वरित लिंक';

  @override
  String get gettingStarted => 'शुरुआत करें';

  @override
  String get propertyManagement => 'प्रॉपर्टीज़';

  @override
  String get paymentsCollections => 'भुगतान';

  @override
  String get leases => 'लीज';

  @override
  String get maintenance => 'रखरखाव';

  @override
  String get faq => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get stillNeedHelp => 'अभी भी मदद चाहिए?';

  @override
  String get contactSupportDesc =>
      'हमारी सहायता टीम आपकी सहायता के लिए यहां है';

  @override
  String get contactUsBtn => 'संपर्क करें';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get category => 'श्रेणी';

  @override
  String get subject => 'विषय';

  @override
  String get message => 'संदेश';

  @override
  String get validationSubjectRequired => 'विषय आवश्यक है';

  @override
  String get validationMessageRequired => 'संदेश आवश्यक है';

  @override
  String get validationMessageTooShort =>
      'कृपया अधिक विवरण प्रदान करें (कम से कम 10 अक्षर)';

  @override
  String get sendRequest => 'अनुरोध भेजें';

  @override
  String get supportRequestSent => 'सहायता अनुरोध सफलतापूर्वक भेजा गया';

  @override
  String get orEmailUs => 'या सीधे हमें ईमेल करें: support@360estate.app';

  @override
  String get about => 'के बारे में';

  @override
  String get tagline => 'पूर्ण संपत्ति प्रबंधन समाधान';

  @override
  String get version => 'संस्करण';

  @override
  String get legal => 'कानूनी';

  @override
  String get licenses => 'लाइसेंस';

  @override
  String get website => 'वेबसाइट';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get followUs => 'हमें फॉलो करें';

  @override
  String get madeWithLove => 'प्रॉपर्टी मैनेजर्स के लिए ❤️ के साथ बनाया गया';

  @override
  String get allRightsReserved => 'सर्वाधिकार सुरक्षित।';

  @override
  String get couldNotLaunchUrl => 'URL लॉन्च नहीं किया जा सका';

  @override
  String get support => 'सहायत';

  @override
  String get howCanWeHelp => 'हम आपकी कैसे मदद कर सकते हैं?';

  @override
  String get supportResponseTime => 'हम आमतौर 24 घंटों के भीतर जवाब देते हैं';

  @override
  String get privacySection => 'गोपनीयता';
}
