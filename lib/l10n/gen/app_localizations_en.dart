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
  String get commonSignOut => 'Sign out';

  @override
  String get errorSomethingWentWrong => 'Something went wrong';

  @override
  String get errorOfflineHint =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get errorMissingConfigTitle => 'App configuration missing';

  @override
  String get validationPhoneTooShort => 'Phone number looks too short';

  @override
  String get signInCta => 'Sign in';

  @override
  String get createAccountCta => 'Create account';

  @override
  String get alreadyHaveAccountCta => 'Already have an account?';

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
  String get languageSystem => 'System default';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get changePassword => 'Change Password';

  @override
  String get notifications => 'Notifications';

  @override
  String get appVersion => 'App Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String deleteAccountConfirmLabel(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get deleteAccountWarning =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get deleteAccountEmailSent =>
      'Email app opened. Please send the message to complete your request.';

  @override
  String get deleteAccountSuccess =>
      'Your account has been deleted successfully.';

  @override
  String get deleteAccountManualFallback =>
      'Could not open your email app. Please email info@360ghar.com with subject \"Account Deletion Request\".';

  @override
  String get delete => 'Delete';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get language => 'Language';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get newPassword => 'New Password';

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
  String get requirementMinLength => 'At least 8 characters';

  @override
  String get requirementUppercase => 'At least one uppercase letter';

  @override
  String get requirementLowercase => 'At least one lowercase letter';

  @override
  String get requirementNumber => 'At least one number';

  @override
  String get rentRemindersDesc => 'Get reminded before rent is due';

  @override
  String get paymentAlertsDesc => 'Know when payments are received';

  @override
  String get leaseExpiryAlertsDesc => 'Get notified before leases expire';

  @override
  String get maintenanceAlertsDesc => 'Updates on maintenance requests';

  @override
  String get inspectionRemindersDesc => 'Reminders for upcoming inspections';

  @override
  String get marketingEmailsDesc => 'Receive updates and promotional content';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get leases => 'Leases';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get category => 'Category';

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
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get legal => 'Legal';

  @override
  String get website => 'Website';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get supportResponseTime => 'We typically respond within 24 hours';

  @override
  String get commonLoadFailedTitle => 'Couldn\'t load this';

  @override
  String get commonLoadFailedBody => 'Check your connection, then try again.';

  @override
  String get commonLoadMoreFailed => 'Couldn\'t load more.';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String get commonFilters => 'Filters';

  @override
  String get navHome => 'Home';

  @override
  String get navProperties => 'Properties';

  @override
  String get navCollections => 'Collections';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navMore => 'More';

  @override
  String get navPressBackToExit => 'Press back again to exit';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String homeRentCardTitle(String month) {
    return '$month rent';
  }

  @override
  String get homeCollectedThisMonth => 'Collected this month';

  @override
  String homeVsLastMonth(String change) {
    return '$change vs last month';
  }

  @override
  String homeRentOutstanding(String amount) {
    return '$amount rent outstanding';
  }

  @override
  String get homeRecordPayment => 'Record payment';

  @override
  String get homeViewAll => 'View all';

  @override
  String homeChargesEmpty(String month) {
    return 'No rent charges for $month yet.';
  }

  @override
  String get homeChargesFailed => 'Couldn\'t load this month\'s charges.';

  @override
  String homeUpcomingExpenses(String amount) {
    return 'Upcoming expenses $amount';
  }

  @override
  String homeStripSemantics(int paid, int total) {
    return '$paid of $total rent charges paid this month. Opens collections.';
  }

  @override
  String get homePortfolioTitle => 'Portfolio';

  @override
  String get homePropertiesLabel => 'Properties';

  @override
  String get homeOccupancyLabel => 'Occupancy';

  @override
  String get homeOccupied => 'Occupied';

  @override
  String get homeVacant => 'Vacant';

  @override
  String get homeUnderMaintenance => 'Under maintenance';

  @override
  String get homeAddProperty => 'Add property';

  @override
  String get homeActivityTitle => 'Recent activity';

  @override
  String get homeActivityEmptyTitle => 'No activity yet';

  @override
  String get homeActivityEmptyBody =>
      'Payments, tasks and lease changes show up here.';

  @override
  String get homeEmptyTitle => 'Start with your first property';

  @override
  String get homeEmptyBody =>
      'Add a property, then record rent as it comes in.';

  @override
  String get rentStatusDue => 'Due';

  @override
  String get rentStatusPartlyPaid => 'Partly paid';

  @override
  String get rentStatusPaid => 'Paid';

  @override
  String get rentStatusOverdue => 'Overdue';

  @override
  String get rentStatusWaived => 'Waived';

  @override
  String get tenantsTitle => 'Tenants';

  @override
  String get tenantsSearchHint => 'Search name, phone or property';

  @override
  String get tenantsFilterAll => 'All';

  @override
  String get tenantsStatusActive => 'Active';

  @override
  String get tenantsStatusVacated => 'Vacated';

  @override
  String get tenantsStatusUnknown => 'Status unknown';

  @override
  String get tenantsNoProperty => 'No property linked';

  @override
  String tenantsActiveLeases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active leases',
      one: '1 active lease',
    );
    return '$_temp0';
  }

  @override
  String get tenantsEmptyTitle => 'No tenants yet';

  @override
  String get tenantsEmptyBody =>
      'A tenant shows up here once you add them to a lease.';

  @override
  String get tenantsNewLease => 'New lease';

  @override
  String get tenantsNoMatchTitle => 'No tenants match';

  @override
  String get tenantsNoMatchBody => 'Try another name or filter.';

  @override
  String get tenantDetailTitle => 'Tenant';

  @override
  String get tenantDetailInvalidLink => 'This tenant link is not valid.';

  @override
  String get tenantDetailContact => 'Contact';

  @override
  String get tenantDetailPhone => 'Phone';

  @override
  String get tenantDetailEmail => 'Email';

  @override
  String get tenantDetailNotAdded => 'Not added';

  @override
  String tenantDetailCall(String name) {
    return 'Call $name';
  }

  @override
  String tenantDetailWrite(String name) {
    return 'Email $name';
  }

  @override
  String get tenantDetailLeases => 'Leases';

  @override
  String get tenantDetailNoLeases => 'No leases yet.';

  @override
  String get tenantDetailAllLeases => 'All leases of this tenant';

  @override
  String get tenantDetailInspections => 'Inspections';

  @override
  String get tenantDetailInspectionsHint => 'Of the current lease';

  @override
  String get tenantDetailInspectionsNone => 'Needs a lease first';

  @override
  String get tenantDetailOpenEnded => 'No end date';

  @override
  String get tenantLeaseDraft => 'Draft';

  @override
  String get tenantLeasePendingSignature => 'Pending signature';

  @override
  String get tenantLeaseActive => 'Active';

  @override
  String get tenantLeaseExpiringSoon => 'Expiring soon';

  @override
  String get tenantLeaseExpired => 'Expired';

  @override
  String get tenantLeaseTerminated => 'Terminated';

  @override
  String get tenantLeaseRenewed => 'Renewed';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesAdd => 'Add expense';

  @override
  String get expensesSearchHint => 'Search title, category or property';

  @override
  String expensesSpentIn(String month) {
    return 'Spent in $month';
  }

  @override
  String expensesCountThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses this month',
      one: '1 expense this month',
      zero: 'No expenses this month',
    );
    return '$_temp0';
  }

  @override
  String get expensesEmptyTitle => 'No expenses yet';

  @override
  String get expensesEmptyBody =>
      'Record repairs, bills and taxes to see where the money goes.';

  @override
  String get expensesNoMatchTitle => 'No expenses match';

  @override
  String get expensesNoMatchBody => 'Try another search or category.';

  @override
  String get expensesUntitled => 'Expense';

  @override
  String get expensesCategoryMaintenance => 'Maintenance';

  @override
  String get expensesCategoryRepairs => 'Repairs';

  @override
  String get expensesCategoryInsurance => 'Insurance';

  @override
  String get expensesCategoryPropertyTax => 'Property tax';

  @override
  String get expensesCategoryHoa => 'HOA';

  @override
  String get expensesCategoryUtilities => 'Utilities';

  @override
  String get expensesCategoryMarketing => 'Marketing';

  @override
  String get expensesCategoryLegal => 'Legal';

  @override
  String get expensesCategoryOther => 'Other';

  @override
  String get expenseFormNewTitle => 'New expense';

  @override
  String get expenseFormEditTitle => 'Edit expense';

  @override
  String get expenseFormAmount => 'Amount';

  @override
  String get expenseFormAmountError => 'Enter an amount above zero.';

  @override
  String get expenseFormDate => 'Date';

  @override
  String get expenseFormProperty => 'Property';

  @override
  String get expenseFormPropertyError => 'Choose a property.';

  @override
  String get expenseFormPropertiesFailed => 'Couldn\'t load your properties.';

  @override
  String get expenseFormTitleLabel => 'Expense title';

  @override
  String get expenseFormTitleHint => 'For example, plumbing repair';

  @override
  String get expenseFormCategory => 'Category';

  @override
  String get expenseFormNotes => 'Notes';

  @override
  String get expenseFormNotesHelper => 'Optional';

  @override
  String get expenseFormDetails => 'Details';

  @override
  String get expenseFormCreate => 'Create expense';

  @override
  String get expenseFormSave => 'Save changes';

  @override
  String get expenseFormSaved => 'Expense saved.';

  @override
  String get expenseFormNotFound => 'This expense was not found.';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsUpload => 'Upload';

  @override
  String get documentsSearchHint => 'Search title or type';

  @override
  String get documentsEmptyTitle => 'No documents yet';

  @override
  String get documentsEmptyBody =>
      'Upload lease agreements, ID proofs and receipts to keep them in one place.';

  @override
  String get documentsNoMatchTitle => 'No documents match';

  @override
  String get documentsNoMatchBody => 'Try another search or type.';

  @override
  String get documentsUntitled => 'Document';

  @override
  String get documentsSharedWithTenant => 'Shared with tenant';

  @override
  String get documentsNoAccess => 'You can\'t open this file.';

  @override
  String get documentsOpenFailed => 'Couldn\'t open this file.';

  @override
  String get documentsLocked => 'No access';

  @override
  String get documentTypeLeaseAgreement => 'Lease agreement';

  @override
  String get documentTypeIdProof => 'ID proof';

  @override
  String get documentTypeAddressProof => 'Address proof';

  @override
  String get documentTypeIncomeProof => 'Income proof';

  @override
  String get documentTypeInspectionReport => 'Inspection report';

  @override
  String get documentTypeReceipt => 'Receipt';

  @override
  String get documentTypeInvoice => 'Invoice';

  @override
  String get documentTypePropertyDeed => 'Property deed';

  @override
  String get documentTypeInsurancePolicy => 'Insurance policy';

  @override
  String get documentTypeOther => 'Other';

  @override
  String get documentUploadTitle => 'Upload document';

  @override
  String get documentUploadChoose => 'Choose a file';

  @override
  String get documentUploadChange => 'Choose another file';

  @override
  String get documentUploadLimits => 'PDF, image or document, up to 25 MB';

  @override
  String get documentUploadNoFile => 'Choose a file to upload.';

  @override
  String get documentUploadTooLarge =>
      'This file is over 25 MB. Choose a smaller one.';

  @override
  String get documentUploadPickFailed =>
      'Could not open the file picker. Try again.';

  @override
  String get documentUploadRemoveFile => 'Remove file';

  @override
  String get documentUploadDetails => 'Details';

  @override
  String get documentUploadTitleLabel => 'Title';

  @override
  String get documentUploadTitleHelper => 'Leave blank to use the file name.';

  @override
  String get documentUploadType => 'Type';

  @override
  String get documentUploadSubmit => 'Upload document';

  @override
  String get documentUploadUploading => 'Uploading';

  @override
  String get documentUploadDone => 'Document uploaded.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsTypeRentRoll => 'Rent roll';

  @override
  String get reportsTypeIncome => 'Income';

  @override
  String get reportsTypeExpenses => 'Expenses';

  @override
  String get reportsTypePnl => 'Profit and loss';

  @override
  String get reportsTypeOccupancy => 'Occupancy';

  @override
  String get reportsTypeMaintenance => 'Maintenance';

  @override
  String get reportsAboutRentRoll =>
      'Rent of every property and whether it is let.';

  @override
  String get reportsAboutIncome => 'Rent collected in the period.';

  @override
  String get reportsAboutExpenses => 'Money spent in the period.';

  @override
  String get reportsAboutPnl => 'Income less expenses in the period.';

  @override
  String get reportsAboutOccupancy => 'How many properties are let or vacant.';

  @override
  String get reportsAboutMaintenance =>
      'How many maintenance requests came in.';

  @override
  String get reportsFrom => 'From';

  @override
  String get reportsTo => 'To';

  @override
  String get reportsAnyDate => 'Any date';

  @override
  String get reportsClearDate => 'Clear date';

  @override
  String get reportsEmptyTitle => 'Nothing to report';

  @override
  String get reportsEmptyBody =>
      'This report has no data for the period you chose.';

  @override
  String reportsBarsSummary(int count, String label, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
    );
    return '$_temp0. Highest: $label, $amount.';
  }

  @override
  String get reportsExportCsv => 'Share as CSV';

  @override
  String get reportDrilldownTitle => 'Report line';

  @override
  String reportDrilldownShare(String percent, String total) {
    return '$percent of $total';
  }

  @override
  String get reportDrilldownRanking => 'All lines, largest first';

  @override
  String get reportDrilldownNoAmounts =>
      'This report has no amounts to compare.';

  @override
  String get tenantsNoMatchLoaded => 'None of the tenants loaded so far match.';

  @override
  String get tenantsLoadMore => 'Load more tenants';

  @override
  String get propertiesFilterAll => 'All';

  @override
  String get propertiesFilterActive => 'Active';

  @override
  String get propertiesFilterOccupied => 'Occupied';

  @override
  String get propertiesFilterVacant => 'Vacant';

  @override
  String get propertiesFilterPg => 'PG';

  @override
  String get propertiesFilterFlat => 'Flat';

  @override
  String get propertiesViewList => 'List';

  @override
  String get propertiesViewGrid => 'Grid';

  @override
  String get propertiesSearchByLocation => 'Search by location';

  @override
  String get propertiesClearLocation => 'Remove location filter';

  @override
  String get propertiesEmptyTitle => 'No properties yet';

  @override
  String get propertiesEmptyBody =>
      'Add your first property to start tracking rent.';

  @override
  String get propertiesNoResultsTitle => 'No properties match';

  @override
  String get propertiesNoResultsBody => 'Try another search or filter.';

  @override
  String get propertiesNoMatchYetBody =>
      'None of the loaded properties match. Load more to keep looking.';

  @override
  String get propertiesLoadMore => 'Load more';

  @override
  String get propertiesPerMonth => 'per month';

  @override
  String get propertyTypeHouse => 'House';

  @override
  String get propertyTypeApartment => 'Apartment';

  @override
  String get propertyTypeBuilderFloor => 'Builder floor';

  @override
  String get propertyTypeRoom => 'Room';

  @override
  String get propertyTypeVilla => 'Villa';

  @override
  String get propertyTypePlot => 'Plot';

  @override
  String get propertyTypeCondo => 'Condo';

  @override
  String get propertyTypePenthouse => 'Penthouse';

  @override
  String get propertyTypeStudio => 'Studio';

  @override
  String get propertyTypeLoft => 'Loft';

  @override
  String get propertyTypePg => 'PG';

  @override
  String get propertyTypeFlatmate => 'Flatmate';

  @override
  String get propertyTypeOffice => 'Office';

  @override
  String get propertyTypeShop => 'Shop';

  @override
  String get propertyTypeWarehouse => 'Warehouse';

  @override
  String get propertyStatusDraft => 'Draft';

  @override
  String get propertyStatusActive => 'Active';

  @override
  String get propertyStatusArchived => 'Archived';

  @override
  String get propertyFallbackName => 'Property';

  @override
  String get propertyDetailTitle => 'Property details';

  @override
  String get propertyEdit => 'Edit property';

  @override
  String get propertyShowOnMap => 'Show on map';

  @override
  String get propertyMoreActions => 'More actions';

  @override
  String get propertyArchive => 'Archive property';

  @override
  String get propertyArchiveConfirmTitle => 'Archive this property?';

  @override
  String get propertyArchiveConfirmBody =>
      'It leaves the active list and keeps its history. You can make it active again from Edit.';

  @override
  String get propertyArchiveAction => 'Archive';

  @override
  String get propertyArchived => 'Property archived';

  @override
  String propertyArchiveFailed(String reason) {
    return 'Couldn\'t archive: $reason';
  }

  @override
  String propertyDepositValue(String amount) {
    return 'Deposit $amount';
  }

  @override
  String get propertyCreateLease => 'Create lease';

  @override
  String get propertyTabOverview => 'Overview';

  @override
  String get propertyTabLease => 'Lease';

  @override
  String get propertyTabRent => 'Rent';

  @override
  String get propertyTabExpenses => 'Expenses';

  @override
  String get propertyTabMaintenance => 'Maintenance';

  @override
  String get propertyTabDocuments => 'Documents';

  @override
  String get propertyTabInspections => 'Inspections';

  @override
  String get propertyPhotos => 'Photos';

  @override
  String get propertyFloorPlans => 'Floor plans';

  @override
  String propertyPhotoLabel(int index, int total) {
    return 'Photo $index of $total';
  }

  @override
  String get propertySpecs => 'Specifications';

  @override
  String get propertyTypeField => 'Property type';

  @override
  String get propertyFloorArea => 'Floor area';

  @override
  String propertyAreaValue(String area) {
    return '$area sq ft';
  }

  @override
  String get propertyBedrooms => 'Bedrooms';

  @override
  String get propertyBathrooms => 'Bathrooms';

  @override
  String get propertyBalconies => 'Balconies';

  @override
  String get propertyAge => 'Age';

  @override
  String propertyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String propertyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get propertyAmenities => 'Amenities';

  @override
  String get propertyRentTerms => 'Rent and collection';

  @override
  String get propertyMonthlyRent => 'Monthly rent';

  @override
  String get propertySecurityDeposit => 'Security deposit';

  @override
  String get propertyDueDayNewLeases => 'Due day (new leases)';

  @override
  String propertyDueDayValue(int day) {
    return 'Day $day';
  }

  @override
  String get propertyGraceNewLeases => 'Grace period (new leases)';

  @override
  String get propertyDescription => 'Description';

  @override
  String get propertyCurrentLease => 'Current lease';

  @override
  String get propertyLeaseTenant => 'Tenant';

  @override
  String get propertyLeaseStart => 'Start';

  @override
  String get propertyLeaseEnd => 'End';

  @override
  String get propertyLeaseRent => 'Rent';

  @override
  String get propertyLeaseEndsIn => 'Ends in';

  @override
  String get propertyLeaseEndsToday => 'Today';

  @override
  String get propertyNoLeaseTitle => 'No lease yet';

  @override
  String get propertyNoLeaseBody =>
      'Create a lease to start collecting rent here.';

  @override
  String get propertyNoRentTitle => 'No rent charges';

  @override
  String get propertyNoRentBody =>
      'Charges for this property show up here once a lease is active.';

  @override
  String get propertyOpenCollections => 'Open collections';

  @override
  String propertyChargeBalance(String amount) {
    return 'Balance $amount';
  }

  @override
  String propertyChargeLateFee(String amount) {
    return 'Late fee $amount';
  }

  @override
  String propertyChargeDue(String date) {
    return 'Due $date';
  }

  @override
  String propertyLeaseNumber(String id) {
    return 'Lease #$id';
  }

  @override
  String get propertyNoExpensesTitle => 'No expenses';

  @override
  String get propertyNoExpensesBody =>
      'Expenses you log for this property show up here.';

  @override
  String get propertyAddExpense => 'Add expense';

  @override
  String get propertyNoMaintenanceTitle => 'No maintenance requests';

  @override
  String get propertyNoMaintenanceBody =>
      'Requests and repairs for this property show up here.';

  @override
  String get propertyNewTask => 'New task';

  @override
  String get propertyNoDocumentsTitle => 'No documents';

  @override
  String get propertyNoDocumentsBody =>
      'Agreements, receipts and IDs for this property show up here.';

  @override
  String get propertyUploadDocument => 'Upload document';

  @override
  String get propertyNoInspectionsTitle => 'No inspections';

  @override
  String get propertyNoInspectionsBody =>
      'Move-in and move-out checks for this property show up here.';

  @override
  String get propertyNewInspection => 'New inspection';

  @override
  String propertyCreatedOn(String date) {
    return 'Created $date';
  }

  @override
  String propertyUploadedOn(String date) {
    return 'Uploaded $date';
  }

  @override
  String propertyConductedOn(String date) {
    return 'Conducted $date';
  }

  @override
  String get propertyNew => 'New property';

  @override
  String get propertyStepBasics => 'Basics';

  @override
  String get propertyStepLocation => 'Location';

  @override
  String propertyStepCounter(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get propertyNext => 'Next';

  @override
  String get propertyCreate => 'Create property';

  @override
  String get propertySaveChanges => 'Save changes';

  @override
  String get propertyNameLabel => 'Property name *';

  @override
  String get propertyNameHint => 'For example, Green Valley PG';

  @override
  String get propertyTypeLabel => 'Property type *';

  @override
  String get propertyStatusLabel => 'Management status';

  @override
  String get propertyDescriptionHint =>
      'Rooms, rules, anything a tenant should know';

  @override
  String get propertySetMapLocation => 'Set map location';

  @override
  String get propertyChangeMapLocation => 'Change map location';

  @override
  String get propertyClearMapLocation => 'Remove map location';

  @override
  String get propertyAddressLabel => 'Address line';

  @override
  String get propertyAddressHint => 'House, street, area';

  @override
  String get propertyCityLabel => 'City *';

  @override
  String get propertyCityHint => 'For example, Pune';

  @override
  String get propertyStateLabel => 'State';

  @override
  String get propertyPincodeLabel => 'PIN code';

  @override
  String get propertyAreaLabel => 'Floor area (sq ft)';

  @override
  String get propertyAgeLabel => 'Age (years)';

  @override
  String get propertyAmenitiesFailed => 'Couldn\'t load amenities.';

  @override
  String get propertyRentLabel => 'Monthly rent (₹) *';

  @override
  String get propertyDepositLabel => 'Security deposit (₹)';

  @override
  String get propertyDueDayLabel => 'Payment due day';

  @override
  String get propertyDueDayHelper => '1 to 28';

  @override
  String get propertyGraceLabel => 'Grace period (days)';

  @override
  String get propertyGraceHelper => '0 to 365';

  @override
  String get propertyRentTermsNote =>
      'New leases start with these values. A late fee is charged once, after the grace period, when the lease has one.';

  @override
  String get propertyAddPhotos => 'Add photos';

  @override
  String get propertyAddFloorPlans => 'Add floor plans';

  @override
  String propertyMediaCount(int count, int max) {
    return '$count of $max added';
  }

  @override
  String get propertyRemoveMedia => 'Remove';

  @override
  String propertyMediaLimit(int max) {
    return 'You can add up to $max.';
  }

  @override
  String get propertyErrorName => 'Enter a property name';

  @override
  String get propertyErrorType => 'Choose a property type';

  @override
  String get propertyErrorCity => 'Enter a city';

  @override
  String get propertyErrorRent => 'Enter the monthly rent';

  @override
  String get propertyErrorDueDay => 'Use a day from 1 to 28';

  @override
  String get propertyErrorGrace => 'Use 0 to 365 days';

  @override
  String get propertyCreated => 'Property created';

  @override
  String get propertyUpdated => 'Property saved';

  @override
  String propertySaveFailed(String reason) {
    return 'Couldn\'t save: $reason';
  }

  @override
  String propertyUploadsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files did not upload',
      one: '1 file did not upload',
    );
    return '$_temp0. Save again to retry.';
  }

  @override
  String get propertyDiscardTitle => 'Discard changes?';

  @override
  String get propertyDiscardBody =>
      'Your changes on this form are not saved yet.';

  @override
  String get propertyDiscard => 'Discard';

  @override
  String get locationSearchTitle => 'Search location';

  @override
  String get locationSearchHint => 'City, area or landmark';

  @override
  String get locationUseCurrent => 'Use current location';

  @override
  String get locationDetecting => 'Finding your location';

  @override
  String get locationCurrentName => 'Current location';

  @override
  String get locationServicesOff =>
      'Location services are off. Turn them on to use this.';

  @override
  String get locationSettings => 'Settings';

  @override
  String get locationPermissionNeeded =>
      'Allow location access to use your current location.';

  @override
  String get locationPermissionBlocked =>
      'Location access is blocked. Allow it in Settings.';

  @override
  String get locationFailed => 'Couldn\'t find your location.';

  @override
  String get locationDetailsFailed =>
      'Couldn\'t open that place. Try another one.';

  @override
  String get locationIdleTitle => 'Find a place';

  @override
  String get locationIdleBody =>
      'Type at least two letters of a city, area or landmark.';

  @override
  String get locationNoResultsTitle => 'No places found';

  @override
  String get locationNoResultsBody =>
      'Check the spelling or try a nearby area.';

  @override
  String get locationSearchFailed => 'Couldn\'t search places.';

  @override
  String get mapZoomIn => 'Zoom in';

  @override
  String get mapZoomOut => 'Zoom out';

  @override
  String tenantDetailPeriod(String start, String end) {
    return '$start to $end';
  }

  @override
  String tenantDetailSince(String start) {
    return 'Since $start';
  }

  @override
  String commonPropertyNumber(String id) {
    return 'Property #$id';
  }

  @override
  String commonLeaseNumber(String id) {
    return 'Lease #$id';
  }

  @override
  String get commonNotSet => 'Not set';

  @override
  String get commonNone => 'None';

  @override
  String get commonSaving => 'Saving';

  @override
  String get commonClearFilters => 'Clear filters';

  @override
  String get commonClearDate => 'Clear date';

  @override
  String get commonAll => 'All';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get collectionsGenerate => 'Generate this month\'s charges';

  @override
  String get collectionsGenerateShort => 'Generate charges';

  @override
  String collectionsGenerated(int created, int skipped) {
    return '$created charges created, $skipped skipped.';
  }

  @override
  String get collectionsCollected => 'Collected';

  @override
  String collectionsCollectedShare(String percent) {
    return '$percent% of billed rent collected';
  }

  @override
  String get collectionsTotalsFailed => 'Couldn\'t load the totals.';

  @override
  String get collectionsEmptyDue => 'Nothing is due';

  @override
  String get collectionsEmptyDueBody =>
      'Generate this month\'s charges to start collecting rent.';

  @override
  String get collectionsEmptyPartial => 'No partly paid charges';

  @override
  String get collectionsEmptyOverdue => 'Nothing is overdue';

  @override
  String get collectionsEmptyPaid => 'No paid charges yet';

  @override
  String get collectionsEmptyWaived => 'No waived charges';

  @override
  String get collectionsEmptyBody =>
      'Charges show up here as their status changes.';

  @override
  String collectionsDueOn(String date) {
    return 'Due $date';
  }

  @override
  String get collectionsNoDueDate => 'No due date';

  @override
  String collectionsPaidOf(String paid, String total) {
    return '$paid of $total paid';
  }

  @override
  String collectionsLateFee(String amount) {
    return 'Late fee $amount';
  }

  @override
  String collectionsDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get collectionsRemind => 'Send a reminder';

  @override
  String collectionsReminderMessage(
    String tenant,
    String amount,
    String property,
    String date,
  ) {
    return 'Hi $tenant, a reminder that your rent of $amount for $property is due on $date. Thank you.';
  }

  @override
  String get collectionsSoon => 'soon';

  @override
  String get collectionsNoMessagingApp =>
      'No messaging app is available to send the reminder.';

  @override
  String get paymentTitle => 'Record payment';

  @override
  String get paymentChargeLabel => 'Charge';

  @override
  String get paymentChargeRequired => 'Choose the charge this payment is for.';

  @override
  String get paymentNoCharges => 'No charge is waiting for a payment.';

  @override
  String paymentOwed(String amount) {
    return '$amount owed';
  }

  @override
  String get paymentBilled => 'Billed';

  @override
  String get paymentPaidSoFar => 'Paid so far';

  @override
  String get paymentBalance => 'Balance';

  @override
  String get paymentDetailsSection => 'Payment';

  @override
  String get paymentAmountLabel => 'Amount received';

  @override
  String get paymentAmountHelper => 'Starts at what the tenant still owes.';

  @override
  String get paymentAmountInvalid => 'Enter an amount above zero.';

  @override
  String paymentAmountTooHigh(String amount) {
    return 'Enter at most $amount, the balance of this charge.';
  }

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodUpi => 'UPI';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodCheque => 'Cheque';

  @override
  String get paymentMethodOnline => 'Online';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get paymentDateLabel => 'Date received';

  @override
  String get paymentNotesLabel => 'Notes (optional)';

  @override
  String get paymentRecorded => 'Payment recorded.';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksNew => 'New task';

  @override
  String get tasksViewList => 'List';

  @override
  String get tasksViewBoard => 'Board';

  @override
  String get tasksFilterOpen => 'Open';

  @override
  String get tasksFilterInProgress => 'In progress';

  @override
  String get tasksFilterDone => 'Done';

  @override
  String get tasksEmptyTitle => 'No tasks yet';

  @override
  String get tasksEmptyBody => 'Report a repair or a chore and track it here.';

  @override
  String get tasksEmptyFilteredTitle => 'No tasks here';

  @override
  String get tasksEmptyFilteredBody => 'Nothing matches this filter.';

  @override
  String tasksReportedOn(String date) {
    return 'Reported $date';
  }

  @override
  String tasksVisitOn(String date) {
    return 'Visit $date';
  }

  @override
  String get tasksLoadMore => 'Load more';

  @override
  String get taskStatusOpen => 'Open';

  @override
  String get taskStatusInReview => 'In review';

  @override
  String get taskStatusInProgress => 'In progress';

  @override
  String get taskStatusResolved => 'Resolved';

  @override
  String get taskStatusClosed => 'Closed';

  @override
  String get taskUrgencyLow => 'Low';

  @override
  String get taskUrgencyMedium => 'Medium';

  @override
  String get taskUrgencyHigh => 'High';

  @override
  String get taskUrgencyEmergency => 'Emergency';

  @override
  String get taskCategoryPlumbing => 'Plumbing';

  @override
  String get taskCategoryElectrical => 'Electrical';

  @override
  String get taskCategoryHvac => 'HVAC';

  @override
  String get taskCategoryAppliance => 'Appliance';

  @override
  String get taskCategoryStructural => 'Structural';

  @override
  String get taskCategoryPestControl => 'Pest control';

  @override
  String get taskCategoryCleaning => 'Cleaning';

  @override
  String get taskCategoryOther => 'Other';

  @override
  String get taskCreateTitle => 'New task';

  @override
  String get taskSectionDetails => 'What needs doing';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskTitleHint => 'Fix the leaking kitchen tap';

  @override
  String get taskTitleRequired => 'Enter a title.';

  @override
  String get taskTitleTooShort => 'Use at least 3 characters.';

  @override
  String get taskDescriptionLabel => 'Description';

  @override
  String get taskDescriptionHint => 'What is wrong, and where?';

  @override
  String get taskSectionCategory => 'Category';

  @override
  String get taskPropertyLabel => 'Property';

  @override
  String get taskPropertyRequired => 'Choose a property.';

  @override
  String get taskNoProperties => 'Add a property before you create tasks.';

  @override
  String get taskAddProperty => 'Add property';

  @override
  String get taskLeaseLabel => 'Lease (optional)';

  @override
  String get taskNoLease => 'No lease';

  @override
  String get taskSectionUrgency => 'Urgency';

  @override
  String get taskSectionCost => 'Cost and visit';

  @override
  String get taskCostLabel => 'Estimated cost (optional)';

  @override
  String get taskCostInvalid => 'Enter 0 or more.';

  @override
  String get taskVisitLabel => 'Visit date (optional)';

  @override
  String taskAssignTo(String name) {
    return 'Assign to $name';
  }

  @override
  String get taskAssignHelp => 'Your agent handles this request.';

  @override
  String get taskCreate => 'Create task';

  @override
  String get taskCreated => 'Task created.';

  @override
  String get taskDetailTitle => 'Task';

  @override
  String get taskNotFoundTitle => 'Task not found';

  @override
  String get taskNotFoundBody =>
      'It may have been removed. Go back to the list.';

  @override
  String get taskInvalidId => 'This link does not point to a task.';

  @override
  String get taskGoBack => 'Back to tasks';

  @override
  String get taskSectionInfo => 'Details';

  @override
  String get taskCategoryLabel => 'Category';

  @override
  String get taskTenantLabel => 'Tenant';

  @override
  String get taskEstimatedCost => 'Estimated cost';

  @override
  String get taskScheduledFor => 'Visit';

  @override
  String get taskAssignedAgent => 'Agent';

  @override
  String taskAgentNumber(String id) {
    return 'Agent #$id';
  }

  @override
  String get taskReported => 'Reported';

  @override
  String get taskSectionUpdate => 'Update';

  @override
  String get taskStatusLabel => 'Status';

  @override
  String get taskUrgencyLabel => 'Urgency';

  @override
  String get taskNotesLabel => 'Completion notes';

  @override
  String get taskNotesHint => 'What was done, and by whom';

  @override
  String get taskSave => 'Save changes';

  @override
  String get taskNothingToSave => 'Nothing changed.';

  @override
  String get taskUpdated => 'Task updated.';

  @override
  String taskProgressSemantics(int step, String label) {
    return 'Step $step of 4: $label';
  }

  @override
  String get leasesTitle => 'Leases';

  @override
  String get leasesNew => 'New lease';

  @override
  String get leasesSearchHint => 'Search tenant or property';

  @override
  String get leasesFilterActive => 'Active';

  @override
  String get leasesFilterExpiring => 'Expiring soon';

  @override
  String get leasesFilterUpcoming => 'Upcoming';

  @override
  String get leasesFilterEnded => 'Ended';

  @override
  String get leasesEmptyTitle => 'No leases yet';

  @override
  String get leasesEmptyBody => 'Create a lease to start collecting rent.';

  @override
  String get leasesNoMatchTitle => 'No leases match';

  @override
  String get leasesNoMatchBody => 'Try another name or filter.';

  @override
  String leasesTerm(String start, String end) {
    return '$start to $end';
  }

  @override
  String get leasesEndsToday => 'Ends today';

  @override
  String leasesEndsIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ends in $count days',
      one: 'Ends in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get leaseStatusDraft => 'Draft';

  @override
  String get leaseStatusPendingSignature => 'Pending signature';

  @override
  String get leaseStatusActive => 'Active';

  @override
  String get leaseStatusExpiringSoon => 'Expiring soon';

  @override
  String get leaseStatusExpired => 'Expired';

  @override
  String get leaseStatusTerminated => 'Terminated';

  @override
  String get leaseStatusRenewed => 'Renewed';

  @override
  String get authEntryHeadline => 'Rent, tenants and repairs in one ledger.';

  @override
  String get authEntrySubtitle => 'Sign in, or create your account.';

  @override
  String get authIdentifierLabel => 'Email or phone number';

  @override
  String get authIdentifierHint => 'you@example.com or 98765 43210';

  @override
  String get authIdentifierRequired => 'Enter your email or phone number.';

  @override
  String get authIdentifierInvalid => 'Enter a valid email or phone number.';

  @override
  String get authCodeHelper =>
      'We send a verification code if you have no password.';

  @override
  String get authUseMyNumber => 'Use my number';

  @override
  String get authLastUsedGoogle => 'Last time you used Google.';

  @override
  String get authLastUsedApple => 'Last time you used Apple.';

  @override
  String authLastUsedEmail(String masked) {
    return 'Last time you used $masked.';
  }

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String authTermsSentence(String terms, String privacy) {
    return 'By continuing, you agree to the $terms and the $privacy.';
  }

  @override
  String authAgreeTerms(String terms, String privacy) {
    return 'I agree to the $terms and the $privacy.';
  }

  @override
  String get authAcceptTerms => 'Accept the terms to continue.';

  @override
  String get authUnverifiedNotice =>
      'Your account is not verified yet. Enter the code we sent, or ask for a new one.';

  @override
  String get authCheckFailed => 'We couldn\'t check your account. Try again.';

  @override
  String get authNoAccount =>
      'No account uses this email or phone. Check it, or create an account.';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Enter your password to sign in.';

  @override
  String get authChange => 'Change';

  @override
  String get authEmail => 'Email';

  @override
  String get authPhone => 'Phone number';

  @override
  String get authPhoneHint => '98765 43210';

  @override
  String get authPhoneInvalid => 'Enter a valid 10-digit phone number.';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordInvalid =>
      'Enter your password. It has at least 6 characters.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNewHere => 'New here?';

  @override
  String get authResetTitle => 'Reset password';

  @override
  String get authResetBody =>
      'We send a code to this number. Then you set a new password.';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authSignupTitle => 'Create your account';

  @override
  String get authSignupSubtitle => 'A few details, then we verify your phone.';

  @override
  String get authFullName => 'Full name';

  @override
  String get authFullNameRequired => 'Enter your full name.';

  @override
  String get authEmailRequired => 'Enter your email.';

  @override
  String get authEmailInvalid => 'Enter a valid email address.';

  @override
  String get authNewPasswordHelper => 'At least 6 characters.';

  @override
  String get authPasswordTooShort => 'Use at least 6 characters.';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authConfirmPasswordRequired => 'Enter the password again.';

  @override
  String get authPasswordsDiffer => 'The passwords do not match.';

  @override
  String get authVerifyPhoneTitle => 'Verify your phone';

  @override
  String get authVerifyEmailTitle => 'Verify your email';

  @override
  String authCodeSentTo(String destination) {
    return 'Enter the 6-digit code we sent to $destination.';
  }

  @override
  String get authCodeLabel => 'Verification code';

  @override
  String get authVerify => 'Verify';

  @override
  String get authDidNotGetCode => 'Didn\'t get the code?';

  @override
  String get authResendCode => 'Resend code';

  @override
  String authResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authSetPasswordTitle => 'Set your password';

  @override
  String get authResetPasswordTitle => 'Reset your password';

  @override
  String get authSetPasswordBody =>
      'Create a password so you can sign in faster next time.';

  @override
  String get authResetPasswordBody => 'Choose a new password for your account.';

  @override
  String authPasswordFor(String account) {
    return 'For $account';
  }

  @override
  String get authNewPassword => 'New password';

  @override
  String get authSetPasswordAction => 'Set password and continue';

  @override
  String get authResetPasswordAction => 'Reset password and continue';

  @override
  String get authUseDifferentAccount => 'Use a different account';

  @override
  String get authLeaveTitle => 'Set a password to continue';

  @override
  String get authLeaveBody =>
      'A password is needed to finish signing in. Leaving signs you out.';

  @override
  String get authAddPhoneTitle => 'Add your phone';

  @override
  String get authAddPhoneBody =>
      'Optional. A verified number helps you recover your account and sign in faster.';

  @override
  String get authVerifyAndContinue => 'Verify and continue';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authSkipForNow => 'Skip for now';

  @override
  String get authProfileTitle => 'A few more details';

  @override
  String get authProfileBody =>
      'We need your full name and date of birth to continue.';

  @override
  String get authDateOfBirth => 'Date of birth';

  @override
  String get authDateOfBirthHint => 'Choose your date of birth';

  @override
  String get authDateOfBirthRequired => 'Choose your date of birth.';

  @override
  String get authProfileSaveFailed =>
      'We couldn\'t save your details. Try again.';

  @override
  String get authSplashTagline => 'Property management, done right.';

  @override
  String get onboardingTitle => 'Your ledger is ready';

  @override
  String get onboardingBody =>
      'Start with one property. Then add tenants, record rent as it comes in, and track repairs, all in one place.';

  @override
  String get onboardingStepProperty => 'Add a property';

  @override
  String get onboardingStepTenants => 'Add tenants and leases';

  @override
  String get onboardingStepRent => 'Record rent every month';

  @override
  String get onboardingAddProperty => 'Add your first property';

  @override
  String get onboardingGoHome => 'Go to home';

  @override
  String get configErrorBody =>
      'The app was built without its settings. Add the missing values to .env, then rebuild and restart the app.';

  @override
  String get inspectionsTitle => 'Inspections';

  @override
  String get inspectionsTemplatesAction => 'Checklist templates';

  @override
  String get inspectionsNew => 'New inspection';

  @override
  String get inspectionsEmptyTitle => 'No inspections yet';

  @override
  String get inspectionsEmptyBody =>
      'Record a move-in, move-out or routine check for a lease.';

  @override
  String inspectionsItemTitle(String type) {
    return '$type inspection';
  }

  @override
  String get inspectionsDateNotSet => 'Date not set';

  @override
  String get inspectionTypeMoveIn => 'Move-in';

  @override
  String get inspectionTypeMoveOut => 'Move-out';

  @override
  String get inspectionTypeRoutine => 'Routine';

  @override
  String get inspectionStateOpen => 'Open';

  @override
  String get inspectionStateSignedByOwner => 'Signed by owner';

  @override
  String get inspectionStateSignedByTenant => 'Signed by tenant';

  @override
  String get inspectionStateSigned => 'Signed';

  @override
  String get inspectionFormTitle => 'New inspection';

  @override
  String get inspectionFormLeaseSection => 'Lease';

  @override
  String get inspectionFormProperty => 'Property';

  @override
  String get inspectionFormLease => 'Lease';

  @override
  String get inspectionFormChooseProperty => 'Choose a property.';

  @override
  String get inspectionFormChooseLease => 'Choose a lease.';

  @override
  String get inspectionFormPickPropertyFirst =>
      'Choose a property to see its leases.';

  @override
  String get inspectionFormNoLease => 'This property has no lease yet.';

  @override
  String get inspectionFormAddLease => 'Add a lease';

  @override
  String get inspectionFormDetailsSection => 'Details';

  @override
  String get inspectionFormType => 'Type';

  @override
  String get inspectionFormDate => 'Date of inspection';

  @override
  String get inspectionFormToday => 'Today';

  @override
  String get inspectionFormNotes => 'Notes';

  @override
  String get inspectionFormNotesHelp =>
      'Overall condition, meter readings, keys handed over.';

  @override
  String get inspectionFormChecklistSection => 'Checklist';

  @override
  String get inspectionFormUseTemplate => 'Use a template';

  @override
  String get inspectionFormAddItem => 'Add a checklist item';

  @override
  String get inspectionFormAddItemButton => 'Add item';

  @override
  String get inspectionFormRemoveItem => 'Remove item';

  @override
  String get inspectionFormNoItems =>
      'No items yet. Add your own, or start from a template.';

  @override
  String get inspectionFormTemplateSheetTitle => 'Start from a template';

  @override
  String inspectionFormTemplateAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added',
      one: '1 item added',
    );
    return '$_temp0';
  }

  @override
  String get inspectionFormCreate => 'Create inspection';

  @override
  String get inspectionFormCreated => 'Inspection created.';

  @override
  String get inspectionDetailTitle => 'Inspection';

  @override
  String get inspectionDetailInvalidLink =>
      'This inspection link is not valid.';

  @override
  String get inspectionDetailSignatures => 'Signatures';

  @override
  String get inspectionDetailOwner => 'Owner';

  @override
  String get inspectionDetailTenant => 'Tenant';

  @override
  String get inspectionDetailNotSigned => 'Not signed yet';

  @override
  String inspectionDetailSignedOn(String date) {
    return 'Signed $date';
  }

  @override
  String get inspectionDetailChecklistEmpty => 'No checklist items.';

  @override
  String get inspectionDetailRequired => 'Required';

  @override
  String get inspectionDetailSign => 'Sign as owner';

  @override
  String get inspectionDetailSignTitle => 'Sign this inspection?';

  @override
  String get inspectionDetailSignBody =>
      'Your signature records that you agree with this checklist. You cannot undo it.';

  @override
  String get inspectionDetailSignConfirm => 'Sign';

  @override
  String get inspectionDetailSigned => 'Inspection signed.';

  @override
  String get inspectionItemPass => 'Pass';

  @override
  String get inspectionItemFail => 'Fail';

  @override
  String get inspectionItemAttention => 'Needs attention';

  @override
  String get inspectionItemPending => 'Pending';

  @override
  String get inspectionTemplatesTitle => 'Checklist templates';

  @override
  String get inspectionTemplatesNew => 'New template';

  @override
  String get inspectionTemplatesEmptyTitle => 'No templates yet';

  @override
  String get inspectionTemplatesEmptyBody =>
      'Save a checklist once and reuse it for every move-in, move-out or yearly check.';

  @override
  String inspectionTemplatesItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get inspectionTemplatesDelete => 'Delete template';

  @override
  String get inspectionTemplatesDeleteTitle => 'Delete this template?';

  @override
  String inspectionTemplatesDeleteBody(String name) {
    return '\"$name\" is removed from this device. Inspections already created keep their checklist.';
  }

  @override
  String get inspectionTemplatesName => 'Template name';

  @override
  String get inspectionTemplatesNameHint => 'For example, Move-in checklist';

  @override
  String get inspectionTemplatesNameRequired => 'Enter a name.';

  @override
  String get inspectionTemplatesDescription => 'Description (optional)';

  @override
  String get inspectionTemplatesItems => 'Checklist items';

  @override
  String get inspectionTemplatesItemsHelp => 'One item per line.';

  @override
  String get inspectionTemplatesItemsRequired => 'Add at least one item.';

  @override
  String get inspectionTemplatesCreate => 'Create';

  @override
  String get applicationsTitle => 'Applications';

  @override
  String get applicationsTabInbox => 'Inbox';

  @override
  String get applicationsTabForms => 'Forms';

  @override
  String get applicationsNewForm => 'New form';

  @override
  String get applicationsInboxEmptyTitle => 'No applications yet';

  @override
  String get applicationsInboxEmptyBody =>
      'Share a form link. Applications from tenants arrive here.';

  @override
  String get applicationsFormsEmptyTitle => 'No forms yet';

  @override
  String get applicationsFormsEmptyBody =>
      'Create a form for a property and share its link with people who want to rent.';

  @override
  String get applicationsActive => 'Active';

  @override
  String get applicationsInactive => 'Inactive';

  @override
  String get applicationsStatusApplicant => 'Awaiting decision';

  @override
  String get applicationsStatusApproved => 'Approved';

  @override
  String get applicationsStatusRejected => 'Rejected';

  @override
  String get applicationsStatusUnknown => 'Unknown';

  @override
  String applicationsQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: 'No questions',
    );
    return '$_temp0';
  }

  @override
  String applicationsExpires(String date) {
    return 'Closes $date';
  }

  @override
  String get applicationsNoExpiry => 'No closing date';

  @override
  String applicationsFee(String amount) {
    return '$amount fee';
  }

  @override
  String get applicationsCopyLink => 'Copy link';

  @override
  String get applicationsLinkCopied => 'Link copied.';

  @override
  String applicationsSubmittedOn(String date) {
    return 'Applied $date';
  }

  @override
  String get applicationsApplicant => 'Applicant';

  @override
  String get applicationFormDefaultTitle => 'Application form';

  @override
  String get applicationFormDetailTitle => 'Application form';

  @override
  String get applicationFormInvalidLink => 'This form link is not valid.';

  @override
  String get applicationFormShareSection => 'Share link';

  @override
  String get applicationFormShareHelp =>
      'Send this link to people who want to rent. It opens the form on any phone.';

  @override
  String get applicationFormNoLink => 'This form has no public link yet.';

  @override
  String get applicationFormShare => 'Share';

  @override
  String get applicationFormPreview => 'Preview';

  @override
  String get applicationFormQuestionsSection => 'Questions';

  @override
  String get applicationFormStandardQuestions =>
      'Every applicant also gives their name, phone and email.';

  @override
  String get applicationFormNoQuestions => 'No extra questions.';

  @override
  String get applicationFormRequired => 'Required';

  @override
  String get applicationFormCreateTitle => 'New application form';

  @override
  String get applicationFormDetailsSection => 'Form details';

  @override
  String get applicationFormProperty => 'Property';

  @override
  String get applicationFormChooseProperty => 'Choose a property.';

  @override
  String get applicationFormTitleLabel => 'Form title';

  @override
  String get applicationFormTitleHint => 'For example, 2 BHK in Sector 51';

  @override
  String get applicationFormTitleRequired => 'Enter a form title.';

  @override
  String get applicationFormDescription => 'Description (optional)';

  @override
  String get applicationFormDescriptionHelp => 'Shown at the top of the form.';

  @override
  String get applicationFormCloses => 'Closing date (optional)';

  @override
  String get applicationFormClearDate => 'Clear date';

  @override
  String get applicationFormAccepting => 'Accept applications';

  @override
  String get applicationFormAcceptingHelp =>
      'Turn off to stop new applications.';

  @override
  String get applicationFormQuestionLabel => 'Question';

  @override
  String get applicationFormQuestionHint => 'For example, Do you have pets?';

  @override
  String get applicationFormQuestionRequired => 'Type the question first.';

  @override
  String get applicationFormAnswerType => 'Answer type';

  @override
  String get applicationFormOptions => 'Choices';

  @override
  String get applicationFormOptionsHelp => 'Separate choices with commas.';

  @override
  String get applicationFormOptionsRequired => 'Add at least one choice.';

  @override
  String get applicationFormRequiredAnswer => 'Answer required';

  @override
  String get applicationFormAddQuestion => 'Add question';

  @override
  String get applicationFormRemoveQuestion => 'Remove question';

  @override
  String get applicationFormCreate => 'Create form';

  @override
  String get applicationFormCreated => 'Form created.';

  @override
  String get applicationFieldText => 'Short answer';

  @override
  String get applicationFieldTextarea => 'Long answer';

  @override
  String get applicationFieldNumber => 'Number';

  @override
  String get applicationFieldDate => 'Date';

  @override
  String get applicationFieldBoolean => 'Yes or no';

  @override
  String get applicationFieldSelect => 'Choice';

  @override
  String get applicationDetailTitle => 'Application';

  @override
  String get applicationDetailInvalidLink =>
      'This application link is not valid.';

  @override
  String get applicationDetailPhone => 'Phone';

  @override
  String get applicationDetailEmail => 'Email';

  @override
  String get applicationDetailNotGiven => 'Not given';

  @override
  String get applicationDetailCall => 'Call';

  @override
  String get applicationDetailWrite => 'Send email';

  @override
  String get applicationDetailAnswers => 'Answers';

  @override
  String get applicationDetailNoAnswers => 'No extra answers.';

  @override
  String get applicationDetailApplicantNote => 'Note from the applicant';

  @override
  String get applicationDetailYes => 'Yes';

  @override
  String get applicationDetailNo => 'No';

  @override
  String get applicationDetailDecision => 'Decision';

  @override
  String applicationDetailDecidedOn(String date) {
    return 'Decided $date';
  }

  @override
  String get applicationDetailYourDecision => 'Your decision';

  @override
  String get applicationDetailDecisionHelp =>
      'The applicant is not told automatically. Call them after you decide.';

  @override
  String get applicationDetailApprove => 'Approve';

  @override
  String get applicationDetailReject => 'Reject';

  @override
  String get applicationDetailApproveTitle => 'Approve this application?';

  @override
  String get applicationDetailRejectTitle => 'Reject this application?';

  @override
  String get applicationDetailDecisionNotes => 'Notes (optional)';

  @override
  String get applicationDetailDecisionNotesHelp => 'Only you see these notes.';

  @override
  String get applicationDetailApproved => 'Application approved.';

  @override
  String get applicationDetailRejected => 'Application rejected.';

  @override
  String get publicApplyTitle => 'Apply to rent';

  @override
  String get publicApplyIntro =>
      'Fill in your details. The owner reviews every application and contacts you.';

  @override
  String publicApplyFee(String amount) {
    return 'Application fee $amount';
  }

  @override
  String get publicApplyAboutYou => 'About you';

  @override
  String get publicApplyName => 'Full name';

  @override
  String get publicApplyNameRequired => 'Enter your name.';

  @override
  String get publicApplyPhone => 'Phone number';

  @override
  String get publicApplyPhoneRequired => 'Enter your phone number.';

  @override
  String get publicApplyPhoneInvalid => 'Enter a 10-digit phone number.';

  @override
  String get publicApplyEmail => 'Email';

  @override
  String get publicApplyEmailRequired => 'Enter your email.';

  @override
  String get publicApplyEmailInvalid => 'Enter an email like name@example.com.';

  @override
  String get publicApplyQuestions => 'A few questions';

  @override
  String get publicApplyRequiredNote => 'Questions marked * need an answer.';

  @override
  String get publicApplyAnswerRequired => 'Answer this question.';

  @override
  String get publicApplyNumberInvalid => 'Enter a number.';

  @override
  String get publicApplyChoose => 'Choose one';

  @override
  String get publicApplyNotes => 'Anything else? (optional)';

  @override
  String get publicApplyNotesHelp =>
      'Move-in date, who will live with you, parking needs.';

  @override
  String get publicApplySubmit => 'Submit application';

  @override
  String get publicApplyClosedTitle => 'Applications are closed';

  @override
  String get publicApplyClosedBody =>
      'This form is not taking applications right now.';

  @override
  String get publicApplySentTitle => 'Application sent';

  @override
  String get publicApplySentBody => 'The owner now has your details.';

  @override
  String get publicApplySentNext => 'What happens next';

  @override
  String get publicApplySentStep1 => 'The owner reviews your application.';

  @override
  String get publicApplySentStep2 =>
      'They contact you on the phone number you gave.';

  @override
  String get publicApplySentStep3 => 'You can close this page now.';

  @override
  String get publicApplySignIn => 'Sign in to 360 Estate';

  @override
  String leaseLateFeeFlat(String amount) {
    return '$amount flat';
  }

  @override
  String leaseLateFeePercent(String percent) {
    return '$percent% of the rent';
  }

  @override
  String get leaseDetailTitle => 'Lease';

  @override
  String get leaseMonthlyRent => 'Monthly rent';

  @override
  String get leaseDeposit => 'Security deposit';

  @override
  String get leaseEndsTodayNotice =>
      'This lease ends today. Renew it or let it end.';

  @override
  String leaseEndsInNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This lease ends in $count days. Renew it or let it end.',
      one: 'This lease ends tomorrow. Renew it or let it end.',
    );
    return '$_temp0';
  }

  @override
  String leaseExpiredNotice(String date) {
    return 'This lease ended on $date.';
  }

  @override
  String get leaseSectionTerm => 'Term';

  @override
  String get leaseStart => 'Start';

  @override
  String get leaseEnd => 'End';

  @override
  String leaseTermElapsed(String percent) {
    return '$percent% of the term has passed';
  }

  @override
  String get leaseSectionTenant => 'Tenant';

  @override
  String get leaseName => 'Name';

  @override
  String get leasePhone => 'Phone';

  @override
  String get leaseEmail => 'Email';

  @override
  String get leaseCallTenant => 'Call the tenant';

  @override
  String get leaseSectionCollection => 'Rent collection';

  @override
  String get leaseDueDay => 'Due day';

  @override
  String leaseDueDayValue(int day) {
    return 'Day $day of each month';
  }

  @override
  String get leaseGracePeriod => 'Grace period';

  @override
  String leaseGraceValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get leaseLateFee => 'Late fee';

  @override
  String get leaseLateFeeRule =>
      'The late fee is charged once, after the grace period.';

  @override
  String get leaseTerminatedOn => 'Ended on';

  @override
  String get leaseReason => 'Reason';

  @override
  String get leaseSectionDocument => 'Signed lease';

  @override
  String get leaseDocumentMissing => 'No signed copy yet. Upload the PDF.';

  @override
  String get leaseDocumentPresent => 'The signed PDF is on file.';

  @override
  String get leaseUploadPdf => 'Upload PDF';

  @override
  String get leaseReplacePdf => 'Replace PDF';

  @override
  String get leaseViewSigned => 'View signed lease';

  @override
  String get leaseUploaded => 'Signed lease uploaded.';

  @override
  String get leaseOpenFailed => 'Couldn\'t open the document.';

  @override
  String get leaseRenew => 'Renew';

  @override
  String get leaseTerminate => 'Terminate';

  @override
  String get leaseRenewTitle => 'Renew lease';

  @override
  String get leaseNewStart => 'New start date';

  @override
  String get leaseNewEnd => 'New end date';

  @override
  String get leaseNewRent => 'New monthly rent';

  @override
  String get leaseNewRentHelper => 'Leave blank to keep the current rent.';

  @override
  String get leaseStartActive => 'Start as active';

  @override
  String get leaseEndAfterStart => 'The end date must be after the start date.';

  @override
  String get leaseRenewed => 'Lease renewed.';

  @override
  String get leaseTerminateTitle => 'Terminate lease';

  @override
  String get leaseTerminateBody =>
      'The tenant moves out on this date. This cannot be undone.';

  @override
  String get leaseTerminationDate => 'Termination date';

  @override
  String get leaseTerminated => 'Lease terminated.';

  @override
  String get leaseFormTitle => 'New lease';

  @override
  String get leaseFormSectionParties => 'Property and tenant';

  @override
  String get leaseFormProperty => 'Property *';

  @override
  String get leaseFormPropertyRequired => 'Choose a property.';

  @override
  String get leaseFormPropertiesFailed => 'Couldn\'t load your properties.';

  @override
  String get leaseFormTenantName => 'Tenant name';

  @override
  String get leaseFormTenantPhone => 'Tenant phone';

  @override
  String get leaseFormTenantEmail => 'Tenant email';

  @override
  String get leaseFormTenantUserId => 'Tenant user ID (optional)';

  @override
  String get leaseFormTenantUserIdHelper =>
      'The tenant\'s account ID, if the tenant has one.';

  @override
  String get leaseFormSectionTerm => 'Term and status';

  @override
  String get leaseFormStart => 'Start date *';

  @override
  String get leaseFormEnd => 'End date *';

  @override
  String get leaseFormDateRequired => 'Pick a date.';

  @override
  String get leaseFormStatus => 'Status';

  @override
  String get leaseFormSectionRent => 'Rent';

  @override
  String get leaseFormRent => 'Monthly rent *';

  @override
  String get leaseFormRentInvalid => 'Enter a monthly rent above zero.';

  @override
  String get leaseFormDeposit => 'Security deposit';

  @override
  String get leaseFormFromProperty =>
      'Filled from the property. Change it if this lease differs.';

  @override
  String get leaseFormSectionRules => 'Rent collection rules';

  @override
  String get leaseFormRulesHelp =>
      'Blank fields take the property\'s values. A flat late fee wins over a percentage.';

  @override
  String get leaseFormDueDay => 'Due day';

  @override
  String get leaseFormGraceDays => 'Grace days';

  @override
  String get leaseFormLateFeeFlat => 'Late fee (flat)';

  @override
  String get leaseFormLateFeePercent => 'Late fee (%)';

  @override
  String leaseFormRange(int min, int max) {
    return 'Enter a whole number from $min to $max.';
  }

  @override
  String get leaseFormPercentRange => 'Enter 0 to 100.';

  @override
  String get leaseFormSectionClauses => 'Special clauses';

  @override
  String get leaseFormClauses => 'Special clauses (optional)';

  @override
  String get leaseFormClausesHint => 'Any terms beyond rent and dates';

  @override
  String get leaseFormCreate => 'Create lease';

  @override
  String get leaseFormCreated => 'Lease created.';

  @override
  String get moreSectionManage => 'Manage';

  @override
  String get moreSectionAccount => 'Account';

  @override
  String get moreSectionSupport => 'Support';

  @override
  String get moreApplications => 'Rental applications';

  @override
  String get moreTenants => 'Tenants';

  @override
  String get moreLeases => 'Leases';

  @override
  String get moreInspections => 'Inspections';

  @override
  String get moreExpenses => 'Expenses';

  @override
  String get moreDocuments => 'Documents';

  @override
  String get moreReports => 'Reports';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreChangePassword => 'Change password';

  @override
  String get moreHelp => 'Help center';

  @override
  String get moreContact => 'Contact us';

  @override
  String get moreSignOutTitle => 'Sign out?';

  @override
  String get moreSignOutBody =>
      'You will need to sign in again to see your properties.';

  @override
  String moreVersion(String version) {
    return '360 Estate $version';
  }

  @override
  String get moreOpenProfile => 'Open your profile';

  @override
  String get moreGuestName => 'Your account';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get profileEditAction => 'Edit profile';

  @override
  String get profileDetailsTitle => 'Your details';

  @override
  String get profileSecurityTitle => 'Security';

  @override
  String get profileNotSet => 'Not added';

  @override
  String get profileName => 'Full name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileTakePhoto => 'Take a photo';

  @override
  String get profileChoosePhoto => 'Choose from gallery';

  @override
  String get profileRemovePhoto => 'Remove new photo';

  @override
  String get profileEmailHelper =>
      'Email changes go through your sign-in settings.';

  @override
  String get profileSavedShort => 'Profile saved';

  @override
  String get profileSaveFailed => 'Couldn\'t save your profile. Try again.';

  @override
  String get passwordPageIntro =>
      'Enter your current password, then choose a new one.';

  @override
  String get passwordShow => 'Show password';

  @override
  String get passwordHide => 'Hide password';

  @override
  String get passwordCurrentLabel => 'Current password';

  @override
  String get passwordNewLabel => 'New password';

  @override
  String get passwordRules => 'Your new password needs';

  @override
  String get passwordTooShort8 => 'Use at least 8 characters.';

  @override
  String get passwordChangedShort => 'Password changed';

  @override
  String get passwordChangeFailedShort =>
      'Couldn\'t change your password. Try again.';

  @override
  String get passwordRuleMet => 'Done';

  @override
  String get passwordRuleMissing => 'Missing';

  @override
  String get settingsLanguageSystemDesc => 'Follow the phone\'s language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageHindi => 'हिन्दी';

  @override
  String get settingsAlertsTitle => 'Notifications and privacy';

  @override
  String get settingsNotificationPrefs => 'Notification preferences';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountDesc => 'Remove your account and its data';

  @override
  String get notifPrefsNote =>
      'These choices are saved on this phone. Push alerts start once they are switched on for 360 Estate.';

  @override
  String get notifPrefsAllTitle => 'Allow notifications';

  @override
  String get notifPrefsAllDesc => 'Turn every alert below on or off';

  @override
  String get notifPrefsAlertsTitle => 'Alerts';

  @override
  String get notifPrefsEmailTitle => 'Email';

  @override
  String get notifPrefRent => 'Rent due reminders';

  @override
  String get notifPrefPayments => 'Payments received';

  @override
  String get notifPrefLeases => 'Leases about to end';

  @override
  String get notifPrefMaintenance => 'Repair updates';

  @override
  String get notifPrefInspections => 'Inspection reminders';

  @override
  String get notifPrefMarketing => 'News and offers';

  @override
  String get privacyDiagnosticsTitle => 'Diagnostics';

  @override
  String get privacyCrashTitle => 'Send crash reports';

  @override
  String get privacyCrashDesc =>
      'Helps us find and fix bugs. Applies the next time you open the app.';

  @override
  String get legalPrivacyPolicy => 'Privacy policy';

  @override
  String get legalTerms => 'Terms of service';

  @override
  String get legalIntro =>
      'The full text is on our website. It opens inside the app.';

  @override
  String get legalOpen => 'Read it now';

  @override
  String get legalOpenFailed =>
      'Couldn\'t open the page. Check your connection and try again.';

  @override
  String get deleteTitle => 'Delete your account';

  @override
  String get deleteSubmit => 'Delete my account';

  @override
  String get helpSearchHint => 'Search questions';

  @override
  String get helpCatAll => 'All';

  @override
  String get helpCatProperties => 'Properties';

  @override
  String get helpCatRent => 'Rent';

  @override
  String get helpCatLeases => 'Leases';

  @override
  String get helpCatMaintenance => 'Maintenance';

  @override
  String get helpCatAccount => 'Account';

  @override
  String get helpQ1 => 'How do I add a property?';

  @override
  String get helpA1 =>
      'Open the Properties tab and tap Add property. Fill in the details, then save.';

  @override
  String get helpQ2 => 'How do I record a rent payment?';

  @override
  String get helpA2 =>
      'Tap Record payment on Home, or open Collections and pick the charge that was paid.';

  @override
  String get helpQ3 => 'How do I create a lease?';

  @override
  String get helpA3 =>
      'Go to More, then Leases, and tap the add button. Pick the property and tenant, then set the rent and dates.';

  @override
  String get helpQ4 => 'How do I run an inspection?';

  @override
  String get helpA4 =>
      'Go to More, then Inspections, and tap the add button. Pick the property and work through the checklist.';

  @override
  String get helpQ5 => 'How do I log a repair?';

  @override
  String get helpA5 =>
      'Open the Tasks tab and tap the add button. Describe the problem and pick the property.';

  @override
  String get helpQ6 => 'How do I change my name or photo?';

  @override
  String get helpA6 =>
      'Go to More, tap your name at the top, then tap Edit profile.';

  @override
  String get helpNoResultsTitle => 'No answers match';

  @override
  String get helpNoResultsBody => 'Try another word, or ask us directly.';

  @override
  String get helpStillStuckTitle => 'Still stuck?';

  @override
  String get helpStillStuckBody =>
      'Send us a message. We usually reply within a day.';

  @override
  String get contactTopic => 'Topic';

  @override
  String get contactCatGeneral => 'General';

  @override
  String get contactCatTechnical => 'Something is broken';

  @override
  String get contactCatBilling => 'Billing';

  @override
  String get contactCatFeature => 'Feature idea';

  @override
  String get contactName => 'Your name';

  @override
  String get contactSubject => 'Subject';

  @override
  String get contactMessageTitle => 'Your message';

  @override
  String get contactMessageHelper =>
      'Tell us what happened and on which screen.';

  @override
  String get contactSend => 'Send message';

  @override
  String get contactSent => 'Message sent. We will reply by email.';

  @override
  String contactEmailDirect(String email) {
    return 'Or email us at $email';
  }

  @override
  String get aboutTagline => 'Rent, tenants and repairs, kept in one ledger.';

  @override
  String aboutVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get aboutLicenses => 'Open-source licences';

  @override
  String get aboutContactTitle => 'Get in touch';

  @override
  String aboutCopyright(String year) {
    return '© $year 360Ghar. All rights reserved.';
  }

  @override
  String get aboutMadeFor => 'Made for property owners in India.';

  @override
  String get notifSignedOutTitle => 'Sign in to see alerts';

  @override
  String get notifSignedOutBody =>
      'Your notifications appear here after you sign in.';

  @override
  String get notifPushNote =>
      'Push alerts are not switched on for this phone yet. Every alert still lands here.';

  @override
  String get notifEmptyTitle => 'No notifications yet';

  @override
  String get notifEmptyBody =>
      'Rent reminders, payments and repair updates show up here.';

  @override
  String get notifUnread => 'New';

  @override
  String get notifDebugTitle => 'Register a device token (debug)';

  @override
  String get notifDebugToken => 'Device token';

  @override
  String get notifDebugPlatform => 'Platform';

  @override
  String get notifDebugRegister => 'Register';

  @override
  String get notifDebugTokenMissing => 'Enter a device token.';

  @override
  String get notifDebugPlatformMissing => 'Choose a platform.';

  @override
  String get notifDebugRegistered => 'Device registered.';

  @override
  String get ownerScopeChooseTitle => 'Choose an owner';

  @override
  String get ownerScopeAllTitle => 'Showing every owner';

  @override
  String ownerScopeManaging(int id) {
    return 'Managing owner #$id';
  }

  @override
  String get ownerScopeNeedOwnerBody =>
      'Properties, leases and rent are listed per owner. Enter the owner id to start.';

  @override
  String get ownerScopeForOwnerBody =>
      'Properties, leases, rent and reports are for this owner.';

  @override
  String get ownerScopeChoose => 'Choose';

  @override
  String get ownerScopeChange => 'Change';

  @override
  String get ownerScopeDialogTitle => 'Owner to manage';

  @override
  String get ownerScopeIdLabel => 'Owner id';

  @override
  String get ownerScopeIdError => 'Enter the owner id.';

  @override
  String get ownerScopeShowAll => 'Show all';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get propertyViewLease => 'View lease';

  @override
  String get taskSectionWhere => 'Property and lease';

  @override
  String paymentDueShort(String date) {
    return 'due $date';
  }

  @override
  String get propertyStepMedia => 'Photos and floor plans';

  @override
  String get reportsRowTotalIncome => 'Total income';

  @override
  String get reportsRowTotalExpenses => 'Total expenses';

  @override
  String get reportsRowNetIncome => 'Net income';

  @override
  String get reportsRowProperties => 'Properties';

  @override
  String get reportsRowProperty => 'Property';

  @override
  String get reportsRowOccupied => 'Occupied';

  @override
  String get reportsRowVacant => 'Vacant';

  @override
  String get reportsRowOccupancyRate => 'Occupancy rate';

  @override
  String get reportsRowMaintenanceRequests => 'Maintenance requests';

  @override
  String get reportsRowPeriod => 'Period';

  @override
  String get reportsRowAllTime => 'All time';

  @override
  String reportsRowFrom(String date) {
    return 'From $date';
  }

  @override
  String reportsRowUntil(String date) {
    return 'Until $date';
  }

  @override
  String reportsRowLeaseEnds(String date) {
    return 'Lease ends $date';
  }

  @override
  String get mapUnsupported => 'The map is not available on this device.';

  @override
  String get mapOpenInBrowser => 'Open in browser';

  @override
  String get leaseFormAmountInvalid => 'Enter an amount of zero or more.';

  @override
  String get expenseFormPropertyUnavailable =>
      'The properties could not be loaded. Try again.';
}
