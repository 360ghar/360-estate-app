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
  String get commonSignOut => 'साइन आउट';

  @override
  String get errorSomethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get errorOfflineHint =>
      'आप ऑफ़लाइन हैं। कृपया अपना इंटरनेट कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get errorMissingConfigTitle => 'ऐप कॉन्फ़िगरेशन उपलब्ध नहीं है';

  @override
  String get validationPhoneTooShort => 'फोन नंबर बहुत छोटा लग रहा है';

  @override
  String get signInCta => 'साइन इन';

  @override
  String get createAccountCta => 'खाता बनाएँ';

  @override
  String get alreadyHaveAccountCta => 'पहले से खाता है?';

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
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get emptyTitle => 'अभी यहाँ कुछ नहीं है';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String deleteAccountConfirmLabel(String word) {
    return 'पुष्टि करने के लिए $word टाइप करें';
  }

  @override
  String get deleteAccountWarning =>
      'इस कार्य को पूर्ववत नहीं किया जा सकता। आपका सभी डेटा स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get deleteAccountEmailSent =>
      'ईमेल ऐप खुल गया है। अनुरोध पूरा करने के लिए कृपया संदेश भेजें।';

  @override
  String get deleteAccountSuccess => 'आपका खाता सफलतापूर्वक हटा दिया गया है।';

  @override
  String get deleteAccountManualFallback =>
      'आपका ईमेल ऐप नहीं खोला जा सका। कृपया विषय \"Account Deletion Request\" के साथ info@360ghar.com पर ईमेल करें।';

  @override
  String get delete => 'हटाएं';

  @override
  String get clearCache => 'कैश साफ़ करें';

  @override
  String get themeMode => 'थीम मोड';

  @override
  String get language => 'भाषा';

  @override
  String get validationNameRequired => 'नाम आवश्यक है';

  @override
  String get validationEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get validationEmailInvalid => 'अमान्य ईमेल';

  @override
  String get newPassword => 'नया पासवर्ड';

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
  String get requirementMinLength => 'कम से कम 8 अक्षर';

  @override
  String get requirementUppercase => 'कम से कम एक बड़ा अक्षर';

  @override
  String get requirementLowercase => 'कम से कम एक छोटा अक्षर';

  @override
  String get requirementNumber => 'कम से कम एक अंक';

  @override
  String get rentRemindersDesc => 'किराया देने से पहले याद दिलाई जाए';

  @override
  String get paymentAlertsDesc => 'जब भुगतान प्राप्त हो तो पता चले';

  @override
  String get leaseExpiryAlertsDesc => 'लीज समाप्त होने से पहले सूचित किया जाए';

  @override
  String get maintenanceAlertsDesc => 'रखरखाव अनुरोधों पर अपडेट';

  @override
  String get inspectionRemindersDesc => 'आगामी निरीक्षणों के लिए अनुस्मारक';

  @override
  String get marketingEmailsDesc => 'अपडेट और प्रचार सामग्री प्राप्त करें';

  @override
  String get privacySettings => 'गोपनीयता सेटिंग्स';

  @override
  String get leases => 'लीज';

  @override
  String get maintenance => 'रखरखाव';

  @override
  String get category => 'श्रेणी';

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
  String get about => 'के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get legal => 'कानूनी';

  @override
  String get website => 'वेबसाइट';

  @override
  String get howCanWeHelp => 'हम आपकी कैसे मदद कर सकते हैं?';

  @override
  String get supportResponseTime => 'हम आमतौर 24 घंटों के भीतर जवाब देते हैं';

  @override
  String get commonLoadFailedTitle => 'यह लोड नहीं हो सका';

  @override
  String get commonLoadFailedBody =>
      'अपना कनेक्शन जांचें, फिर दोबारा कोशिश करें।';

  @override
  String get commonLoadMoreFailed => 'और लोड नहीं हो सका।';

  @override
  String get commonLoading => 'लोड हो रहा है';

  @override
  String get commonClearSearch => 'खोज साफ़ करें';

  @override
  String get commonFilters => 'फ़िल्टर';

  @override
  String get navHome => 'होम';

  @override
  String get navProperties => 'प्रॉपर्टी';

  @override
  String get navCollections => 'वसूली';

  @override
  String get navTasks => 'काम';

  @override
  String get navMore => 'और';

  @override
  String get navPressBackToExit => 'बाहर निकलने के लिए फिर से बैक दबाएं';

  @override
  String get homeGreetingMorning => 'सुप्रभात';

  @override
  String get homeGreetingAfternoon => 'नमस्कार';

  @override
  String get homeGreetingEvening => 'शुभ संध्या';

  @override
  String homeRentCardTitle(String month) {
    return '$month का किराया';
  }

  @override
  String get homeCollectedThisMonth => 'इस महीने वसूला गया';

  @override
  String homeVsLastMonth(String change) {
    return 'पिछले महीने से $change';
  }

  @override
  String homeRentOutstanding(String amount) {
    return '$amount किराया बकाया';
  }

  @override
  String get homeRecordPayment => 'भुगतान दर्ज करें';

  @override
  String get homeViewAll => 'सभी देखें';

  @override
  String homeChargesEmpty(String month) {
    return '$month के लिए अभी कोई किराया शुल्क नहीं है।';
  }

  @override
  String get homeChargesFailed => 'इस महीने के शुल्क लोड नहीं हो सके।';

  @override
  String homeUpcomingExpenses(String amount) {
    return 'आने वाले खर्च $amount';
  }

  @override
  String homeStripSemantics(int paid, int total) {
    return 'इस महीने $total में से $paid किराया शुल्क चुकाए गए। वसूली खुलती है।';
  }

  @override
  String get homePortfolioTitle => 'पोर्टफोलियो';

  @override
  String get homePropertiesLabel => 'प्रॉपर्टी';

  @override
  String get homeOccupancyLabel => 'भराव';

  @override
  String get homeOccupied => 'भरी हुई';

  @override
  String get homeVacant => 'खाली';

  @override
  String get homeUnderMaintenance => 'रखरखाव में';

  @override
  String get homeAddProperty => 'प्रॉपर्टी जोड़ें';

  @override
  String get homeActivityTitle => 'हाल की गतिविधि';

  @override
  String get homeActivityEmptyTitle => 'अभी कोई गतिविधि नहीं';

  @override
  String get homeActivityEmptyBody =>
      'भुगतान, काम और लीज़ के बदलाव यहां दिखेंगे।';

  @override
  String get homeEmptyTitle => 'अपनी पहली प्रॉपर्टी से शुरू करें';

  @override
  String get homeEmptyBody =>
      'एक प्रॉपर्टी जोड़ें, फिर किराया आने पर दर्ज करें।';

  @override
  String get rentStatusDue => 'बकाया';

  @override
  String get rentStatusPartlyPaid => 'आंशिक भुगतान';

  @override
  String get rentStatusPaid => 'चुकाया गया';

  @override
  String get rentStatusOverdue => 'अतिदेय';

  @override
  String get rentStatusWaived => 'माफ़';

  @override
  String get tenantsTitle => 'किरायेदार';

  @override
  String get tenantsSearchHint => 'नाम, फ़ोन या प्रॉपर्टी खोजें';

  @override
  String get tenantsFilterAll => 'सभी';

  @override
  String get tenantsStatusActive => 'सक्रिय';

  @override
  String get tenantsStatusVacated => 'खाली किया';

  @override
  String get tenantsStatusUnknown => 'स्थिति अज्ञात';

  @override
  String get tenantsNoProperty => 'कोई प्रॉपर्टी नहीं जुड़ी';

  @override
  String tenantsActiveLeases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय लीज़',
      one: '1 सक्रिय लीज़',
    );
    return '$_temp0';
  }

  @override
  String get tenantsEmptyTitle => 'अभी कोई किरायेदार नहीं';

  @override
  String get tenantsEmptyBody =>
      'किसी लीज़ में जोड़ने के बाद किरायेदार यहां दिखेगा।';

  @override
  String get tenantsNewLease => 'नई लीज़';

  @override
  String get tenantsNoMatchTitle => 'कोई किरायेदार नहीं मिला';

  @override
  String get tenantsNoMatchBody => 'कोई दूसरा नाम या फ़िल्टर आज़माएं।';

  @override
  String get tenantDetailTitle => 'किरायेदार';

  @override
  String get tenantDetailInvalidLink => 'यह किरायेदार लिंक मान्य नहीं है।';

  @override
  String get tenantDetailContact => 'संपर्क';

  @override
  String get tenantDetailPhone => 'फ़ोन';

  @override
  String get tenantDetailEmail => 'ईमेल';

  @override
  String get tenantDetailNotAdded => 'नहीं जोड़ा गया';

  @override
  String tenantDetailCall(String name) {
    return '$name को कॉल करें';
  }

  @override
  String tenantDetailWrite(String name) {
    return '$name को ईमेल करें';
  }

  @override
  String get tenantDetailLeases => 'लीज़';

  @override
  String get tenantDetailNoLeases => 'अभी कोई लीज़ नहीं।';

  @override
  String get tenantDetailAllLeases => 'इस किरायेदार की सभी लीज़';

  @override
  String get tenantDetailInspections => 'निरीक्षण';

  @override
  String get tenantDetailInspectionsHint => 'मौजूदा लीज़ के';

  @override
  String get tenantDetailInspectionsNone => 'पहले लीज़ चाहिए';

  @override
  String get tenantDetailOpenEnded => 'कोई समाप्ति तिथि नहीं';

  @override
  String get tenantLeaseDraft => 'ड्राफ़्ट';

  @override
  String get tenantLeasePendingSignature => 'हस्ताक्षर बाकी';

  @override
  String get tenantLeaseActive => 'सक्रिय';

  @override
  String get tenantLeaseExpiringSoon => 'जल्द समाप्त';

  @override
  String get tenantLeaseExpired => 'समाप्त';

  @override
  String get tenantLeaseTerminated => 'समाप्त की गई';

  @override
  String get tenantLeaseRenewed => 'नवीनीकृत';

  @override
  String get expensesTitle => 'खर्च';

  @override
  String get expensesAdd => 'खर्च जोड़ें';

  @override
  String get expensesSearchHint => 'शीर्षक, श्रेणी या प्रॉपर्टी खोजें';

  @override
  String expensesSpentIn(String month) {
    return '$month में खर्च';
  }

  @override
  String expensesCountThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस महीने $count खर्च',
      one: 'इस महीने 1 खर्च',
      zero: 'इस महीने कोई खर्च नहीं',
    );
    return '$_temp0';
  }

  @override
  String get expensesEmptyTitle => 'अभी कोई खर्च नहीं';

  @override
  String get expensesEmptyBody =>
      'पैसा कहां जाता है देखने के लिए मरम्मत, बिल और टैक्स दर्ज करें।';

  @override
  String get expensesNoMatchTitle => 'कोई खर्च नहीं मिला';

  @override
  String get expensesNoMatchBody => 'कोई दूसरी खोज या श्रेणी आज़माएं।';

  @override
  String get expensesUntitled => 'खर्च';

  @override
  String get expensesCategoryMaintenance => 'रखरखाव';

  @override
  String get expensesCategoryRepairs => 'मरम्मत';

  @override
  String get expensesCategoryInsurance => 'बीमा';

  @override
  String get expensesCategoryPropertyTax => 'प्रॉपर्टी टैक्स';

  @override
  String get expensesCategoryHoa => 'सोसाइटी शुल्क';

  @override
  String get expensesCategoryUtilities => 'बिजली-पानी';

  @override
  String get expensesCategoryMarketing => 'मार्केटिंग';

  @override
  String get expensesCategoryLegal => 'कानूनी';

  @override
  String get expensesCategoryOther => 'अन्य';

  @override
  String get expenseFormNewTitle => 'नया खर्च';

  @override
  String get expenseFormEditTitle => 'खर्च बदलें';

  @override
  String get expenseFormAmount => 'राशि';

  @override
  String get expenseFormAmountError => 'शून्य से ज़्यादा राशि दर्ज करें।';

  @override
  String get expenseFormDate => 'तारीख';

  @override
  String get expenseFormProperty => 'प्रॉपर्टी';

  @override
  String get expenseFormPropertyError => 'एक प्रॉपर्टी चुनें।';

  @override
  String get expenseFormPropertiesFailed => 'आपकी प्रॉपर्टी लोड नहीं हो सकीं।';

  @override
  String get expenseFormTitleLabel => 'खर्च का शीर्षक';

  @override
  String get expenseFormTitleHint => 'जैसे, प्लंबिंग मरम्मत';

  @override
  String get expenseFormCategory => 'श्रेणी';

  @override
  String get expenseFormNotes => 'नोट्स';

  @override
  String get expenseFormNotesHelper => 'वैकल्पिक';

  @override
  String get expenseFormDetails => 'विवरण';

  @override
  String get expenseFormCreate => 'खर्च बनाएं';

  @override
  String get expenseFormSave => 'बदलाव सहेजें';

  @override
  String get expenseFormSaved => 'खर्च सहेजा गया।';

  @override
  String get expenseFormNotFound => 'यह खर्च नहीं मिला।';

  @override
  String get documentsTitle => 'दस्तावेज़';

  @override
  String get documentsUpload => 'अपलोड करें';

  @override
  String get documentsSearchHint => 'शीर्षक या प्रकार खोजें';

  @override
  String get documentsEmptyTitle => 'अभी कोई दस्तावेज़ नहीं';

  @override
  String get documentsEmptyBody =>
      'लीज़ एग्रीमेंट, आईडी प्रूफ़ और रसीदें एक जगह रखने के लिए अपलोड करें।';

  @override
  String get documentsNoMatchTitle => 'कोई दस्तावेज़ नहीं मिला';

  @override
  String get documentsNoMatchBody => 'कोई दूसरी खोज या प्रकार आज़माएं।';

  @override
  String get documentsUntitled => 'दस्तावेज़';

  @override
  String get documentsSharedWithTenant => 'किरायेदार के साथ साझा';

  @override
  String get documentsNoAccess => 'आप यह फ़ाइल नहीं खोल सकते।';

  @override
  String get documentsOpenFailed => 'यह फ़ाइल नहीं खुल सकी।';

  @override
  String get documentsLocked => 'पहुंच नहीं';

  @override
  String get documentTypeLeaseAgreement => 'लीज़ एग्रीमेंट';

  @override
  String get documentTypeIdProof => 'आईडी प्रूफ़';

  @override
  String get documentTypeAddressProof => 'पते का प्रमाण';

  @override
  String get documentTypeIncomeProof => 'आय का प्रमाण';

  @override
  String get documentTypeInspectionReport => 'निरीक्षण रिपोर्ट';

  @override
  String get documentTypeReceipt => 'रसीद';

  @override
  String get documentTypeInvoice => 'बिल';

  @override
  String get documentTypePropertyDeed => 'प्रॉपर्टी डीड';

  @override
  String get documentTypeInsurancePolicy => 'बीमा पॉलिसी';

  @override
  String get documentTypeOther => 'अन्य';

  @override
  String get documentUploadTitle => 'दस्तावेज़ अपलोड करें';

  @override
  String get documentUploadChoose => 'फ़ाइल चुनें';

  @override
  String get documentUploadChange => 'दूसरी फ़ाइल चुनें';

  @override
  String get documentUploadLimits => 'PDF, इमेज या दस्तावेज़, 25 MB तक';

  @override
  String get documentUploadNoFile => 'अपलोड करने के लिए फ़ाइल चुनें।';

  @override
  String get documentUploadTooLarge =>
      'यह फ़ाइल 25 MB से बड़ी है। छोटी फ़ाइल चुनें।';

  @override
  String get documentUploadPickFailed =>
      'फ़ाइल चुनने वाला नहीं खुल सका। फिर से कोशिश करें।';

  @override
  String get documentUploadRemoveFile => 'फ़ाइल हटाएं';

  @override
  String get documentUploadDetails => 'विवरण';

  @override
  String get documentUploadTitleLabel => 'शीर्षक';

  @override
  String get documentUploadTitleHelper =>
      'फ़ाइल का नाम रखने के लिए खाली छोड़ें।';

  @override
  String get documentUploadType => 'प्रकार';

  @override
  String get documentUploadSubmit => 'दस्तावेज़ अपलोड करें';

  @override
  String get documentUploadUploading => 'अपलोड हो रहा है';

  @override
  String get documentUploadDone => 'दस्तावेज़ अपलोड हो गया।';

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportsTypeRentRoll => 'किराया सूची';

  @override
  String get reportsTypeIncome => 'आय';

  @override
  String get reportsTypeExpenses => 'खर्च';

  @override
  String get reportsTypePnl => 'लाभ और हानि';

  @override
  String get reportsTypeOccupancy => 'भराव';

  @override
  String get reportsTypeMaintenance => 'रखरखाव';

  @override
  String get reportsAboutRentRoll =>
      'हर प्रॉपर्टी का किराया और वह किराए पर है या नहीं।';

  @override
  String get reportsAboutIncome => 'अवधि में वसूला गया किराया।';

  @override
  String get reportsAboutExpenses => 'अवधि में खर्च हुआ पैसा।';

  @override
  String get reportsAboutPnl => 'अवधि में आय में से खर्च घटाकर।';

  @override
  String get reportsAboutOccupancy =>
      'कितनी प्रॉपर्टी किराए पर हैं या खाली हैं।';

  @override
  String get reportsAboutMaintenance => 'कितने रखरखाव अनुरोध आए।';

  @override
  String get reportsFrom => 'से';

  @override
  String get reportsTo => 'तक';

  @override
  String get reportsAnyDate => 'कोई भी तारीख';

  @override
  String get reportsClearDate => 'तारीख हटाएं';

  @override
  String get reportsEmptyTitle => 'रिपोर्ट करने को कुछ नहीं';

  @override
  String get reportsEmptyBody =>
      'चुनी गई अवधि में इस रिपोर्ट में कोई डेटा नहीं है।';

  @override
  String reportsBarsSummary(int count, String label, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पंक्तियां',
      one: '1 पंक्ति',
    );
    return '$_temp0। सबसे ज़्यादा: $label, $amount।';
  }

  @override
  String get reportsExportCsv => 'CSV के रूप में साझा करें';

  @override
  String get reportDrilldownTitle => 'रिपोर्ट की पंक्ति';

  @override
  String reportDrilldownShare(String percent, String total) {
    return '$total का $percent';
  }

  @override
  String get reportDrilldownRanking => 'सभी पंक्तियां, सबसे बड़ी पहले';

  @override
  String get reportDrilldownNoAmounts =>
      'इस रिपोर्ट में तुलना के लिए कोई राशि नहीं है।';

  @override
  String get tenantsNoMatchLoaded =>
      'अब तक लोड हुए किसी किरायेदार से मेल नहीं है।';

  @override
  String get tenantsLoadMore => 'और किरायेदार लोड करें';

  @override
  String get propertiesFilterAll => 'सभी';

  @override
  String get propertiesFilterActive => 'सक्रिय';

  @override
  String get propertiesFilterOccupied => 'भरी हुई';

  @override
  String get propertiesFilterVacant => 'खाली';

  @override
  String get propertiesFilterPg => 'पीजी';

  @override
  String get propertiesFilterFlat => 'फ़्लैट';

  @override
  String get propertiesViewList => 'सूची';

  @override
  String get propertiesViewGrid => 'ग्रिड';

  @override
  String get propertiesSearchByLocation => 'जगह से खोजें';

  @override
  String get propertiesClearLocation => 'जगह का फ़िल्टर हटाएं';

  @override
  String get propertiesEmptyTitle => 'अभी कोई प्रॉपर्टी नहीं';

  @override
  String get propertiesEmptyBody =>
      'किराया ट्रैक करने के लिए अपनी पहली प्रॉपर्टी जोड़ें।';

  @override
  String get propertiesNoResultsTitle => 'कोई प्रॉपर्टी मेल नहीं खाती';

  @override
  String get propertiesNoResultsBody => 'कोई दूसरी खोज या फ़िल्टर आज़माएं।';

  @override
  String get propertiesNoMatchYetBody =>
      'लोड की गई कोई प्रॉपर्टी मेल नहीं खाती। आगे देखने के लिए और लोड करें।';

  @override
  String get propertiesLoadMore => 'और लोड करें';

  @override
  String get propertiesPerMonth => 'प्रति माह';

  @override
  String get propertyTypeHouse => 'मकान';

  @override
  String get propertyTypeApartment => 'अपार्टमेंट';

  @override
  String get propertyTypeBuilderFloor => 'बिल्डर फ़्लोर';

  @override
  String get propertyTypeRoom => 'कमरा';

  @override
  String get propertyTypeVilla => 'विला';

  @override
  String get propertyTypePlot => 'प्लॉट';

  @override
  String get propertyTypeCondo => 'कॉन्डो';

  @override
  String get propertyTypePenthouse => 'पेंटहाउस';

  @override
  String get propertyTypeStudio => 'स्टूडियो';

  @override
  String get propertyTypeLoft => 'लॉफ़्ट';

  @override
  String get propertyTypePg => 'पीजी';

  @override
  String get propertyTypeFlatmate => 'फ़्लैटमेट';

  @override
  String get propertyTypeOffice => 'ऑफ़िस';

  @override
  String get propertyTypeShop => 'दुकान';

  @override
  String get propertyTypeWarehouse => 'गोदाम';

  @override
  String get propertyStatusDraft => 'ड्राफ़्ट';

  @override
  String get propertyStatusActive => 'सक्रिय';

  @override
  String get propertyStatusArchived => 'संग्रहित';

  @override
  String get propertyFallbackName => 'प्रॉपर्टी';

  @override
  String get propertyDetailTitle => 'प्रॉपर्टी का विवरण';

  @override
  String get propertyEdit => 'प्रॉपर्टी बदलें';

  @override
  String get propertyShowOnMap => 'नक्शे पर देखें';

  @override
  String get propertyMoreActions => 'और विकल्प';

  @override
  String get propertyArchive => 'प्रॉपर्टी संग्रहित करें';

  @override
  String get propertyArchiveConfirmTitle => 'यह प्रॉपर्टी संग्रहित करें?';

  @override
  String get propertyArchiveConfirmBody =>
      'यह सक्रिय सूची से हट जाएगी और इसका इतिहास बना रहेगा। आप इसे बदलाव वाले पेज से फिर सक्रिय कर सकते हैं।';

  @override
  String get propertyArchiveAction => 'संग्रहित करें';

  @override
  String get propertyArchived => 'प्रॉपर्टी संग्रहित की गई';

  @override
  String propertyArchiveFailed(String reason) {
    return 'संग्रहित नहीं हो सकी: $reason';
  }

  @override
  String propertyDepositValue(String amount) {
    return 'जमा राशि $amount';
  }

  @override
  String get propertyCreateLease => 'लीज़ बनाएं';

  @override
  String get propertyTabOverview => 'सारांश';

  @override
  String get propertyTabLease => 'लीज़';

  @override
  String get propertyTabRent => 'किराया';

  @override
  String get propertyTabExpenses => 'खर्च';

  @override
  String get propertyTabMaintenance => 'रखरखाव';

  @override
  String get propertyTabDocuments => 'दस्तावेज़';

  @override
  String get propertyTabInspections => 'निरीक्षण';

  @override
  String get propertyPhotos => 'फ़ोटो';

  @override
  String get propertyFloorPlans => 'फ़्लोर प्लान';

  @override
  String propertyPhotoLabel(int index, int total) {
    return 'फ़ोटो $index / $total';
  }

  @override
  String get propertySpecs => 'विशेषताएं';

  @override
  String get propertyTypeField => 'प्रॉपर्टी का प्रकार';

  @override
  String get propertyFloorArea => 'फ़र्श क्षेत्र';

  @override
  String propertyAreaValue(String area) {
    return '$area वर्ग फ़ुट';
  }

  @override
  String get propertyBedrooms => 'बेडरूम';

  @override
  String get propertyBathrooms => 'बाथरूम';

  @override
  String get propertyBalconies => 'बालकनी';

  @override
  String get propertyAge => 'उम्र';

  @override
  String propertyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल',
    );
    return '$_temp0';
  }

  @override
  String propertyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String get propertyAmenities => 'सुविधाएं';

  @override
  String get propertyRentTerms => 'किराया और वसूली';

  @override
  String get propertyMonthlyRent => 'मासिक किराया';

  @override
  String get propertySecurityDeposit => 'सुरक्षा जमा';

  @override
  String get propertyDueDayNewLeases => 'देय दिन (नई लीज़)';

  @override
  String propertyDueDayValue(int day) {
    return 'दिन $day';
  }

  @override
  String get propertyGraceNewLeases => 'छूट अवधि (नई लीज़)';

  @override
  String get propertyDescription => 'विवरण';

  @override
  String get propertyCurrentLease => 'मौजूदा लीज़';

  @override
  String get propertyLeaseTenant => 'किरायेदार';

  @override
  String get propertyLeaseStart => 'शुरुआत';

  @override
  String get propertyLeaseEnd => 'समाप्ति';

  @override
  String get propertyLeaseRent => 'किराया';

  @override
  String get propertyLeaseEndsIn => 'खत्म होने में';

  @override
  String get propertyLeaseEndsToday => 'आज';

  @override
  String get propertyNoLeaseTitle => 'अभी कोई लीज़ नहीं';

  @override
  String get propertyNoLeaseBody => 'यहां किराया वसूलने के लिए लीज़ बनाएं।';

  @override
  String get propertyNoRentTitle => 'कोई किराया शुल्क नहीं';

  @override
  String get propertyNoRentBody =>
      'लीज़ सक्रिय होने पर इस प्रॉपर्टी के शुल्क यहां दिखेंगे।';

  @override
  String get propertyOpenCollections => 'वसूली खोलें';

  @override
  String propertyChargeBalance(String amount) {
    return 'बाकी $amount';
  }

  @override
  String propertyChargeLateFee(String amount) {
    return 'विलंब शुल्क $amount';
  }

  @override
  String propertyChargeDue(String date) {
    return 'देय $date';
  }

  @override
  String propertyLeaseNumber(String id) {
    return 'लीज़ #$id';
  }

  @override
  String get propertyNoExpensesTitle => 'कोई खर्च नहीं';

  @override
  String get propertyNoExpensesBody =>
      'इस प्रॉपर्टी के लिए दर्ज खर्च यहां दिखेंगे।';

  @override
  String get propertyAddExpense => 'खर्च जोड़ें';

  @override
  String get propertyNoMaintenanceTitle => 'रखरखाव का कोई अनुरोध नहीं';

  @override
  String get propertyNoMaintenanceBody =>
      'इस प्रॉपर्टी के अनुरोध और मरम्मत यहां दिखेंगे।';

  @override
  String get propertyNewTask => 'नया काम';

  @override
  String get propertyNoDocumentsTitle => 'कोई दस्तावेज़ नहीं';

  @override
  String get propertyNoDocumentsBody =>
      'इस प्रॉपर्टी के अनुबंध, रसीदें और पहचान पत्र यहां दिखेंगे।';

  @override
  String get propertyUploadDocument => 'दस्तावेज़ अपलोड करें';

  @override
  String get propertyNoInspectionsTitle => 'कोई निरीक्षण नहीं';

  @override
  String get propertyNoInspectionsBody =>
      'इस प्रॉपर्टी की मूव-इन और मूव-आउट जांच यहां दिखेंगी।';

  @override
  String get propertyNewInspection => 'नया निरीक्षण';

  @override
  String propertyCreatedOn(String date) {
    return '$date को बनाया';
  }

  @override
  String propertyUploadedOn(String date) {
    return '$date को अपलोड';
  }

  @override
  String propertyConductedOn(String date) {
    return '$date को किया गया';
  }

  @override
  String get propertyNew => 'नई प्रॉपर्टी';

  @override
  String get propertyStepBasics => 'बुनियादी जानकारी';

  @override
  String get propertyStepLocation => 'जगह';

  @override
  String propertyStepCounter(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get propertyNext => 'आगे';

  @override
  String get propertyCreate => 'प्रॉपर्टी बनाएं';

  @override
  String get propertySaveChanges => 'बदलाव सहेजें';

  @override
  String get propertyNameLabel => 'प्रॉपर्टी का नाम *';

  @override
  String get propertyNameHint => 'जैसे, ग्रीन वैली पीजी';

  @override
  String get propertyTypeLabel => 'प्रॉपर्टी का प्रकार *';

  @override
  String get propertyStatusLabel => 'प्रबंधन स्थिति';

  @override
  String get propertyDescriptionHint =>
      'कमरे, नियम, किरायेदार के लिए ज़रूरी बातें';

  @override
  String get propertySetMapLocation => 'नक्शे पर जगह चुनें';

  @override
  String get propertyChangeMapLocation => 'नक्शे पर जगह बदलें';

  @override
  String get propertyClearMapLocation => 'नक्शे की जगह हटाएं';

  @override
  String get propertyAddressLabel => 'पता';

  @override
  String get propertyAddressHint => 'मकान, गली, इलाका';

  @override
  String get propertyCityLabel => 'शहर *';

  @override
  String get propertyCityHint => 'जैसे, पुणे';

  @override
  String get propertyStateLabel => 'राज्य';

  @override
  String get propertyPincodeLabel => 'पिन कोड';

  @override
  String get propertyAreaLabel => 'फ़र्श क्षेत्र (वर्ग फ़ुट)';

  @override
  String get propertyAgeLabel => 'उम्र (साल)';

  @override
  String get propertyAmenitiesFailed => 'सुविधाएं लोड नहीं हो सकीं।';

  @override
  String get propertyRentLabel => 'मासिक किराया (₹) *';

  @override
  String get propertyDepositLabel => 'सुरक्षा जमा (₹)';

  @override
  String get propertyDueDayLabel => 'भुगतान का दिन';

  @override
  String get propertyDueDayHelper => '1 से 28';

  @override
  String get propertyGraceLabel => 'छूट अवधि (दिन)';

  @override
  String get propertyGraceHelper => '0 से 365';

  @override
  String get propertyRentTermsNote =>
      'नई लीज़ इन्हीं मानों से शुरू होती हैं। लीज़ में विलंब शुल्क हो तो वह छूट अवधि के बाद एक बार लगता है।';

  @override
  String get propertyAddPhotos => 'फ़ोटो जोड़ें';

  @override
  String get propertyAddFloorPlans => 'फ़्लोर प्लान जोड़ें';

  @override
  String propertyMediaCount(int count, int max) {
    return '$max में से $count जोड़ी गईं';
  }

  @override
  String get propertyRemoveMedia => 'हटाएं';

  @override
  String propertyMediaLimit(int max) {
    return 'आप अधिकतम $max जोड़ सकते हैं।';
  }

  @override
  String get propertyErrorName => 'प्रॉपर्टी का नाम दर्ज करें';

  @override
  String get propertyErrorType => 'प्रॉपर्टी का प्रकार चुनें';

  @override
  String get propertyErrorCity => 'शहर दर्ज करें';

  @override
  String get propertyErrorRent => 'मासिक किराया दर्ज करें';

  @override
  String get propertyErrorDueDay => '1 से 28 के बीच का दिन लिखें';

  @override
  String get propertyErrorGrace => '0 से 365 दिन लिखें';

  @override
  String get propertyCreated => 'प्रॉपर्टी बनाई गई';

  @override
  String get propertyUpdated => 'प्रॉपर्टी सहेजी गई';

  @override
  String propertySaveFailed(String reason) {
    return 'सहेजा नहीं जा सका: $reason';
  }

  @override
  String propertyUploadsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें अपलोड नहीं हुईं',
    );
    return '$_temp0। फिर से कोशिश करने के लिए दोबारा सहेजें।';
  }

  @override
  String get propertyDiscardTitle => 'बदलाव छोड़ दें?';

  @override
  String get propertyDiscardBody => 'इस फ़ॉर्म के बदलाव अभी सहेजे नहीं गए हैं।';

  @override
  String get propertyDiscard => 'छोड़ें';

  @override
  String get locationSearchTitle => 'जगह खोजें';

  @override
  String get locationSearchHint => 'शहर, इलाका या लैंडमार्क';

  @override
  String get locationUseCurrent => 'मौजूदा जगह इस्तेमाल करें';

  @override
  String get locationDetecting => 'आपकी जगह ढूंढ रहे हैं';

  @override
  String get locationCurrentName => 'मौजूदा जगह';

  @override
  String get locationServicesOff =>
      'लोकेशन सेवाएं बंद हैं। इसके लिए उन्हें चालू करें।';

  @override
  String get locationSettings => 'सेटिंग्स';

  @override
  String get locationPermissionNeeded =>
      'मौजूदा जगह के लिए लोकेशन की अनुमति दें।';

  @override
  String get locationPermissionBlocked =>
      'लोकेशन की अनुमति बंद है। सेटिंग्स में इसे चालू करें।';

  @override
  String get locationFailed => 'आपकी जगह नहीं मिल सकी।';

  @override
  String get locationDetailsFailed => 'वह जगह नहीं खुल सकी। कोई दूसरी चुनें।';

  @override
  String get locationIdleTitle => 'कोई जगह खोजें';

  @override
  String get locationIdleBody =>
      'शहर, इलाके या लैंडमार्क के कम से कम दो अक्षर लिखें।';

  @override
  String get locationNoResultsTitle => 'कोई जगह नहीं मिली';

  @override
  String get locationNoResultsBody => 'वर्तनी जांचें या पास का इलाका आज़माएं।';

  @override
  String get locationSearchFailed => 'जगहें खोजी नहीं जा सकीं।';

  @override
  String get mapZoomIn => 'ज़ूम इन';

  @override
  String get mapZoomOut => 'ज़ूम आउट';

  @override
  String tenantDetailPeriod(String start, String end) {
    return '$start से $end';
  }

  @override
  String tenantDetailSince(String start) {
    return '$start से';
  }

  @override
  String commonPropertyNumber(String id) {
    return 'प्रॉपर्टी #$id';
  }

  @override
  String commonLeaseNumber(String id) {
    return 'लीज़ #$id';
  }

  @override
  String get commonNotSet => 'सेट नहीं';

  @override
  String get commonNone => 'कोई नहीं';

  @override
  String get commonSaving => 'सहेजा जा रहा है';

  @override
  String get commonClearFilters => 'फ़िल्टर हटाएं';

  @override
  String get commonClearDate => 'तारीख हटाएं';

  @override
  String get commonAll => 'सभी';

  @override
  String get collectionsTitle => 'वसूली';

  @override
  String get collectionsGenerate => 'इस महीने के शुल्क बनाएं';

  @override
  String get collectionsGenerateShort => 'शुल्क बनाएं';

  @override
  String collectionsGenerated(int created, int skipped) {
    return '$created शुल्क बनाए गए, $skipped छोड़े गए।';
  }

  @override
  String get collectionsCollected => 'वसूला गया';

  @override
  String collectionsCollectedShare(String percent) {
    return 'बिल किए गए किराए का $percent% वसूला गया';
  }

  @override
  String get collectionsTotalsFailed => 'कुल राशि लोड नहीं हो सकी।';

  @override
  String get collectionsEmptyDue => 'कुछ भी बकाया नहीं है';

  @override
  String get collectionsEmptyDueBody =>
      'किराया वसूलना शुरू करने के लिए इस महीने के शुल्क बनाएं।';

  @override
  String get collectionsEmptyPartial => 'कोई आंशिक भुगतान वाला शुल्क नहीं';

  @override
  String get collectionsEmptyOverdue => 'कुछ भी अतिदेय नहीं है';

  @override
  String get collectionsEmptyPaid => 'अभी कोई चुकाया गया शुल्क नहीं';

  @override
  String get collectionsEmptyWaived => 'कोई माफ़ किया गया शुल्क नहीं';

  @override
  String get collectionsEmptyBody =>
      'शुल्क की स्थिति बदलने पर वे यहां दिखेंगे।';

  @override
  String collectionsDueOn(String date) {
    return 'देय $date';
  }

  @override
  String get collectionsNoDueDate => 'कोई देय तिथि नहीं';

  @override
  String collectionsPaidOf(String paid, String total) {
    return '$total में से $paid चुकाया';
  }

  @override
  String collectionsLateFee(String amount) {
    return 'विलंब शुल्क $amount';
  }

  @override
  String collectionsDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन अतिदेय',
      one: '1 दिन अतिदेय',
    );
    return '$_temp0';
  }

  @override
  String get collectionsRemind => 'रिमाइंडर भेजें';

  @override
  String collectionsReminderMessage(
    String tenant,
    String amount,
    String property,
    String date,
  ) {
    return 'नमस्ते $tenant, याद दिलाना है कि $property का आपका $amount किराया $date को देय है। धन्यवाद।';
  }

  @override
  String get collectionsSoon => 'जल्द';

  @override
  String get collectionsNoMessagingApp =>
      'रिमाइंडर भेजने के लिए कोई मैसेजिंग ऐप नहीं मिला।';

  @override
  String get paymentTitle => 'भुगतान दर्ज करें';

  @override
  String get paymentChargeLabel => 'शुल्क';

  @override
  String get paymentChargeRequired => 'यह भुगतान किस शुल्क का है, चुनें।';

  @override
  String get paymentNoCharges => 'कोई शुल्क भुगतान का इंतज़ार नहीं कर रहा।';

  @override
  String paymentOwed(String amount) {
    return '$amount बकाया';
  }

  @override
  String get paymentBilled => 'बिल की गई राशि';

  @override
  String get paymentPaidSoFar => 'अब तक चुकाया';

  @override
  String get paymentBalance => 'बाकी';

  @override
  String get paymentDetailsSection => 'भुगतान';

  @override
  String get paymentAmountLabel => 'प्राप्त राशि';

  @override
  String get paymentAmountHelper => 'किरायेदार पर बाकी राशि से शुरू होता है।';

  @override
  String get paymentAmountInvalid => 'शून्य से अधिक राशि दर्ज करें।';

  @override
  String paymentAmountTooHigh(String amount) {
    return 'अधिकतम $amount दर्ज करें, जो इस शुल्क का बाकी है।';
  }

  @override
  String get paymentMethodLabel => 'भुगतान का तरीका';

  @override
  String get paymentMethodCash => 'नकद';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get paymentMethodBankTransfer => 'बैंक ट्रांसफ़र';

  @override
  String get paymentMethodCheque => 'चेक';

  @override
  String get paymentMethodOnline => 'ऑनलाइन';

  @override
  String get paymentMethodOther => 'अन्य';

  @override
  String get paymentDateLabel => 'प्राप्ति की तारीख';

  @override
  String get paymentNotesLabel => 'नोट्स (वैकल्पिक)';

  @override
  String get paymentRecorded => 'भुगतान दर्ज हो गया।';

  @override
  String get tasksTitle => 'काम';

  @override
  String get tasksNew => 'नया काम';

  @override
  String get tasksViewList => 'सूची';

  @override
  String get tasksViewBoard => 'बोर्ड';

  @override
  String get tasksFilterOpen => 'खुले';

  @override
  String get tasksFilterInProgress => 'चल रहे';

  @override
  String get tasksFilterDone => 'पूरे';

  @override
  String get tasksEmptyTitle => 'अभी कोई काम नहीं';

  @override
  String get tasksEmptyBody =>
      'मरम्मत या कोई काम दर्ज करें और यहां उस पर नज़र रखें।';

  @override
  String get tasksEmptyFilteredTitle => 'यहां कोई काम नहीं';

  @override
  String get tasksEmptyFilteredBody => 'इस फ़िल्टर से कुछ मेल नहीं खाता।';

  @override
  String tasksReportedOn(String date) {
    return '$date को दर्ज';
  }

  @override
  String tasksVisitOn(String date) {
    return 'विज़िट $date';
  }

  @override
  String get tasksLoadMore => 'और लोड करें';

  @override
  String get taskStatusOpen => 'खुला';

  @override
  String get taskStatusInReview => 'समीक्षा में';

  @override
  String get taskStatusInProgress => 'चल रहा है';

  @override
  String get taskStatusResolved => 'हल हो गया';

  @override
  String get taskStatusClosed => 'बंद';

  @override
  String get taskUrgencyLow => 'कम';

  @override
  String get taskUrgencyMedium => 'मध्यम';

  @override
  String get taskUrgencyHigh => 'ऊंची';

  @override
  String get taskUrgencyEmergency => 'आपात';

  @override
  String get taskCategoryPlumbing => 'प्लंबिंग';

  @override
  String get taskCategoryElectrical => 'बिजली';

  @override
  String get taskCategoryHvac => 'एसी और वेंटिलेशन';

  @override
  String get taskCategoryAppliance => 'उपकरण';

  @override
  String get taskCategoryStructural => 'ढांचा';

  @override
  String get taskCategoryPestControl => 'कीट नियंत्रण';

  @override
  String get taskCategoryCleaning => 'सफ़ाई';

  @override
  String get taskCategoryOther => 'अन्य';

  @override
  String get taskCreateTitle => 'नया काम';

  @override
  String get taskSectionDetails => 'क्या करना है';

  @override
  String get taskTitleLabel => 'शीर्षक';

  @override
  String get taskTitleHint => 'रसोई का टपकता नल ठीक करें';

  @override
  String get taskTitleRequired => 'शीर्षक दर्ज करें।';

  @override
  String get taskTitleTooShort => 'कम से कम 3 अक्षर लिखें।';

  @override
  String get taskDescriptionLabel => 'विवरण';

  @override
  String get taskDescriptionHint => 'क्या खराब है, और कहां?';

  @override
  String get taskSectionCategory => 'श्रेणी';

  @override
  String get taskPropertyLabel => 'प्रॉपर्टी';

  @override
  String get taskPropertyRequired => 'एक प्रॉपर्टी चुनें।';

  @override
  String get taskNoProperties => 'काम बनाने से पहले एक प्रॉपर्टी जोड़ें।';

  @override
  String get taskAddProperty => 'प्रॉपर्टी जोड़ें';

  @override
  String get taskLeaseLabel => 'लीज़ (वैकल्पिक)';

  @override
  String get taskNoLease => 'कोई लीज़ नहीं';

  @override
  String get taskSectionUrgency => 'तात्कालिकता';

  @override
  String get taskSectionCost => 'खर्च और विज़िट';

  @override
  String get taskCostLabel => 'अनुमानित खर्च (वैकल्पिक)';

  @override
  String get taskCostInvalid => '0 या अधिक दर्ज करें।';

  @override
  String get taskVisitLabel => 'विज़िट की तारीख (वैकल्पिक)';

  @override
  String taskAssignTo(String name) {
    return '$name को सौंपें';
  }

  @override
  String get taskAssignHelp => 'आपका एजेंट यह काम संभालेगा।';

  @override
  String get taskCreate => 'काम बनाएं';

  @override
  String get taskCreated => 'काम बन गया।';

  @override
  String get taskDetailTitle => 'काम';

  @override
  String get taskNotFoundTitle => 'काम नहीं मिला';

  @override
  String get taskNotFoundBody =>
      'हो सकता है इसे हटा दिया गया हो। सूची पर वापस जाएं।';

  @override
  String get taskInvalidId => 'यह लिंक किसी काम का नहीं है।';

  @override
  String get taskGoBack => 'कामों पर वापस';

  @override
  String get taskSectionInfo => 'विवरण';

  @override
  String get taskCategoryLabel => 'श्रेणी';

  @override
  String get taskTenantLabel => 'किरायेदार';

  @override
  String get taskEstimatedCost => 'अनुमानित खर्च';

  @override
  String get taskScheduledFor => 'विज़िट';

  @override
  String get taskAssignedAgent => 'एजेंट';

  @override
  String taskAgentNumber(String id) {
    return 'एजेंट #$id';
  }

  @override
  String get taskReported => 'दर्ज किया';

  @override
  String get taskSectionUpdate => 'अपडेट करें';

  @override
  String get taskStatusLabel => 'स्थिति';

  @override
  String get taskUrgencyLabel => 'तात्कालिकता';

  @override
  String get taskNotesLabel => 'पूरा होने के नोट्स';

  @override
  String get taskNotesHint => 'क्या किया गया, और किसने';

  @override
  String get taskSave => 'बदलाव सहेजें';

  @override
  String get taskNothingToSave => 'कुछ नहीं बदला।';

  @override
  String get taskUpdated => 'काम अपडेट हो गया।';

  @override
  String taskProgressSemantics(int step, String label) {
    return '4 में से चरण $step: $label';
  }

  @override
  String get leasesTitle => 'लीज़';

  @override
  String get leasesNew => 'नई लीज़';

  @override
  String get leasesSearchHint => 'किरायेदार या प्रॉपर्टी खोजें';

  @override
  String get leasesFilterActive => 'चालू';

  @override
  String get leasesFilterExpiring => 'जल्द खत्म';

  @override
  String get leasesFilterUpcoming => 'आगामी';

  @override
  String get leasesFilterEnded => 'खत्म';

  @override
  String get leasesEmptyTitle => 'अभी कोई लीज़ नहीं';

  @override
  String get leasesEmptyBody => 'किराया वसूलना शुरू करने के लिए एक लीज़ बनाएं।';

  @override
  String get leasesNoMatchTitle => 'कोई लीज़ मेल नहीं खाती';

  @override
  String get leasesNoMatchBody => 'कोई दूसरा नाम या फ़िल्टर आज़माएं।';

  @override
  String leasesTerm(String start, String end) {
    return '$start से $end';
  }

  @override
  String get leasesEndsToday => 'आज खत्म';

  @override
  String leasesEndsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन में खत्म',
      one: '1 दिन में खत्म',
    );
    return '$_temp0';
  }

  @override
  String get leaseStatusDraft => 'ड्राफ़्ट';

  @override
  String get leaseStatusPendingSignature => 'हस्ताक्षर बाकी';

  @override
  String get leaseStatusActive => 'चालू';

  @override
  String get leaseStatusExpiringSoon => 'जल्द खत्म';

  @override
  String get leaseStatusExpired => 'खत्म हो गई';

  @override
  String get leaseStatusTerminated => 'समाप्त की गई';

  @override
  String get leaseStatusRenewed => 'नवीनीकृत';

  @override
  String get authEntryHeadline =>
      'किराया, किरायेदार और मरम्मत, एक ही बहीखाते में।';

  @override
  String get authEntrySubtitle => 'साइन इन करें, या अपना खाता बनाएं।';

  @override
  String get authIdentifierLabel => 'ईमेल या फ़ोन नंबर';

  @override
  String get authIdentifierHint => 'you@example.com या 98765 43210';

  @override
  String get authIdentifierRequired => 'अपना ईमेल या फ़ोन नंबर दर्ज करें।';

  @override
  String get authIdentifierInvalid => 'सही ईमेल या फ़ोन नंबर दर्ज करें।';

  @override
  String get authCodeHelper => 'पासवर्ड न होने पर हम सत्यापन कोड भेजते हैं।';

  @override
  String get authUseMyNumber => 'मेरा नंबर इस्तेमाल करें';

  @override
  String get authLastUsedGoogle => 'पिछली बार आपने Google इस्तेमाल किया था।';

  @override
  String get authLastUsedApple => 'पिछली बार आपने Apple इस्तेमाल किया था।';

  @override
  String authLastUsedEmail(String masked) {
    return 'पिछली बार आपने $masked इस्तेमाल किया था।';
  }

  @override
  String get authOrContinueWith => 'या इससे जारी रखें';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String authTermsSentence(String terms, String privacy) {
    return 'जारी रखकर, आप $terms और $privacy से सहमत होते हैं।';
  }

  @override
  String authAgreeTerms(String terms, String privacy) {
    return 'मैं $terms और $privacy से सहमत हूं।';
  }

  @override
  String get authAcceptTerms => 'जारी रखने के लिए शर्तें स्वीकार करें।';

  @override
  String get authUnverifiedNotice =>
      'आपका खाता अभी सत्यापित नहीं है। भेजा गया कोड दर्ज करें, या नया कोड मांगें।';

  @override
  String get authCheckFailed =>
      'हम आपका खाता जांच नहीं सके। दोबारा कोशिश करें।';

  @override
  String get authNoAccount =>
      'इस ईमेल या फ़ोन से कोई खाता नहीं है। इसे जांचें, या खाता बनाएं।';

  @override
  String get authLoginTitle => 'फिर से स्वागत है';

  @override
  String get authLoginSubtitle => 'साइन इन करने के लिए अपना पासवर्ड दर्ज करें।';

  @override
  String get authChange => 'बदलें';

  @override
  String get authEmail => 'ईमेल';

  @override
  String get authPhone => 'फ़ोन नंबर';

  @override
  String get authPhoneHint => '98765 43210';

  @override
  String get authPhoneInvalid => 'सही 10 अंकों का फ़ोन नंबर दर्ज करें।';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authPasswordInvalid =>
      'अपना पासवर्ड दर्ज करें। इसमें कम से कम 6 अक्षर हैं।';

  @override
  String get authShowPassword => 'पासवर्ड दिखाएं';

  @override
  String get authHidePassword => 'पासवर्ड छिपाएं';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authNewHere => 'नए हैं?';

  @override
  String get authResetTitle => 'पासवर्ड रीसेट करें';

  @override
  String get authResetBody =>
      'हम इस नंबर पर कोड भेजेंगे। फिर आप नया पासवर्ड सेट करेंगे।';

  @override
  String get authSendCode => 'कोड भेजें';

  @override
  String get authSignupTitle => 'अपना खाता बनाएं';

  @override
  String get authSignupSubtitle =>
      'कुछ जानकारी, फिर हम आपका फ़ोन सत्यापित करेंगे।';

  @override
  String get authFullName => 'पूरा नाम';

  @override
  String get authFullNameRequired => 'अपना पूरा नाम दर्ज करें।';

  @override
  String get authEmailRequired => 'अपना ईमेल दर्ज करें।';

  @override
  String get authEmailInvalid => 'सही ईमेल पता दर्ज करें।';

  @override
  String get authNewPasswordHelper => 'कम से कम 6 अक्षर।';

  @override
  String get authPasswordTooShort => 'कम से कम 6 अक्षर इस्तेमाल करें।';

  @override
  String get authConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get authConfirmPasswordRequired => 'पासवर्ड फिर से दर्ज करें।';

  @override
  String get authPasswordsDiffer => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get authVerifyPhoneTitle => 'अपना फ़ोन सत्यापित करें';

  @override
  String get authVerifyEmailTitle => 'अपना ईमेल सत्यापित करें';

  @override
  String authCodeSentTo(String destination) {
    return '$destination पर भेजा गया 6 अंकों का कोड दर्ज करें।';
  }

  @override
  String get authCodeLabel => 'सत्यापन कोड';

  @override
  String get authVerify => 'सत्यापित करें';

  @override
  String get authDidNotGetCode => 'कोड नहीं मिला?';

  @override
  String get authResendCode => 'कोड फिर से भेजें';

  @override
  String authResendIn(int seconds) {
    return '$seconds सेकंड में फिर से भेजें';
  }

  @override
  String get authSetPasswordTitle => 'अपना पासवर्ड सेट करें';

  @override
  String get authResetPasswordTitle => 'अपना पासवर्ड रीसेट करें';

  @override
  String get authSetPasswordBody =>
      'पासवर्ड बनाएं ताकि अगली बार जल्दी साइन इन कर सकें।';

  @override
  String get authResetPasswordBody => 'अपने खाते के लिए नया पासवर्ड चुनें।';

  @override
  String authPasswordFor(String account) {
    return '$account के लिए';
  }

  @override
  String get authNewPassword => 'नया पासवर्ड';

  @override
  String get authSetPasswordAction => 'पासवर्ड सेट करें और जारी रखें';

  @override
  String get authResetPasswordAction => 'पासवर्ड रीसेट करें और जारी रखें';

  @override
  String get authUseDifferentAccount => 'दूसरा खाता इस्तेमाल करें';

  @override
  String get authLeaveTitle => 'जारी रखने के लिए पासवर्ड सेट करें';

  @override
  String get authLeaveBody =>
      'साइन इन पूरा करने के लिए पासवर्ड ज़रूरी है। बाहर जाने पर आप साइन आउट हो जाएंगे।';

  @override
  String get authAddPhoneTitle => 'अपना फ़ोन जोड़ें';

  @override
  String get authAddPhoneBody =>
      'वैकल्पिक। सत्यापित नंबर से खाता वापस पाना और साइन इन आसान होता है।';

  @override
  String get authVerifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get authChangeNumber => 'नंबर बदलें';

  @override
  String get authSkipForNow => 'अभी छोड़ें';

  @override
  String get authProfileTitle => 'कुछ और जानकारी';

  @override
  String get authProfileBody =>
      'जारी रखने के लिए हमें आपका पूरा नाम और जन्म तिथि चाहिए।';

  @override
  String get authDateOfBirth => 'जन्म तिथि';

  @override
  String get authDateOfBirthHint => 'अपनी जन्म तिथि चुनें';

  @override
  String get authDateOfBirthRequired => 'अपनी जन्म तिथि चुनें।';

  @override
  String get authProfileSaveFailed =>
      'हम आपकी जानकारी सेव नहीं कर सके। दोबारा कोशिश करें।';

  @override
  String get authSplashTagline => 'प्रॉपर्टी प्रबंधन, सही तरीके से।';

  @override
  String get onboardingTitle => 'आपका बहीखाता तैयार है';

  @override
  String get onboardingBody =>
      'एक प्रॉपर्टी से शुरू करें। फिर किरायेदार जोड़ें, किराया आने पर दर्ज करें, और मरम्मत पर नज़र रखें, सब एक जगह।';

  @override
  String get onboardingStepProperty => 'प्रॉपर्टी जोड़ें';

  @override
  String get onboardingStepTenants => 'किरायेदार और लीज़ जोड़ें';

  @override
  String get onboardingStepRent => 'हर महीने किराया दर्ज करें';

  @override
  String get onboardingAddProperty => 'अपनी पहली प्रॉपर्टी जोड़ें';

  @override
  String get onboardingGoHome => 'होम पर जाएं';

  @override
  String get configErrorBody =>
      'ऐप बिना सेटिंग के बनाया गया है। .env में कमी वाली वैल्यू जोड़ें, फिर ऐप दोबारा बनाएं और शुरू करें।';

  @override
  String get inspectionsTitle => 'निरीक्षण';

  @override
  String get inspectionsTemplatesAction => 'चेकलिस्ट टेम्पलेट';

  @override
  String get inspectionsNew => 'नया निरीक्षण';

  @override
  String get inspectionsEmptyTitle => 'अभी कोई निरीक्षण नहीं';

  @override
  String get inspectionsEmptyBody =>
      'किसी लीज़ के लिए मूव-इन, मूव-आउट या नियमित जांच दर्ज करें।';

  @override
  String inspectionsItemTitle(String type) {
    return '$type निरीक्षण';
  }

  @override
  String get inspectionsDateNotSet => 'तारीख तय नहीं';

  @override
  String get inspectionTypeMoveIn => 'मूव-इन';

  @override
  String get inspectionTypeMoveOut => 'मूव-आउट';

  @override
  String get inspectionTypeRoutine => 'नियमित';

  @override
  String get inspectionStateOpen => 'खुला';

  @override
  String get inspectionStateSignedByOwner => 'मालिक ने हस्ताक्षर किए';

  @override
  String get inspectionStateSignedByTenant => 'किरायेदार ने हस्ताक्षर किए';

  @override
  String get inspectionStateSigned => 'हस्ताक्षरित';

  @override
  String get inspectionFormTitle => 'नया निरीक्षण';

  @override
  String get inspectionFormLeaseSection => 'लीज़';

  @override
  String get inspectionFormProperty => 'प्रॉपर्टी';

  @override
  String get inspectionFormLease => 'लीज़';

  @override
  String get inspectionFormChooseProperty => 'एक प्रॉपर्टी चुनें।';

  @override
  String get inspectionFormChooseLease => 'एक लीज़ चुनें।';

  @override
  String get inspectionFormPickPropertyFirst =>
      'इसकी लीज़ देखने के लिए एक प्रॉपर्टी चुनें।';

  @override
  String get inspectionFormNoLease => 'इस प्रॉपर्टी की अभी कोई लीज़ नहीं है।';

  @override
  String get inspectionFormAddLease => 'लीज़ जोड़ें';

  @override
  String get inspectionFormDetailsSection => 'विवरण';

  @override
  String get inspectionFormType => 'प्रकार';

  @override
  String get inspectionFormDate => 'निरीक्षण की तारीख';

  @override
  String get inspectionFormToday => 'आज';

  @override
  String get inspectionFormNotes => 'नोट्स';

  @override
  String get inspectionFormNotesHelp =>
      'कुल स्थिति, मीटर रीडिंग, सौंपी गई चाबियां।';

  @override
  String get inspectionFormChecklistSection => 'चेकलिस्ट';

  @override
  String get inspectionFormUseTemplate => 'टेम्पलेट इस्तेमाल करें';

  @override
  String get inspectionFormAddItem => 'चेकलिस्ट आइटम जोड़ें';

  @override
  String get inspectionFormAddItemButton => 'आइटम जोड़ें';

  @override
  String get inspectionFormRemoveItem => 'आइटम हटाएं';

  @override
  String get inspectionFormNoItems =>
      'अभी कोई आइटम नहीं। अपने आइटम जोड़ें या किसी टेम्पलेट से शुरू करें।';

  @override
  String get inspectionFormTemplateSheetTitle => 'टेम्पलेट से शुरू करें';

  @override
  String inspectionFormTemplateAdded(int count) {
    return '$count आइटम जोड़े गए';
  }

  @override
  String get inspectionFormCreate => 'निरीक्षण बनाएं';

  @override
  String get inspectionFormCreated => 'निरीक्षण बन गया।';

  @override
  String get inspectionDetailTitle => 'निरीक्षण';

  @override
  String get inspectionDetailInvalidLink => 'यह निरीक्षण लिंक मान्य नहीं है।';

  @override
  String get inspectionDetailSignatures => 'हस्ताक्षर';

  @override
  String get inspectionDetailOwner => 'मालिक';

  @override
  String get inspectionDetailTenant => 'किरायेदार';

  @override
  String get inspectionDetailNotSigned => 'अभी हस्ताक्षर नहीं';

  @override
  String inspectionDetailSignedOn(String date) {
    return '$date को हस्ताक्षर किए';
  }

  @override
  String get inspectionDetailChecklistEmpty => 'कोई चेकलिस्ट आइटम नहीं।';

  @override
  String get inspectionDetailRequired => 'ज़रूरी';

  @override
  String get inspectionDetailSign => 'मालिक के रूप में हस्ताक्षर करें';

  @override
  String get inspectionDetailSignTitle => 'इस निरीक्षण पर हस्ताक्षर करें?';

  @override
  String get inspectionDetailSignBody =>
      'आपका हस्ताक्षर दर्ज करता है कि आप इस चेकलिस्ट से सहमत हैं। इसे वापस नहीं लिया जा सकता।';

  @override
  String get inspectionDetailSignConfirm => 'हस्ताक्षर करें';

  @override
  String get inspectionDetailSigned => 'निरीक्षण पर हस्ताक्षर हो गए।';

  @override
  String get inspectionItemPass => 'ठीक';

  @override
  String get inspectionItemFail => 'खराब';

  @override
  String get inspectionItemAttention => 'ध्यान चाहिए';

  @override
  String get inspectionItemPending => 'बाकी';

  @override
  String get inspectionTemplatesTitle => 'चेकलिस्ट टेम्पलेट';

  @override
  String get inspectionTemplatesNew => 'नया टेम्पलेट';

  @override
  String get inspectionTemplatesEmptyTitle => 'अभी कोई टेम्पलेट नहीं';

  @override
  String get inspectionTemplatesEmptyBody =>
      'एक बार चेकलिस्ट सहेजें और हर मूव-इन, मूव-आउट या सालाना जांच में दोबारा इस्तेमाल करें।';

  @override
  String inspectionTemplatesItemCount(int count) {
    return '$count आइटम';
  }

  @override
  String get inspectionTemplatesDelete => 'टेम्पलेट हटाएं';

  @override
  String get inspectionTemplatesDeleteTitle => 'यह टेम्पलेट हटाएं?';

  @override
  String inspectionTemplatesDeleteBody(String name) {
    return '\"$name\" इस डिवाइस से हट जाएगा। पहले से बने निरीक्षणों की चेकलिस्ट बनी रहेगी।';
  }

  @override
  String get inspectionTemplatesName => 'टेम्पलेट का नाम';

  @override
  String get inspectionTemplatesNameHint => 'उदाहरण के लिए, मूव-इन चेकलिस्ट';

  @override
  String get inspectionTemplatesNameRequired => 'नाम दर्ज करें।';

  @override
  String get inspectionTemplatesDescription => 'विवरण (वैकल्पिक)';

  @override
  String get inspectionTemplatesItems => 'चेकलिस्ट आइटम';

  @override
  String get inspectionTemplatesItemsHelp => 'हर लाइन में एक आइटम।';

  @override
  String get inspectionTemplatesItemsRequired => 'कम से कम एक आइटम जोड़ें।';

  @override
  String get inspectionTemplatesCreate => 'बनाएं';

  @override
  String get applicationsTitle => 'आवेदन';

  @override
  String get applicationsTabInbox => 'इनबॉक्स';

  @override
  String get applicationsTabForms => 'फ़ॉर्म';

  @override
  String get applicationsNewForm => 'नया फ़ॉर्म';

  @override
  String get applicationsInboxEmptyTitle => 'अभी कोई आवेदन नहीं';

  @override
  String get applicationsInboxEmptyBody =>
      'फ़ॉर्म का लिंक साझा करें। किरायेदारों के आवेदन यहां आएंगे।';

  @override
  String get applicationsFormsEmptyTitle => 'अभी कोई फ़ॉर्म नहीं';

  @override
  String get applicationsFormsEmptyBody =>
      'किसी प्रॉपर्टी के लिए फ़ॉर्म बनाएं और किराये पर लेने वालों से उसका लिंक साझा करें।';

  @override
  String get applicationsActive => 'सक्रिय';

  @override
  String get applicationsInactive => 'निष्क्रिय';

  @override
  String get applicationsStatusApplicant => 'फ़ैसला बाकी';

  @override
  String get applicationsStatusApproved => 'स्वीकृत';

  @override
  String get applicationsStatusRejected => 'अस्वीकृत';

  @override
  String get applicationsStatusUnknown => 'अज्ञात';

  @override
  String applicationsQuestionCount(int count) {
    return '$count सवाल';
  }

  @override
  String applicationsExpires(String date) {
    return '$date को बंद';
  }

  @override
  String get applicationsNoExpiry => 'बंद होने की तारीख नहीं';

  @override
  String applicationsFee(String amount) {
    return '$amount शुल्क';
  }

  @override
  String get applicationsCopyLink => 'लिंक कॉपी करें';

  @override
  String get applicationsLinkCopied => 'लिंक कॉपी हो गया।';

  @override
  String applicationsSubmittedOn(String date) {
    return '$date को आवेदन';
  }

  @override
  String get applicationsApplicant => 'आवेदक';

  @override
  String get applicationFormDefaultTitle => 'आवेदन फ़ॉर्म';

  @override
  String get applicationFormDetailTitle => 'आवेदन फ़ॉर्म';

  @override
  String get applicationFormInvalidLink => 'यह फ़ॉर्म लिंक मान्य नहीं है।';

  @override
  String get applicationFormShareSection => 'लिंक साझा करें';

  @override
  String get applicationFormShareHelp =>
      'यह लिंक किराये पर लेने वालों को भेजें। यह किसी भी फ़ोन पर फ़ॉर्म खोलता है।';

  @override
  String get applicationFormNoLink =>
      'इस फ़ॉर्म का अभी कोई सार्वजनिक लिंक नहीं है।';

  @override
  String get applicationFormShare => 'साझा करें';

  @override
  String get applicationFormPreview => 'पूर्वावलोकन';

  @override
  String get applicationFormQuestionsSection => 'सवाल';

  @override
  String get applicationFormStandardQuestions =>
      'हर आवेदक अपना नाम, फ़ोन और ईमेल भी देता है।';

  @override
  String get applicationFormNoQuestions => 'कोई अतिरिक्त सवाल नहीं।';

  @override
  String get applicationFormRequired => 'ज़रूरी';

  @override
  String get applicationFormCreateTitle => 'नया आवेदन फ़ॉर्म';

  @override
  String get applicationFormDetailsSection => 'फ़ॉर्म का विवरण';

  @override
  String get applicationFormProperty => 'प्रॉपर्टी';

  @override
  String get applicationFormChooseProperty => 'एक प्रॉपर्टी चुनें।';

  @override
  String get applicationFormTitleLabel => 'फ़ॉर्म का शीर्षक';

  @override
  String get applicationFormTitleHint => 'उदाहरण के लिए, सेक्टर 51 में 2 BHK';

  @override
  String get applicationFormTitleRequired => 'फ़ॉर्म का शीर्षक दर्ज करें।';

  @override
  String get applicationFormDescription => 'विवरण (वैकल्पिक)';

  @override
  String get applicationFormDescriptionHelp => 'फ़ॉर्म के ऊपर दिखता है।';

  @override
  String get applicationFormCloses => 'बंद होने की तारीख (वैकल्पिक)';

  @override
  String get applicationFormClearDate => 'तारीख हटाएं';

  @override
  String get applicationFormAccepting => 'आवेदन स्वीकार करें';

  @override
  String get applicationFormAcceptingHelp => 'नए आवेदन रोकने के लिए बंद करें।';

  @override
  String get applicationFormQuestionLabel => 'सवाल';

  @override
  String get applicationFormQuestionHint =>
      'उदाहरण के लिए, क्या आपके पास पालतू जानवर हैं?';

  @override
  String get applicationFormQuestionRequired => 'पहले सवाल लिखें।';

  @override
  String get applicationFormAnswerType => 'जवाब का प्रकार';

  @override
  String get applicationFormOptions => 'विकल्प';

  @override
  String get applicationFormOptionsHelp => 'विकल्पों को कॉमा से अलग करें।';

  @override
  String get applicationFormOptionsRequired => 'कम से कम एक विकल्प जोड़ें।';

  @override
  String get applicationFormRequiredAnswer => 'जवाब ज़रूरी';

  @override
  String get applicationFormAddQuestion => 'सवाल जोड़ें';

  @override
  String get applicationFormRemoveQuestion => 'सवाल हटाएं';

  @override
  String get applicationFormCreate => 'फ़ॉर्म बनाएं';

  @override
  String get applicationFormCreated => 'फ़ॉर्म बन गया।';

  @override
  String get applicationFieldText => 'छोटा जवाब';

  @override
  String get applicationFieldTextarea => 'लंबा जवाब';

  @override
  String get applicationFieldNumber => 'संख्या';

  @override
  String get applicationFieldDate => 'तारीख';

  @override
  String get applicationFieldBoolean => 'हां या नहीं';

  @override
  String get applicationFieldSelect => 'विकल्प';

  @override
  String get applicationDetailTitle => 'आवेदन';

  @override
  String get applicationDetailInvalidLink => 'यह आवेदन लिंक मान्य नहीं है।';

  @override
  String get applicationDetailPhone => 'फ़ोन';

  @override
  String get applicationDetailEmail => 'ईमेल';

  @override
  String get applicationDetailNotGiven => 'नहीं दिया';

  @override
  String get applicationDetailCall => 'कॉल करें';

  @override
  String get applicationDetailWrite => 'ईमेल भेजें';

  @override
  String get applicationDetailAnswers => 'जवाब';

  @override
  String get applicationDetailNoAnswers => 'कोई अतिरिक्त जवाब नहीं।';

  @override
  String get applicationDetailApplicantNote => 'आवेदक का नोट';

  @override
  String get applicationDetailYes => 'हां';

  @override
  String get applicationDetailNo => 'नहीं';

  @override
  String get applicationDetailDecision => 'फ़ैसला';

  @override
  String applicationDetailDecidedOn(String date) {
    return '$date को फ़ैसला';
  }

  @override
  String get applicationDetailYourDecision => 'आपका फ़ैसला';

  @override
  String get applicationDetailDecisionHelp =>
      'आवेदक को अपने आप सूचना नहीं मिलती। फ़ैसले के बाद उन्हें कॉल करें।';

  @override
  String get applicationDetailApprove => 'स्वीकार करें';

  @override
  String get applicationDetailReject => 'अस्वीकार करें';

  @override
  String get applicationDetailApproveTitle => 'यह आवेदन स्वीकार करें?';

  @override
  String get applicationDetailRejectTitle => 'यह आवेदन अस्वीकार करें?';

  @override
  String get applicationDetailDecisionNotes => 'नोट्स (वैकल्पिक)';

  @override
  String get applicationDetailDecisionNotesHelp =>
      'ये नोट्स सिर्फ़ आपको दिखते हैं।';

  @override
  String get applicationDetailApproved => 'आवेदन स्वीकार हो गया।';

  @override
  String get applicationDetailRejected => 'आवेदन अस्वीकार हो गया।';

  @override
  String get publicApplyTitle => 'किराये के लिए आवेदन';

  @override
  String get publicApplyIntro =>
      'अपना विवरण भरें। मालिक हर आवेदन देखते हैं और आपसे संपर्क करते हैं।';

  @override
  String publicApplyFee(String amount) {
    return 'आवेदन शुल्क $amount';
  }

  @override
  String get publicApplyAboutYou => 'आपके बारे में';

  @override
  String get publicApplyName => 'पूरा नाम';

  @override
  String get publicApplyNameRequired => 'अपना नाम दर्ज करें।';

  @override
  String get publicApplyPhone => 'फ़ोन नंबर';

  @override
  String get publicApplyPhoneRequired => 'अपना फ़ोन नंबर दर्ज करें।';

  @override
  String get publicApplyPhoneInvalid => '10 अंकों का फ़ोन नंबर दर्ज करें।';

  @override
  String get publicApplyEmail => 'ईमेल';

  @override
  String get publicApplyEmailRequired => 'अपना ईमेल दर्ज करें।';

  @override
  String get publicApplyEmailInvalid => 'name@example.com जैसा ईमेल दर्ज करें।';

  @override
  String get publicApplyQuestions => 'कुछ सवाल';

  @override
  String get publicApplyRequiredNote => '* वाले सवालों का जवाब ज़रूरी है।';

  @override
  String get publicApplyAnswerRequired => 'इस सवाल का जवाब दें।';

  @override
  String get publicApplyNumberInvalid => 'एक संख्या दर्ज करें।';

  @override
  String get publicApplyChoose => 'एक चुनें';

  @override
  String get publicApplyNotes => 'कुछ और? (वैकल्पिक)';

  @override
  String get publicApplyNotesHelp =>
      'आने की तारीख, साथ कौन रहेगा, पार्किंग की ज़रूरत।';

  @override
  String get publicApplySubmit => 'आवेदन भेजें';

  @override
  String get publicApplyClosedTitle => 'आवेदन बंद हैं';

  @override
  String get publicApplyClosedBody => 'यह फ़ॉर्म अभी आवेदन नहीं ले रहा है।';

  @override
  String get publicApplySentTitle => 'आवेदन भेज दिया गया';

  @override
  String get publicApplySentBody => 'मालिक के पास अब आपका विवरण है।';

  @override
  String get publicApplySentNext => 'आगे क्या होगा';

  @override
  String get publicApplySentStep1 => 'मालिक आपका आवेदन देखेंगे।';

  @override
  String get publicApplySentStep2 =>
      'वे आपके दिए गए फ़ोन नंबर पर संपर्क करेंगे।';

  @override
  String get publicApplySentStep3 => 'अब आप यह पेज बंद कर सकते हैं।';

  @override
  String get publicApplySignIn => '360 एस्टेट में साइन इन करें';

  @override
  String leaseLateFeeFlat(String amount) {
    return '$amount तय';
  }

  @override
  String leaseLateFeePercent(String percent) {
    return 'किराए का $percent%';
  }

  @override
  String get leaseDetailTitle => 'लीज़';

  @override
  String get leaseMonthlyRent => 'मासिक किराया';

  @override
  String get leaseDeposit => 'सिक्योरिटी डिपॉज़िट';

  @override
  String get leaseEndsTodayNotice =>
      'यह लीज़ आज खत्म हो रही है। इसे नवीनीकृत करें या खत्म होने दें।';

  @override
  String leaseEndsInNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'यह लीज़ $count दिन में खत्म होगी। इसे नवीनीकृत करें या खत्म होने दें।',
      one: 'यह लीज़ कल खत्म होगी। इसे नवीनीकृत करें या खत्म होने दें।',
    );
    return '$_temp0';
  }

  @override
  String leaseExpiredNotice(String date) {
    return 'यह लीज़ $date को खत्म हो गई।';
  }

  @override
  String get leaseSectionTerm => 'अवधि';

  @override
  String get leaseStart => 'शुरुआत';

  @override
  String get leaseEnd => 'अंत';

  @override
  String leaseTermElapsed(String percent) {
    return 'अवधि का $percent% बीत चुका है';
  }

  @override
  String get leaseSectionTenant => 'किरायेदार';

  @override
  String get leaseName => 'नाम';

  @override
  String get leasePhone => 'फ़ोन';

  @override
  String get leaseEmail => 'ईमेल';

  @override
  String get leaseCallTenant => 'किरायेदार को कॉल करें';

  @override
  String get leaseSectionCollection => 'किराया वसूली';

  @override
  String get leaseDueDay => 'देय दिन';

  @override
  String leaseDueDayValue(int day) {
    return 'हर महीने का $dayवां दिन';
  }

  @override
  String get leaseGracePeriod => 'छूट अवधि';

  @override
  String leaseGraceValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get leaseLateFee => 'विलंब शुल्क';

  @override
  String get leaseLateFeeRule => 'विलंब शुल्क छूट अवधि के बाद एक बार लगता है।';

  @override
  String get leaseTerminatedOn => 'खत्म होने की तारीख';

  @override
  String get leaseReason => 'कारण';

  @override
  String get leaseSectionDocument => 'हस्ताक्षरित लीज़';

  @override
  String get leaseDocumentMissing =>
      'अभी कोई हस्ताक्षरित प्रति नहीं। PDF अपलोड करें।';

  @override
  String get leaseDocumentPresent => 'हस्ताक्षरित PDF सहेजी हुई है।';

  @override
  String get leaseUploadPdf => 'PDF अपलोड करें';

  @override
  String get leaseReplacePdf => 'PDF बदलें';

  @override
  String get leaseViewSigned => 'हस्ताक्षरित लीज़ देखें';

  @override
  String get leaseUploaded => 'हस्ताक्षरित लीज़ अपलोड हो गई।';

  @override
  String get leaseOpenFailed => 'दस्तावेज़ खुल नहीं सका।';

  @override
  String get leaseRenew => 'नवीनीकृत करें';

  @override
  String get leaseTerminate => 'समाप्त करें';

  @override
  String get leaseRenewTitle => 'लीज़ नवीनीकृत करें';

  @override
  String get leaseNewStart => 'नई शुरुआत की तारीख';

  @override
  String get leaseNewEnd => 'नई अंतिम तारीख';

  @override
  String get leaseNewRent => 'नया मासिक किराया';

  @override
  String get leaseNewRentHelper => 'मौजूदा किराया रखने के लिए खाली छोड़ें।';

  @override
  String get leaseStartActive => 'चालू के रूप में शुरू करें';

  @override
  String get leaseEndAfterStart =>
      'अंतिम तारीख शुरुआत की तारीख के बाद होनी चाहिए।';

  @override
  String get leaseRenewed => 'लीज़ नवीनीकृत हो गई।';

  @override
  String get leaseTerminateTitle => 'लीज़ समाप्त करें';

  @override
  String get leaseTerminateBody =>
      'किरायेदार इस तारीख को चला जाएगा। इसे वापस नहीं किया जा सकता।';

  @override
  String get leaseTerminationDate => 'समाप्ति की तारीख';

  @override
  String get leaseTerminated => 'लीज़ समाप्त हो गई।';

  @override
  String get leaseFormTitle => 'नई लीज़';

  @override
  String get leaseFormSectionParties => 'प्रॉपर्टी और किरायेदार';

  @override
  String get leaseFormProperty => 'प्रॉपर्टी *';

  @override
  String get leaseFormPropertyRequired => 'एक प्रॉपर्टी चुनें।';

  @override
  String get leaseFormPropertiesFailed => 'आपकी प्रॉपर्टी लोड नहीं हो सकीं।';

  @override
  String get leaseFormTenantName => 'किरायेदार का नाम';

  @override
  String get leaseFormTenantPhone => 'किरायेदार का फ़ोन';

  @override
  String get leaseFormTenantEmail => 'किरायेदार का ईमेल';

  @override
  String get leaseFormTenantUserId => 'किरायेदार यूज़र ID (वैकल्पिक)';

  @override
  String get leaseFormTenantUserIdHelper => 'किरायेदार का अकाउंट ID, अगर है।';

  @override
  String get leaseFormSectionTerm => 'अवधि और स्थिति';

  @override
  String get leaseFormStart => 'शुरुआत की तारीख *';

  @override
  String get leaseFormEnd => 'अंतिम तारीख *';

  @override
  String get leaseFormDateRequired => 'एक तारीख चुनें।';

  @override
  String get leaseFormStatus => 'स्थिति';

  @override
  String get leaseFormSectionRent => 'किराया';

  @override
  String get leaseFormRent => 'मासिक किराया *';

  @override
  String get leaseFormRentInvalid => 'शून्य से अधिक मासिक किराया दर्ज करें।';

  @override
  String get leaseFormDeposit => 'सिक्योरिटी डिपॉज़िट';

  @override
  String get leaseFormFromProperty =>
      'प्रॉपर्टी से भरा गया। अगर यह लीज़ अलग है तो बदलें।';

  @override
  String get leaseFormSectionRules => 'किराया वसूली के नियम';

  @override
  String get leaseFormRulesHelp =>
      'खाली फ़ील्ड प्रॉपर्टी के मान लेते हैं। तय विलंब शुल्क प्रतिशत से ऊपर माना जाता है।';

  @override
  String get leaseFormDueDay => 'देय दिन';

  @override
  String get leaseFormGraceDays => 'छूट के दिन';

  @override
  String get leaseFormLateFeeFlat => 'विलंब शुल्क (तय)';

  @override
  String get leaseFormLateFeePercent => 'विलंब शुल्क (%)';

  @override
  String leaseFormRange(int min, int max) {
    return '$min से $max तक पूर्ण संख्या दर्ज करें।';
  }

  @override
  String get leaseFormPercentRange => '0 से 100 दर्ज करें।';

  @override
  String get leaseFormSectionClauses => 'विशेष शर्तें';

  @override
  String get leaseFormClauses => 'विशेष शर्तें (वैकल्पिक)';

  @override
  String get leaseFormClausesHint => 'किराए और तारीखों के अलावा कोई शर्त';

  @override
  String get leaseFormCreate => 'लीज़ बनाएं';

  @override
  String get leaseFormCreated => 'लीज़ बन गई।';

  @override
  String get moreSectionManage => 'प्रबंधन';

  @override
  String get moreSectionAccount => 'खाता';

  @override
  String get moreSectionSupport => 'सहायता';

  @override
  String get moreApplications => 'किराये के आवेदन';

  @override
  String get moreTenants => 'किरायेदार';

  @override
  String get moreLeases => 'लीज़';

  @override
  String get moreInspections => 'निरीक्षण';

  @override
  String get moreExpenses => 'खर्च';

  @override
  String get moreDocuments => 'दस्तावेज़';

  @override
  String get moreReports => 'रिपोर्ट';

  @override
  String get moreSettings => 'सेटिंग्स';

  @override
  String get moreChangePassword => 'पासवर्ड बदलें';

  @override
  String get moreHelp => 'सहायता केंद्र';

  @override
  String get moreContact => 'हमसे संपर्क करें';

  @override
  String get moreSignOutTitle => 'साइन आउट करें?';

  @override
  String get moreSignOutBody =>
      'अपनी प्रॉपर्टी देखने के लिए आपको फिर से साइन इन करना होगा।';

  @override
  String moreVersion(String version) {
    return '360 एस्टेट $version';
  }

  @override
  String get moreOpenProfile => 'अपनी प्रोफ़ाइल खोलें';

  @override
  String get moreGuestName => 'आपका खाता';

  @override
  String get profilePageTitle => 'प्रोफ़ाइल';

  @override
  String get profileEditAction => 'प्रोफ़ाइल बदलें';

  @override
  String get profileDetailsTitle => 'आपकी जानकारी';

  @override
  String get profileSecurityTitle => 'सुरक्षा';

  @override
  String get profileNotSet => 'नहीं जोड़ा गया';

  @override
  String get profileName => 'पूरा नाम';

  @override
  String get profileEmail => 'ईमेल';

  @override
  String get profilePhone => 'फ़ोन';

  @override
  String get profileChangePhoto => 'फ़ोटो बदलें';

  @override
  String get profileTakePhoto => 'फ़ोटो लें';

  @override
  String get profileChoosePhoto => 'गैलरी से चुनें';

  @override
  String get profileRemovePhoto => 'नई फ़ोटो हटाएं';

  @override
  String get profileEmailHelper => 'ईमेल आपकी साइन-इन सेटिंग्स से बदलता है।';

  @override
  String get profileSavedShort => 'प्रोफ़ाइल सहेजी गई';

  @override
  String get profileSaveFailed =>
      'आपकी प्रोफ़ाइल सहेजी नहीं जा सकी। फिर कोशिश करें।';

  @override
  String get passwordPageIntro =>
      'अपना मौजूदा पासवर्ड डालें, फिर नया पासवर्ड चुनें।';

  @override
  String get passwordShow => 'पासवर्ड दिखाएं';

  @override
  String get passwordHide => 'पासवर्ड छिपाएं';

  @override
  String get passwordCurrentLabel => 'मौजूदा पासवर्ड';

  @override
  String get passwordNewLabel => 'नया पासवर्ड';

  @override
  String get passwordRules => 'आपके नए पासवर्ड में होना चाहिए';

  @override
  String get passwordTooShort8 => 'कम से कम 8 अक्षर रखें।';

  @override
  String get passwordChangedShort => 'पासवर्ड बदल गया';

  @override
  String get passwordChangeFailedShort =>
      'आपका पासवर्ड बदला नहीं जा सका। फिर कोशिश करें।';

  @override
  String get passwordRuleMet => 'पूरा';

  @override
  String get passwordRuleMissing => 'बाकी';

  @override
  String get settingsLanguageSystemDesc => 'फ़ोन की भाषा अपनाएं';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageHindi => 'हिन्दी';

  @override
  String get settingsAlertsTitle => 'सूचनाएं और गोपनीयता';

  @override
  String get settingsNotificationPrefs => 'सूचना प्राथमिकताएं';

  @override
  String get settingsPrivacy => 'गोपनीयता';

  @override
  String get settingsDeleteAccount => 'खाता हटाएं';

  @override
  String get settingsDeleteAccountDesc => 'अपना खाता और उसका डेटा हटाएं';

  @override
  String get notifPrefsNote =>
      'ये विकल्प इस फ़ोन पर सहेजे जाते हैं। 360 एस्टेट के लिए पुश सूचनाएं चालू होते ही अलर्ट शुरू होंगे।';

  @override
  String get notifPrefsAllTitle => 'सूचनाओं की अनुमति दें';

  @override
  String get notifPrefsAllDesc => 'नीचे के सभी अलर्ट एक साथ चालू या बंद करें';

  @override
  String get notifPrefsAlertsTitle => 'अलर्ट';

  @override
  String get notifPrefsEmailTitle => 'ईमेल';

  @override
  String get notifPrefRent => 'किराया बकाया रिमाइंडर';

  @override
  String get notifPrefPayments => 'प्राप्त भुगतान';

  @override
  String get notifPrefLeases => 'खत्म होने वाली लीज़';

  @override
  String get notifPrefMaintenance => 'मरम्मत अपडेट';

  @override
  String get notifPrefInspections => 'निरीक्षण रिमाइंडर';

  @override
  String get notifPrefMarketing => 'समाचार और ऑफ़र';

  @override
  String get privacyDiagnosticsTitle => 'निदान';

  @override
  String get privacyCrashTitle => 'क्रैश रिपोर्ट भेजें';

  @override
  String get privacyCrashDesc =>
      'इससे हमें गड़बड़ियां ढूंढने और ठीक करने में मदद मिलती है। अगली बार ऐप खोलने पर लागू होगा।';

  @override
  String get legalPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get legalTerms => 'सेवा की शर्तें';

  @override
  String get legalIntro =>
      'पूरा पाठ हमारी वेबसाइट पर है। यह ऐप के अंदर खुलता है।';

  @override
  String get legalOpen => 'अभी पढ़ें';

  @override
  String get legalOpenFailed =>
      'पेज नहीं खुल सका। कनेक्शन जांचें और फिर कोशिश करें।';

  @override
  String get deleteTitle => 'अपना खाता हटाएं';

  @override
  String get deleteSubmit => 'मेरा खाता हटाएं';

  @override
  String get helpSearchHint => 'सवाल खोजें';

  @override
  String get helpCatAll => 'सभी';

  @override
  String get helpCatProperties => 'प्रॉपर्टी';

  @override
  String get helpCatRent => 'किराया';

  @override
  String get helpCatLeases => 'लीज़';

  @override
  String get helpCatMaintenance => 'रखरखाव';

  @override
  String get helpCatAccount => 'खाता';

  @override
  String get helpQ1 => 'मैं प्रॉपर्टी कैसे जोड़ूं?';

  @override
  String get helpA1 =>
      'प्रॉपर्टी टैब खोलें और प्रॉपर्टी जोड़ें पर टैप करें। जानकारी भरें, फिर सहेजें।';

  @override
  String get helpQ2 => 'मैं किराये का भुगतान कैसे दर्ज करूं?';

  @override
  String get helpA2 =>
      'होम पर भुगतान दर्ज करें पर टैप करें, या वसूली खोलें और चुकाया गया शुल्क चुनें।';

  @override
  String get helpQ3 => 'मैं लीज़ कैसे बनाऊं?';

  @override
  String get helpA3 =>
      'और में जाएं, फिर लीज़ खोलें और जोड़ें बटन पर टैप करें। प्रॉपर्टी और किरायेदार चुनें, फिर किराया और तारीखें तय करें।';

  @override
  String get helpQ4 => 'मैं निरीक्षण कैसे करूं?';

  @override
  String get helpA4 =>
      'और में जाएं, फिर निरीक्षण खोलें और जोड़ें बटन पर टैप करें। प्रॉपर्टी चुनें और चेकलिस्ट पूरी करें।';

  @override
  String get helpQ5 => 'मैं मरम्मत का काम कैसे दर्ज करूं?';

  @override
  String get helpA5 =>
      'काम टैब खोलें और जोड़ें बटन पर टैप करें। समस्या बताएं और प्रॉपर्टी चुनें।';

  @override
  String get helpQ6 => 'मैं अपना नाम या फ़ोटो कैसे बदलूं?';

  @override
  String get helpA6 =>
      'और में जाएं, ऊपर अपने नाम पर टैप करें, फिर प्रोफ़ाइल बदलें पर टैप करें।';

  @override
  String get helpNoResultsTitle => 'कोई जवाब नहीं मिला';

  @override
  String get helpNoResultsBody => 'कोई दूसरा शब्द आज़माएं, या सीधे हमसे पूछें।';

  @override
  String get helpStillStuckTitle => 'अब भी अटके हैं?';

  @override
  String get helpStillStuckBody =>
      'हमें संदेश भेजें। हम आम तौर पर एक दिन में जवाब देते हैं।';

  @override
  String get contactTopic => 'विषय';

  @override
  String get contactCatGeneral => 'सामान्य';

  @override
  String get contactCatTechnical => 'कुछ काम नहीं कर रहा';

  @override
  String get contactCatBilling => 'बिलिंग';

  @override
  String get contactCatFeature => 'सुविधा का सुझाव';

  @override
  String get contactName => 'आपका नाम';

  @override
  String get contactSubject => 'विषय पंक्ति';

  @override
  String get contactMessageTitle => 'आपका संदेश';

  @override
  String get contactMessageHelper => 'बताएं क्या हुआ और किस स्क्रीन पर।';

  @override
  String get contactSend => 'संदेश भेजें';

  @override
  String get contactSent => 'संदेश भेज दिया गया। हम ईमेल से जवाब देंगे।';

  @override
  String contactEmailDirect(String email) {
    return 'या हमें $email पर ईमेल करें';
  }

  @override
  String get aboutTagline => 'किराया, किरायेदार और मरम्मत, एक ही बहीखाते में।';

  @override
  String aboutVersion(String version, String build) {
    return 'संस्करण $version ($build)';
  }

  @override
  String get aboutLicenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get aboutContactTitle => 'संपर्क करें';

  @override
  String aboutCopyright(String year) {
    return '© $year 360Ghar. सर्वाधिकार सुरक्षित।';
  }

  @override
  String get aboutMadeFor => 'भारत के प्रॉपर्टी मालिकों के लिए बना।';

  @override
  String get notifSignedOutTitle => 'अलर्ट देखने के लिए साइन इन करें';

  @override
  String get notifSignedOutBody =>
      'साइन इन करने के बाद आपकी सूचनाएं यहां दिखेंगी।';

  @override
  String get notifPushNote =>
      'इस फ़ोन पर अभी पुश अलर्ट चालू नहीं हैं। हर अलर्ट फिर भी यहां आता है।';

  @override
  String get notifEmptyTitle => 'अभी कोई सूचना नहीं';

  @override
  String get notifEmptyBody =>
      'किराया रिमाइंडर, भुगतान और मरम्मत के अपडेट यहां दिखेंगे।';

  @override
  String get notifUnread => 'नया';

  @override
  String get notifDebugTitle => 'डिवाइस टोकन दर्ज करें (डीबग)';

  @override
  String get notifDebugToken => 'डिवाइस टोकन';

  @override
  String get notifDebugPlatform => 'प्लैटफ़ॉर्म';

  @override
  String get notifDebugRegister => 'दर्ज करें';

  @override
  String get notifDebugTokenMissing => 'डिवाइस टोकन डालें।';

  @override
  String get notifDebugPlatformMissing => 'प्लैटफ़ॉर्म चुनें।';

  @override
  String get notifDebugRegistered => 'डिवाइस दर्ज हो गया।';

  @override
  String get ownerScopeChooseTitle => 'मालिक चुनें';

  @override
  String get ownerScopeAllTitle => 'सभी मालिक दिख रहे हैं';

  @override
  String ownerScopeManaging(int id) {
    return 'मालिक #$id का प्रबंधन';
  }

  @override
  String get ownerScopeNeedOwnerBody =>
      'प्रॉपर्टी, लीज़ और किराया हर मालिक के लिए अलग दिखते हैं। शुरू करने के लिए मालिक की आईडी डालें।';

  @override
  String get ownerScopeForOwnerBody =>
      'प्रॉपर्टी, लीज़, किराया और रिपोर्ट इसी मालिक के हैं।';

  @override
  String get ownerScopeChoose => 'चुनें';

  @override
  String get ownerScopeChange => 'बदलें';

  @override
  String get ownerScopeDialogTitle => 'किस मालिक का प्रबंधन करना है';

  @override
  String get ownerScopeIdLabel => 'मालिक आईडी';

  @override
  String get ownerScopeIdError => 'मालिक आईडी डालें।';

  @override
  String get ownerScopeShowAll => 'सभी दिखाएं';

  @override
  String get authContinueWithApple => 'Apple से जारी रखें';

  @override
  String get propertyViewLease => 'लीज़ देखें';

  @override
  String get taskSectionWhere => 'प्रॉपर्टी और लीज़';

  @override
  String paymentDueShort(String date) {
    return 'देय $date';
  }

  @override
  String get propertyStepMedia => 'फ़ोटो और फ़्लोर प्लान';

  @override
  String get reportsRowTotalIncome => 'कुल आय';

  @override
  String get reportsRowTotalExpenses => 'कुल खर्च';

  @override
  String get reportsRowNetIncome => 'शुद्ध आय';

  @override
  String get reportsRowProperties => 'प्रॉपर्टी';

  @override
  String get reportsRowProperty => 'प्रॉपर्टी';

  @override
  String get reportsRowOccupied => 'भरी हुई';

  @override
  String get reportsRowVacant => 'खाली';

  @override
  String get reportsRowOccupancyRate => 'भराव दर';

  @override
  String get reportsRowMaintenanceRequests => 'रखरखाव अनुरोध';

  @override
  String get reportsRowPeriod => 'अवधि';

  @override
  String get reportsRowAllTime => 'शुरू से अब तक';

  @override
  String reportsRowFrom(String date) {
    return '$date से';
  }

  @override
  String reportsRowUntil(String date) {
    return '$date तक';
  }

  @override
  String reportsRowLeaseEnds(String date) {
    return 'लीज़ $date को खत्म होगी';
  }

  @override
  String get mapUnsupported => 'इस डिवाइस पर नक्शा उपलब्ध नहीं है।';

  @override
  String get mapOpenInBrowser => 'ब्राउज़र में खोलें';
}
